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
 * Servlet implementation class CombineSubmit
 */
public class CombineSubmit extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CombineSubmit() {
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
		
		DbConnect dbc = dbm.createPreparedStatement("UPDATE rover SET rover_crew=? WHERE rover_crew=?");
		
		String new_name = "";
		if(request.getParameter("new_name")!=null) {
			new_name = request.getParameter("new_name");
		}
		
		String old_names = "";
		if(request.getParameter("old_names_str")!=null) {
			old_names = request.getParameter("old_names_str");
		}
		if(old_names.endsWith(",")) {
			old_names = old_names.substring(0, old_names.length()-1);
		}
		response.getWriter().print(old_names);
		
		for(String old_name: old_names.split(",")) {
			dbc.setString(1, new_name);
			dbc.setString(2, old_name);
			dbc.executeRepetiveUpdate();
		}
		
		dbc.end();
		dbm.close();
		
		response.sendRedirect("/moot/pages/admin/utils/crew_name_combine.jsp");
	}

}
