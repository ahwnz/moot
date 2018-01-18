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
<moot:mootreport name="Church Service">

<%@page import="redcloud.db.*" %>

<h2>Church Service</h2>
<%
final DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

final DbConnect dbc = dbm.doQuery("SELECT rover_id, CONCAT(first_name,' ',last_name) AS full_name, email, rover_crew FROM rover WHERE church_service='Y'");


%>
<table cellpadding=2 border=1 align='center'>

<tr>
	<th>Application ID</th>
	<th>Name</th>
	<th>Email</th>
	<th>Rover Crew</th>
</tr>

<% while(dbc.next()) { %>
	<tr>
		<td><%=dbc.getInt("rover_id")%></td>
		<td><%=dbc.getString("full_name")%></td>
		<td><%=dbc.getString("email")%></td>
		<td><%=dbc.getString("rover_crew")%></td>
	</tr>
<%
}

dbc.endQuery();
dbm.close();
%>

</table>

</moot:mootreport>