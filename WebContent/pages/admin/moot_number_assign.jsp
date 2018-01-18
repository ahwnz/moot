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

Copyright (c) 2009 Hero Moot Adminstration
@author Alex Westphal

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sub-license, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

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

<% String menusel = "utils"; %>

<%@ include file="page_head.jsp" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="common.ComparablePair" %>

<h2>Moot Number Assign</h2>

<%
DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

DbConnect dbc1 = dbm.doQuery("SELECT rover_id, CONCAT(last_name,', ',first_name) As full_name, moot_number FROM rover");

ArrayList<Integer> id_list = new ArrayList<Integer>();
ArrayList<ComparablePair<String, Integer>> name_list = new ArrayList<ComparablePair<String, Integer>>();
ArrayList<ComparablePair<Integer, Integer>> assigned_num_list = new ArrayList<ComparablePair<Integer, Integer>>();

ArrayList<Integer> unassigned_num_list = new ArrayList<Integer>();
for(int i=0; i<300; i++) {
	unassigned_num_list.add(i);
}

while(dbc1.next()) {
	int rover_id = dbc1.getInt("rover_id");
	id_list.add(rover_id);
	name_list.add(new ComparablePair<String, Integer>(dbc1.getString("full_name"), rover_id));
	
	int moot_num = dbc1.getInt("moot_number");
	assigned_num_list.add(new ComparablePair<Integer, Integer>(moot_num, rover_id));
	unassigned_num_list.remove((Object) moot_num);
}
dbc1.endQuery();
dbm.close();

if(id_list.size()>0) {
	Collections.sort(id_list);
	Collections.sort(name_list, name_list.get(0).comparator);
	Collections.sort(assigned_num_list, assigned_num_list.get(0).comparator);
	
	id_list.trimToSize();
	name_list.trimToSize();
	assigned_num_list.trimToSize();
	unassigned_num_list.trimToSize();
	%>
	
	<table width='100%' cellpadding='0' cellspacing='0' border='0'>
		<tr>
			<td valign='top' width='12%'>
				<a href='/moot/pages/admin/utilities.jsp'><img src='/moot/images/back.png' height='16' width='16' border='0'></a>
				<a class='cmdlink' href='/moot/pages/admin/utilities.jsp'><span style='position:relative;top:-4px;'>Utilities Menu</span></a>
				<div style='line-height:8px;'>&nbsp;</div>
			</td>
	
			<td valign='top' width='80%'>
		
				<form action='/moot/servlet/admin/AssignMootNumber' method='POST'>
					<select name='id_list' id='id_list' onChange='idSelectChange(); return false;'>
						<% for(int i=0; i<id_list.size(); i++) { %>
							<option value=<%=id_list.get(i)%>><%=id_list.get(i)%></option>
						<% }%>
					</select>
					<select name='name_list' id='name_list' onChange='nameSelectChange(); return false;'>
						<% for(int i=0; i<name_list.size(); i++) { %>
							<option value=<%=name_list.get(i).getB()%>><%=name_list.get(i).getA()%></option>
						<% } %>
					</select>
					<select name='num_list' id='num_list'>
						<option value=0>None</option>
						<optgroup label='Unassigned'>
							<% for(int i=0; i<unassigned_num_list.size(); i++) { %>
								<option value=<%=unassigned_num_list.get(i)%>><%=unassigned_num_list.get(i)%></option>
							<% } %>
						</optgroup>
						<optgroup label='Assigned'>
							<% for(int i=0; i<assigned_num_list.size(); i++) { 
								int assigned_num = assigned_num_list.get(i).getA();
								if(assigned_num != 0 ) { %>
									<option value=<%=assigned_num%>><%=assigned_num%></option>
								<% }
							} %>
						</optgroup>
					</select>
					
					<button onClick='doSubmit(); return false;'>Assign Number</button>
				</form>
			</td>
		</tr>
	</table>
	
	<script>
	var assigned_num_map = new Object();
	<% for(int i=0; i<assigned_num_list.size(); i++) { %>
		assigned_num_map[<%=assigned_num_list.get(i).getB()%>] = <%=assigned_num_list.get(i).getA()%>;
	<% } %>
	
	function idSelectChange() {
		var id_list_value = document.getElementById('id_list').value;
		document.getElementById('name_list').value = id_list_value;
		document.getElementById('num_list').value = assigned_num_map[id_list_value];
	}

	function nameSelectChange() {
		var name_list_value = document.getElementById('name_list').value;
		document.getElementById('id_list').value = name_list_value;
		document.getElementById('num_list').value = assigned_num_map[name_list_value];
	}

	function doSubmit() {
		document.forms[0].submit();
	}
	</script>
	
<% } %>

<%@ include file="page_foot.jsp" %>