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


<% 
DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

DbConnect dbc = dbm.doQuery("SELECT tour_id, tour_name FROM tour");
ArrayList<Integer> tour_id_list = new ArrayList<Integer>();
ArrayList<String> tour_name_list = new ArrayList<String>();

while(dbc.next()) {
	tour_id_list.add(dbc.getInt("tour_id"));
	tour_name_list.add(dbc.getString("tour_name"));
}


dbc = dbm.createPreparedStatement("SELECT CONCAT(first_name, ' ', last_name) AS full_name, rover_crew, region, home_phone, work_phone, mobile_phone, "+
		"email, tour_pref_1, tour_pref_2, tour_pref_3, tour_assigned FROM rover WHERE rover_id=?");


int rover_id = Integer.parseInt(request.getParameter("appid"));

dbc.setInt(1, rover_id);
dbc.executeQuery();

if(dbc.next()) {
	String region = dbc.getString("region");
	String region_name = "";
	
	if(region.equals("Region1")) {
		region_name = "Upper North Island";
	} else if(region.equals("Region2")) {
		region_name = "Central North Island";
	} else if(region.equals("Region3")) {
		region_name = "Lower North Island";
	} else if(region.equals("Region4")) {
		region_name = "Upper South Island";
	} else if(region.equals("Region5")) {
		region_name = "Lower South Island";
	} else if(region.equals("Australia")) {
		region_name = "Australia";
	} else if(region.equals("Other")) {
		region_name = "Other International";
	}

	DbConnect dbc2 = dbm.createPreparedStatement("SELECT tour_name FROM tour WHERE tour_id=?");

	String tour_pref_1_name = "", tour_pref_2_name = "", tour_pref_3_name = "", tour_assigned_name = "";

	int tour_pref_1 = dbc.getInt("tour_pref_1");
	int tour_pref_2 = dbc.getInt("tour_pref_2");
	int tour_pref_3 = dbc.getInt("tour_pref_3");
	int tour_assigned = dbc.getInt("tour_assigned");

	if(tour_pref_1 > 0) {
		dbc2.setInt(1, tour_pref_1);
		dbc2.executeQuery();
		if(dbc2.next()) {
			tour_pref_1_name = dbc2.getString("tour_name");
		}
	}

	if(tour_pref_2 > 0) {
		dbc2.setInt(1, tour_pref_2);
		dbc2.executeQuery();
		if(dbc2.next()) {
			tour_pref_2_name = dbc2.getString("tour_name");
		}
	}

	if(tour_pref_3 > 0) {
		dbc2.setInt(1, tour_pref_3);
		dbc2.executeQuery();
		if(dbc2.next()) {
			tour_pref_3_name = dbc2.getString("tour_name");
		}
	}
	
	if(tour_assigned > 0) {
		dbc2.setInt(1, tour_assigned);
		dbc2.executeQuery();
		if(dbc2.next()) {
			tour_assigned_name = dbc2.getString("tour_name");
		}
	}

    String fullName = dbc.getString("full_name");
%>

<html>

<moot:moothead>
    <title>Hero Moot - Tours - <%=fullName%></title>
    <moot:mootmenu selected='tours'/>
</moot:moothead>

<moot:bodytable>

<h2>Tour Assignment Edit</h2>

<form action='/moot/servlet/admin/TourRoverSave' method='POST'>
<table cellpadding='2' cellspacing='0' border='0'>

<tr>
	<td>Application ID:</td>
	<td><%=rover_id%></td>
</tr>
<tr>
	<td>Name:</td>
	<td><%=fullName%></td>
</tr>
<tr>
	<td>Rover Crew:</td>
	<td><%=dbc.getString("rover_crew")%></td>
</tr>
<tr>
	<td>Region:</td>
	<td><%=region_name%></td>
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
	<td>First Preference:</td>
	<td><%=tour_pref_1_name%></td>
</tr>
<tr>
	<td>Second Preference:</td>
	<td><%=tour_pref_2_name%></td>
</tr>
<tr>
	<td>Third Preference:</td>
	<td><%=tour_pref_3_name%></td>
</tr>
<tr>
	<td>Assigned Tour</td>
	<moot:hasrole role="mootadmin,mootoffsite">
		<td><select name='tour_assigned'>
			<option value='0'<%=tour_assigned==0?" selected":""%>>- unassigned-</option>
			<%for(int i=0; i<tour_id_list.size(); i++) { 
				int tour_id = tour_id_list.get(i);
			%>
				<option value='<%=tour_id%>'<%=tour_id==tour_assigned?" selected":""%>><%=tour_name_list.get(i)%></option>
			<% } %>
		</select></td>
	</moot:hasrole>
	<!--<moot:nothasrole role="mootadmin, mootoffsite">
		<td><%=tour_assigned_name%></td>
	</moot:nothasrole>-->
</tr>
<tr>
	<td><button onclick='doSubmit(); return false;'>Save</button></td>
	<td><a href='/moot/pages/admin/tours.jsp?order=&oc=a'>Cancel</a></td>
</tr>

</table>

<input type='hidden' name='appid' id='appid' value='<%=rover_id%>'></input>

</form>

</moot:bodytable>

<%
} 

dbc.endQuery();
dbm.close();
%>



<script>

function doSubmit() {
	document.forms[0].submit();
}

</script>

</html>