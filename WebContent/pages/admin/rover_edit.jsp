<%--  ______________________________________
     / ____________________________________ \
    / /     /        \     /         \     \ \
   / /     /          \   /           \     \ \
  / /     / _   _   ___\ /____     ___ \     \ \
 / /     / | | | | |  _| |  _ \   / _ \ \     \ \
 \ \    /  | |_| | | |_  | |_| | / / \ \ \    / /
  \ \  /   |  _  | |  _| | _  /  | | | |  \  / /
   \ \/    | | | | | |_  | |\ \  \ \_/ /   \/ /
    \ \    |_| |_| |___| |_| \_\  \___/    / /
     \ \            _       _             / /
      \ \          / \     / \           / /
       \ \        /   \   /   \         / /
        \ \      /     \ /     \       / /
         \ \    /    M O O T    \     / /
          \ \__/_________________\___/ /
           \_____Canterbury 2010______/

Copyright (c) 2009-2010, Redcloud Development, Ltd. All rights reserved
@author Alex Westphal

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib uri='WEB-INF/moot-utils.tld' prefix ='moot'%>

<%@ page import="redcloud.db.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.HashMap" %>

<% 
int rover_id = Integer.parseInt(request.getParameter("appid"));
 
DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

final String[] months = new String[] {"January","February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};

DbConnect dbc = dbm.doQuery("SELECT tour_id, tour_name FROM tour");
final ArrayList<Integer> tour_id_list = new ArrayList<Integer>();
final ArrayList<String> tour_name_list = new ArrayList<String>();

while(dbc.next()) {
	tour_id_list.add(dbc.getInt("tour_id"));
	tour_name_list.add(dbc.getString("tour_name"));
}
dbc.endQuery();



//Default Values
String first_name = "";
String last_name = "";
String nickname = "";
Calendar dob = Calendar.getInstance();
String sex = "Undecided";
String address = "";
String home_phone = "";
String work_phone = "";
String mobile_phone = "";
String email = "";
String rover_crew = "";
String region = "Region1";
String rover_status = "Full";
String transport_type = "OwnChch";
String transport_specific_arrival = "";
String transport_specific_departure = "";
String church_service = "N";
String denom = "";
HashMap<String,Boolean> specific_skills = new HashMap<String, Boolean>();
String service_skills = "";
int tour_pref_1 = 0;
int tour_pref_2 = 0;
int tour_pref_3 = 0;
int tour_assigned = 0;
String accommodation = "Tent";
String valid = "N";
String rrl_aprove = "P";
String staff = "N";
String staff_license = "N";
String staff_manual = "N";
String staff_warrant = "None";
String staff_skills = "";
String moot_status = "1";

//Medical Default Values
String contact_name = "";
String contact_phone = "";
String contact_relationship = "";
String doctor_name = "";
String doctor_phone = "";
String doctor_address = "";
HashMap<String, Boolean> medical_conditions = new HashMap<String, Boolean>();
String conditions = "";
String dietary_requirements = "";
String moot_contact_name = "";
int service_years = 0;


dbc = dbm.createPreparedStatement("SELECT first_name, last_name, date_of_birth, nickname, address, home_phone, work_phone, mobile_phone, email,"+
		"rover_crew, transport_type, transport_specific_arrival, transport_specific_departure, specific_skills, service_skills, tour_pref_1, "+
		"tour_pref_2, tour_pref_3, tour_assigned, sex, region, rover_status, church_service, accommodation, valid, rrl_aprove, staff, "+
		"denom, staff_license, staff_manual, staff_warrant, staff_skills, moot_status, service_years FROM rover WHERE rover_id=?");

dbc.setInt(1, rover_id);
dbc.executeQuery();
if(dbc.next()) {

    first_name = dbc.getString("first_name");
	last_name = dbc.getString("last_name");
	nickname = dbc.getString("nickname");
	dob = dbc.getDateTime("date_of_birth");
	sex = dbc.getString("sex");
	address = dbc.getString("address");
	home_phone = dbc.getString("home_phone");
	work_phone = dbc.getString("work_phone");
	mobile_phone = dbc.getString("mobile_phone");
	email = dbc.getString("email");
	rover_crew = dbc.getString("rover_crew");
	region = dbc.getString("region");
	rover_status = dbc.getString("rover_status");
	transport_type = dbc.getString("transport_type");
	transport_specific_arrival = dbc.getString("transport_specific_arrival");
	transport_specific_departure = dbc.getString("transport_specific_departure");
	specific_skills = (HashMap<String, Boolean>) dbc.getHashMap("specific_skills");
	service_skills = dbc.getString("service_skills");
	tour_pref_1 = dbc.getInt("tour_pref_1");
	tour_pref_2 = dbc.getInt("tour_pref_2");
	tour_pref_3 = dbc.getInt("tour_pref_3");
	tour_assigned = dbc.getInt("tour_assigned");
	church_service = dbc.getString("church_service");
        denom = dbc.getString("denom");
	accommodation = dbc.getString("accommodation");
	valid = dbc.getString("valid");
	rrl_aprove = dbc.getString("rrl_aprove");
	staff = dbc.getString("staff");
        staff_license = dbc.getString("staff_license");
        staff_manual = dbc.getString("staff_manual");
        staff_warrant = dbc.getString("staff_warrant");
        staff_skills = dbc.getString("staff_skills");
        moot_status = dbc.getString("moot_status");
        service_years = dbc.getInt("service_years");
}
dbc.endQuery();

int dob_day = dob.get(Calendar.DAY_OF_MONTH);
int dob_month = dob.get(Calendar.MONTH);
int dob_year = dob.get(Calendar.YEAR);

dbc = dbm.createPreparedStatement("SELECT contact_name, contact_phone, contact_relationship, moot_contact_name, doctor_name, doctor_phone, "+
		"doctor_address, medical_conditions, conditions, dietary_requirements FROM medical WHERE rover_id=?");

dbc.setInt(1, rover_id);
dbc.executeQuery();

if(dbc.next()) {

	contact_name = dbc.getString("contact_name");
	contact_phone = dbc.getString("contact_phone");
	contact_relationship = dbc.getString("contact_relationship");
	doctor_name = dbc.getString("doctor_name");
	doctor_phone = dbc.getString("doctor_phone");
	doctor_address = dbc.getString("doctor_address");
	medical_conditions = (HashMap<String, Boolean>) dbc.getHashMap("medical_conditions");
	conditions = dbc.getString("conditions");
	dietary_requirements = dbc.getString("dietary_requirements");
        moot_contact_name = dbc.getString("moot_contact_name");
}
dbc.endQuery();
dbm.close();
%>

<html>

<moot:moothead>
    <% if(rover_id == 0) { %>
        <title>SM69TH Moot - Administration - New Application</title>
    <% } else { %>
        <title>SM69TH Moot - Administration - <%=first_name%> <%=last_name%></title>
    <% } %>
    <moot:mootmenu selected='admin'/>
</moot:moothead>

<moot:bodytable>

<h2><%=rover_id==0?"New Application":"Application Edit"%></h2>

<form action='/moot/servlet/admin/RoverSave' method='POST'>
<table cellpadding='2' cellspacing='0' border='0'>

<tr>
	<td>Application ID:</td>
	<td><%=rover_id%></td>
</tr>
<tr>
	<td>First Name:</td>
	<td><input name='first_name' value='<%=first_name%>'></input></td>
</tr>
<tr>
	<td>Last Name:</td>
	<td><input name='last_name' value='<%=last_name%>'></input></td>
</tr>
<tr>
	<td>Nickname:</td>
	<td><input name='nickname' value='<%=nickname%>'></input></td>
</tr>
<tr>
	<td>Date of Birth:</td>
	<td>
		<select name='date_of_birth_day' id='date_of_birth_day'>
				<%for(int i=1; i<=31; i++) { %>
					<option value='<%=i%>'<%=i==dob_day?" selected":""%>><%=i%></option>
				<% } %>
		</select>
		<select name='date_of_birth_month' id='date_of_birth_month'>
			<% for(int i=0; i<months.length; i++) { %>
				<option value='<%=i%>'<%=i==dob_month?" selected":""%>><%=months[i] %></option>
			<% } %>
		</select>
		<select name='date_of_birth_year' id='date_of_birth_year'>
			<%for(int i=1970; i<=2008; i++) { %>
				<option value='<%=i%>'<%=i==dob_year?" selected":""%>><%=i%></option>
			<% } %>
		</select>
	</td>
</tr>
<tr>
	<td>Sex:</td>
	<td><select name='sex'>
		<option value='Male'<%=sex.equals("Male")?" selected":""%>>Male</option>
		<option value='Female'<%=sex.equals("Female")?" selected":""%>>Female</option>
		<option value='Undecided'<%=sex.equals("Undecided")?" selected":""%>>Undecided</option>
	</select></td>
</tr>
<tr>
	<td>Address:</td>
	<td><textarea name='address'><%=address%></textarea></td>
</tr>
<tr>
	<td>Home Phone:</td>
	<td><input name='home_phone' value='<%=home_phone%>'></input></td>
</tr>
<tr>
	<td>Work Phone:</td>
	<td><input name='work_phone' value='<%=work_phone%>'></input></td>
</tr>
<tr>
	<td>Mobile Phone:</td>
	<td><input name='mobile_phone' value='<%=mobile_phone%>'></input></td>
</tr>
<tr>
	<td>Email:</td>
	<td><input name='email' value='<%=email%>'></input></td>
</tr>
<tr>
	<td>Rover Crew:</td>
	<td><input name='rover_crew' value='<%=rover_crew%>'></input></td>
</tr>
<tr>
	<td>Region:</td>
	<td><select name='region'>
		<option value='Region1'<%=region.equals("Region1")?" selected":""%>>Upper North Island</option>
		<option value='Region2'<%=region.equals("Region2")?" selected":""%>>Central North Island</option>
		<option value='Region3'<%=region.equals("Region3")?" selected":""%>>Lower North Island</option>
		<option value='Region4'<%=region.equals("Region4")?" selected":""%>>Upper South Island</option>
		<option value='Region5'<%=region.equals("Region5")?" selected":""%>>Lower South Island</option>
		<option value='Australia'<%=region.equals("Australia")?" selected":""%>>Australia</option>
		<option value='Other'<%=region.equals("Other")?" selected":""%>>Other International</option>
	</select></td>
</tr>
<tr>
	<td>Rover Status:</td>
	<td><select name='rover_status'>
		<option value='Full'<%=rover_status.equals("Full")?" selected":""%>>Full</option>
		<option value='Associate'<%=rover_status.equals("Associate")?" selected":""%>>Associate</option>
		<option value='Squire'<%=rover_status.equals("Squire")?" selected":""%>>Squire</option>
		<option value='Leader'<%=rover_status.equals("Leader")?" selected":""%>>Leader</option>
	</select></td>
</tr>
<tr>
	<td>Moot Status:</td>
	<td><select name='moot_status'>
		<option value='1'<%=moot_status.equals("1")?" selected":""%>>Virgin Mooter</option>
		<option value='2'<%=moot_status.equals("2")?" selected":""%>>2nd Moot</option>
		<option value='3'<%=moot_status.equals("3")?" selected":""%>>3rd Moot</option>
		<option value='4'<%=moot_status.equals("4")?" selected":""%>>4th Moot</option>
                <option value='5'<%=moot_status.equals("5")?" selected":""%>>5th Moot</option>
                <option value='Lost'<%=moot_status.equals("Lost")?" selected":""%>>Lost Count</option>
	</select></td>
</tr>
<tr>
	<td>Transport Type:</td>
	<td><select name='transport_type'>
		<option value='Plane'<%=transport_type.equals("Plane")?" selected":""%>>Plane</option>
		<option value='Bus'<%=transport_type.equals("Bus")?" selected":""%>>Bus</option>
		<option value='Train'<%=transport_type.equals("Train")?" selected":""%>>Train</option>
		<option value='OwnChch'<%=transport_type.equals("OwnChch")?" selected":""%>>Own Chistchurch</option>
		<option value='OwnSite'<%=transport_type.equals("OwnSite")?" selected":""%>>Own Site</option>
	</select></td>
</tr>
<tr>
	<td>Transport Specific (Arrival):</td>
	<td><input name='transport_specific_arrival' value='<%=transport_specific_arrival%>'></input></td>
</tr>
<tr>
	<td>Transport Specific (Departure):</td>
	<td><input name='transport_specific_departure' value='<%=transport_specific_departure%>'></input></td>
</tr>
<tr>
	<td>Church Service:</td>
	<td><select name='church_service'>
		<option value='Y'<%=church_service.equals("Y")?" selected":""%>>Yes</option>
		<option value='N'<%=church_service.equals("N")?" selected":""%>>No</option>
	</select></td>
</tr>
<tr>
	<td>Denomination:</td>
	<td><select name='denom'>
		<option value=''<%=denom.equals("")?" selected":""%>></option>
		<option value='Presbyterian'<%=denom.equals("Presbyterian")?" selected":""%>>Presbyterian</option>
                <option value='Catholic'<%=denom.equals("Catholic")?" selected":""%>>Catholic</option>
                <option value='Anglican'<%=denom.equals("Anglican")?" selected":""%>>Anglican</option>
                <option value='Methodist'<%=denom.equals("Methodist")?" selected":""%>>Methodist</option>

	</select></td>
</tr>
<tr>
	<td>Service Skills:</td>
	<td><table>
		<% for(String skill: new String[] {"builder","electrician","plumbing","painter","gardening","welding"}) { 
			if(specific_skills.containsKey(skill) && specific_skills.get(skill)) {
				%><tr><td><%=skill%></td><td><input type='checkbox' name='<%=skill%>' id='<%=skill%>' checked></input></td></tr><%
			} else {
				%><tr><td><%=skill%></td><td><input type='checkbox' name='<%=skill%>' id='<%=skill%>'></input></td></tr><%
			}
		} %>
	</table></td>
</tr>
<tr>
	<td>Additional Skills:</td>
	<td><textarea name='service_skills'><%=service_skills%></textarea></td>
</tr>
<tr>
        <td>Service Years:</td>
        <td><select name="service_years">
                <% for(int i=0; i<50; i++) { %>
                <option value="<%=i%>" <%=service_years==i?"selected":""%>><%=i%></option>
                <% } %>
            </select></td>
</tr>
<tr>
	<td>First Tour Preference:</td>
	<td><select name='tour_pref_1'>
		<option value='0'<%=tour_pref_1==0?" selected":""%>>- unassigned-</option>
		<%for(int i=0; i<tour_id_list.size(); i++) { 
			int tour_id = tour_id_list.get(i);
		%>
			<option value='<%=tour_id%>'<%=tour_id==tour_pref_1?" selected":""%>><%=tour_name_list.get(i)%></option>
		<% } %>
	</select></td>
</tr>
<tr>
	<td>Second Tour Preference:</td>
	<td><select name='tour_pref_2'>
		<option value='0'<%=tour_pref_2==0?" selected":""%>>- unassigned-</option>
		<%for(int i=0; i<tour_id_list.size(); i++) { 
			int tour_id = tour_id_list.get(i);
		%>
			<option value='<%=tour_id%>'<%=tour_id==tour_pref_2?" selected":""%>><%=tour_name_list.get(i)%></option>
		<% } %>
	</select></td>
</tr>
<tr>
	<td>Third Tour Preference:</td>
	<td><select name='tour_pref_3'>
		<option value='0'<%=tour_pref_3==0?" selected":""%>>- unassigned-</option>
		<%for(int i=0; i<tour_id_list.size(); i++) { 
			int tour_id = tour_id_list.get(i);
		%>
			<option value='<%=tour_id%>'<%=tour_id==tour_pref_3?" selected":""%>><%=tour_name_list.get(i)%></option>
		<% } %>
	</select></td>
</tr>
<tr>
	<td>Assigned Tour:</td>
	<td><select name='tour_assigned'>
		<option value='0'<%=tour_assigned==0?" selected":""%>>- unassigned-</option>
		<%for(int i=0; i<tour_id_list.size(); i++) { 
			int tour_id = tour_id_list.get(i);
		%>
			<option value='<%=tour_id%>'<%=tour_id==tour_assigned?" selected":""%>><%=tour_name_list.get(i)%></option>
		<% } %>
	</select></td>
</tr>
<tr>
	<td>Accommodation:</td>
	<td><select name='accommodation'>
		<option value='Tent'<%=accommodation.equals("Tent")?" selected":""%>>Tent</option>
		<option value='Own'<%=accommodation.equals("Own")?" selected":""%>>Own Tent</option>
	</select></td>
</tr>
<tr>
	<td>Valid:</td>
	<td><select name='valid'>
		<option value='Y'<%=valid.equals("Y")?" selected":""%>>Yes</option>
		<option value='N'<%=valid.equals("N")?" selected":""%>>No</option>
	</select></td>
</tr>
<tr>
	<td>RRL Approve:</td>
	<td><select name='rrl_aprove'>
		<option value='Y'<%=rrl_aprove.equals("Y")?" selected":""%>>Approved</option>
		<option value='N'<%=rrl_aprove.equals("N")?" selected":""%>>Not Approved</option>
		<option value='P'<%=rrl_aprove.equals("P")?" selected":""%>>Pending</option>
	</select></td>
</tr>
<tr>
	<td>Staff:</td>
	<td><select name='staff'>
		<option value='Y'<%=staff.equals("Y")?" selected":""%>>Yes</option>
		<option value='N'<%=staff.equals("N")?" selected":""%>>No</option>
	</select></td>
</tr>
<tr>
	<td>Staff License:</td>
	<td><select name='staff_license'>
		<option value='Y'<%=staff_license.equals("Y")?" selected":""%>>Yes</option>
		<option value='N'<%=staff_manual.equals("N")?" selected":""%>>No</option>
	</select></td>
</tr>
<tr>
	<td>Staff Manual:</td>
	<td><select name='staff_manual'>
		<option value='Y'<%=staff_manual.equals("Y")?" selected":""%>>Yes</option>
		<option value='N'<%=staff_manual.equals("N")?" selected":""%>>No</option>
	</select></td>
</tr>
<tr>
	<td>Staff Warrant:</td>
	<td><select name='staff_warrant'>
		<option value='None'<%=staff_warrant.equals("None")?" selected":""%>>None</option>
		<option value='Keas'<%=staff_warrant.equals("Keas")?" selected":""%>>Keas</option>
                <option value='Cubs'<%=staff_warrant.equals("Cubs")?" selected":""%>>Cubs</option>
                <option value='Scouts'<%=staff_warrant.equals("Scouts")?" selected":""%>>Scouts</option>
                <option value='Venturers'<%=staff_warrant.equals("Venturers")?" selected":""%>>Venturers</option>
                <option value='Zone'<%=staff_warrant.equals("Zone")?" selected":""%>>Zone</option>
	</select></td>
</tr>
<tr>
        <td>Staff Skills:</td>
        <td><input name='staff_skills' value='<%=staff_skills%>'></input></td>
</tr>
<tr>
	<td>Contact Name:</td>
	<td><input name='contact_name' value='<%=contact_name%>'></input></td>
</tr>
<tr>
	<td>Contact Phone:</td>
	<td><input name='contact_phone' value='<%=contact_phone%>'></input></td>
</tr>
<tr>
	<td>Contact Relationship:</td>
	<td><input name='contact_relationship' value='<%=contact_relationship%>'></input></td>
</tr>
<tr>
	<td>Doctor Name:</td>
	<td><input name='doctor_name' value='<%=doctor_name%>'></input></td>
</tr>
<tr>
	<td>Doctor Phone:</td>
	<td><input name='doctor_phone' value='<%=doctor_phone%>'></input></td>
</tr>
<tr>
	<td>Doctor Address:</td>
	<td><textarea name='doctor_address'><%=doctor_address%></textarea></td>
</tr>
<tr>
	<td>Moot Contact:</td>
	<td><input name='moot_contact_name' value='<%=moot_contact_name%>'></input></td>
</tr>
<tr>
	<td>Medical Conditions:</td>
	<td><table>
		<% for(String cond: new String[] {"asthma","insect_allergy","hay_fever","haemophilia","fainting","epilepsy","heart_condition","rheumatic_fever", 
				"diabetes","food_allergy","penicillin_allergy","sleep_walking"}) {
			if(medical_conditions.containsKey(cond) && medical_conditions.get(cond)) {
				%><tr><td><%=cond%></td><td><input type='checkbox' name='<%=cond%>' id='<%=cond%>' checked></input></td></tr><%
			} else {
				%><tr><td><%=cond%></td><td><input type='checkbox' name='<%=cond%>' id='<%=cond%>'></input></td></tr><%
			}
		} %>
	</table></td>
</tr>
<tr>
	<td>Additional Condition:</td>
	<td><textarea name='conditions'><%=conditions%></textarea></td>
</tr>
<tr>
	<td>Dietary Requirements:</td>
	<td><textarea name='dietary_requirements'><%=dietary_requirements%></textarea></td>
</tr>

<tr>
	<td>
		<button onclick='doSubmit(); return false;'>Save</button>
		<% if(rover_id>0) { %>
			<button onclick='doDelete(); return false;'>Delete</button>
		<% } %>
	</td>
	<td>
		<a href='/moot/pages/admin/administration.jsp?order=&oc=a'>Cancel</a>
	</td>
</tr>


</table>

<input type='hidden' name='appid' id='appid' value='<%=rover_id%>'></input>
<input type='hidden' name='delete' id='delete' value=''></input>

</form>

<script>

function doSubmit() {
    document.forms[0].submit();
}

function doDelete() {
    if(confirm("Are you sure you want to delete <%=first_name.equals("")?"rover_"+rover_id:first_name%>'s application?")) {
        document.getElementById("delete").value="del";
        document.forms[0].submit();
    }
}

</script>

</moot:bodytable>