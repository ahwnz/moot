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

<%@ page import="java.util.Calendar" %>
<%@ page import="application.Constants" %>
<%@ page import="common.KeyValue" %>
<%@ page import="common.DisplayUtils" %>
<%@ page import="redcloud.db.*" %>


<% 
DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

DbConnect dbc = dbm.createPreparedStatement("SELECT CONCAT(first_name, ' ', last_name) AS full_name, rover_crew, region, home_phone, work_phone, mobile_phone, "+
		"email, tour_assigned, main_fee_recieved, main_fee_date, staff, late_fee FROM rover WHERE rover_id=?");

DbConnect dbc2 = dbm.createPreparedStatement("SELECT payment_id, payment_for, method, amount, date FROM payment WHERE rover_id=?");
DbConnect dbc3 = dbm.createPreparedStatement("SELECT tour_cost, tour_name FROM tour WHERE tour_id=?");
DbConnect dbc4 = dbm.createPreparedStatement("SELECT item_cost, item_name, quantity  FROM rover_merchandise r JOIN merchandise m ON r.item_id=m.item_id WHERE rover_id=?");

String[] months = new String[] {"January","February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};

int rover_id = Integer.parseInt(request.getParameter("appid"));

int edit_id = -1;
if(request.getParameter("edit")!=null) {
	edit_id = Integer.parseInt(request.getParameter("edit"));
}

KeyValue kv = new KeyValue(dbm);
int invoice_no = kv.getInt("invoice_no");
int receipt_no = kv.getInt("receipt_no");

dbc.setInt(1, rover_id);
dbc.executeQuery();

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

	String payment_recieved = dbc.getString("main_fee_recieved");
	Calendar payment_date = dbc.getDateTime("main_fee_date");
		
	int payment_date_day = payment_date.get(Calendar.DAY_OF_MONTH);
	int payment_date_month = payment_date.get(Calendar.MONTH);
	
	int main_fee = Constants.MOOT_FEE;
	boolean isStaff = dbc.getString("staff").equals("Y");
	if(isStaff) {
		main_fee = Constants.STAFF_FEE;
	}

    String fullName = dbc.getString("full_name");

    String late_fee = dbc.getString("late_fee");
    

	%>

    <html>

    <moot:moothead>
        <title>SM69TH Moot - Payments - <%=fullName%></title>
        <moot:mootmenu selected='payments'/>
    </moot:moothead>

    <moot:bodytable>

    <h2>Rover Payments Edit</h2>

    <form action='/moot/servlet/admin/PaymentsRoverSave' method='POST'>
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
		<td>Main Fee Payment:</td>
		<td><select name='main_fee_recieved' id='main_fee_recieved'>
			<option value='N'<%=payment_recieved.equals("N")?" selected":""%>>No</option>
			<option value='Y'<%=payment_recieved.equals("Y")?" selected":""%>>Yes</option>
		</select></td>
	</tr>
	<tr>
		<td>Main Fee Date:</td>
		<td><select name='payment_date_day' id='payment_date_day'>
			<% for(int i=1; i<32; i++) { %>
				<option value=<%=i%><%=i==payment_date_day?" selected":""%>><%=i%></option>
			<% } %>
		</select>
		<select name='payment_date_month' id='payment_date_month'>
			<% for(int i=0; i<12; i++) { %>
				<option value=<%=i%><%=i==payment_date_month?" selected":""%>><%=months[i]%></option>
			<% } %>
		</select></td>
	</tr>
    <tr>
        <td>Late Fee:</td>
		<td><select name='late_fee' id='late_fee'>
			<option value='N'<%=late_fee.equals("N")?" selected":""%>>No</option>
			<option value='Y'<%=late_fee.equals("Y")?" selected":""%>>Yes</option>
		</select></td>
    </tr>
	<tr>
		<td>Charges:</td>
		<td><table cellpadding='4'>
			<tr><th>For</th><th>Quantity</th><th>Price</th><th>Total</th></tr>
			
			<tr><td>Main Fee<%=isStaff?" (Staff)":""%></td><td>1</td><td>$<%=DisplayUtils.displayAmount(main_fee)%></td><td>$<%=DisplayUtils.displayAmount(main_fee)%></td></tr>
            <%
			int total_cost = main_fee;

            if(late_fee.equals("Y")) {
                total_cost += Constants.LATE_FEE;
            %>
            <tr><td>Late Fee</td><td>1</td><td>$<%=DisplayUtils.displayAmount(Constants.LATE_FEE)%></td><td>$<%=DisplayUtils.displayAmount(Constants.LATE_FEE)%></td></tr>
            <%
            }

			int tour_assigned = dbc.getInt("tour_assigned");
			if(tour_assigned != 0) {
				dbc3.setInt(1, tour_assigned);
				dbc3.executeQuery();
				if(dbc3.next()) {
					int tour_cost = dbc3.getInt("tour_cost");
					total_cost += tour_cost;
					%><tr>
						<td><%=dbc3.getString("tour_name")%></td>
						<td>1</td>
						<td>$<%=DisplayUtils.displayAmount(tour_cost)%></td>
						<td>$<%=DisplayUtils.displayAmount(tour_cost)%></td>
					</tr><%
				}
			}
			
			dbc4.setInt(1, rover_id);
			dbc4.executeQuery();
			while(dbc4.next()) {
				int item_cost = dbc4.getInt("item_cost");
				int quantity = dbc4.getInt("quantity");
				int group_cost = item_cost*quantity;
				total_cost += group_cost;
				if(quantity>0) {
					%><tr>
						<td><%=dbc4.getString("item_name")%></td>
						<td><%=quantity%></td>
						<td>$<%=DisplayUtils.displayAmount(item_cost)%></td>
						<td>$<%=DisplayUtils.displayAmount(group_cost)%></td>
					</tr><%
				}
			}
			
			%>
			<tr><th colspan=3 align='right'>Total:</th><td>$<%=DisplayUtils.displayAmount(total_cost)%></td></tr>
		</table></td>
	</tr>
	
	<tr>
		<td>Payments:</td>
		<td><table cellpadding='4'>
			<tr><th>For</th><th>Amount</th><th>Method</th><th colspan=2>Date</th><th></th></tr>
			<% 
			int total_payed = 0;
			dbc2.setInt(1, rover_id);
			dbc2.executeQuery();
			while(dbc2.next()) { 
				int payment_id = dbc2.getInt("payment_id");
				Calendar date = dbc2.getDateTime("date");
				
				int date_day = date.get(Calendar.DAY_OF_MONTH);
				int date_month = date.get(Calendar.MONTH);
				
				String method = dbc2.getString("method");
				
				int amount = dbc2.getInt("amount");
				total_payed += amount;
				
				if(edit_id==payment_id) { 
					%>
					<tr>
					<td><input type='text' name='for' id='for' value='<%=dbc2.getString("payment_for")%>'></input></td>
					<td><input type='text' name='amount' id='amount' class="amount" value='<%=DisplayUtils.displayAmount(amount)%>'></input></td>
					<td><select name='method' id='method'>
						<option value='Cheque'<%=method.equals("Cheque")?" selected":""%>>Cheque</option>
						<option value='Cash'<%=method.equals("Cash")?" selected":""%>>Cash</option>
						<option value='Eftpos'<%=method.equals("Eftpos")?" selected":""%>>Eftpos</option>
						<option value='Internet'<%=method.equals("Internet")?" selected":""%>>Internet</option>
                                                <option value='Credit Card'<%=method.equals("Credit Card")?" selected":""%>>Credit Card</option>
					</select></td>
					<td><select name='payment_day' id='payment_day'>
						<% for(int i=1; i<32; i++) { %>
							<option value=<%=i%><%=date_day==i?" selected":""%>><%=i%></option>
						<% } %>
					</select></td>
					<td><select name='payment_month' id='payment_month'>
						<% for(int i=0; i<months.length; i++) { %>
							<option value=<%=i%><%=date_month==i?" selected":""%>><%=months[i]%></option>
						<% } %>
					</select></td>
					<td><a href='#' onClick='doDelete("<%=payment_id%>"); return false;'>Delete</a></td>
				</tr>
				<% 	} else { %>
				<tr>
					<td><%=dbc2.getString("payment_for")%></td>
					<td>$<%=DisplayUtils.displayAmount(amount)%></td>
					<td><%=method%></td>
					<td align='center'><%=date_day%></td>
					<td><%=months[date_month]%></td>
					<td><a href='#' onClick='doEdit("<%=payment_id%>"); return false;'>Edit</a></td>
				</tr>
				<%	} 
			} %>
			<% if(edit_id==0) { %>
				<tr>
					<td><input type='text' name='for' id='for' value=''></input></td>
					<td><input type='text' name='amount' id='amount' class="amount" value=''></input></td>
					<td><select name='method' id='method'>
						<option value='Cheque'>Cheque</option>
						<option value='Cash' selected>Cash</option>
						<option value='Eftpos'>Eftpos</option>
						<option value='Internet'>Internet</option>
                                                <option value='Credit Card'>Credit Card</option>
					</select></td>
					<td><select name='payment_day' id='payment_day'>
						<% for(int i=1; i<32; i++) { %>
							<option value=<%=i%>><%=i%></option>
						<% } %>
					</select></td>
					<td><select name='payment_month' id='payment_month'>
						<% for(int i=0; i<months.length; i++) { %>
							<option value=<%=i%>><%=months[i]%></option>
						<% } %>
					</select></td>
					<td></td>
				</tr>
			<% } %>
			<tr><th>Total Payed:</th><td>$<%=DisplayUtils.displayAmount(total_payed)%></td><td colspan='3'><a href='#' onClick='doNew(); return false;'>New Payment</a></td></tr>
			<tr><th>Total Owing:</th><td>$<%=DisplayUtils.displayAmount(total_cost-total_payed)%></td></tr>
		</table></td>
	</tr>
	<tr>
		<td>Paperwork:</td>
        <td>
            <div id="rlinks"></div>
            <input type="text" id="rid" value=<%=receipt_no%> onchange="ridChange(); return false;"/>
            <div id="slinks"></div>
            <input type="text" id="sid" value=<%=invoice_no%> onchange="sidChange(); return false;"/>
        </td>
	</tr>
	<tr>
		<td><button onclick='doSubmit(); return false;'>Save</button></td>
		<td><a href='/moot/pages/admin/payments_rover_edit.jsp?appid=<%=rover_id%>'>Cancel</a></td>
	</tr>

    </table>

    <input type='hidden' name='appid' id='appid' value='<%=rover_id%>'></input>
    <input type='hidden' name='edit' id='edit' value='-1'></input>
    <input type='hidden' name='delete' id='delete' value='-1'></input>
    <input type='hidden' name='save' id='save' value='<%=edit_id%>'></input>

    </form>

    </moot:bodytable>

<%
} 

