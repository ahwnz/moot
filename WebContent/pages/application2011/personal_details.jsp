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

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="page_head.jsp" %>

<%@ page import="redcloud.db.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Calendar" %>

<% 
int id1 = (int) Long.parseLong(request.getParameter("id1"))%(256*1025);
int id2 = (int) Long.parseLong(request.getParameter("id2"))%(256*1025);
if(id1==id2) {
%>

<h2>Personal Details</h2>


<table cellpadding='2' cellspacing='0' border='0'>

<% 
DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

DbConnect dbc = dbm.doQuery("SELECT tour_id, tour_name FROM tour");
HashMap<Integer, String> tours = new HashMap<Integer, String>();

while(dbc.next()) {
	tours.put(dbc.getInt("tour_id"), dbc.getString("tour_name"));
}

dbc = dbm.createPreparedStatement("SELECT * FROM rover WHERE rover_id=?");

dbc.setInt(1, id1);
dbc.executeQuery();

if(dbc.next()) {
	
	Calendar dob = dbc.getDateTime("date_of_birth");
	
	String[] months = new String[] {"January","Febuary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
	
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
%>

<tr>
	<td>Application ID:</td>
	<td><%=id1%></td>
</tr>
<tr>
	<td>First Name:</td>
	<td><%=dbc.getString("first_name")%></td>
</tr>
<tr>
	<td>Last Name:</td>
	<td><%=dbc.getString("last_name")%></td>
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
	<td>Transport Type:</td>
	<td><%=dbc.getString("transport_type")%></td>
</tr>
<tr>
	<td>Transport Specific:</td>
	<td><%=dbc.getString("transport_specific")%></td>
</tr>
<tr>
	<td>Church Service:</td>
	<td><%=dbc.getString("church_service").equals("Y")?"Yes":"No"%></td>
</tr>
<tr>
	<td>Service Skills</td>
	<td><%=skills_str%></td>
</tr>
<tr>
	<td>Additional Skills:</td>
	<td><%=dbc.getString("service_skills")%></td>
</tr>
<tr>
	<td>First Tour Preference</td>
	<td><%=tours.get(dbc.getInt("tour_pref_1"))%></td>
</tr>
<tr>
	<td>Second Tour Preference</td>
	<td><%=tours.get(dbc.getInt("tour_pref_2"))%></td>
</tr>
<tr>
	<td>Third Tour Preference</td>
	<td><%=tours.get(dbc.getInt("tour_pref_3"))%></td>
</tr>
<tr>
	<td>Assigned Tour</td>
	<td><%=tours.get(dbc.getInt("tour_assigned"))%></td>
</tr>
<tr>
	<td>Accommodation:</td>
	<td><%=dbc.getString("accommodation")%></td>
</tr>
<tr>
	<td>Valid:</td>
	<td><%=dbc.getString("church_service").equals("Y")?"Validated":"Not Validated"%></td>
</tr>
<tr>
	<td>RRL Approve:</td>
	<td><%=rrl_aprove%></td>
</tr>

<%
} 

dbc.endQuery();
dbm.close();

}
%>

</table>

<%@ include file="page_foot.jsp" %>