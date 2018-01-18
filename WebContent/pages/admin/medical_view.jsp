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
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.HashMap" %>

<% 
DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

int rover_id = Integer.parseInt(request.getParameter("appid"));

DbConnect dbc = dbm.createPreparedStatement("SELECT * FROM rover WHERE rover_id=?");
dbc.setInt(1, rover_id);
dbc.executeQuery();

DbConnect dbc2 = dbm.createPreparedStatement("SELECT * FROM medical WHERE rover_id=?");
dbc2.setInt(1, rover_id);
dbc2.executeQuery();

if(dbc.next() && dbc2.next()) {
	
	Calendar dob = dbc.getDateTime("date_of_birth");
	
	String[] months = new String[] {"January","February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
	
	HashMap<String, Boolean> medical_conditions = (HashMap<String, Boolean>) dbc2.getHashMap("medical_conditions");
	String cond_str = "";
	for(String cond: new String[] {"asthma","insect_allergy","hay_fever","haemophilia","fainting","epilepsy","heart_condition","rheumatic_fever", 
			"diabetes","food_allergy","penicillin_allergy","sleep_walking"}) {
		if(medical_conditions.containsKey(cond) && medical_conditions.get(cond)) {
			cond_str += cond + ", ";
		}
	}

    String firstName = dbc.getString("first_name");
    String lastName = dbc.getString("last_name");
%>

<html>

<moot:moothead>
    <title>Hero Moot - Medical - <%=firstName%> <%=lastName%></title>
    <moot:mootmenu selected='medical'/>
</moot:moothead>
<moot:bodytable>

<h2>Medical Information</h2>

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
	<td>Address:</td>
	<td><%=dbc.getString("address")%></td>
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
	<td>Contact Name:</td>
	<td><%=dbc2.getString("contact_name")%></td>
</tr>
<tr>
	<td>Contact Phone:</td>
	<td><%=dbc2.getString("contact_phone")%></td>
</tr>

<tr>
	<td>Contact Address:</td>
	<td><%=dbc2.getString("contact_address")%></td>
</tr>
<tr>
	<td>Doctor Name:</td>
	<td><%=dbc2.getString("doctor_name")%></td>
</tr>
<tr>
	<td>Doctor Phone:</td>
	<td><%=dbc2.getString("doctor_phone")%></td>
</tr>
<tr>
	<td>Doctor Address:</td>
	<td><%=dbc2.getString("doctor_address")%></td>
</tr>
<tr>
	<td>Moot Contact:</td>
	<td><%=dbc2.getString("moot_contact_name")%></td>
</tr>
<tr>
	<td>Medical Conditions</td>
	<td><%=cond_str%></td>
</tr>
<tr>
	<td>Additional Conditions:</td>
	<td><%=dbc2.getString("conditions")%></td>
</tr>
<tr>
	<td>Dietary Requirements:</td>
	<td><%=dbc2.getString("dietary_requirements")%></td>
</tr>

</table>

</moot:bodytable>
<%
}

dbc.endQuery();
dbc2.endQuery();
dbm.close();
%>

</html>