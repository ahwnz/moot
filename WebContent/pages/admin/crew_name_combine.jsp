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

<h2>Crew Name Combine</h2>

<%
DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

DbConnect dbc = dbm.doQuery("SELECT DISTINCT(rover_crew) FROM rover ORDER BY rover_crew");
%>

<table width='100%' cellpadding='0' cellspacing='0' border='0'>
	<tr>
		<td valign='top' width='12%'>
			<a href='/moot/pages/admin/utilities.jsp'><img src='/moot/images/back.png' height='16' width='16' border='0'></a>
			<a class='cmdlink' href='/moot/pages/admin/utilities.jsp'><span style='position:relative;top:-4px;'>Utilities Menu</span></a>
			<div style='line-height:8px;'>&nbsp;</div>
		</td>

		<td valign='top' width='80%'>

			Enter a crew name into the box and select 1 or more names to combine under the entered name.
			<br>
			<form action='/moot/servlet/admin/CombineSubmit' method='POST'>
				<table cellpadding=4>
					<tr>
						<td>Crew Name:</td>
						<td><input type='text' name='new_name' id='new_name'></input></td>
					</tr>
					<tr>
						<td>Names:</td>
						<td><select name='old_names' id='old_names' multiple size=5>
						<% while(dbc.next()) { 
							String crew = dbc.getString("rover_crew");
							%>
							<option value='<%=crew%>'><%=crew%></option>
						<% } %>
						</select></td>
					</tr>
					<tr><td><button onclick='doSubmit(); return false;'>Combine</button></td></tr>

				</table>
				<input type='hidden' name='old_names_str' id='old_names_str' value=''></input>
			</form>
		</td>
	</tr>
</table>

<%
dbc.endQuery();
dbm.close();
%>

<script>

function doSubmit() {
	if(document.getElementById('new_name').value!="") {
		var opt = document.getElementById("old_names");
		var str = "";
		for(var i=0; i<opt.length; i++) {
			if(opt[i].selected) {
				str += opt[i].value + ",";
			}
		}
		document.getElementById('old_names_str').value = str;
		document.forms[0].submit();
	} else {
		document.getElementById('new_name').focus();
	}
}

</script>

<%@ include file="page_foot.jsp" %>