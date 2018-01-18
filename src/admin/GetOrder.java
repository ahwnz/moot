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

import redcloud.db.*;

/**
 * Servlet implementation class GetOrder
 */
public class GetOrder extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetOrder() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		DbManager dbm = new DbManager("jdbc/moot");
                dbm.open();
		
		int app_id = Integer.parseInt(request.getParameter("appid"));
		System.out.println(" Rover ID="+app_id);
		
		if(request.getParameter("remove")!=null) {
			int remove = Integer.parseInt(request.getParameter("remove"));
			dbm.doUpdate("DELETE FROM rover_merchandise WHERE rec_id="+remove);
		}
		
		if(request.getParameter("add")!=null) {
			int add = Integer.parseInt(request.getParameter("add"));
			dbm.doUpdate("INSERT INTO rover_merchandise SET rover_id="+app_id+", item_id="+add);
		}
		
		DbConnect dbc = dbm.createPreparedStatement("SELECT r.rec_id, r.item_id, m.item_name FROM rover_merchandise r JOIN merchandise m ON r.item_id=m.item_id WHERE rover_id=6");
		//dbc.setInt(1, app_id);
		dbc.executeQuery();
		
		String html = "<table>" +
				"<tr><th>Item ID</th><th>Item Name</th><th></th></tr>";
		
		while(dbc.next()) {
			System.out.println("Position : Loop");
			int rec_id = dbc.getInt("rec_id");
			int item_id = dbc.getInt("item_id");
			String item_name = dbc.getString("item_name");
			
			html += "<tr>" +
						"<td>"+item_id+
						"<td>"+item_name+
						"<td><a href='#' onClick='removeItem("+rec_id+"); return false;'>Remove</a>"+
					"</tr>";
		}
		html += "</table>";
		
		dbc.endQuery();
		dbm.close();
		
		response.getWriter().print(html);
	}

}
