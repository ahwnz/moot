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
<moot:mootreport name="Individual Merchandise Orders">

<%@page import="redcloud.db.*" %>

<h2>Individual Merchandise Orders</h2>
<br>
<%
DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

DbConnect dbc1 = dbm.doQuery("SELECT rover_id, CONCAT(first_name,' ',last_name) AS full_name, moot_number FROM rover ORDER BY rover_id");
DbConnect dbc2 = dbm.createPreparedStatement("SELECT r.size, r.quantity, m.item_name FROM rover_merchandise r, merchandise m WHERE r.item_id = m.item_id AND r.rover_id = ?");

%>

<table cellpadding=2 border=1 align='center'>
    <%
    while(dbc1.next()) {
        int rover_id = dbc1.getInt("rover_id");
        dbc2.setInt(1,rover_id);
        dbc2.executeQuery();
     %>
     <tr><th colspan="3">MN: <%=dbc1.getInt("moot_number")%> - <%=dbc1.getString("full_name")%></th></tr>
        <%
        while(dbc2.next()) {
            int quantity = dbc2.getInt("r.quantity");
            String size = dbc2.getString("r.size");

            if(size.length() > 0) size = " ("+size+")";

            if(quantity > 0) {%><tr><td><%=dbc2.getString("m.item_name")%></td><td><%=size%></td><td><%=quantity%></td></tr><%}
         } %>
        <tr><td colspan="3">&nbsp;</td></tr>
    <% } %>
</table>

<%
dbc1.endQuery();
dbc2.endQuery();
dbm.close();
%>

</moot:mootreport>