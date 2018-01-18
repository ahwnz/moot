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
@author Alex Westphal sucks

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

<moot:moothead title='Utilities - Registration'>
	<%@ page import="redcloud.db.*" %>
    <%@ page import="java.util.*" %>
	<%@ page import="common.Pair"%>
	<moot:mootmenu selected='utils'/>
    <style>
        td.title {
            text-align:right;
            font-weight:bolder;
        }

        td.content {
            text-align:center;
        }

    </style>
    <script src="/moot/jscript/finger.js"></script>
</moot:moothead>

<%
final DbManager dbm = new DbManager("jdbc/moot");
dbm.open();

final List<Pair<Integer,String>> list = new ArrayList<Pair<Integer,String>>();

final DbConnect dbc = dbm.doQuery("SELECT rover_id, CONCAT(last_name,', ',first_name) AS full_name FROM rover ORDER BY rover_id");

while(dbc.next()) {
    list.add(new Pair<Integer, String>(dbc.getInt("rover_id"), dbc.getString("full_name")));
}

dbc.endQuery();
dbm.close();
%>

<moot:bodytable>

<h2>Registration</h2>

<table align="center" cellpadding="4">
    <tr id="row1">
        <td class="title">Application ID:</td>
        <td>&nbsp;</td>
        <td class="content">
            <select id="appid">
                <option value="0"> - App Id - </option>
                <% for(Pair<Integer, String> pair: list) {%>
               <option value="<%=pair.getA()%>"><%=String.format("%d - %s", pair.getA(), pair.getB())%></option>
               <% } %>
            </select>
        </td>
    </tr>
    <%
    Collections.sort(list, new Comparator<Pair<Integer, String>>() {
        public int compare(Pair<Integer, String> pair1, Pair<Integer, String> pair2) {
            return pair1.getB().compareTo(pair2.getB());
        }
    });
    %>
    <tr id="row2">
        <td class="title">Name:</td>
        <td>&nbsp;</td>
        <td class="content">
            <select id="name">
                <option value="0"> - Name - </option>
               <% 
               char lc = ' ';
                for(Pair<Integer, String> pair: list) {
                    char c = Character.toUpperCase(pair.getB().charAt(0));
                    if(c != lc) {
                        if(lc != ' ') { %></optgroup><% }
                        %><optgroup label="<%=c%>"><%
                        lc = c;
                    }
                %>
               <option value="<%=pair.getA()%>"><%=String.format("%s (%d)", pair.getB(), pair.getA())%></option>
               <% } %>
            </select>
        </td>
    </tr>
    <tr>
        <td class="title">Nickname:</td>
        <td>&nbsp;</td>
        <td class="content"><div id="nickname"></div></td>
    </tr>
    <tr>
        <td class="title">Crew:</td>
        <td>&nbsp;</td>
        <td class="content"><div id="crew"></div></td>
    </tr>
    <tr>
        <td class="title">Region:</td>
        <td>&nbsp;</td>
        <td class="content"><div id="region"></div></td>
    </tr>
    <tr>
        <td class="title">Moot Number:</td>
        <td>&nbsp;</td>
        <td class="content"><div id="mootnum"></div></td>
    </tr>
    <tr>
        <td class="title">Registered:</td>
        <td>&nbsp;</td>
        <td class="content"><div id="registered"></div></td>
    </tr>
    <tr>
        <td class="title">Payed:</td>
        <td>&nbsp;</td>
        <td class="content"><div id="payed"></div></td>
    </tr>
    <tr>
        <td class="title">Owing:</td>
        <td>&nbsp;</td>
        <td class="content"><div id="owing"></div></td>
    </tr>
    <tr>
        <td class="title">Pay:</td>
        <td>&nbsp;</td>
        <td class="content"><div id="pay"></div></td>
    </tr>
    <tr>
        <td class="title">Receipt:</td>
        <td>&nbsp;</td>
        <td class="content"><div id="receipt"></div></td>
    </tr>
    
</table>

<script>
    $(document).ready(function() {
        $("#row1").mouseover(function() {
            document.getElementById("appid").focus();
        });
        $("#row2").mouseover(function() {
            document.getElementById("name").focus();
        });

        var getDetails = function(id) {
            $.get("/moot/servlet/admin/register/GetRover",{appid:id}, function(xml) {
                $("#nickname").html($("nickname", xml).text());
                $("#crew").html($("crew", xml).text());
                $("#region").html($("region", xml).text());
                $("#mootnum").html($("mootnum", xml).text());
                var owing = $("owing", xml).text();
                var payed = $("payed", xml).text();

                var fully_payed = owing == "0";
                if($("registered", xml).text() == 'N') {
                    var register = $("<button id='register'>Register</button>");
                    $("#registered").empty().append(register);
                    register.click(function() {
                        if(fully_payed || confirm("Register without full payment?")) {
                            $.get("/moot/servlet/admin/register/Register", {appid:id}, function(xml) {
                                $("#registered").html($("status", xml).text());
                            });
                        }
                    });
                } else $("#registered").html("Registered");
                $("#payed").html(payed);
                $("#owing").html(owing);
                if(!fully_payed) {
                    var method = $("<select id='method'><option value='Cheque'>Cheque</option><option value='Cash'>Cash</option><option value='Eftpos'>Eftpos</option><option value='Credit Card'>Credit Card</option></select>");
                    var pay = $("<button id='pay'>Pay</button>");
                    $("#pay").empty().append(method).append(pay);
                    pay.click(function() {
                        $.get("/moot/servlet/admin/register/Pay", {appid:id, method:method.val(),amount:owing}, function() {
                            getDetails(id);
                        });
                    });
                } else $("#pay").html("Payed");
                $("#receipt").html("<a href='/moot/servlet/paperwork/StandardReceipt?appid="+id+"&images=y&pid="+$("rid", xml).text()+"' target='_blank'>Download Receipt</a>");
            });
        };

        $("#appid").change(function() {$("#name").val($(this).val()); getDetails($(this).val());});
        $("#name").change(function() {$("#appid").val($(this).val()); getDetails($(this).val());});
        
    });
</script>



</moot:bodytable>
</html>