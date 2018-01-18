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

Copyright (c) 2009 Hero Moot Adminstration
@author Alex Westphal

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sub-license, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

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

<% String menusel = "tours"; %>

<%@ include file="page_head.jsp" %>

<h2>Tour List</h2>

<%
final DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

final DbConnect dbc = dbm.doQuery("SELECT tour_id, tour_name, tour_cost FROM tour");

%>

<table align='center' cellpadding=4 cellspacing=0 border=0>
	<tr>
		<th align='center'>Tour ID</th>
		<th>Tour Name</th>
		<th>Tour Cost</th>
	</tr>
	
<% 
int lineNum = 0;
while(dbc.next()) {
	final int tour_id = dbc.getInt("tour_id");
%>
	<tr<%=(++lineNum)%2==0?" class='dkrow'":""%>>
		<td align='center'><%=tour_id%></td>
		<td><a class='listlink' href='/moot/pages/admin/tour_edit.jsp?tourid=<%=tour_id%>'><%=dbc.getString("tour_name")%></a></td>
		<td>$<%=dbc.getInt("tour_cost")%></td>
	</tr>
<%
}
dbc.endQuery();
dbm.close();
%>

</table>



<%@ include file="page_foot.jsp" %>