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

<moot:moothead title='Payments'>
    <%@ page import="java.util.Calendar" %>
    <%@ page import="application.Constants" %>
    <%@ page import="common.DisplayUtils" %>
    <%@ page import="redcloud.db.*" %>
    <moot:mootmenu selected='payments'/>
</moot:moothead>

<moot:bodytable>

<h2>Payments</h2>

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

String sqlStmt = "SELECT rover_id, first_name, last_name, rover_crew, email, staff, tour_assigned, main_fee_recieved, main_fee_date, late_fee FROM rover";

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
		case 's':
			sqlStmt += " staff";
			break;
		case 'p':
			sqlStmt += " main_fee_date";
			break;
		case 'd':
			sqlStmt += " DESC";
	}
}


DbConnect dbc = dbm.doQuery(sqlStmt);
DbConnect dbc2 = dbm.createPreparedStatement("SELECT amount FROM payment WHERE rover_id=?");
DbConnect dbc3 = dbm.createPreparedStatement("SELECT tour_cost FROM tour WHERE tour_id=?");
DbConnect dbc4 = dbm.createPreparedStatement("SELECT m.item_cost, r.quantity FROM rover_merchandise r JOIN merchandise m ON r.item_id=m.item_id WHERE rover_id=?");
%>

<table align='center' cellpadding=4 cellspacing=0 border=1>
	<tr>
		<th nowrap><a class='listlink' href='/moot/pages/admin/payments.jsp?order=<%=order%>&oc=a' title='Order by Application ID'>Application ID</a></th>
		<th nowrap><a class='listlink' href='/moot/pages/admin/payments.jsp?order=<%=order%>&oc=f' title='Order by First Name'>First Name</a></th>
		<th nowrap><a class='listlink' href='/moot/pages/admin/payments.jsp?order=<%=order%>&oc=l' title='Order by Last Name'>Last Name</a></th>
		<th nowrap><a class='listlink' href='/moot/pages/admin/payments.jsp?order=<%=order%>&oc=c' title='Order by Rover Crew'>Rover Crew</a></th>
		<th nowrap>Email</th>
		<th nowrap><a class='listlink' href='/moot/pages/admin/payments.jsp?order=<%=order%>&oc=s' title='Order by Staff'>Staff</a></th>
		<th nowrap>Amount Payed</th>
		<th nowrap>Amount Owing</th>
		<th nowrap><a class='listlink' href='/moot/pages/admin/payments.jsp?order=<%=order%>&oc=p' title='Order by Main Fee Payment Date'>Main Fee Payment</a></th>
	</tr>
	
	<% 
	int lineNum=0;
	while(dbc.next()) { 
		int rover_id = dbc.getInt("rover_id");
		
		int amount_payed = 0;
		
		dbc2.setInt(1, rover_id);
		dbc2.executeQuery();
		while(dbc2.next()) {
			amount_payed += dbc2.getInt("amount");
		}
		
		int amount_owing = 0;
		
		if(dbc.getString("staff").equals("Y")) {
			amount_owing += Constants.STAFF_FEE;
		} else {
			amount_owing += Constants.MOOT_FEE;
		}
		
		int tour_assigned = dbc.getInt("tour_assigned");
		if(tour_assigned != 0) {
			dbc3.setInt(1, tour_assigned);
			dbc3.executeQuery();
			if(dbc3.next()) {
				amount_owing += dbc3.getInt("tour_cost");
			}
		}
		
		dbc4.setInt(1, rover_id);
		dbc4.executeQuery();
		while(dbc4.next()) {
			amount_owing += dbc4.getInt("m.item_cost")*dbc4.getInt("r.quantity");
		}

        if(dbc.getString("late_fee").equals("Y")) amount_owing += Constants.LATE_FEE;
		
		amount_owing -= amount_payed;
	
		
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
			<td><a class='listlink' href='/moot/pages/admin/payments_rover_edit.jsp?appid=<%=rover_id%>'><%=dbc.getString("first_name")%></a></td>
			<td><%=dbc.getString("last_name")%></td>
			<td><%=dbc.getString("rover_crew")%></td>
			<td><a href='mailto:<%=dbc.getString("email")%>'><%=dbc.getString("email")%></a></td>
			<td><%=dbc.getString("staff").equals("Y")?"Yes":"No"%></td>
                        <td><%=DisplayUtils.displayAmount(amount_payed)%></td>
			<td><%=DisplayUtils.displayAmount(amount_owing)%></td>
			<td><%=payment_date%></td>
		</tr>
		<% 
	} 
	%>

</table>
<%
dbc.endQuery();
dbc2.endQuery();
dbc3.endQuery();
dbc4.endQuery();
dbm.close();
%>

</moot:bodytable>
</html>