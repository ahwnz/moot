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
<moot:mootreport name="Email List">

<%@page import="redcloud.db.*" %>

<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>

<h2>Applicant Emails</h2>
<br>
<%
DbManager dbm = new DbManager("jdbc/moot");
dbm.open();
DbConnect dbc = dbm.doQuery("SELECT email FROM rover");

String notInc = request.getParameter("notinc");
if(null == notInc) notInc = "";


Set<String> notIncSet = new HashSet<String>();
StringBuilder sb = new StringBuilder();

for(String str: notInc.split("\\s*?,\\s*?")) {
    str = str.trim().toLowerCase();
    notIncSet.add(str);
    sb.append(str);
    sb.append(", ");
}

while(dbc.next()) {
        String email = dbc.getString("email").trim().toLowerCase();
        if(!notIncSet.contains(email)) {
            sb.append(email);
            sb.append(", ");
        }
}
String list = sb.toString();


dbc.endQuery();
dbm.close();
%>
<div align='center'><a href='mailto:<%=list%>'><%=list%></a></div>

</moot:mootreport>
