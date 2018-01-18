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

package paperwork;

import common.KeyValue;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import redcloud.db.DbConnect;
import redcloud.db.DbManager;

public class StandardReceipt extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
        
        final boolean images = request.getParameter("images")!=null && request.getParameter("images").equals("y");

		int rover_id = 0;
		if(request.getParameter("appid") != null ) {
			rover_id = Integer.parseInt(request.getParameter("appid"));
		}

        final DbManager dbm = new DbManager("jdbc/moot");
		dbm.open();

        final Receipt receipt = Receipt.build(dbm, rover_id);

        if(request.getParameter("pid") != null) {
            int receipt_no = Integer.parseInt(request.getParameter("pid"));
            if(receipt_no == -1) {
                KeyValue kv = new KeyValue(dbm);
                receipt_no = Integer.parseInt(kv.get("receipt_no"));
            }
            receipt.setReceiptNo(receipt_no);
        }

        final DbConnect dbc = dbm.createPreparedStatement("SELECT payment_id, payment_for, method, amount, date FROM payment WHERE rover_id = ?");
        dbc.setInt(1, rover_id);
        dbc.executeQuery();

        while(dbc.next()) {
            Receipt.Line line = new Receipt.Line(dbc.getDate("date"),
                    dbc.getString("payment_for"), dbc.getInt("payment_id"),
                    dbc.getString("method"), dbc.getInt("amount"));
            receipt.getLines().add(line);
        }
        dbc.endQuery();

        KeyValue kv = new KeyValue(dbm);
        kv.put("receipt_no", ""+(receipt.getReceiptNo()+1));

        dbm.close();

        (new ReceiptGenerator()).generate(response, receipt, images);
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
