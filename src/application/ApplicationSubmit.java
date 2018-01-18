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
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import redcloud.db.*;
import redcloud.common.Mailer;

/**
 * Servlet implementation class ApplicationSubmit
 */
public class ApplicationSubmit extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ApplicationSubmit() {
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
		
		DbConnect dbc = dbm.createPreparedStatement("INSERT INTO rover SET first_name=?, last_name=?, nickname=?, date_of_birth=?, rover_crew=?, "+
				"region=?, address=?, home_phone=?, work_phone=?, mobile_phone=?, email=?, sex=?, rover_status=?, transport_type=?, "+
				"transport_specific_arrival=?, transport_specific_departure=?, church_service=?, specific_skills=?, service_skills=?, "+
				"tour_pref_1=?, tour_pref_2=?, tour_pref_3=?, accommodation=?, staff=?, staff_license=?, staff_manual=?, "+
                                "staff_warrant=?, staff_skills=?, moot_status=?, service_years=?, denom=?");
		
		dbc.setString(1, request.getParameter("first_name"));
		dbc.setString(2, request.getParameter("last_name"));
		dbc.setString(3, request.getParameter("nickname"));
                Calendar cal = Calendar.getInstance();
		String[] dobParts = request.getParameter("date_of_birth").split("/");
                cal.set(Calendar.DAY_OF_MONTH, Integer.parseInt(dobParts[0]));
                cal.set(Calendar.MONTH, Integer.parseInt(dobParts[1])-1);
		cal.set(Calendar.YEAR, Integer.parseInt(dobParts[2]));
		dbc.setDate(4, cal);
		dbc.setString(5, request.getParameter("rover_crew"));
		dbc.setString(6, request.getParameter("region"));
		dbc.setString(7, request.getParameter("address"));
		dbc.setString(8, request.getParameter("home_phone"));
		dbc.setString(9, request.getParameter("work_phone"));
		dbc.setString(10, request.getParameter("mobile_phone"));
		dbc.setString(11, request.getParameter("email"));
		dbc.setString(12, request.getParameter("sex"));
		dbc.setString(13, request.getParameter("rover_status"));
		dbc.setString(14, request.getParameter("transport_type"));
		dbc.setString(15, request.getParameter("transport_specific_arrival"));
		dbc.setString(16, request.getParameter("transport_specific_departure"));
		dbc.setString(17, request.getParameter("church_service"));
		HashMap<String, Boolean> specific_skills = new HashMap<String, Boolean>();
		for(String skill: new String[] {"builder","electrician","plumbing","painter","gardening","welding"}) {
			if(request.getParameter(skill)!=null) {
				specific_skills.put(skill, true);
			}
		}
		dbc.setHashMap(18, specific_skills);
		dbc.setString(19, request.getParameter("service_skills"));
		
		dbc.setInt(20, request.getParameter("tour_pref_1"));
		dbc.setInt(21, request.getParameter("tour_pref_2"));
		dbc.setInt(22, request.getParameter("tour_pref_3"));
		dbc.setString(23, request.getParameter("accommodation"));
                dbc.setString(24,request.getParameter("staff"));
                dbc.setString(25,request.getParameter("staff_license"));
                dbc.setString(26,request.getParameter("staff_manual"));
                dbc.setString(27,request.getParameter("staff_warrant"));
                dbc.setString(28,request.getParameter("staff_skills"));
                dbc.setString(29,request.getParameter("moot_status"));
                dbc.setString(30,request.getParameter("service_years"));
                dbc.setString(31,request.getParameter("denom"));
		dbc.executeUpdate();
		
		dbc = dbm.doQuery("SELECT LAST_INSERT_ID()");
		int app_id = 0;
		if(dbc.next()) {
			app_id = dbc.getInt(1);
		} else {
			System.out.println("Error: Can't Get Application ID.");
		}
		dbc.endQuery();
		
