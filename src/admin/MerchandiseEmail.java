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

package admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import redcloud.common.Mailer;
import redcloud.db.DbConnect;
import redcloud.db.DbManager;

import application.Constants;
import java.util.Random;

/**
 *
 * @author alexanderw
 */
public class MerchandiseEmail extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        final DbManager dbm = new DbManager("jdbc/moot");
        dbm.open();

        final DbConnect dbc = dbm.doQuery("SELECT rover_id, first_name, email FROM rover");

        Mailer mailer = new Mailer();
        boolean next = true;
        do {
            mailer.openConnection(Constants.MAIL_SERVER, Constants.MAIL_USER, Constants.MAIL_PASSWORD);
            for(int i=0; i<20 && next; i++) {
                next = dbc.next();
                int ob_id = (256*1025*((new Random()).nextInt(4096)))+dbc.getInt("rover_id");
                StringBuilder body = new StringBuilder();
                body.append("Hi "); body.append(dbc.getString("first_name")); body.append(",<br><br>");
                body.append("Last chance to order the fantastic merchandise on offer for Smooth Moot 2010! Orders must be in by Friday 5th February! ");
                body.append("Please click on the link below to double check your previously placed order, add more merchandise to your order or place a brand new order!<br><br>");
                body.append("<a href='http://www.nelsonzone.org.nz/moot/pages/application/merchandise_order.jsp?appid=");
                body.append(ob_id); body.append("' target='_blank'>Smooth Moot Merchandise</a>");
                body.append("<br><br>");
                body.append("See you all at Hero Moot 2010<br>Smooth Moot Administration<br>");
                mailer.sendHtmlMessage(Constants.MAIL_FROM, Constants.MAIL_REPLY_TO, dbc.getString("email"), "Smooth Moot Merchandise", body.toString());
            }
            mailer.closeConnection();
            try { Thread.sleep(10000); } catch(InterruptedException ex) {}
        } while(next);
        dbc.endQuery();
        dbm.close();
        response.sendRedirect("/moot/pages/admin/utilities.jsp");
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
