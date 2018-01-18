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

package application;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import redcloud.db.DbConnect;
import redcloud.db.DbManager;

/**
 * Servlet implementation class MerchandiseSubmit
 */
public class MerchandiseSubmit extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MerchandiseSubmit() {
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
		
		DbConnect dbc1 = dbm.doQuery("SELECT item_id FROM merchandise");
		DbConnect dbc2 = dbm.createPreparedStatement("SELECT item_id FROM rover_merchandise WHERE item_id=? AND rover_id=?");
		DbConnect dbc3 = dbm.createPreparedStatement("INSERT INTO rover_merchandise SET size=?, quantity=?, item_id=?, rover_id=?");
		DbConnect dbc4 = dbm.createPreparedStatement("UPDATE rover_merchandise SET size=?, quantity=? WHERE item_id=? AND rover_id=?");
		
		while(dbc1.next()) {
			int item_id = dbc1.getInt("item_id");
			dbc2.setInt(1, item_id);
			dbc2.setInt(2, app_id);
			dbc2.executeQuery();
			if(dbc2.next()) {
				dbc4.setString(1, request.getParameter("size_"+item_id));
				dbc4.setInt(2, request.getParameter("quantity_"+item_id));
				dbc4.setInt(3, item_id);
				dbc4.setInt(4, app_id);
				dbc4.executeRepetiveUpdate();
			} else {
				dbc3.setString(1, request.getParameter("size_"+item_id));
				dbc3.setInt(2, request.getParameter("quantity_"+item_id));
				dbc3.setInt(3, item_id);
				dbc3.setInt(4, app_id);
				dbc3.executeRepetiveUpdate();
			}
		}
		
		dbc1.endQuery();
		dbc2.endQuery();
		dbc3.endQuery();
		dbc4.endQuery();
		dbm.close();
		
		response.sendRedirect("/moot/pages/application2011/merchandise_done.jsp");
	}

}
