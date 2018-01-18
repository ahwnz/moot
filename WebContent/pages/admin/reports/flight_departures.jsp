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
<moot:mootreport name="Flight Arrivals">

<%@page import="redcloud.db.*" %>

<h2>Flight Departure</h2>

<%
final DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

final DbConnect dbc = dbm.doQuery("SELECT CONCAT(first_name,' ',last_name) AS full_name, email, transport_specific_arrival, transport_to FROM rover WHERE transport_type='Plane'");

%>
<table cellpadding=2 border=1 align='center'>

<tr>
	<th>Name</th>
	<th>Email</th>
	<th>Info</th>
	<th>Flight Number</th>
</tr>

<% while(dbc.next()) {%>
	<tr>
		<td><%=dbc.getString("full_name")%></td>
		<td><%=dbc.getString("email")%></td>
		<td><%=dbc.getString("transport_specific_arrival")%></td>
		<td><%=dbc.getString("transport_to")%></td>
	</tr>
<%
}

dbc.endQuery();
dbm.close();
%>
</table>
</moot:mootreport>