dbc.endQuery();
dbc2.endQuery();
dbc3.endQuery();
dbc4.endQuery();
dbm.close();
%>



<script>

function doSubmit() {
	document.forms[0].submit();
}

function doEdit(payment_id) {
	document.getElementById("edit").value = payment_id;
	document.forms[0].submit();
}

function doNew() {
	document.getElementById("edit").value=0;
	document.forms[0].submit();
}

function doDelete(payment_id) {
	document.getElementById("delete").value = payment_id;
	document.forms[0].submit();
}

    $(".amount").change(function() {
    var oldStr = $(this).val();
    var newStr = "";
    var hadDot = false;
    for(var i=0; i<oldStr.length; i++) {
        switch(oldStr.charAt(i)) {
            case '.':
                if(hadDot) break; else hadDot = true;
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                newStr += oldStr.charAt(i);
        }
    }
    $(this).val(newStr);
});

setReceipt(<%=receipt_no%>);
setStatement(<%=invoice_no%>);

function ridChange() {
    var in_str = document.getElementById("rid").value;
	var out_str = "";
	for(var i=0; i<in_str.length; i++) {
		if(isNumeric(in_str.charAt(i))) {
			out_str += in_str.charAt(i);
		}
	}
	document.getElementById("rid").value = out_str;
    setReceipt(out_str);
}

