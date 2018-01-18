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
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import redcloud.db.DbConnect;
import redcloud.db.DbManager;

public class GetTeam extends HttpServlet {

    public static String getTeam(DbManager dbm, int teamNum) {

        final DbConnect dbc = dbm.createPreparedStatement("SELECT r.rover_id, CONCAT(r.first_name,' ',r.last_name) AS full_name, r.rover_crew " +
                "FROM rover r, rover_team t WHERE r.rover_id=t.rover_id AND team_number=? ORDER BY r.rover_id");
        dbc.setInt(1, teamNum);
        dbc.executeQuery();


        StringBuffer buff = new StringBuffer();
        buff.append("<table align='center' cellpadding=4 cellspacing=0 border=1>");
        buff.append("<tr><th>Application ID</th><th>Name</th><th>Crew</th><th></th></tr>");

        while(dbc.next()) {
            int rover_id = dbc.getInt("r.rover_id");
            buff.append("<tr><td>");
            buff.append(rover_id);
            buff.append("</td><td>");
            buff.append(dbc.getString("full_name"));
            buff.append("</td><td>");
            buff.append(dbc.getString("r.rover_crew"));
            buff.append("</td><td><a onclick='removeMember(");
            buff.append(teamNum);
            buff.append(',');
            buff.append(rover_id);
            buff.append("); return false'>Remove</a></td></tr>");
        }
        buff.append("</table>");
        dbc.endQuery();

        return buff.toString();
    }

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

        int tnum = Integer.parseInt(request.getParameter("tnum"));

        DbManager dbm = new DbManager("jdbc/moot");
        dbm.open();
        String team = getTeam(dbm, tnum);
        dbm.close();

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.print(team);
        out.flush();  
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
