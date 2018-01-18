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
import application.ApplicationSubmit;
import application.Constants;
import application.ValidateSubmit;

/**
 * Servlet implementation class SendValidateEmail
 */
public class SendValidateEmail extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SendValidateEmail() {
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
		if(null != request.getParameter("appid")) {
			final int rover_id = Integer.parseInt(request.getParameter("appid"));
			
			final DbManager dbm = new DbManager("jdbc/moot");
			dbm.open();
			
			final DbConnect dbc = dbm.createPreparedStatement("SELECT first_name, email FROM rover WHERE rover_id = ?");
			dbc.setInt(1,rover_id);
			dbc.executeQuery();
			
			final Mailer mailer = new Mailer();
			final long obId = Constants.obscureID(rover_id);
			if(dbc.next() && mailer.openConnection(Constants.MAIL_SERVER, Constants.MAIL_USER, Constants.MAIL_PASSWORD)) {
				String body = 	"Hi "+ dbc.getString("first_name")+",<br>" +
								"<br>" +
								"Your application  for Hero Moot 2010 needs to be validated.<br>" +
								"Please check your details <a href='"+Constants.SERVER_URL+"/moot/pages/application/personal_details.jsp?id1="+obId+"&id2="+Constants.obscureID(rover_id)+"' target='_blank'>here</a> and click the link below to validate.<br>"+
								"<br>" +
								"<a href='"+Constants.SERVER_URL+"/moot/servlet/application/ValidateSubmit?appid="+obId+"' target='_blank'>Validate Application</a><br>" +
								"<br>" +
								"The application will now be sent to your Regional Rover Leader for approval.<br>" +
								"Your Application ID is "+rover_id+".<br>"+
								"<br>" +
								"In order to finalise your application, a deposit of $100 minimum must be received. Please send this through as soon as possible, to secure your place at Hero Moot 2010.<br>"+
								"Deposits are non-refundable, but are transferrable to new applicants, should you later decide that you won’t attend Hero Moot 2010.<br>"+
								"Please do not send cash. All cheques to be made payable to Scouts NZ Rover Moot, and posted to Hero Moot, PO Box 6231, Upper Riccarton, Christchurch 8442.<br>"+
								"If you would like to pay by internet transfer, please email admin@heromoot.com for the banking details. Do not reply directly to this email.<br>"+
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
				
				mailer.sendHtmlMessage(Constants.MAIL_FROM, Constants.MAIL_REPLY_TO, dbc.getString("email"), "Hero Moot Application", body);
				mailer.closeConnection();
			}
			
			dbc.endQuery();
			dbm.close();
			
			response.sendRedirect("/moot/pages/admin/utils/send_validation_email.jsp?appid="+rover_id);
		}
	}

}