function sidChange() {
    var in_str = document.getElementById("sid").value;
	var out_str = "";
	for(var i=0; i<in_str.length; i++) {
		if(isNumeric(in_str.charAt(i))) {
			out_str += in_str.charAt(i);
		}
	}
	document.getElementById("sid").value = out_str;
    setStatement(out_str);
}

function setReceipt(rid) {
    document.getElementById("rlinks").innerHTML = "<table cellpadding=2>"+
			"<tr><td><a href='/moot/servlet/paperwork/StandardReceipt?appid=<%=rover_id%>&images=y&pid="+rid+"'>Download Receipt</a></td><td rowspan=4></td></tr>"+
			"<tr><td><a href='/moot/servlet/paperwork/StandardReceipt?appid=<%=rover_id%>&images=n&pid="+rid+"'>Download Receipt (no images)</a></td></tr>"+
            "</table>";
}

function setStatement(sid) {
    document.getElementById("slinks").innerHTML = "<table cellpadding=2>"+
			"<tr><td><a href='/moot/servlet/paperwork/StandardInvoice?appid=<%=rover_id%>&images=y&pid="+sid+"'>Download Invoice</a></td></tr>"+
			"<tr><td><a href='/moot/servlet/paperwork/StandardInvoice?appid=<%=rover_id%>&images=n&pid="+sid+"'>Download Invoice (no images)</a></td></tr>"+
            "</table>";
}

</script>

</html>