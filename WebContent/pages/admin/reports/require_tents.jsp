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
<moot:mootreport name="Flight Arrivals">

<%@page import="java.util.*" %>
<%@page import="redcloud.db.*" %>
<%@page import="common.SimpleRover" %>

<h2>Require Tents</h2>

<%
final DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

final DbConnect dbc = dbm.doQuery("SELECT rover_id, CONCAT(first_name,' ',last_name) AS full_name, rover_crew, region FROM rover WHERE accommodation = 'Tent'");

ArrayList<SimpleRover> list = new ArrayList<SimpleRover>();

while(dbc.next()) {
    list.add(new SimpleRover(dbc.getInt("rover_id"), dbc.getString("full_name"), dbc.getString("region").equals("Australia")?"Australia":dbc.getString("rover_crew")));
}

dbc.endQuery();
dbm.close();

Collections.sort(list, new Comparator<SimpleRover>() {

    public int compare(SimpleRover sr1, SimpleRover sr2) {
        return sr1.rover_crew.compareTo(sr2.rover_crew);
    }
});

%>
<table cellpadding=2 border=1 align='center'>

<%
boolean first = true;
String last_crew = "";
for(SimpleRover sr: list) {
    if(!sr.rover_crew.equals(last_crew)) {
        if(first) first = false;
        else { %><tr><td colspan="2"><br></td></tr><%}
        %>
        <tr><th align="center" colspan="2"><%=sr.rover_crew%></th></tr>
        <tr><th>Application ID</th><th>Name</th></tr>
        <%

        last_crew = sr.rover_crew;
    }
%>
<tr>
    <td align="center"><%=sr.rover_id%></td>
    <td><%=sr.full_name%></td>
</tr>
<%}%>
</table>
</moot:mootreport>