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
<moot:mootreport name="Medical Conditions">

<%@page import="redcloud.db.*" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>

<h2>Medical Conditions</h2>

<%
DbManager dbm = new DbManager("jdbc/moot");
dbm.open();
DbConnect dbc = dbm.doQuery("SELECT r.rover_id, CONCAT(r.first_name,' ',r.last_name) AS full_name, r.rover_crew, m.medical_conditions FROM rover r JOIN medical m ON r.rover_id=m.rover_id");

ArrayList<Integer> id_list = new ArrayList<Integer>();
ArrayList<String> name_list = new ArrayList<String>();
ArrayList<String> crew_list = new ArrayList<String>();
ArrayList<HashMap<String, Boolean>> conditions_list = new ArrayList<HashMap<String, Boolean>>();

while(dbc.next()) {
	id_list.add(dbc.getInt("r.rover_id"));
	name_list.add(dbc.getString("full_name"));
	crew_list.add(dbc.getString("r.rover_crew"));
	conditions_list.add((HashMap<String, Boolean>) dbc.getHashMap("m.medical_conditions"));
}
id_list.trimToSize();
name_list.trimToSize();
conditions_list.trimToSize();

int asthma_num = 0;
int insect_allergy_num = 0;
int hay_fever_num = 0;
int haemophilia_num = 0;
int fainting_num = 0;
int epilepsy_num = 0;
int heart_condition_num = 0;
int rheumatic_fever_num = 0;
int diabetes_num = 0;
int food_allergy_num = 0;
int penicillin_allergy_num = 0;
int sleep_walking_num = 0;

String asthma_str = "";
String insect_allergy_str = "";
String hay_fever_str = "";
String haemophilia_str = "";
String fainting_str = "";
String epilepsy_str = "";
String heart_condition_str = "";
String rheumatic_fever_str = "";
String diabetes_str = "";
String food_allergy_str = "";
String penicillin_allergy_str = "";
String sleep_walking_str = "";

