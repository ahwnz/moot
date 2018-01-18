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
<moot:mootreport name="Service Skills">

<%@page import="redcloud.db.*" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.lang.StringBuilder" %>

<h2>Service Skills</h2>

<%
DbManager dbm = new DbManager("jdbc/moot");
dbm.open();
DbConnect dbc = dbm.doQuery("SELECT rover_id, CONCAT(first_name,' ',last_name) AS full_name, specific_skills FROM rover");

ArrayList<Integer> id_list = new ArrayList<Integer>();
ArrayList<String> name_list = new ArrayList<String>();
ArrayList<HashMap<String, Boolean>> skills_list = new ArrayList<HashMap<String, Boolean>>();

while(dbc.next()) {
	id_list.add(dbc.getInt("rover_id"));
	name_list.add(dbc.getString("full_name"));
	skills_list.add((HashMap<String, Boolean>) dbc.getHashMap("specific_skills"));
}
id_list.trimToSize();
name_list.trimToSize();
skills_list.trimToSize();

int builder_num = 0;
int electrician_num = 0;
int plumbing_num = 0;
int painter_num = 0;
int gardening_num = 0;
int welding_num = 0;

StringBuilder builder_str = new StringBuilder();
StringBuilder electrician_str = new StringBuilder();
StringBuilder plumbing_str = new StringBuilder();
StringBuilder painter_str = new StringBuilder();
StringBuilder gardening_str = new StringBuilder();
StringBuilder welding_str = new StringBuilder();

HashMap<String, Boolean> skills;
for(int i=0; i<id_list.size(); i++) {
	skills = skills_list.get(i);
	if(skills.containsKey("builder") && skills.get("builder")) {
		builder_num++;
		builder_str.append("<tr><td>");
		builder_str.append(id_list.get(i));
		builder_str.append("</td><td>");
		builder_str.append(name_list.get(i));
		builder_str.append("</td></tr>");
	}
	if(skills.containsKey("electrician") && skills.get("electrician")) {
		electrician_num++;
		electrician_str.append("<tr><td>");
		electrician_str.append(id_list.get(i));
		electrician_str.append("</td><td>");
		electrician_str.append(name_list.get(i));
		electrician_str.append("</td></tr>");
	}
	if(skills.containsKey("plumbing") && skills.get("plumbing")) {
		plumbing_num++;
		plumbing_str.append("<tr><td>");
		plumbing_str.append(id_list.get(i));
		plumbing_str.append("</td><td>");
		plumbing_str.append(name_list.get(i));
		plumbing_str.append("</td></tr>");
	}
	if(skills.containsKey("painter") && skills.get("painter")) {
		painter_num++;
		painter_str.append("<tr><td>");
		painter_str.append(id_list.get(i));
		painter_str.append("</td><td>");
		painter_str.append(name_list.get(i));
		painter_str.append("</td></tr>");
	}
	if(skills.containsKey("gardening") && skills.get("gardening")) {
		gardening_num++;
		gardening_str.append("<tr><td>");
		gardening_str.append(id_list.get(i));
		gardening_str.append("</td><td>");
		gardening_str.append(name_list.get(i));
		gardening_str.append("</td></tr>");
	}
	if(skills.containsKey("welding") && skills.get("welding")) {
		welding_num++;
		welding_str.append("<tr><td>");
		welding_str.append(id_list.get(i));
		welding_str.append("</td><td>");
		welding_str.append(name_list.get(i));
		welding_str.append("</td></tr>");
	}
}
%>
<br>
<table cellpadding=2 border=1 align='center'>
	<tr><th colspan=2>Builder (<%=builder_num%>)</th></tr>
	<tr><th nowrap>Application Number</th><th nowrap>Name</th></tr>
	<%=builder_str%>
	<tr><td colspan=2><br></td></tr>
	<tr><th colspan=2>Electrician (<%=electrician_num%>)</th></tr>
	<tr><th nowrap>Application Number</th><th nowrap>Name</th></tr>
	<%=electrician_str%>
	<tr><td colspan=2><br></td></tr>
	<tr><th colspan=2>Plumbing (<%=plumbing_num%>)</th></tr>
	<tr><th nowrap>Application Number</th><th nowrap>Name</th></tr>
	<%=plumbing_str%>
	<tr><td colspan=2><br></td></tr>
	<tr><th colspan=2>Painter (<%=painter_num%>)</th></tr>
	<tr><th nowrap>Application Number</th><th nowrap>Name</th></tr>
	<%=painter_str%>
	<tr><td colspan=2><br></td></tr>
	<tr><th colspan=2>Gardening (<%=gardening_num%>)</th></tr>
	<tr><th nowrap>Application Number</th><th nowrap>Name</th></tr>
	<%=gardening_str%>
	<tr><td colspan=2><br></td></tr>
	<tr><th colspan=2>Welding (<%=welding_num%>)</th></tr>
	<tr><th nowrap>Application Number</th><th nowrap>Name</th></tr>
	<%=welding_str%>
	<tr><td colspan=2><br></td></tr>
</table>

<%
dbc.endQuery();
dbm.close();
%>
</moot:mootreport>