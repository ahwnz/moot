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

<%@ page import='redcloud.db.*' %>

<% 
DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

DbConnect dbc = dbm.createPreparedStatement("SELECT CONCAT(first_name, ' ', last_name) AS full_name, rover_crew, region, home_phone, work_phone, mobile_phone, "+
		"email, transport_type, transport_specific_arrival, transport_specific_departure, transport_to, transport_from, need_accomodation FROM rover WHERE rover_id=?");

int rover_id = Integer.parseInt(request.getParameter("appid"));

dbc.setInt(1, rover_id);
dbc.executeQuery();

if(dbc.next()) {
	String transport_type = dbc.getString("transport_type");
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

    String fullName = dbc.getString("full_name");

	%>

    <html>

    <moot:moothead>
        <title>Hero Moot - Transport - <%=fullName%></title>
        <moot:mootmenu selected='transport'/>
    </moot:moothead>

    <moot:bodytable>

    <h2>Transport Edit</h2>

    <form action='/moot/servlet/admin/TransportSave' method='POST'>
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
		<td>Transport Type:</td>
		<td><select name='transport_type'>
			<option value='Plane'<%=transport_type.equals("Plane")?" selected":""%>>Plane</option>
			<option value='Bus'<%=transport_type.equals("Bus")?" selected":""%>>Bus</option>
			<option value='Train'<%=transport_type.equals("Train")?" selected":""%>>Train</option>
			<option value='OwnChch'<%=transport_type.equals("OwnChch")?" selected":""%>>Own to Christchurch</option>
			<option value='OwnSite'<%=transport_type.equals("OwnSite")?" selected":""%>>Own to Site</option>
		</select></td>
	</tr>
	<tr>
		<td>Transport Detail (Arrival):</td>
		<td><textarea name='transport_specific_arrival'><%=dbc.getString("transport_specific_arrival")%></textarea></td>
	</tr>
	<tr>
		<td>Flight Number (Arrival):</td>
		<td><input type='text' name='transport_to' value='<%=dbc.getString("transport_to")%>'></input></td>
	</tr>
    <tr>
        <td>Wednesday Accomodation:</td>
        <td><select name='need_accomodation'>
        <option value='Y'<%=dbc.getString("need_accomodation").equals("Y")?" selected":""%>>Yes</option>
        <option value='N'<%=dbc.getString("need_accomodation").equals("N")?" selected":""%>>No</option>
        </select></td>
    </tr>
	<tr>
		<td>Transport Detail (Departure):</td>
		<td><textarea name='transport_specific_departure'><%=dbc.getString("transport_specific_departure")%></textarea></td>
	</tr>
	<tr>
		<td>Flight Number (Departure):</td>
		<td><input type='text' name='transport_to' value='<%=dbc.getString("transport_from")%>'></input></td>
	</tr>
	<tr>
		<td><button onclick='doSubmit(); return false;'>Save</button></td>
		<td><a href='/moot/pages/admin/transport.jsp?order=&oc=a'>Cancel</a></td>
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