HashMap<String, Boolean> conditions;
for(int i=0; i<id_list.size(); i++) {
	conditions = conditions_list.get(i);
	if(conditions.containsKey("asthma") && conditions.get("asthma")) {
		asthma_num++;
		asthma_str += "<tr><td>"+id_list.get(i)+"</td><td>"+name_list.get(i)+"</td><td>"+crew_list.get(i)+"</td></tr>";
	}
	if(conditions.containsKey("insect_allergy") && conditions.get("insect_allergy")) {
		insect_allergy_num++;
		insect_allergy_str += "<tr><td>"+id_list.get(i)+"</td><td>"+name_list.get(i)+"</td><td>"+crew_list.get(i)+"</td></tr>";
	}
	if(conditions.containsKey("hay_fever") && conditions.get("hay_fever")) {
		hay_fever_num++;
		hay_fever_str += "<tr><td>"+id_list.get(i)+"</td><td>"+name_list.get(i)+"</td><td>"+crew_list.get(i)+"</td></tr>";
	}
	if(conditions.containsKey("haemophilia") && conditions.get("haemophilia")) {
		haemophilia_num++;
		haemophilia_str += "<tr><td>"+id_list.get(i)+"</td><td>"+name_list.get(i)+"</td><td>"+crew_list.get(i)+"</td></tr>";
	}
	if(conditions.containsKey("fainting") && conditions.get("fainting")) {
		fainting_num++;
		fainting_str += "<tr><td>"+id_list.get(i)+"</td><td>"+name_list.get(i)+"</td><td>"+crew_list.get(i)+"</td></tr>";
	}
	if(conditions.containsKey("epilepsy") && conditions.get("epilepsy")) {
		epilepsy_num++;
		epilepsy_str += "<tr><td>"+id_list.get(i)+"</td><td>"+name_list.get(i)+"</td><td>"+crew_list.get(i)+"</td></tr>";
	}
	if(conditions.containsKey("heart_condition") && conditions.get("heart_condition")) {
		heart_condition_num++;
		heart_condition_str += "<tr><td>"+id_list.get(i)+"</td><td>"+name_list.get(i)+"</td><td>"+crew_list.get(i)+"</td></tr>";
	}
	if(conditions.containsKey("rheumatic_fever") && conditions.get("rheumatic_fever")) {
		rheumatic_fever_num++;
		rheumatic_fever_str += "<tr><td>"+id_list.get(i)+"</td><td>"+name_list.get(i)+"</td><td>"+crew_list.get(i)+"</td></tr>";
	}
	if(conditions.containsKey("diabetes") && conditions.get("diabetes")) {
		diabetes_num++;
		diabetes_str += "<tr><td>"+id_list.get(i)+"</td><td>"+name_list.get(i)+"</td><td>"+crew_list.get(i)+"</td></tr>";
	}
	if(conditions.containsKey("food_allergy") && conditions.get("food_allergy")) {
		food_allergy_num++;
		food_allergy_str += "<tr><td>"+id_list.get(i)+"</td><td>"+name_list.get(i)+"</td><td>"+crew_list.get(i)+"</td></tr>";
	}
	if(conditions.containsKey("penicillin_allergy") && conditions.get("penicillin_allergy")) {
		penicillin_allergy_num++;
		penicillin_allergy_str += "<tr><td>"+id_list.get(i)+"</td><td>"+name_list.get(i)+"</td><td>"+crew_list.get(i)+"</td></tr>";
	}
	if(conditions.containsKey("sleep_walking") && conditions.get("sleep_walking")) {
		sleep_walking_num++;
		sleep_walking_str += "<tr><td>"+id_list.get(i)+"</td><td>"+name_list.get(i)+"</td><td>"+crew_list.get(i)+"</td></tr>";
	}
	
}
%>
<br>
<table cellpadding=2 border=1 align='center'>
	<tr><th colspan=3>Asthma(<%=asthma_num%>)</th></tr>
	<tr><th nowrap>Application Number</th><th nowrap>Name</th><th nowrap>Rover Crew</th></tr>
	<%=asthma_str%>
	<tr><td colspan=3><br></td></tr>
	<tr><th colspan=3>Insect Allergy (<%=insect_allergy_num%>)</th></tr>
	<tr><th nowrap>Application Number</th><th nowrap>Name</th><th nowrap>Rover Crew</th></tr>
	<%=insect_allergy_str%>
	<tr><td colspan=3><br></td></tr>
	<tr><th colspan=3>Hay Fever (<%=hay_fever_num%>)</th></tr>
	<tr><th nowrap>Application Number</th><th nowrap>Name</th><th nowrap>Rover Crew</th></tr>
	<%=hay_fever_str%>
	<tr><td colspan=3><br></td></tr>
	<tr><th colspan=3>Haemophilia (<%=haemophilia_num%>)</th></tr>
	<tr><th nowrap>Application Number</th><th nowrap>Name</th><th nowrap>Rover Crew</th></tr>
	<%=haemophilia_str%>
	<tr><td colspan=3><br></td></tr>
	<tr><th colspan=3>Fainting (<%=fainting_num%>)</th></tr>
	<tr><th nowrap>Application Number</th><th nowrap>Name</th><th nowrap>Rover Crew</th></tr>
	<%=fainting_str%>
	<tr><td colspan=3><br></td></tr>
	<tr><th colspan=3>Epilepsy (<%=epilepsy_num%>)</th></tr>
	<tr><th nowrap>Application Number</th><th nowrap>Name</th><th nowrap>Rover Crew</th></tr>
	<%=epilepsy_str%>
	<tr><td colspan=3><br></td></tr>
	<tr><th colspan=3>Heart Condition (<%=heart_condition_num%>)</th></tr>
	<tr><th nowrap>Application Number</th><th nowrap>Name</th><th nowrap>Rover Crew</th></tr>
	<%=heart_condition_str%>
	<tr><td colspan=3><br></td></tr>
	<tr><th colspan=3>Rheumatic Fever (<%=rheumatic_fever_num%>)</th></tr>
	<tr><th nowrap>Application Number</th><th nowrap>Name</th><th nowrap>Rover Crew</th></tr>
	<%=rheumatic_fever_str%>
	<tr><td colspan=3><br></td></tr>
	<tr><th colspan=3>Diabetes (<%=diabetes_num%>)</th></tr>
	<tr><th nowrap>Application Number</th><th nowrap>Name</th><th nowrap>Rover Crew</th></tr>
	<%=diabetes_str%>
	<tr><td colspan=3><br></td></tr>
	<tr><th colspan=3>Food Allergy (<%=food_allergy_num%>)</th></tr>
	<tr><th nowrap>Application Number</th><th nowrap>Name</th><th nowrap>Rover Crew</th></tr>
	<%=food_allergy_str%>
	<tr><td colspan=3><br></td></tr>
	<tr><th colspan=3>Penicillin Allergy (<%=penicillin_allergy_num%>)</th></tr>
	<tr><th nowrap>Application Number</th><th nowrap>Name</th><th nowrap>Rover Crew</th></tr>
	<%=penicillin_allergy_str%>
	<tr><td colspan=3><br></td></tr>
	<tr><th colspan=3>Sleep Walking (<%=sleep_walking_num%>)</th></tr>
	<tr><th nowrap>Application Number</th><th nowrap>Name</th><th nowrap>Rover Crew</th></tr>
	<%=sleep_walking_str%>
	<tr><td colspan=3><br></td></tr>
</table>

<%
dbc.endQuery();
dbm.close();
%>
</moot:mootreport>