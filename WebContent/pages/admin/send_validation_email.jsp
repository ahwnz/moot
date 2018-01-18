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

Copyright (c) 2009 Hero Moot Administration
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

<% String menusel = "utils"; %>

<%@ include file="page_head.jsp" %>

<h2>Send Validation Email</h2>

<%

String msg = "";
if(request.getParameter("appid")!=null) {
	msg = "Validation Email Sent to AppID = "+ request.getParameter("appid");
}

final DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

final DbConnect dbc = dbm.doQuery("SELECT rover_id, CONCAT(first_name,' ',last_name) AS full_name FROM rover WHERE valid = 'N'");

%>

<table width='100%' cellpadding='0' cellspacing='0' border='0'>
	<tr>
		<td valign='top' width='12%'>
			<a href='/moot/pages/admin/utilities.jsp'><img src='/moot/images/back.png' height='16' width='16' border='0'></a>
			<a class='cmdlink' href='/moot/pages/admin/utilities.jsp'><span style='position:relative;top:-4px;'>Utilities Menu</span></a>
			<div style='line-height:8px;'>&nbsp;</div>
		</td>

		<td valign='top' width='80%'>

			<form action='/moot/servlet/admin/SendValidateEmail' method='POST'>
			
			<select name='appid' id='appid'>
				<% while(dbc.next()) {%>
					<option value='<%=dbc.getInt("rover_id")%>'><%=dbc.getInt("rover_id")%> - <%=dbc.getString("full_name")%></option>
				<% } %>
			</select>
			<button onClick='doSubmit(); return false;'>Send Email</button>
			
			</form>
			<br>
			<%=msg%>
		</td>
	</tr>
</table>

<% 
dbc.endQuery();
dbm.close();
%>

<script>

function doSubmit() {
	document.forms[0].submit();
}

</script>

<% %>

<%@ include file="page_foot.jsp" %>