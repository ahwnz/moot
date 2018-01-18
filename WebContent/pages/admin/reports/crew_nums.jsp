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
<moot:mootreport name="Crew Numbers">

    <%@ page import="redcloud.db.*"%>

<h2>Crew Numbers</h2>

<% 
DbManager dbm = new DbManager("jdbc/moot");
dbm.open();
DbConnect dbc1 = dbm.createPreparedStatement("SELECT DISTINCT(rover_crew) FROM rover ORDER BY rover_crew");
DbConnect dbc2 = dbm.createPreparedStatement("SELECT COUNT(*) FROM rover WHERE rover_crew=?");
%>

<table cellpadding=2 border=1 align='center'>
<tr><th nowrap>Rover Crew</th><th nowrap>Number</th></tr>
<%
dbc1.executeQuery();
while(dbc1.next()) {
	String crew = dbc1.getString(1);
	dbc2.setString(1, crew);
	dbc2.executeQuery();
	if(dbc2.next()) { 
		%><tr><td><%=crew%></td><td align='center'><%=dbc2.getInt(1)%></td></tr><%
	}
}
%>

</table>

<%
dbc1.endQuery();
dbc2.endQuery();
dbm.close();
%>

</moot:mootreport>