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
<moot:mootreport name="Merchandise Orders">

<%@page import="redcloud.db.*" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>

<%@ page import="common.Pair" %>

<h2>Merchandise Orders</h2>

<%
final DbManager dbm = new DbManager("jdbc/moot"); 
dbm.open(); 

String sqlStmt = "SELECT item_id, item_name FROM merchandise";

int mid = 0;

if(request.getParameter("mid")!=null) { 
	mid = Integer.parseInt(request.getParameter("mid"));
	if(mid!=0) sqlStmt += " WHERE item_id="+mid;
}

final DbConnect dbc1 = dbm.doQuery(sqlStmt);

final DbConnect dbc2 = dbm.createPreparedStatement("SELECT r.rover_id, CONCAT(r.first_name,' ',r.last_name) AS full_name, m.quantity, m.size FROM rover r JOIN rover_merchandise m WHERE r.rover_id=m.rover_id AND m.quantity <> 0 AND m.item_id = ?");

final ArrayList<Pair<String,ArrayList<HashMap<String, String>>>> itemList = new ArrayList<Pair<String,ArrayList<HashMap<String, String>>>>();

while(dbc1.next()) {
	final int itemID = dbc1.getInt("item_id");
	final String itemName = dbc1.getString("item_name");
	final ArrayList<HashMap<String,String>> roverList = new ArrayList<HashMap<String,String>>();
	
	dbc2.setInt(1, itemID);
	dbc2.executeQuery();
	
	int itemQuantity = 0;
	
	while(dbc2.next()) {
		final HashMap<String,String> roverItem = new HashMap<String,String>();
		roverItem.put("rover_id", ""+dbc2.getInt("r.rover_id"));
		roverItem.put("full_name", dbc2.getString("full_name"));
		
		int orderQuantity = dbc2.getInt("m.quantity");
		itemQuantity += orderQuantity;
		roverItem.put("quantity", ""+orderQuantity);
		
		roverItem.put("size", dbc2.getString("m.size"));
		
		roverList.add(roverItem);
	}
	
	itemList.add(new Pair<String, ArrayList<HashMap<String,String>>>(itemName + " ("+itemQuantity+")", roverList));
}

dbc1.endQuery();
dbc2.endQuery();
dbm.close();

%>
<table cellpadding=2 border=1 align='center'>
	

	<% for(Pair<String, ArrayList<HashMap<String,String>>> item: itemList) {%>
		<tr><th colspan=4 nowrap><%=item.getA()%></th></tr>
		<tr>
		<th nowrap>Application ID</th>
		<th nowrap>Name</th>
		<th nowrap>Size</th>
		<th nowrap>Quantity</th>
	</tr>
		<% for(HashMap<String,String> roverItem: item.getB()) {%>
			<tr>
				<td><%=roverItem.get("rover_id")%></td>
				<td><%=roverItem.get("full_name")%></td>
				<td><%=roverItem.get("size")%></td>
				<td><%=roverItem.get("quantity")%></td>
			</tr>
		<% } %>
		<tr><td colspan=4><br></td></tr>
	<% } %>


</table>

</moot:mootreport>