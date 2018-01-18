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
<html>

<moot:moothead title='Tours'>
    <%@ page import="java.util.Calendar" %>
    <%@ page import="redcloud.db.*" %>
    <moot:mootmenu selected='tours'/>
</moot:moothead>

<moot:bodytable>



<h2>Off Site Tours</h2>

<%
DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

String order = "";

if(request.getParameter("order")!=null) {
	order = request.getParameter("order");
}

if(request.getParameter("oc")!=null) {
	char oc = request.getParameter("oc").charAt(0);
	String newOrder = ""+oc;
	if(order.length()==0) {
	} else if(order.charAt(0)==oc) {
		newOrder += 'd';
	} else {
		newOrder += order.charAt(0);
	}
	for(int i=1; i<order.length(); i++) {
		if(order.charAt(i)!=oc) {
			newOrder += order.charAt(i);
		}
	}
	for(int i=0; i<newOrder.length()-1; i++) {
		if(newOrder.charAt(i)=='d' && newOrder.charAt(i+1)=='d') {
			newOrder = newOrder.substring(0,i) + newOrder.substring(i+2);
		}
	}
	order = newOrder;
}

String sqlStmt = "SELECT rover_id, first_name, last_name, rover_crew, tour_pref_1, tour_pref_2, tour_pref_3, tour_assigned, main_fee_recieved, main_fee_date FROM rover";

boolean first = true;
for(int i=0; i<order.length(); i++) {
	if(first) {
		first = false;
		sqlStmt += " ORDER BY";
	} else if(order.charAt(i)!='d') {
		sqlStmt += ",";
	}
	switch(order.charAt(i)) {
		case 'a':
			sqlStmt += " rover_id";
			break;
		case 'f':
			sqlStmt += " first_name";
			break;
		case 'l':
			sqlStmt += " last_name";
			break;
		case 'c':
			sqlStmt += " rover_crew";
			break;
		case '1':
			sqlStmt += " tour_pref_1";
			break;
		case '2':
			sqlStmt += " tour_pref_2";
			break;
		case '3':
			sqlStmt += " tour_pref_3";
			break;
		case 't':
			sqlStmt += " tour_assigned";
			break;
		case 'p':
			sqlStmt += " payment_date";
			break;
		case 'd':
			sqlStmt += " DESC";
	}
}


DbConnect dbc = dbm.doQuery(sqlStmt);
DbConnect dbc2 = dbm.createPreparedStatement("SELECT tour_name FROM tour WHERE tour_id=?");
%>

<table align='center' cellpadding=4 cellspacing=0 border=1>
	<tr>
		<th nowrap><a class='listlink' href='/moot/pages/admin/tours.jsp?order=<%=order%>&oc=a' title='Order by Application ID'>Application ID</a></th>
		<th nowrap><a class='listlink' href='/moot/pages/admin/tours.jsp?order=<%=order%>&oc=f' title='Order by First Name'>First Name</a></th>
		<th nowrap><a class='listlink' href='/moot/pages/admin/tours.jsp?order=<%=order%>&oc=l' title='Order by Last Name'>Last Name</a></th>
		<th nowrap><a class='listlink' href='/moot/pages/admin/tours.jsp?order=<%=order%>&oc=c' title='Order by Rover Crew'>Rover Crew</a></th>
		<th nowrap><a class='listlink' href='/moot/pages/admin/tours.jsp?order=<%=order%>&oc=1' title='Order by First Preference'>First Preference</a></th>
		<th nowrap><a class='listlink' href='/moot/pages/admin/tours.jsp?order=<%=order%>&oc=2' title='Order by Second Preference'>Second Preference</a></th>
		<th nowrap><a class='listlink' href='/moot/pages/admin/tours.jsp?order=<%=order%>&oc=3' title='Order by Third Preference'>Third Preference</a></th>
		<th nowrap><a class='listlink' href='/moot/pages/admin/tours.jsp?order=<%=order%>&oc=p' title='Order by Payment Date'>Payment Date</a></th>
		<th nowrap><a class='listlink' href='/moot/pages/admin/tours.jsp?order=<%=order%>&oc=t' title='Order by Assigned Tour'>Tour Assigned</a></th>
	</tr>
	
	<% 
	int lineNum=0;
	while(dbc.next()) { 
		int rover_id = dbc.getInt("rover_id");
		
		String tour_pref_1_name = "", tour_pref_2_name = "", tour_pref_3_name = "", tour_assigned_name = "";
		
		int tour_pref_1 = Integer.parseInt(dbc.getString("tour_pref_1"));
		int tour_pref_2 = Integer.parseInt(dbc.getString("tour_pref_2"));
		int tour_pref_3 = Integer.parseInt(dbc.getString("tour_pref_3"));
		int tour_assigned = Integer.parseInt(dbc.getString("tour_assigned"));
		
		if(tour_pref_1 > 0) {
			dbc2.setInt(1, tour_pref_1);
			dbc2.executeQuery();
			dbc2.next();
			tour_pref_1_name = dbc2.getString("tour_name");
		}
		
		if(tour_pref_2 > 0) {
			dbc2.setInt(1, tour_pref_2);
			dbc2.executeQuery();
			dbc2.next();
			tour_pref_2_name = dbc2.getString("tour_name");
		}
		
		if(tour_pref_3 > 0) {
			dbc2.setInt(1,tour_pref_3);
			dbc2.executeQuery();
			dbc2.next();
			tour_pref_3_name = dbc2.getString("tour_name");
		}
		
		if(tour_assigned > 0) {
			dbc2.setInt(1, tour_assigned);
			dbc2.executeQuery();
			dbc2.next();
			tour_assigned_name = dbc2.getString("tour_name");
		}
		
		String payment_date = "";
		if(dbc.getString("main_fee_recieved").equals("Y")) {
			Calendar date = dbc.getDateTime("main_fee_date");
			
			String[] months = new String[] {"January","Febuary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
			
			payment_date = date.get(Calendar.DAY_OF_MONTH)+"-"+months[date.get(Calendar.MONTH)];
		}
		
		lineNum++;
		%>
		<tr<%=lineNum%2==0?" class='dkrow'":""%>>
			<td align='center'><%=rover_id%></td>
			<td><a class='listlink' href='/moot/pages/admin/tour_rover_edit.jsp?appid=<%=rover_id%>'><%=dbc.getString("first_name")%></a></td>
			<td><%=dbc.getString("last_name")%></td>
			<td><%=dbc.getString("rover_crew")%></td>
			<td><%=tour_pref_1_name%></td>
			<td><%=tour_pref_2_name%></td>
			<td><%=tour_pref_3_name%></td>
			<td><%=payment_date%></td>
			<td><%=tour_assigned_name%></td>
		</tr>
		<% 
	} %>

</table>
<%
dbc.endQuery();
dbc2.endQuery();
dbm.close();
%>

</moot:bodytable>