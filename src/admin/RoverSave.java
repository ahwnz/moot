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
import java.util.Calendar;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import redcloud.db.*;

/**
 * Servlet implementation class RoverSave
 */
public class RoverSave extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RoverSave() {
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
		cleanup: {
		
			dbm.open();
			
			int rover_id = Integer.parseInt(request.getParameter("appid"));
			
			String delete = request.getParameter("delete");
			if(delete!=null && !delete.equals("")) {
				dbm.doUpdate("DELETE FROM rover WHERE rover_id="+rover_id);
				dbm.doUpdate("DELETE FROM medical WHERE rover_id="+rover_id);
				dbm.doUpdate("DELETE FROM payment WHERE rover_id="+rover_id);
				dbm.doUpdate("DELETE FROM rover_merchandise WHERE rover_id="+rover_id);
				break cleanup;
			}
			
			String sqlStmt = "rover SET first_name=?, last_name=?, nickname=?, date_of_birth=?, rover_crew=?, region=?, " +
				"address=?, home_phone=?, work_phone=?, mobile_phone=?, email=?, sex=?, rover_status=?, transport_type=?, "+
				"transport_specific_arrival=?, transport_specific_departure=?, church_service=?, specific_skills=?, "+
				"service_skills=?, tour_pref_1=?, tour_pref_2=?, tour_pref_3=?, tour_assigned=?, accommodation=?, valid=?, "+
				"rrl_aprove=?, staff=?, staff_license=?, staff_manual=?, staff_warrant=?, staff_skills=?, denom=?, "+
                                "service_years=?, moot_status=?";
			
			if(rover_id==0) {
				sqlStmt = "INSERT INTO " + sqlStmt + ", apply_date=?";
			} else {
				sqlStmt = "UPDATE " + sqlStmt + " WHERE rover_id="+rover_id;
			}
			
			DbConnect dbc = dbm.createPreparedStatement(sqlStmt);
			
			dbc.setString(1, request.getParameter("first_name"));
			dbc.setString(2, request.getParameter("last_name"));
			dbc.setString(3, request.getParameter("nickname"));
			Calendar cal = Calendar.getInstance();
			cal.set(Calendar.DAY_OF_MONTH, Integer.parseInt(request.getParameter("date_of_birth_day")));
			cal.set(Calendar.MONTH, Integer.parseInt(request.getParameter("date_of_birth_month")));
			cal.set(Calendar.YEAR, Integer.parseInt(request.getParameter("date_of_birth_year")));
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
			dbc.setInt(23, request.getParameter("tour_assigned"));
			dbc.setString(24, request.getParameter("accommodation"));
			dbc.setString(25, request.getParameter("valid"));
			dbc.setString(26, request.getParameter("rrl_aprove"));
			dbc.setString(27, request.getParameter("staff"));
                        dbc.setString(28, request.getParameter("staff_license"));
                        dbc.setString(29, request.getParameter("staff_manual"));
                        dbc.setString(30, request.getParameter("staff_warrant"));
                        dbc.setString(31, request.getParameter("staff_skills"));
                        dbc.setString(32, request.getParameter("denom"));
                        dbc.setInt(33, Integer.parseInt(request.getParameter("service_years")));
                        dbc.setString(34, request.getParameter("moot_status"));
			if(rover_id==0) {
				dbc.setDate(35, Calendar.getInstance());
			}
			dbc.executeUpdate();
			
			if(rover_id==0) {
				dbc = dbm.doQuery("SELECT LAST_INSERT_ID() AS last");
				if(dbc.next()) {
					rover_id = dbc.getInt("last");
				}
				dbc.endQuery();
				
				if(rover_id==0) {
					break cleanup;
				}
			}
			
			
			dbc = dbm.doQuery("SELECT rec_id FROM medical WHERE rover_id="+rover_id);
			if(dbc.next()) {
				sqlStmt = "UPDATE medical SET contact_name=?, contact_phone=?, contact_relationship=?, moot_contact_name=?, doctor_name=?, doctor_phone=?, "+
						"doctor_address=?, medical_conditions=?, conditions=?, dietary_requirements=? WHERE rover_id=?";
			} else {
				sqlStmt = "INSERT INTO medical SET contact_name=?, contact_phone=?, contact_relationship=?, moot_contact_name=?, doctor_name=?, doctor_phone=?, "+
				"doctor_address=?, medical_conditions=?, conditions=?, dietary_requirements=?, rover_id=?";
			}
			dbc.endQuery();
			
			dbc = dbm.createPreparedStatement(sqlStmt);
			dbc.setString(1, request.getParameter("contact_name"));
			dbc.setString(2, request.getParameter("contact_phone"));
			dbc.setString(3, request.getParameter("contact_relationship"));
                        dbc.setString(4, request.getParameter("moot_contact_name"));
			dbc.setString(5, request.getParameter("doctor_name"));
			dbc.setString(6, request.getParameter("doctor_phone"));
			dbc.setString(7, request.getParameter("doctor_address"));
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
			dbc.setInt(11, rover_id);
			dbc.executeUpdate();
		
		}
		
		dbm.close();
		response.sendRedirect("/moot/pages/admin/administration.jsp?order=&oc=a");
	}

}