		dbc = dbm.createPreparedStatement("INSERT INTO medical SET rover_id=?, contact_name=?, contact_relationship=?, contact_phone=?, " +
				"doctor_name=?, doctor_address=?, doctor_phone=?, medical_conditions=?, conditions=?, dietary_requirements=?, moot_contact_name=?");
		dbc.setInt(1, app_id);
		dbc.setString(2, request.getParameter("contact_name"));
		dbc.setString(3, request.getParameter("contact_relationship"));
		dbc.setString(4, request.getParameter("contact_phone"));
		dbc.setString(5, request.getParameter("doctor_name"));
		dbc.setString(6, request.getParameter("doctor_address"));
		dbc.setString(7, request.getParameter("doctor_phone"));
		HashMap<String, Boolean> medical_conditions = new HashMap<String, Boolean>();
		for(String cond: new String[] {"asthma","insect_allergy","hay_fever","haemophilia","fainting","epilepsy","heart_condition","rheumatic_fever", 
				"diabetes","food_allergy","penicillin_allergy","sleep_walking"}) {
			if(request.getParameter(cond)!=null) {
				medical_conditions.put(cond, true);
			}
		}
		dbc.setHashMap(8, medical_conditions);
		dbc.setString(9, request.getParameter("conditions"));
		dbc.setString(10, request.getParameter("dietary_requirements"));
                dbc.setString(11, request.getParameter("moot_contact_name"));
		dbc.executeUpdate();
		
		dbc = dbm.createPreparedStatement("INSERT INTO rover_merchandise SET rover_id=?, item_id=38,quantity=?");
                dbc.setInt(1, app_id);
                dbc.setInt(2, Integer.parseInt(request.getParameter("bar_cards")));
                dbc.executeUpdate();

		dbm.close();
		
		sendValidateEmail(request, app_id);
		response.sendRedirect("/moot/pages/application2011/sent.jsp?appid="+app_id);
	}
	
	public static void sendValidateEmail(HttpServletRequest request, int app_id) {
//            Mailer mailer = new Mailer();
//            boolean open = mailer.openSSLConnection(Constants.MAIL_SERVER, Constants.MAIL_USER, Constants.MAIL_PASSWORD, Constants.MAIL_PORT);
//            if(open) {
//                mailer.sendHtmlMessage(Constants.MAIL_FROM, Constants.MAIL_REPLY_TO, "alexanderwnz@gmail.com", "Smooth Moot Application", "Test Email");
//                mailer.closeConnection();
//            } else {
//                System.err.println(mailer.getErrorMsg());
//                System.err.println("Error: Not Sent ("+app_id+")");
//            }
		Mailer mailer = new Mailer();
		long obId = Constants.obscureID(app_id);
		if(mailer.openSSLConnection(Constants.MAIL_SERVER, Constants.MAIL_USER, Constants.MAIL_PASSWORD, Constants.MAIL_PORT)) {
			String body = 	"Hi "+ request.getParameter("first_name")+",<br>" +
                                        "<br>" +
                                        "Your application  for SM69TH Moot needs to be validated.<br>" +
                                        "Please check your details <a href='"+Constants.SERVER_URL+"/moot/pages/application2011/personal_details.jsp?id1="+obId+"&id2="+Constants.obscureID(app_id)+"' target='_blank'>here</a> and click the link below to validate.<br>"+
                                        "<br>" +
                                        "<a href='"+Constants.SERVER_URL+"/moot/servlet/application/ValidateSubmit?appid="+obId+"' target='_blank'>Validate Application</a><br>" +
                                        "<br>" +
                                        "The application will now be sent to your Regional Rover Leader for approval.<br>" +
                                        "Your Application ID is "+app_id+".<br>"+
                                        "<br>" +
                                        "In order to finalise your application, a deposit of $100 minimum must be received. Please send this through as soon as possible, to secure your place at Smooth Moot 2011.<br>"+
                                        "Deposits are non-refundable, but are transferrable to new applicants, should you later decide that you won’t attend Smooth Moot 2011.<br>"+
                                        "<br>"+
                                        "Cheers,<br>" +
                                        "Smooth Moot Administration<br>" +
                                        "<br>" +
                                        "For more information and updates:<br>" +
                                        "<ul>"+
                                        "<li><a href='http://www.sm69thmoot.com/'>Smooth Moot Website</a></li>" +
                                        "<li><a href='http://www.facebook.com/pages/Rotorua-New-Zealand/SM69THmoot/106823772704664#!/pages/Rotorua-New-Zealand/SM69THmoot/106823772704664?ref=ts'>Facebook</a></li>" +
                                        "</ul>"+
                                        "<br><br>" +
                                        "This email contains confidental information, if you are not the intended recipient please<br>" +
                                        "imediatly send to "+Constants.ADMIN_EMAIL+" and delete this email.<br>";

			mailer.sendHtmlMessage(Constants.MAIL_FROM, Constants.MAIL_REPLY_TO, request.getParameter("email"), "Smooth Moot Application", body);
			mailer.closeConnection();
		} else System.err.println("Error: Validation Email send failed (ID="+app_id+").");
	}
}
