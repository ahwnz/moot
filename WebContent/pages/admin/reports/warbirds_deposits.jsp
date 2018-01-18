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
<moot:mootreport name="Warbirds Deposits">

<%@page import="redcloud.db.*" %>

<h2>Warbirds Deposits</h2>

<%
DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

final int WARBIRDS_ID = 1;

DbConnect dbc1 = dbm.createPreparedStatement("SELECT COUNT(*) AS total FROM rover WHERE tour_assigned=?");

DbConnect dbc2 = dbm.createPreparedStatement("SELECT rover_id, CONCAT(first_name,' ',last_name) AS full_name, rover_crew FROM rover WHERE tour_assigned=?");

DbConnect dbc3 = dbm.createPreparedStatement("SELECT amount FROM payment WHERE rover_id=?");

dbc1.setInt(1, WARBIRDS_ID);
dbc1.executeQuery();

int count = 0;
if(dbc1.next()) {
	count = dbc1.getInt("total");
}
dbc1.endQuery();

dbc2.setInt(1, WARBIRDS_ID);
dbc2.executeQuery();

%>

<table cellpadding=2 border=1 align='center'>
	<tr><th colspan=4 nowrap>Warbirds (<%=count%>)</th></tr>
	
	<tr>
		<th nowrap>Application ID</th>
		<th nowrap>Name</th>
		<th nowrap>Rover Crew</th>
		<th nowrap>Deposit</th>
	</tr>
	<% 
	int rover_id;
	while(dbc2.next()) {
		rover_id = dbc2.getInt("rover_id");
		
		dbc3.setInt(1, rover_id);
		dbc3.executeQuery();
		
		int total_payed = 0;
		while(dbc3.next()) {
			total_payed += dbc3.getInt("amount");
		}
		
		String deposit;
		if(total_payed >= 350) {
			deposit = "<div style='color:black'>Paid</div>";
		}
		else {
			deposit = "<div style='color:red'>Not Paid</div>";
		}
		
		%><tr>
			<td><%=rover_id%></td>
			<td><%=dbc2.getString("full_name")%></td>
			<td><%=dbc2.getString("rover_crew")%></td>
			<td><%=deposit%></td>
		</tr><%
	}
	%>

</table>

<%

dbc2.endQuery();
dbc3.endQuery();
dbm.close();
%>

</moot:mootreport>