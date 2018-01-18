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

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="page_head.jsp" %>
<%@ page import="redcloud.db.*" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="common.DisplayUtils" %>

<h1>Merchandise Order Form</h1>
<br><br>
For more information see <a href='http://www.sm69thmoot.com/store.html' target='_blank' title='Merchandise'>Merchandise.</a>
<br><br>
<%
merch: {
//if(true) break merch;

int app_id = (int) Long.parseLong(request.getParameter("appid"))%(256*1025);

DbManager dbm = new DbManager("jdbc/moot");
dbm.open();
DbConnect dbc = dbm.createPreparedStatement("SELECT rover_id, CONCAT(first_name,' ',last_name) AS full_name FROM rover WHERE rover_id=?");
DbConnect dbc1 = dbm.doQuery("SELECT item_id, item_name, item_cost, available_sizes FROM merchandise ORDER BY item_id");
DbConnect dbc2 = dbm.createPreparedStatement("SELECT size, quantity FROM rover_merchandise WHERE item_id=? AND rover_id=?");

error_block: {

int grand_total = 0;

Calendar deadline = Calendar.getInstance();
deadline.set(2011, 3, 1);
boolean dlp = (Calendar.getInstance().after(deadline));

dbc.setInt(1, app_id);
dbc.executeQuery();
if(dbc.next()) { %>
	Name: <%=dbc.getString("full_name")%> Application ID: <%=app_id%><br><br>
<% } else { %>
	Invalid ID.
<% 
	break error_block;
} %>
<form action='/moot/servlet/application/MerchandiseSubmit' method='POST'>
<table align='center' cellspacing=2 cellpadding=2>
	<tr>
		<th align='center'>Item</th>
		<th align='center'>Cost</th>
		<th align='center'>Size</th>
		<th align='center'>Quantity</th>
		<th align='center'>Total</th>
	</tr>

<% 
while(dbc1.next()) { 
	int item_id = dbc1.getInt("item_id");
	dbc2.setInt(1, item_id);
	dbc2.setInt(2, app_id);
	dbc2.executeQuery();
	boolean exists = dbc2.next();
	
	int cost = dbc1.getInt("item_cost");
	String size = exists?dbc2.getString("size"):"N";
	int quantity = exists?dbc2.getInt("quantity"):0;
	int total = cost*quantity;
	grand_total += total;
	
	String available_sizes = dbc1.getString("available_sizes");
%>
	<tr>
		<td><%=dbc1.getString("item_name")%></td>
		<td>$<%=DisplayUtils.displayAmount(cost)%><input type="hidden" name="cost_<%=item_id%>" id="cost_<%=item_id%>" value=<%=cost%>></input></td>
		<td align='right'>
			<% if(available_sizes.equals("N")) { %>
				N/A
			<% } else if(dlp) { %>
				<%=size%>
			<% } else {%>
				<select name="size_<%=item_id%>" id="size_<%=item_id%>">
					<% for(String asize: available_sizes.split(",")) { %>
						<option value='<%=asize%>'<%=asize.equals(size)?" selected":""%>><%=asize%></option>
					<% } %>
				</select>
			<% } %>
		</td>
		<td align='right'>
			<% if(dlp) { %>
				<%=quantity%>
			<% } else { %>
				<select name="quantity_<%=item_id%>" id="quantity_<%=item_id%>" onChange='calcTotal(<%=item_id%>); return false;'>
					<% for(int i=quantity; i<=10; i++) { %>
						<option value=<%=i%><%=i==quantity?" selected":""%>><%=i%></option>
					<% } %>
				</select>
			<% } %>
		</td>
                <td align='center'><div id="total_<%=item_id%>">$<%=DisplayUtils.displayAmount(total)%></div></td>
	</tr>

<% } %>


<tr><th colspan='4' align='right'>Total:</th><td align='center'><div id='grand_total'>$<%=DisplayUtils.displayAmount(grand_total)%></div></td></tr>

<% if(!dlp) { %>
	<tr><td colspan='5' align='center'>
		<button onclick='doSubmit(); return false;'>Save</button>
	</td></tr>
<% } %>

</table>

<input type='hidden' name='appid' value='<%=app_id%>'></input>

</form>



<script>

var grandTotal = <%=grand_total%>;

function calcTotal(id) {
	var prev = document.getElementById("total_"+id).innerHTML.substring(1)*1;
	var cost = document.getElementById("cost_"+id).value;
	var quantity = document.getElementById("quantity_"+id).value;
	var total = cost*quantity;
	document.getElementById("total_"+id).innerHTML = "$"+(total/100)+"."+(total%100);

	grandTotal -= prev;
	grandTotal += total;
	document.getElementById("grand_total").innerHTML = "$"+(grandTotal/100)+"."+(total%100);
}

function doSubmit() {
	if(grandTotal==0 && (!confirm("You havent ordered any merchandise.\nAre you sure you want to go to SM69TH Moot naked?"))) {
		return false;
	} 
    document.forms[0].submit();
}

</script>

<%
}

dbc1.endQuery();
dbc2.endQuery();
dbm.close();

}
%>

<%@ include file="page_foot.jsp" %>