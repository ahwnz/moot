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
<moot:mootreport name="Additional Medical Conditions">

<%@page import="redcloud.db.*" %>

<h2>Additional Medical Conditions</h2>

<%
final DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

final DbConnect dbc = dbm.doQuery("SELECT r.rover_id, CONCAT(r.first_name,' ',r.last_name) AS full_name, m.conditions FROM rover r JOIN medical m ON r.rover_id=m.rover_id WHERE m.conditions <> ''");
%>

<table cellpadding=2 border=1 align='center'>

	<tr>
		<th nowrap> Application ID</th>
		<th nowrap>Name</th>
		<th>Conditions</th>
	</tr>

<% while(dbc.next()) {%>
	<tr>
		<td><%=dbc.getInt("r.rover_id")%></td>
		<td><%=dbc.getString("full_name")%></td>
		<td><%=dbc.getString("m.conditions")%></td>
	</tr>
<% } %>

</table>

<% 
dbc.endQuery();
dbm.close();
%>


</moot:mootreport>