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

<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Collections" %>
<%@page import="java.util.Comparator" %>
<%@page import="java.util.regex.*" %>
<%@page import="redcloud.db.*" %>
<%@page import="common.Flight" %>

<h2>Flight Arrivals</h2>

<%
final DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

final DbConnect dbc = dbm.doQuery("SELECT CONCAT(first_name,' ',last_name) AS full_name, mobile_phone, transport_specific_arrival, transport_to FROM rover WHERE transport_type='Plane'");

ArrayList<Flight> list = new ArrayList<Flight>();
while(dbc.next()) {
    Flight fa = new Flight();
    fa.name = dbc.getString("full_name");
    fa.cell_phone = dbc.getString("mobile_phone");
	fa.info = dbc.getString("transport_specific_arrival");
	fa.flight_num = dbc.getString("transport_to");
    list.add(fa);
}

dbc.endQuery();
dbm.close();

Pattern wedPattern = Pattern.compile("[wW][eE][dD]");
Pattern thuPattern = Pattern.compile("[tT][hH][uU]");

Pattern amPattern = Pattern.compile("[aA][mM]");
Pattern pmPattern = Pattern.compile("[pP][mM]");

Pattern timePattern = Pattern.compile("(\\d{1,2}[\\.:]\\d{1,2}|\\d{1,2}) ?[aApP][mM]");

for(Flight fa: list) {
    for(int i=0; i<fa.cell_phone.length(); i++) {
        switch(fa.cell_phone.charAt(i)) {
            case ' ':
            case '-':
            case '+':
                fa.cell_phone = fa.cell_phone.substring(0, i) + fa.cell_phone.substring(i+1, fa.cell_phone.length());
                break;
            default:
                break;
        }
    }
    if(fa.cell_phone.startsWith("61")) fa.cell_phone = '0' + fa.cell_phone;
    if(fa.cell_phone.startsWith("061")) {
        if(fa.cell_phone.length() >= 9)
            fa.cell_phone = "(061) ("+fa.cell_phone.substring(3,6)+") "+fa.cell_phone.substring(6,9) + " " + fa.cell_phone.substring(9);
    } else {
        if(fa.cell_phone.length() >= 6)
            fa.cell_phone = "("+fa.cell_phone.substring(0,3)+") "+fa.cell_phone.substring(3,6) + " " + fa.cell_phone.substring(6);
    }

    if(wedPattern.matcher(fa.info).find()) fa.day = "Wed";
    else if(thuPattern.matcher(fa.info).find()) fa.day = "Thu";
    else fa.day = "";

    if(amPattern.matcher(fa.info).find()) fa.am = true; else fa.am = false;

    Matcher matcher = timePattern.matcher(fa.info);
    if(matcher.find()) {
        String[] time = matcher.group(1).split("[.:]");
        fa.hour = Integer.parseInt(time[0]);
        if(time.length > 1)
            fa.minute = Integer.parseInt(time[1]);
            
        if(fa.hour != 0) fa.time = String.format("%02d:%02d %s", fa.hour, fa.minute, fa.am?"AM":"PM");

    }
}

Collections.sort(list, new Comparator<Flight>() {
    
    public int compare(Flight f1, Flight f2) {

        boolean f1Wed = f1.day.equals("Wed");
        boolean f2Wed = f2.day.equals("Wed");

        boolean f1Thu = f1.day.equals("Thu");
        boolean f2Thu = f2.day.equals("Thu");

        if(f1Wed && !f2Wed) return -1;
        if(f2Wed && !f1Wed) return 1;

        if(f1Thu && !f2Thu) return -1;
        if(f2Thu && !f1Thu) return 1;

        if(f1.info.length() == 0 && f2.info.length() != 0) return 1;
        if(f2.info.length() == 0 && f1.info.length() != 0) return -1;

        int f1Time = f1.hour*60 + f1.minute;
        int f2Time = f2.hour*60 + f2.minute;
        if(!f1.am && f1.hour != 12) f1Time += 720;
        if(!f2.am && f2.hour != 12) f2Time += 720;

        return new Integer(f1Time).compareTo(f2Time);
    }

});


%>
<table cellpadding=2 border=1 align='center'>

<tr>
	<th>Name</th>
	<th>Mobile Phone</th>
    <th>Day</th>
    <th>Time</th>
	<th>Info</th>
	<th>Flight Number</th>
</tr>

<% for(Flight f: list) { %>
<tr>
    <td><%=f.name%></td>
    <td><%=f.cell_phone%></td>
    <td><%=f.day%></td>
    <td><%=f.time%></td>
    <td><%=f.info%></td>
    <td><%=f.flight_num%></td>
</tr>
<% } %>

</table>
</moot:mootreport>