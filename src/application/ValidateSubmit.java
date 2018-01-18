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
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import redcloud.db.*;
import redcloud.common.Mailer;

/**
 * Servlet implementation class ValidateSubmit
 */
public class ValidateSubmit extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ValidateSubmit() {
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
		
		int app_id = Constants.clearID(Long.parseLong(request.getParameter("appid")));

        DbConnect dbc = dbm.createPreparedStatement("SELECT valid FROM rover WHERE rover_id=?");
        dbc.setInt(1, app_id);
        dbc.executeQuery();

        if(dbc.next() && dbc.getString("valid").equals("N")) {
            DbConnect dbc1 = dbm.createPreparedStatement("UPDATE rover SET valid='Y', apply_date=? WHERE rover_id=?");
            dbc1.setDate(1, Calendar.getInstance());
            dbc1.setInt(2, app_id);
            dbc1.executeUpdate();
		
            sendRRLAproveEmail(dbm, app_id);
        }
        dbc.endQuery();
		dbm.close();
		
		response.sendRedirect("/moot/pages/application/validated.jsp?appid="+app_id);
	}
	
	
	
	private static void sendAdminEmail(Mailer mailer, int app_id) {
		String body = "Hi "+Constants.ADMIN_NAME+",\n" +
				"\n" +
				"A new Hero Moot application has been recived.\n" +
				"The Application ID is "+ app_id+".\n" +
				"\n" +
				"Cheers,\n" +
				"Hero Moot Administration System";
		
		mailer.sendTextMessage(Constants.MAIL_FROM, Constants.MAIL_REPLY_TO, Constants.ADMIN_EMAIL, "New SM69TH Application", body);
	}
	
	
	
	public static void sendRRLAproveEmail(DbManager dbm, int app_id) {
		DbConnect dbc = dbm.doQuery("SELECT first_name, last_name, nickname, sex, address, home_phone, work_phone, mobile_phone, email, rover_crew, region " +
				"FROM rover WHERE rover_id="+app_id);
		
		Mailer mailer = new Mailer();
		mailer.openSSLConnection(Constants.MAIL_SERVER, Constants.MAIL_USER, Constants.MAIL_PASSWORD, Constants.MAIL_PORT);
		sendAdminEmail(mailer, app_id);
		if(dbc.next()) {
			String region = dbc.getString("region");
			String name = "", email = "";
			if(region.equals("Region1")) {
				name = Constants.REGION_1_RRL_NAME;
				email = Constants.REGION_1_RRL_EMAIL;
			} else if(region.equals("Region2")) {
				name = Constants.REGION_2_RRL_NAME;
				email = Constants.REGION_2_RRL_EMAIL;
			} else if(region.equals("Region3")) {
				name = Constants.REGION_3_RRL_NAME;
				email = Constants.REGION_3_RRL_EMAIL;
			} else if(region.equals("Region4")) {
				name = Constants.REGION_4_RRL_NAME;
				email = Constants.REGION_4_RRL_EMAIL;
			} else if(region.equals("Region5")) {
				name = Constants.REGION_5_RRL_NAME;
				email = Constants.REGION_5_RRL_EMAIL;
			}
		
			String body = "Hi "+name+",<br>" +
					"<br>" +
					"A rover in your region has applied to attend SM69th Moot 2011. You are recieving this<br>" +
					"email becuse as Regional Rover Leader they need your aproval to attend Hero Moot.<br>" +
					"Their details are as follows:<br>" +
					"<br>Name: "+dbc.getString("first_name")+" "+dbc.getString("last_name")+
					"<br>Application ID: "+app_id+
					"<br>Nickname: "+dbc.getString("nickname")+
					"<br>Sex: "+dbc.getString("sex")+
					"<br>Rover Crew: "+dbc.getString("rover_crew")+
					"<br>Home Phone: "+dbc.getString("home_phone")+
					"<br>Work Phone: "+dbc.getString("work_phone")+
					"<br>Mobile Phone: "+dbc.getString("mobile_phone")+
					"<br>Email: "+dbc.getString("email")+
					"<br>" +
					"You can aprove or reject their application by using the links below:<br>" +
					"<br>" +
					"<a href='"+Constants.SERVER_URL+"/moot/servlet/application/RRLAproveSubmit?appid="+Constants.obscureID(app_id)+"&aprove=y' target='_blank'>Aprove Application</a><br>"+
					"<a href='"+Constants.SERVER_URL+"/moot/servlet/application/RRLAproveSubmit?appid="+Constants.obscureID(app_id)+"&aprove=n' target='_blank'>Reject Application</a><br>" +
					"<br>" +
					"If you have any questions please contact "+Constants.ADMIN_EMAIL+".<br>" +
					"<br>" +
					"Cheers,<br>" +
					"SM69TH Moot Administration<br>" +
					"<br><br>" +
					"This email contains confidental information intended for the Regional Rover Leader of<br>" +
					"Scouts New Zealand "+region+". If you have recieved this email in error please send <br>" +
					"immediately to "+Constants.ADMIN_EMAIL+" and delete this email.";
		
			mailer.sendHtmlMessage(Constants.MAIL_FROM, Constants.MAIL_REPLY_TO, email, "SM69TH Moot Application", body);
		
		
		}
		dbc.endQuery();
		mailer.closeConnection();
	}
}
