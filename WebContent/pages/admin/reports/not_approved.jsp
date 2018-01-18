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
<moot:mootreport name="Not Approved">

<%@page import="redcloud.db.*" %>

<%
final String region = request.getParameter("region");

final DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

final String sqlStmt = "SELECT rover_id, CONCAT(first_name,' ',last_name) AS full_name, rover_crew, region FROM rover WHERE rrl_aprove = 'P'";

final DbConnect dbc;
if(region == null) dbc = dbm.doQuery(sqlStmt);
else {
	dbc = dbm.createPreparedStatement(sqlStmt + " AND region = ?");
	dbc.setString(1, region);
	dbc.executeQuery();
}

%>
<h2>Not Approved<%=region==null?"":" ("+region+")"%></h2>

<table cellpadding=2 border=1 align='center'>
	<tr>
		<th>Application ID</th>
		<th>Name</th>
		<th>Rover Crew</th>
		<th>Region</th>
	</tr>
<% while(dbc.next()) {%>
	<tr>
		<td><%=dbc.getInt("rover_id")%></td>
		<td><%=dbc.getString("full_name")%></td>
		<td><%=dbc.getString("rover_crew")%></td>
		<td><%=dbc.getString("region")%></td>
	</tr>
<%
}
dbm.close();

%>
</table>

</moot:mootreport>