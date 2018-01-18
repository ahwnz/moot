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

<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri='WEB-INF/moot-utils.tld' prefix ='moot'%>
<moot:mootreport name="Australian Contingent">

<%@page import="redcloud.db.*" %>

<h2>Australian Contingent</h2>
<br>
<%
DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

DbConnect dbc = dbm.doQuery("SELECT tour_id, tour_name FROM tour");
Map<Integer, String> tours = new HashMap<Integer, String>();
tours.put(0, " - ");
while(dbc.next()) {
    tours.put(dbc.getInt("tour_id"), dbc.getString("tour_name"));
}
dbc.endQuery();

dbc = dbm.doQuery("SELECT first_name, last_name, email, moot_number, rover_crew, valid, rrl_aprove, tour_assigned FROM rover WHERE region = 'Australia'");

%>
<table cellpadding=2 border=1 align='center'>
    <tr>
        <th>First Name</th><th>Last Name</th><th>Email</th><th>Moot Number</th>
        <th>Rover Crew</th><th>Valid</th><th>RRL Approve</th><th>Tour</th>
    </tr>
    <% while(dbc.next()) {%>
    <tr>
        <td><%=dbc.getString("first_name")%></td>
        <td><%=dbc.getString("last_name")%></td>
        <td><%=dbc.getString("email")%></td>
        <td><%=dbc.getInt("moot_number")%></td>
        <td><%=dbc.getString("rover_crew")%></td>
        <td><%=dbc.getString("valid")%></td>
        <td><%=dbc.getString("rrl_aprove")%></td>
        <td><%=tours.get(dbc.getInt("tour_assigned"))%></td>
    </tr>
    <% } %>
</table>
<%
dbc.endQuery();
dbm.close();
%>

</moot:mootreport>