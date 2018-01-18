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

<moot:moothead title='Transport'>
    <%@ page import="redcloud.db.*" %>
    <moot:mootmenu selected='transport'/>

    <style type="text/css">
        a span.abv, a:hover span.exp {
            display: inline;
            color: black;
        }
        a:hover span.abv, a span.exp {
            display: none;
            color: black;
        }
    </style>
</moot:moothead>

<moot:bodytable>

<h2>Moot Transport</h2>

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

String sqlStmt = "SELECT rover_id, first_name, last_name, rover_crew, region, email, transport_type, transport_specific_arrival, transport_specific_departure FROM rover";

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
        case 'r':
            sqlStmt += " region";
            break;
        case 'c':
            sqlStmt += " rover_crew";
            break;
        case 't':
            sqlStmt += " transport_type";
            break;
        case 'd':
            sqlStmt += " DESC";
    }
}


DbConnect dbc = dbm.doQuery(sqlStmt);
%>

<table align='center' width=850 cellpadding=4 cellspacing=0 border=1>
    <tr>
        <th nowrap><a class='listlink' href='/moot/pages/admin/transport.jsp?order=<%=order%>&oc=a' title='Order by Application ID'>Application ID</a></th>
        <th nowrap><a class='listlink' href='/moot/pages/admin/transport.jsp?order=<%=order%>&oc=f' title='Order by First Name'>First Name</a></th>
        <th nowrap><a class='listlink' href='/moot/pages/admin/transport.jsp?order=<%=order%>&oc=l' title='Order by Last Name'>Last Name</a></th>
        <th nowrap><a class='listlink' href='/moot/pages/admin/transport.jsp?order=<%=order%>&oc=c' title='Order by Rover Crew'> Rover Crew</a></th>
        <th nowrap><a class='listlink' href='/moot/pages/admin/transport.jsp?order=<%=order%>&oc=r' title='Order by Region'> Region</a></th>
        <th nowrap>Email</th>
        <th nowrap><a class='listlink' href='/moot/pages/admin/transport.jsp?order=<%=order%>&oc=t' title='Order by Transport Type'>Type</a></th>
        <th nowrap>Arrival</th>
        <th nowrap>Departure</th>
    </tr>

    <%
    int lineNum=0;
    while(dbc.next()) {
        int rover_id = dbc.getInt("rover_id");
        lineNum++;

        String arrival = dbc.getString("transport_specific_arrival");
        String departure = dbc.getString("transport_specific_departure");

        String arrival_abv = arrival.substring(0, Math.min(arrival.length(), 10));
        String departure_abv = departure.substring(0, Math.min(departure.length(), 10));
    %>
    <tr<%=lineNum%2==0?" class='dkrow'":""%>>
        <td align='center'><%=rover_id%></td>
        <td><a class='listlink' href='/moot/pages/admin/transport_edit.jsp?appid=<%=rover_id%>'><%=dbc.getString("first_name")%></a></td>
        <td><%=dbc.getString("last_name")%></td>
        <td><%=dbc.getString("rover_crew")%></td>
        <td><%=dbc.getString("region")%></td>
        <td><a href='mailto:<%=dbc.getString("email")%>'><%=dbc.getString("email")%></a></td>
        <td><%=dbc.getString("transport_type")%></td>
        <td width="80"><a><span class="abv"><%=arrival_abv%></span><span class="exp"><%=arrival%></span></a></td>
        <td width="80"><a><span class="abv"><%=departure_abv%></span><span class="exp"><%=departure%></span></a></td>
    </tr>
    <% } %>

</table>
<%
dbc.endQuery();
dbm.close();
%>

</moot:bodytable>
</html>