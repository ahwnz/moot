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
 * Copyright (c) 2009 Hero Moot Administration
 * @author Alex Westphal
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sub-license, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
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

/**
 * Servlet implementation class InfoEmailSend
 */
public class InfoEmailSend extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public InfoEmailSend() {
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
		
		int app_id = Integer.parseInt(request.getParameter("id_select"));
		
		DbManager dbm = new DbManager("jdbc/moot");
		dbm.open();
		DbConnect dbc = dbm.createPreparedStatement("SELECT first_name, email FROM rover WHERE rover_id=?");
		dbc.setInt(1, app_id);
		dbc.executeQuery();
		dbc.next();
		
		Mailer mailer = new Mailer();
		long obId = Constants.obscureID(app_id);
		mailer.openConnection(Constants.MAIL_SERVER, Constants.MAIL_USER, Constants.MAIL_PASSWORD);
		
		String body = 	"Hi "+dbc.getString("first_name")+",<br>" +
						"<br>" +
						"Click <a href='"+Constants.SERVER_URL+"/moot/pages/application/personal_details.jsp?id1="+obId+"&id2="+Constants.obscureID(app_id)+"' target='_blank'>here</a> to view you personal details.<br>"+
						"<br>"+
						"Cheers,<br>" +
						"Hero Moot Administration<br>" +
						"<br>" +
						"For more information and updates:<br>" +
						"<ul>"+
						"<li><a href='http://www.heromoot.com'>Hero Moot Website</a></li>" +
						"<li><a href='http://www.facebook.com/heromoot'>Facebook</a></li>" +
						"</ul>"+
						"<br><br>" +
						"This email contains confidental information, if you are not the intended recipient please<br>" +
						"imediatly send to "+Constants.ADMIN_EMAIL+" and delete this email.<br>";
		
		mailer.sendHtmlMessage(Constants.MAIL_FROM, Constants.MAIL_REPLY_TO, dbc.getString("email"), "Hero Moot Information", body);
		mailer.closeConnection();
		
		dbc.endQuery();
		dbm.close();
		
		response.sendRedirect("/moot/pages/admin/utilities.jsp");
	}

}
