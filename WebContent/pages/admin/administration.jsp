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

<moot:moothead title='Administration'>
    <%@ page import="redcloud.db.*" %>
    <moot:mootmenu selected='admin'/>
</moot:moothead>

<moot:bodytable>

<h2>Application Administration</h2>

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

String sqlStmt = "SELECT rover_id, first_name, last_name, nickname, rover_crew, region, email, moot_number, apply_date, valid, rrl_aprove FROM rover";

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
		case 'n':
			sqlStmt += " nickname";
			break;
		case 'r':
			sqlStmt += " region";
			break;
		case 'c':
			sqlStmt += " rover_crew";
			break;
		case 'm':
			sqlStmt += " moot_number";
			break;
		case 't':
			sqlStmt += " apply_date";
			break;
		case 'v':
			sqlStmt += " valid";
			break;
		case 'p':
			sqlStmt += " rrl_aprove";
			break;
		case 'd':
			sqlStmt += " DESC";
	}
}


DbConnect dbc = dbm.doQuery(sqlStmt);
%>

<moot:hasrole role="mootadmin">
	<table align='center' width=900 cellpadding=4 cellspacing=0 border=0>
		<tr>
			<td>
				<a class='addbtn' href='/moot/pages/admin/rover_edit.jsp?appid=0' title='Add a new application'><img src='/moot/images/add.png' width='16' height='16' border='0'></a>
				<a href='/moot/pages/admin/rover_edit.jsp?appid=0' title='Add a new application'>New Application</a>
			</td>
		</tr>
	</table>
</moot:hasrole>

<table id="main" align='center' width=900 cellpadding=4 cellspacing=0 border=1>
	<tr>
		<th nowrap><a class='listlink' href='/moot/pages/admin/administration.jsp?order=<%=order%>&oc=a' title='Order by Application ID'>Application ID</a></th>
		<th nowrap><a class='listlink' href='/moot/pages/admin/administration.jsp?order=<%=order%>&oc=f' title='Order by First Name'>First Name</a></th>
		<th nowrap><a class='listlink' href='/moot/pages/admin/administration.jsp?order=<%=order%>&oc=l' title='Order by Last Name'>Last Name</a></th>
		<th nowrap><a class='listlink' href='/moot/pages/admin/administration.jsp?order=<%=order%>&oc=n' title='Order by Nickname'>Nickname</a></th>
		<th nowrap><a class='listlink' href='/moot/pages/admin/administration.jsp?order=<%=order%>&oc=c' title='Order by Rover Crew'> Rover Crew</a></th>
		<th nowrap><a class='listlink' href='/moot/pages/admin/administration.jsp?order=<%=order%>&oc=r' title='Order by Region'> Region</a></th>
		<th nowrap>Email</th>
		<th nowrap><a class='listlink' href='/moot/pages/admin/administration.jsp?order=<%=order%>&oc=m' title='Order by Moot Number'>Moot Number</a></th>
		<th nowrap><a class='listlink' href='/moot/pages/admin/administration.jsp?order=<%=order%>&oc=t' title='Order by Application Date'>Date</a></th>
		<th nowrap><a class='listlink' href='/moot/pages/admin/administration.jsp?order=<%=order%>&oc=v' title='Order by Validated'>Validated</a></th>
		<th nowrap><a class='listlink' href='/moot/pages/admin/administration.jsp?order=<%=order%>&oc=p' title='Order by RRL Approved'>RRL Aproved</a></th>
	</tr>
	
	<% 
	int lineNum=0;
	while(dbc.next()) { 
		int moot_num = dbc.getInt("moot_number");
		int rover_id = dbc.getInt("rover_id");
		String valid = dbc.getString("valid");
		String rrl_aprove = dbc.getString("rrl_aprove");
		
		String first_name = dbc.getString("first_name");
		if(first_name.equals("")) {
			first_name = "rover_"+rover_id;
		}
		
		String moot_num_str = "";
		if(moot_num != 0) {
			moot_num_str = "" + moot_num;
			if(rover_id == 114) {
				moot_num_str = "sqrt("+moot_num+")";
			}
		}
		
		lineNum++;
	%>
	<tr<%=lineNum%2==0?" class='dkrow'":""%>>
		<td align='center'><%=rover_id%></td>
		<td>
			<moot:hasrole role="mootadmin">
				<a class='listlink' href='/moot/pages/admin/rover_edit.jsp?appid=<%=rover_id%>'><%=first_name%></a>
			</moot:hasrole>
			<moot:nothasrole role="mootadmin">
				<a class='listlink' href='/moot/pages/admin/rover_view.jsp?appid=<%=rover_id%>'><%=first_name%></a>
			</moot:nothasrole>
		
		</td>
		<td><%=dbc.getString("last_name")%></td>
		<td><%=dbc.getString("nickname")%></td>
		<td><%=dbc.getString("rover_crew")%></td>
		<td><%=dbc.getString("region")%></td>
		<td><a href='mailto:<%=dbc.getString("email")%>'><%=dbc.getString("email")%></a></td>
		<td align='center'><%=moot_num_str%></td>
		<td align='center'><%=String.format("%tF", dbc.getDate("apply_date"))%></td>
		<td align='center'><%=valid.equals("Y")?"Validated":"<div style='color:red'>Not Validated</div>"%></td>
		<td align='center'><%=rrl_aprove.equals("Y")?"Approved":rrl_aprove.equals("N")?"<div style='color:red'>Not Approved</div>":"<div style='color:blue'>Pending</div>"%></td>
	</tr>
	<% } %>
	<tr><td colspan=11></td></tr>
	<tr><th>Total:</th><th align='left' colspan=10><%=lineNum%></th></tr>
</table>

<%
dbc.endQuery();
dbm.close();

%>
</moot:bodytable>
</html>

