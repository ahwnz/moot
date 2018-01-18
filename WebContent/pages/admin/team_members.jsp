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
<html>

<moot:moothead title='Team Members'>
	<%@ page import="redcloud.db.*" %>
    <%@ page import="admin.GetTeam" %>
	<%@ page import="java.util.List"%>
    <%@ page import="java.util.ArrayList"%>
    <%@ page import="java.util.Collections"%>
    <moot:mootmenu selected='teams'/>
</moot:moothead>

<moot:bodytable>

<h2>Shooting Trophy</h2>
<br>

<%
String add_str = request.getParameter("add");
int add = 0;
if(add_str!=null) add = Integer.parseInt(add_str);
%>

<table align='center' cellpadding=4 cellspacing=0 border=0>
    <tr>
        <td>
            <select id="algorithm">
                <option value=0>- Algorithm -</option>
                <option value=1>Simple Algorithm</option>
                <option value=2>Simple Crew Based Algorithm</option>
                <option value=3>Greedy Crew Based Algorithm</option
            </select>
            <select id="team_count">
                <option value=0>- Team Count -</option>
                <%for(int i=0; i<20; i++) {%>
                    <option value=<%=i%>><%=i%></option>
                <% } %>
            </select>
            <button onclick="runAllocate(); return false;">Allocate</button>
        </td>
    </tr>
</table>
<%
final DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

final DbConnect dbc = dbm.doQuery("SELECT DISTINCT team_number FROM rover_team ORDER BY team_number");
final List<Integer> teamList = new ArrayList<Integer>();

while(dbc.next()) {
    int teamNum = dbc.getInt("team_number");
    teamList.add(teamNum);
}
dbc.endQuery();


int lowest = 1;
for(int i=0; i<add; i++) {
    while(teamList.contains(lowest)) lowest++;
    teamList.add(lowest);
}

Collections.sort(teamList);

for(int team: teamList) {
    %>
    <h3>Team <%=team%></h3>
    <div id="team<%=team%>"><%=GetTeam.getTeam(dbm, team)%></div>
    <br>
    <div id="team<%=team%>_add" align="center"></div>
    <%
}

dbm.close();
%>

<br><br><h3></h3>
<table align='center' cellpadding=4 cellspacing=0 border=0>
    <tr>
        <td>
            <a href="/moot/pages/admin/teams.jsp?add=<%=add+1%>" title='Add Team'>
                <img src='/moot/images/add.png' width='16' height='16' border='0'>
            </a>
            &nbsp;&nbsp;
            <a href="/moot/pages/admin/team_members.jsp?add=<%=add+1%>" title='Add Team'>Add New Team</a>
        </td>
    </tr>
</table>

<script src='/moot/jscript/oplsajax.js'></script>
<script>

    collapseAddAll();

    function getTeam(teamNum) {
        makeAjaxCall(getDisplayTeam(teamNum), "/moot/servlet/admin/GetTeam", "tnum="+teamNum);
    }

    function getTeamAll() {
        <% for(int team: teamList) { %>getTeam(<%=team%>);<% } %>
    }

    function getDisplayTeam(teamNum) {
        return function(str) {
            document.getElementById("team"+teamNum).innerHTML = str;
        }
    }

    function removeMember(teamNum, appid) {
        makeAjaxCall(getDisplayTeam(teamNum), "/moot/servlet/admin/RemoveTeamMember", "appid="+appid+"&tnum="+teamNum);
    }

    function collapseAdd(teamNum) {
        document.getElementById("team"+teamNum+"_add").innerHTML = "<a onclick='expandAdd("+teamNum+"); return false;' title='Add Team Member'>"+
            "<img src='/moot/images/add.png' width='16' height='16' border='0'>&nbsp;&nbsp;Add Team Member</a>";
    }

    function expandAdd(teamNum) {
        collapseAddAll();
        makeAjaxCall(getDisplayAdd(teamNum), "/moot/servlet/admin/GetTeamUnassigned", "tnum="+teamNum);
    }

    function getDisplayAdd(teamNum) {
        return function(str) {
            document.getElementById("team"+teamNum+"_add").innerHTML = str;
        }
    }

    function collapseAddAll() {
        <% for(int team: teamList) { %>collapseAdd(<%=team%>);<% } %>
    }

    function addMember(teamNum) {
        var appid = document.getElementById("team"+teamNum+"_add_select").value;
        makeAjaxCall(getDisplayTeam(teamNum), "/moot/servlet/admin/AddTeamMember", "appid="+appid+"&tnum="+teamNum);
        collapseAddAll();
    }

    function runAllocate() {
        var algorithm = document.getElementById("algorithm").value;
        var team_count = document.getElementById("team_count").value;

        if(team_count == 0) {
            alert("Please select a team count.");
        } else if(algorithm == 0) {
            alert("Please select an algorithm.");
        } else if(algorithm == 1) {
            if(confirm("This will delete all existing team allocations are you sure?")) {
                window.location = "/moot/servlet/admin/SimpleTeamAssignSubmit?team_count="+team_count;
            }
        } else if(algorithm == 2) {
            if(confirm("This will delete all existing team allocations are you sure?")) {
                window.location = "/moot/servlet/admin/SimpleCrewTeamAssignSubmit?team_count="+team_count;
            }
        } else if(algorithm == 3) {
            if(confirm("This will delete all existing team allocations are you sure?")) {
                window.location = "/moot/servlet/admin/GreedyCrewTeamAssignSubmit?team_count="+team_count;
            }
        }
    }

</script>
</moot:bodytable>
</html>