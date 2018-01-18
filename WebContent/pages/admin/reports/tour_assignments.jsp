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
<%@taglib uri='WEB-INF/moot-utils.tld' prefix ='moot'%>
<moot:mootreport name="Tour Assignments">

<%@page import="redcloud.db.*" %>

<h2>Tour Assignments</h2>

<%
DbManager dbm = new DbManager("jdbc/moot"); //Create database object using "jdbc/moot" context
dbm.open(); //Open connection to database

String sqlStmt = "SELECT tour_id, tour_name FROM tour";

int tid = 0;

if(request.getParameter("tid")!=null) { //check if tour id is specified in url
	tid = Integer.parseInt(request.getParameter("tid"));
	if(tid!=0) sqlStmt += " WHERE tour_id="+tid;
}

//Query to get list of tours
DbConnect dbc1 = dbm.doQuery(sqlStmt);

//Query to get the number of rovers assigned to a tour
DbConnect dbc2 = dbm.createPreparedStatement("SELECT COUNT(*) AS total FROM rover WHERE tour_assigned=?");

//Query to get rover information
DbConnect dbc3 = dbm.createPreparedStatement("SELECT rover_id, CONCAT(first_name,' ',last_name) AS full_name, rover_crew FROM rover WHERE tour_assigned=?");

%>
<table cellpadding=2 border=1 align='center'>

<%

while(dbc1.next()) { //Loop through tours
	int tour_id = dbc1.getInt("tour_id");
	String tour_name = dbc1.getString("tour_name");
	
	dbc2.setInt(1, tour_id);
	dbc3.setInt(1, tour_id);
	dbc2.executeQuery();
	dbc3.executeQuery();
	
	int count = 0;
	if(dbc2.next()) {
		count = dbc2.getInt("total");
	}
	
	%>
	<tr><th colspan=3 nowrap><%=tour_name%> (<%=count%>)</th></tr>
	<tr>
		<th nowrap>Application ID</th>
		<th nowrap>Name</th>
		<th nowrap>Rover Crew</th>
	</tr>
	
	<% while(dbc3.next()) {%> <%-- Loop through rovers on the particular tour --%>
		<tr>
			<td><%=dbc3.getInt("rover_id")%></td>
			<td><%=dbc3.getString("full_name")%></td>
			<td><%=dbc3.getString("rover_crew")%></td>
		</tr>
	<% } %>
	
	<tr><td colspan=3><br></td></tr>
	
	<%
}

//Close queries and database connection
dbc1.endQuery();
dbc2.endQuery();
dbc3.endQuery();
dbm.close();
%>

</table>

</moot:mootreport>