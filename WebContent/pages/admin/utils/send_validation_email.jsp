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

<moot:moothead title='Utilities - Send Validation Email'>
    <%@ page import="redcloud.db.*" %>
    <moot:mootmenu selected='utils'/>
</moot:moothead>

<moot:bodytable>

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

</moot:bodytable>
</html>