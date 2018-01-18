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
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Calendar" %>

<% 
int rover_id = Integer.parseInt(request.getParameter("appid"));

DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

DbConnect dbc = dbm.doQuery("SELECT tour_id, tour_name FROM tour");
HashMap<Integer, String> tours = new HashMap<Integer, String>();

while(dbc.next()) {
	tours.put(dbc.getInt("tour_id"), dbc.getString("tour_name"));
}

dbc = dbm.createPreparedStatement("SELECT * FROM rover WHERE rover_id=?");

dbc.setInt(1, rover_id);
dbc.executeQuery();

if(dbc.next()) {
	
	Calendar dob = dbc.getDateTime("date_of_birth");
	
	String[] months = new String[] {"January","February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
	
	String rrl_aprove = dbc.getString("rrl_aprove");
	if(rrl_aprove.equals("Y")) {
		rrl_aprove = "Approved";
	} else if(rrl_aprove.equals("N")) {
		rrl_aprove = "Not Approved";
	} else {
		rrl_aprove = "Pending";
	}
	
	HashMap<String, Boolean> specific_skills = (HashMap<String, Boolean>) dbc.getHashMap("specific_skills");
	String skills_str = "";
	for(String skill: new String[] {"builder","electrician","plumbing","painter","gardening","welding"}) {
		if(specific_skills.containsKey(skill) && specific_skills.get(skill)) {
			skills_str += skill+", ";
		}
	}

        String firstName = dbc.getString("first_name");
        String lastName = dbc.getString("last_name");
%>

<html>

<moot:moothead>
    <title>SM69TH Moot - Administration - <%=firstName%> <%=lastName%></title>
    <moot:mootmenu selected='admin'/>
</moot:moothead>

<moot:bodytable>

<h2>Application View</h2>

<table cellpadding='2' cellspacing='0' border='0'>

<tr>
	<td>Application ID:</td>
	<td><%=rover_id%></td>
</tr>
<tr>
	<td>First Name:</td>
	<td><%=firstName%></td>
</tr>
<tr>
	<td>Last Name:</td>
	<td><%=lastName%></td>
</tr>
<tr>
	<td>Nickname:</td>
	<td><%=dbc.getString("nickname")%></td>
</tr>
<tr>
	<td>Date of Birth:</td>
	<td><%=dob.get(Calendar.DAY_OF_MONTH)%>-<%=months[dob.get(Calendar.MONTH)]%>-<%=dob.get(Calendar.YEAR)%></td>
</tr>
<tr>
	<td>Sex:</td>
	<td><%=dbc.getString("sex")%></td>
</tr>
<tr>
	<td>Address</td>
	<td><%=dbc.getString("address")%></td>
</tr>
<tr>
	<td>Home Phone:</td>
	<td><%=dbc.getString("home_phone")%></td>
</tr>
<tr>
	<td>Work Phone:</td>
	<td><%=dbc.getString("work_phone")%></td>
</tr>
<tr>
	<td>Mobile Phone:</td>
	<td><%=dbc.getString("mobile_phone")%></td>
</tr>
<tr>
	<td>Email:</td>
	<td><%=dbc.getString("email")%></td>
</tr>
<tr>
	<td>Rover Crew:</td>
	<td><%=dbc.getString("rover_crew")%></td>
</tr>
<tr>
	<td>Region:</td>
	<td><%=dbc.getString("region")%></td>
</tr>
<tr>
	<td>Rover Status:</td>
	<td><%=dbc.getString("rover_status")%></td>
</tr>
<tr>
        <td>Moot Status:</td>
        <td><%=dbc.getString("moot_status")%></td>
</tr>
<tr>
	<td>Transport Type:</td>
	<td><%=dbc.getString("transport_type")%></td>
</tr>
<tr>
	<td>Transport Arrival:</td>
	<td><%=dbc.getString("transport_specific_arrival")%></td>
</tr>
<tr>
	<td>Transport Departure:</td>
	<td><%=dbc.getString("transport_specific_departure")%></td>
</tr>
<tr>
	<td>Church Service:</td>
	<td><%=dbc.getString("church_service").equals("Y")?"Yes":"No"%></td>
</tr>
<tr>
	<td>Denomination:</td>
	<td><%=dbc.getString("denom")%></td>
</tr>
<tr>
	<td>Service Skills:</td>
	<td><%=skills_str%></td>
</tr>
<tr>
	<td>Additional Skills:</td>
	<td><%=dbc.getString("service_skills")%></td>
</tr>
<tr>
        <td>Years of Service:</td>
        <td><%=dbc.getInt("service_years")%></td>
</tr>
<tr>
	<td>First Tour Preference:</td>
	<td><%=tours.get(dbc.getInt("tour_pref_1"))%></td>
</tr>
<tr>
	<td>Second Tour Preference:</td>
	<td><%=tours.get(dbc.getInt("tour_pref_2"))%></td>
</tr>
<tr>
	<td>Third Tour Preference:</td>
	<td><%=tours.get(dbc.getInt("tour_pref_3"))%></td>
</tr>
<tr>
	<td>Assigned Tour:</td>
	<td><%=tours.get(dbc.getInt("tour_assigned"))%></td>
</tr>
<tr>
	<td>Accommodation:</td>
	<td><%=dbc.getString("accommodation")%></td>
</tr>
<tr>
	<td>Valid:</td>
	<td><%=dbc.getString("valid").equals("Y")?"Validated":"Not Validated"%></td>
</tr>
<tr>
	<td>RRL Approve:</td>
	<td><%=rrl_aprove%></td>
</tr>
<tr>
	<td>Staff:</td>
	<td><%=dbc.getString("staff").equals("Y") ? "Yes" : "No"%></td>
</tr>
<tr>
	<td>Staff License:</td>
	<td><%=dbc.getString("staff_license").equals("Y") ? "Yes" : "No"%></td>
</tr>
<tr>
	<td>Staff Manual Qualified:</td>
	<td><%=dbc.getString("staff_manual").equals("Y") ? "Yes" : "No"%></td>
</tr>
<tr>
	<td>Staff Warrant:</td>
	<td><%=dbc.getString("staff_warrant")%></td>
</tr>
<tr>
	<td>Staff Skills:</td>
	<td><%=dbc.getString("staff_skills")%></td>
</tr>

</table>
</moot:bodytable>


<%
} 

dbc.endQuery();
dbm.close();
%>


