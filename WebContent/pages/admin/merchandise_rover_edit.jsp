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

<%@ page import="redcloud.db.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="common.DisplayUtils" %>

<% 
DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

int rover_id = Integer.parseInt(request.getParameter("appid"));

DbConnect dbc = dbm.createPreparedStatement("SELECT CONCAT(first_name, ' ', last_name) AS full_name, rover_crew, region, home_phone, work_phone, mobile_phone, "+
"email FROM rover WHERE rover_id=?");
dbc.setInt(1, rover_id);
dbc.executeQuery();

DbConnect dbc1 = dbm.doQuery("SELECT item_id, item_name, item_cost, available_sizes FROM merchandise ORDER BY item_id");
DbConnect dbc2 = dbm.createPreparedStatement("SELECT size, quantity FROM rover_merchandise WHERE item_id=? AND rover_id=?");

int grand_total = 0;

if(dbc.next()) {
	
	String region = dbc.getString("region");
	String region_name = "";
	if(region.equals("Region1")) {
		region_name = "Upper North Island";
	} else if(region.equals("Region2")) {
		region_name = "Central North Island";
	} else if(region.equals("Region3")) {
		region_name = "Lower North Island";
	} else if(region.equals("Region4")) {
		region_name = "Upper South Island";
	} else if(region.equals("Region5")) {
		region_name = "Lower South Island";
	} else if(region.equals("Australia")) {
		region_name = "Australia";
	} else if(region.equals("Other")) {
		region_name = "Other International";
	}

    String fullName = dbc.getString("full_name");

	%>

    <html>

    <moot:moothead>
        <title>SM69TH Moot - Merchandise - <%=fullName%></title>
        <moot:mootmenu selected='merchandise'/>
    </moot:moothead>
    <moot:bodytable>

    <h2>Merchandise Order</h2>

    <form action='/moot/servlet/admin/MerchandiseRoverSave' method='POST'>
    <table cellpadding='2' cellspacing='0' border='0'>

	<tr>
		<td>Application ID:</td>
		<td><%=rover_id%></td>
	</tr>
	<tr>
		<td>Name:</td>
		<td><%=fullName%></td>
	</tr>
	<tr>
		<td>Rover Crew:</td>
		<td><%=dbc.getString("rover_crew")%></td>
	</tr>
	<tr>
		<td>Region:</td>
		<td><%=region_name%></td>
	</tr>
	<tr>
		<td>Home Phone:</td>
		<td><%=dbc.getString("home_phone")%></td>
	</tr>
	<tr>
		<td>Work Phone:</td>
		<td><%=dbc.getString("work_phone")%></td>
	</tr>
	<tr>
		<td>Mobile Phone:</td>
		<td><%=dbc.getString("mobile_phone")%></td>
	</tr>
	<tr>
		<td>Email:</td>
		<td><%=dbc.getString("email")%></td>
	</tr>
	<tr>
		<td>Ordered Items:</td>
		<td><table align='center' cellspacing=2 cellpadding=2>
			<tr>
				<th align='center'>Item</th>
				<th align='center'>Cost</th>
				<th align='center'>Size</th>
				<th align='center'>Quantity</th>
				<th align='center'>Total</th>
			</tr>

			<% while(dbc1.next()) { 
				int item_id = dbc1.getInt("item_id");
				dbc2.setInt(1, item_id);
				dbc2.setInt(2, rover_id);
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
					<td>$<%=cost%><input type="hidden" name="cost_<%=item_id%>" id="cost_<%=item_id%>" value=<%=cost%>></input></td>
					<td align='right'>
						<% if(available_sizes.equals("N")) { %>
							N/A
						<% } else { %>
							<select name="size_<%=item_id%>" id="size_<%=item_id%>">
							<% for(String asize: available_sizes.split(",")) { %>
								<option value='<%=asize%>'<%=asize.equals(size)?" selected":""%>><%=asize%></option>
							<% } %>
							</select>
						<% } %>
					</td>
					<td align='right'><select name="quantity_<%=item_id%>" id="quantity_<%=item_id%>" onChange='calcTotal(<%=item_id%>); return false;'>
						<%  for(int i=0; i<=10; i++) { %>
							<option value=<%=i%><%=i==quantity?" selected":""%>><%=i%></option>
						<% } %>
					</select></td>
					<td align='center'><div id="total_<%=item_id%>">$<%=DisplayUtils.displayAmount(total)%></div></td>
				</tr>
				
			<% } %>
			<tr>
				<th colspan=4 align='right'>Total:</th>
				<td align='center'><div id='grand_total'>$<%=DisplayUtils.displayAmount(grand_total)%></div></td>
			</tr>
		</table></td>
	</tr>
	<tr><td align='center'>
        <button onclick='doSubmit(); return false;'>Save</button>
    </td></tr>
    
    </table>

    <input type='hidden' name='appid' id='appid' value='<%=rover_id%>'></input>
    <input type='hidden' name='remove' id='remove' value=''></input>

    </form>

    </moot:bodytable>
	
<%
} 

dbc.endQuery();
dbc1.endQuery();
dbc2.endQuery();

%>



<script>

var grandTotal = <%=grand_total%>;

function calcTotal(id) {
	var prev = document.getElementById("total_"+id).innerHTML.substring(1)*1;
	var cost = document.getElementById("cost_"+id).value;
	var quantity = document.getElementById("quantity_"+id).value;
	var total = cost*quantity;
	document.getElementById("total_"+id).innerHTML = "$"+total;

	grandTotal -= prev;
	grandTotal += total;
	document.getElementById("grand_total").innerHTML = "$"+grandTotal; 
}

function doSubmit() {
	document.forms[0].submit();
}

</script>

</html>