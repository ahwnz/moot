/**     ______________________________________
 *     / ____________________________________ \
 *    / /     /        \     /         \     \ \
 *   / /     /          \   /           \     \ \
 *  / /     / _   _   ___\ /____     ___ \     \ \
 * / /     / | | | | |  _| |  _ \   / _ \ \     \ \
 * \ \    /  | |_| | | |_  | |_| | / / \ \ \    / /
 *  \ \  /   |  _  | |  _| | _  /  | | | |  \  / /
 *   \ \/    | | | | | |_  | |\ \  \ \_/ /   \/ /
 *    \ \    |_| |_| |___| |_| \_\  \___/    / /
 *     \ \            _       _             / /
 *      \ \          / \     / \           / /
 *       \ \        /   \   /   \         / /
 *        \ \      /     \ /     \       / /
 *         \ \    /    M O O T    \     / /
 *          \ \__/_________________\___/ /
 *           \_____Canterbury 2010______/
 *
 * Copyright (c) 2009-2010, Redcloud Development, Ltd. All rights reserved
 * @author Alex Westphal
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

package admin.registration;

import application.Constants;
import common.KeyValue;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import redcloud.db.DbConnect;
import redcloud.db.DbManager;


public class GetRover extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

        response.setContentType("text/xml");
        PrintWriter out = response.getWriter();
        try {

            int rover_id = Integer.parseInt(request.getParameter("appid"));


            DbManager dbm = new DbManager("jdbc/moot");
            dbm.open();

            DbConnect dbc = dbm.createPreparedStatement("SELECT nickname, rover_crew, region, moot_number, registered, staff, tour_assigned, late_fee FROM rover WHERE rover_id = ?");
            DbConnect dbc2 = dbm.createPreparedStatement("SELECT amount FROM payment WHERE rover_id=?");
            DbConnect dbc3 = dbm.createPreparedStatement("SELECT tour_cost FROM tour WHERE tour_id=?");
            DbConnect dbc4 = dbm.createPreparedStatement("SELECT m.item_cost, r.quantity FROM rover_merchandise r JOIN merchandise m ON r.item_id=m.item_id WHERE rover_id=?");
            int amount_payed = 0;
            int amount_owing = 0;

            dbc.setInt(1, rover_id);
            dbc.executeQuery();

            dbc2.setInt(1, rover_id);
            dbc2.executeQuery();
        
            if(dbc.next()) {

                while(dbc2.next()) {
                    amount_payed += dbc2.getInt("amount");
                }

                if(dbc.getString("staff").equals("Y")) {
                    amount_owing += Constants.STAFF_FEE;
                } else {
                    amount_owing += Constants.MOOT_FEE;
                }

                int tour_assigned = dbc.getInt("tour_assigned");
                if(tour_assigned != 0) {
                    dbc3.setInt(1, tour_assigned);
                    dbc3.executeQuery();
                    if(dbc3.next()) {
                        amount_owing += dbc3.getInt("tour_cost");
                    }
                }

                dbc4.setInt(1, rover_id);
                dbc4.executeQuery();
                while(dbc4.next()) {
                    amount_owing += dbc4.getInt("m.item_cost")*dbc4.getInt("r.quantity");
                }

                if(dbc.getString("late_fee").equals("Y")) amount_owing += Constants.LATE_FEE;

                amount_owing -= amount_payed;

                KeyValue kv = new KeyValue(dbm);

                out.print("<details>");
                out.printf("<nickname>%s</nickname>", dbc.getString("nickname"));
                out.printf("<crew>%s</crew>", dbc.getString("rover_crew"));
                out.printf("<region>%s</region>", dbc.getString("region"));
                out.printf("<mootnum>%s</mootnum>", dbc.getString("moot_number"));
                out.printf("<registered>%s</registered>", dbc.getString("registered"));
                out.printf("<payed>%s</payed>", amount_payed);
                out.printf("<owing>%s</owing>", amount_owing);
                out.printf("<rid>%s</rid>", kv.get("receipt_no"));
                out.print("</details>");
            }

            dbc.endQuery();
            dbc2.endQuery();
            dbc3.endQuery();
            dbc4.endQuery();
            dbm.close();
        } finally {
            out.flush();
            out.close();
        }
        
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
