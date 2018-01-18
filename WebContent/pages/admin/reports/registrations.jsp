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
<moot:mootreport name="Registrations">

<%@page import="redcloud.db.*" %>

<h2>Registrations</h2>
<br>
<%
DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

DbConnect dbc1 = dbm.doQuery("SELECT rover_id, CONCAT(first_name,' ',last_name) AS full_name, nickname, rover_crew, moot_number FROM rover WHERE registered = 'Y' ORDER BY rover_id");
DbConnect dbc2 = dbm.doQuery("SELECT rover_id, CONCAT(first_name,' ',last_name) AS full_name, nickname, rover_crew, moot_number FROM rover WHERE registered = 'N' ORDER BY rover_id");

%>
<h3>Registered</h3>
<table cellpadding=2 border=1 align='center'>
    <tr><th>Application ID</th><th>Name</th><th>Nickname</th><th>Crew</th><th>Moot Number</th></tr>
    <% while(dbc1.next()) { %>
    <tr>
        <td><%=dbc1.getInt("rover_id")%></td>
        <td><%=dbc1.getString("full_name")%></td>
        <td><%=dbc1.getString("nickname")%></td>
        <td><%=dbc1.getString("rover_crew")%></td>
        <td><%=dbc1.getInt("moot_number")%></td>
    </tr>
    <% } %>
</table>
<br>
<h3>Not Registered</h3>
<table cellpadding=2 border=1 align='center'>
    <tr><th>Application ID</th><th>Name</th><th>Nickname</th><th>Crew</th><th>Moot Number</th></tr>
    <% while(dbc2.next()) { %>
    <tr>
        <td><%=dbc2.getInt("rover_id")%></td>
        <td><%=dbc2.getString("full_name")%></td>
        <td><%=dbc2.getString("nickname")%></td>
        <td><%=dbc2.getString("rover_crew")%></td>
        <td><%=dbc2.getInt("moot_number")%></td>
    </tr>
    <% } %>
</table>
<%
dbc1.endQuery();
dbc2.endQuery();
dbm.close();
%>

</moot:mootreport>