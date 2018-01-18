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

import redcloud.db.DbConnect;
import redcloud.db.DbManager;

/**
 * Servlet implementation class AssignMootNumber
 */
public class AssignMootNumber extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AssignMootNumber() {
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
		
		DbConnect dbc1 = dbm.createPreparedStatement("SELECT rover_id FROM rover WHERE moot_number=?");
		DbConnect dbc2 = dbm.createPreparedStatement("UPDATE rover SET moot_number=? WHERE rover_id=?");
		
		int rover_id = Integer.parseInt(request.getParameter("id_list"));
		int moot_num = Integer.parseInt(request.getParameter("num_list"));
		
		dbc1.setInt(1, moot_num);
		dbc1.executeQuery();
		
		while(dbc1.next()) {
			int other_rover_id = dbc2.getInt("rover_id");
			dbc2.setInt(1, 0);
			dbc2.setInt(2, other_rover_id);
			dbc2.executeRepetiveUpdate();
		}
		
		dbc2.setInt(1, moot_num);
		dbc2.setInt(2, rover_id);
		dbc2.executeUpdate();
		
		dbc1.endQuery();
		dbm.close();
		
		response.sendRedirect("/moot/pages/admin/utils/moot_number_assign.jsp");
	}

}
