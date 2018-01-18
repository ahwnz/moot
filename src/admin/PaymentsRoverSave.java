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

import common.DisplayUtils;
import java.io.IOException;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import redcloud.db.*;

/**
 * Servlet implementation class PaymentsRoverSave
 */
public class PaymentsRoverSave extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PaymentsRoverSave() {
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
		
		int delete = 0;
		if(request.getParameter("delete")!=null) {
			delete = Integer.parseInt(request.getParameter("delete"));
			
			if(delete>0) {
				DbConnect dbc = dbm.createPreparedStatement("DELETE FROM payment WHERE payment_id=?");
				dbc.setInt(1, delete);
				dbc.executeUpdate();
			}
		}
		
		if(request.getParameter("save")!=null) {
			int save = Integer.parseInt(request.getParameter("save"));
			
			DbConnect dbc = dbm.createPreparedStatement("UPDATE rover SET main_fee_recieved=?, main_fee_date=?, late_fee=? WHERE rover_id=?");
			dbc.setString(1, request.getParameter("main_fee_recieved"));
			Calendar date = Calendar.getInstance();
			date.set(Calendar.DAY_OF_MONTH, Integer.parseInt(request.getParameter("payment_date_day")));
			date.set(Calendar.MONTH, Integer.parseInt(request.getParameter("payment_date_month")));
			dbc.setDate(2, date);
            dbc.setString(3, request.getParameter("late_fee"));
			dbc.setInt(4, app_id);
			dbc.executeUpdate();
			
			if(save==0) {
				dbc = dbm.createPreparedStatement("INSERT INTO payment SET rover_id=?, payment_for=?, amount=?, method=?, date=?");
				dbc.setInt(1, app_id);
				dbc.setString(2, request.getParameter("for"));
				dbc.setInt(3, DisplayUtils.parseAmount(request.getParameter("amount")));
				dbc.setString(4, request.getParameter("method"));
				
				Calendar cal = Calendar.getInstance();
				cal.set(Calendar.DAY_OF_MONTH, Integer.parseInt(request.getParameter("payment_day")));
				cal.set(Calendar.MONTH, Integer.parseInt(request.getParameter("payment_month")));
				dbc.setDate(5, cal);
				dbc.executeUpdate();
				
			} else if(save>0) {
				dbc = dbm.createPreparedStatement("UPDATE payment SET payment_for=?, amount=?, method=?, date=? WHERE payment_id=?");
				dbc.setString(1, request.getParameter("for"));
				dbc.setInt(2, DisplayUtils.parseAmount(request.getParameter("amount")));
				dbc.setString(3, request.getParameter("method"));
				
				Calendar cal = Calendar.getInstance();
				cal.set(Calendar.DAY_OF_MONTH, Integer.parseInt(request.getParameter("payment_day")));
				cal.set(Calendar.MONTH, Integer.parseInt(request.getParameter("payment_month")));
				dbc.setDate(4, cal);
				
				dbc.setInt(5, save);
				
				dbc.executeUpdate();
			}
		}
		
		if(request.getParameter("edit")!=null) {
			int edit = Integer.parseInt(request.getParameter("edit"));
			if(edit >=0 || delete>0) {
				response.sendRedirect("/moot/pages/admin/payments_rover_edit.jsp?appid="+app_id+"&edit="+edit);
			} else {
				response.sendRedirect("/moot/pages/admin/payments_rover_edit.jsp?appid="+app_id);
			}
		}
	}

}
