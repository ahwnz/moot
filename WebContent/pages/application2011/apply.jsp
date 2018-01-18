<%--
______________________________________________________
      __     _   _      ___      __   ______   _     _
    /    )   /  /|    /        /    )   /      /    /
----\-------/| /-|---/___-----(___ /---/------/___ /--
     \     / |/  |  /    )        /   /      /    /
_(____/___/__/___|_(____/___(____/___/______/____/____

                   69th NZ Rover Moot

Copyright (c) 2009-2011, Redcloud Development, Ltd. All rights reserved
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

<%@ include file="page_head.jsp" %>
<%@ page import="redcloud.db.*" %>
<%@ page import="java.util.ArrayList" %>

<%
DbManager dbm = new DbManager("jdbc/moot");
dbm.open();
DbConnect dbc = dbm.doQuery("SELECT tour_id, tour_name FROM tour ORDER BY tour_name");
ArrayList<Integer> idList = new ArrayList<Integer>();
ArrayList<String> nameList = new ArrayList<String>();
while(dbc.next()) {
        idList.add(dbc.getInt("tour_id"));
        nameList.add(dbc.getString("tour_name"));
}
dbc.endQuery();
dbm.close();
%>

<style type="text/css" >
    body {
        font-family:Verdana, Arial, sans-serif;
    }

    input, textarea {
            border:1px solid #aaa;
            font-size:18px; padding:4px;
            text-align:center;
            background-color: #ccc;
            -moz-box-shadow:0 0 10px #222 inset;
            -webkit-box-shadow:0 0 10px #222 inset;
    }
    select {
        padding: 2px 0px;
        /*width: 200px;*/
        text-align: center;
    }
    #calroot {
            z-index:10; margin-top:-1px;
            width:198px; padding:2px;
            background-color:#fff;
            font-size:11px;
            border:1px solid #ccc;
            -moz-border-radius:5px;
            -webkit-border-radius:5px;
            -moz-box-shadow: 0 0 15px #666;
            -webkit-box-shadow: 0 0 15px #666;
    }
    #calhead { padding:2px 0; height:22px; }
    
    #caltitle {
            font-size:14px;
            color:#FF0000;
            float:left;
            text-align:center;
            width:155px;
            line-height:20px;
            text-shadow:0 1px 0 #ddd;
    }
    #calnext, #calprev {
            display:block; float:left;
            width:20px; height:20px;
            background:transparent url(/moot/images/prev.png) no-repeat scroll center center;
            cursor:pointer;
    }
    #calnext { background-image:url(/moot/images/next.png); float:right; }
    #calprev.caldisabled, #calnext.caldisabled { visibility:hidden; }
    #caltitle select { font-size:10px; }
    #caldays { height:14px; border-bottom:1px solid #ddd; }
    #caldays span {
            display:block; float:left;
            width:28px; text-align:center;
    }
    #calweeks { background-color:#fff; margin-top:4px; }
    .calweek { clear:left; height:22px; }
    .calweek a {
            display:block; float:left;
            width:27px; height:20px;
            text-decoration:none; text-align:center;
            font-size:11px; color:#666;
            margin-left:1px; line-height:20px;
            -moz-border-radius:3px; -webkit-border-radius:3px;
    }
    .calweek a:hover, .calfocus { background-color:#ddd; }
    a.calsun { color:red; }
    a.caloff { color:#ccc; }
    a.caloff:hover { background-color:rgb(250, 245, 245); }
    a.caldisabled {
            background-color:#efefef !important;
            color:#ccc	!important;
            cursor:default;
    }
    #calcurrent { background-color:#bf463b; color:#fff; }
    #caltoday { background-color:#333; color:#fff; }
    label {
        color:#FFFFFF; font-size:18px;
        font-family:Verdana,Arial,Helvetica,sans-serif;
        margin: 2px 10px; padding:0;
        text-align: center;
    }
    .modal {
            background-color:#fff;
            display:none;
            width:600px;
            padding:15px;
            text-align:left;
            border:2px solid #333;

            opacity:0.8;
            -moz-border-radius:6px;
            -webkit-border-radius:6px;
            -moz-box-shadow: 0 0 50px #ccc;
            -webkit-box-shadow: 0 0 50px #ccc;
    }

    .modal h2 {
            margin:0px;
            padding:10px 0 10px 45px;
            border-bottom:1px solid #333;
            font-size:20px;
    }

    .error {
	/* supply height to ensure consistent positioning for every browser */
	height:15px;
	background-color:#f2ad6a;
	border:1px solid #f9cc8b;
	font-size:11px;
	color:#000;
	padding:3px 10px;
	margin-left:-2px;

	/* CSS3 spicing for mozilla and webkit */
	-moz-border-radius:4px;
	-webkit-border-radius:4px;
	-moz-border-radius-bottomleft:0;
	-moz-border-radius-topleft:0;
	-webkit-border-bottom-left-radius:0;
	-webkit-border-top-left-radius:0;

	-moz-box-shadow:0 0 6px #ddd;
	-webkit-box-shadow:0 0 6px #ddd;
    }

    .denom {
        display:none;
    }

    .formtext {
        color:#555;
        font-size: 90%;
    }

    .staffonly {
        display: none;
    }

    /* slider root element */
.slider {
	background:#E6723C url(/moot/images/gradient_h30.png) repeat-x 0 0;
	height:9px;
	position:relative;
	cursor:pointer;
	border:1px solid #333;
	width:500px;
	float:left;
	clear:right;
	margin-top:10px;
	-moz-border-radius:5px;
	-webkit-border-radius:5px;
	-moz-box-shadow:inset 0 0 8px #000;
}

    /* progress bar (enabled with progress: true) */
    .progress {
	height:9px;
	background-color:#FFC500;
	display:none;
	opacity:0.6;
    }

    /* drag handle */
    .handle {
	background:#fff url(/moot/images/gradient_h30.png) repeat-x 0 0;
	height:28px;
	width:28px;
	top:-12px;
	position:absolute;
	display:block;
	margin-top:1px;
	border:1px solid #000;
	cursor:move;
	-moz-box-shadow:0 0 6px #000;
	-webkit-box-shadow:0 0 6px #000;
	-moz-border-radius:14px;
	-webkit-border-radius:14px;

    }

    /* the input field */
    .range {
	border:1px inset #ddd;
	float:left;
	font-size:20px;
	margin:0 0 0 15px;
	padding:3px 0;
	text-align:center;
	width:50px;
	-moz-border-radius:5px;
	-webkit-border-radius:5px;
    }


    
</style>


<h1>Application Form</h1>


<br><br>
<form action="/moot/servlet/application/ApplicationSubmit" method="POST">
    <table width="700px" cellpadding="2" cellspacing="0" border="0">
        <tr><td colspan="4" align="center"><h2>Personal Details</h2></td></tr>
        <tr>
            <td width="150px"><label>First Name</label></td>
            <td width="200px"><input type="text" name="first_name" required="required" maxlength="50"/></td>
            <td width="150px"><label>Last Name</label></td>
            <td width="200px"><input type="text" name="last_name" required="required" maxlength="50"/></td>
        </tr>
    
        <tr>
            <td><label>Nickname</label></td>
            <td><input type="text" name="nickname" maxlength="50"/></td>
            <td><label>Date of Birth</label></td>
            <td><input type="date" name="date_of_birth" required="required"/></td>
        </tr>
        <tr>
            <td><label>Address</label></td>
            <td><textarea name="address" required="required"></textarea></td>
            <td><label>Sex</label></td>
            <td><select name="sex" id="sex" required="required">
                    <option value="" selected></option>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                </select></td>
        </tr>
        <tr>
            <td><label>Home Phone</label></td>
            <td><input name="home_phone" type="text" maxlength="50" pattern="[0-9 ]*"/></td>
            <td><label>Mobile Phone</label></td>
            <td><input name="mobile_phone" type="text" maxlength="50" pattern="[0-9 ]*"/></td>
        </tr>
        <tr>
            <td><label>Work Phone</label></td>
            <td><input name="work_phone" type="text" maxlength="50" pattern="[0-9 ]*"/></td>
            <td><label>Email</label></td>
            <td><input name="email" type="email" maxlength="50" required="required"/></td>
        </tr>
        <tr>
            <td><label>Rover Crew</label></td>
            <td><input name="rover_crew" type="text" maxlength="50"></td>
            <td><label>Rover Status</label></td>
            <td><select name="rover_status" required="required">
                    <option value="" selected></option>
                    <option value="Squire">Squire</option>
                    <option value="Full">Full</option>
                    <option value="Associate">Associate</option>
                    <option value="Leader">Leader</option>
                </select></td>
        </tr>
        <tr>
            <td><label>Region</label></td>
            <td><select name='region' id='region' required="required">
                    <option value='' selected></option>
                    <option value='Region1'>Upper North Island</option>
                    <option value='Region2'>Central North Island</option>
                    <option value='Region3'>Lower North Island</option>
                    <option value='Region4'>Upper South Island</option>
                    <option value='Region5'>Lower South Island</option>
                    <option value='Australia'>Australia</option>
            </select></td>
            <td><label>Moot Status</label></td>
            <td><select name="moot_status" required="required">
                    <option value='' selected></option>
                    <option value="1">Virgin Mooter</option>
                    <option value="2">2nd Moot</option>
                    <option value="3">3rd Moot</option>
                    <option value="4">4th Moot</option>
                    <option value="5">5th Moot</option>
                    <option value="Lost">Lost Count</option>
                </select></td>
        </tr>

        <tr><td colspan="4" align="center"><br><h2>Transport</h2></td></tr>
        <tr>
            <td><label>Accommodation</label></td>
            <td><select name="accommodation" required="required">
                    <option value="" selected></option>
                    <option value="Cabin">Assign to Cabin</option>
                    <option value="Tent">Assign to Tent</option>
                    <option value="Own">Bringing Own Tent</option>
                </select></td>
            <td><label>Transport Type</label></td>
            <td><select name="transport_type" required="required">
                    <option value="" selected></option>
                    <option value="Plane">Plane to Rotorua</option>
                    <option value="Bus">Bus to Rotorua</option>
                    <option value="OwnSite">Own to Site</option>
                </select></td>
        </tr>
        <tr>
            <td><label>Arrival</label></td>
            <td><input name="transport_specific_arrival" type="text" maxlength="250"></td>
            <td><label>Departure</label></td>
            <td><input name="transport_specific_departure" type="text" maxlength="250"></td>
        </tr>
        <tr><td colspan="4" align="center" class="formtext">Please keep us up to date with your travel arrangements.</td></tr>

        <tr><td colspan="4" align="center"><br><h2>Other Details</h2></td></tr>
        <tr><td colspan="4" align="center"class="formtext">Do you wish to attend a church service on easter Sunday.</td></tr>
        <tr>
            <td><label>Church Service</label></td>
            <td><select name="church_service" id="church_service">
                    <option value="N">No</option>
                    <option value="Y">Yes</option>
                </select></td>
            <td class="denom"><label>Denomination</label></td>
            <td class="denom"><select name="denom">
                    <option value=""></option>
                    <option value="Presbyterian">Presbyterian</option>
                    <option value="Catholic"> Catholic</option>
                    <option value="Anglican">Anglican</option>
                    <option value="Methodist">Methodist</option>
                </select></td>

        </tr>
        <tr>
            <td><label>Service Project</label></td>
            <td colspan="3" class="formtext"><table>
                    <tr>
                        <td>Builder</td>
                        <td><input type='checkbox' name='builder' id='builder'></td>
                        <td>Electrician</td>
                        <td><input type='checkbox' name='electrician' id='electrician'></td>
                        <td>Plumber</td>
                        <td><input type='checkbox' name='plumbing' id='plumbing'></td>
                        <td>Painter</td>
                        <td><input type='checkbox' name='painter' id='painter'></td>
                        <td>Gardening</td>
                        <td><input type='checkbox' name='gardening' id='gardening'></td>
                        <td>Welding<td>
                        <td><input type='checkbox' name='welding' id='welding'></td>
                    </tr>
                </table></td>
        </tr>
        <tr>
            <td><label>Other Skills</label></td>
            <td colspan=3><input type='text' maxlength='200' name='service_skills' id='service_skills' style="width: 500px;"/></td>
        </tr>
        <tr>
            <td class="formtext"><label>Years of Service</label><br>(As a Rover or Leader)</td>
            <td colspan="3"><input type="range" name="service_years" min="0" max="50" value="0" /></td>
        </tr>
         <tr>
            <td class="formtext"><label>Bar Cards</label><br>($20 each)</td>
            <td colspan="3"><input type="range" name="bar_cards" min="0" max="20" value="0" /></td>
        </tr>

        <tr><td colspan="4" align="center"><br><h2>Offsite Tours</h2></td></tr>

        <tr>
            <td><label>1st Choice</label></td>
            <td><select class="tours" name='tour_pref_1' id='tour_pref_1' required="required">
                    <option value=''></option>
                    <%for(int i=0; i<idList.size(); i++) { %>
                            <option value='<%=idList.get(i)%>'><%=nameList.get(i)%></option>
                    <%} %>
                </select></td>

            <td colspan="2" rowspan="3" class="formtext">
            Please select three offsite tours in order of preference. We will endeavor to allocate everyone to their first choice, however you will be allocated
            a tour on a first come, first served basis only once full payment has been received. <a href="http://www.sm69thmoot.com/tours.html" target='_blank'>More Information</a>
            </td>
	</tr>
	<tr>
            <td><label>2nd Choice</label></td>
            <td><select class="tours" name='tour_pref_2' id='tour_pref_2' required="required">
                    <option value=''</option>
                    <%for(int i=0; i<idList.size(); i++) { %>
                            <option value='<%=idList.get(i)%>'><%=nameList.get(i)%></option>
                    <%} %>
            </select></td>
	</tr>
	<tr>
            <td><label>3rd Choice</label></td>
            <td><select class="tours" name='tour_pref_3' id='tour_pref_3' required="required">
                    <option value=''></option>
                    <%for(int i=0; i<idList.size(); i++) { %>
                            <option value='<%=idList.get(i)%>'><%=nameList.get(i)%></option>
                    <%} %>
            </select></td>
	</tr>
        <tr><td colspan="4" align="center"><br><h2>Staff</h2></td></tr>
        <tr>
            <td><label>Application Type</label></td>
            <td><select name="staff" id="staff">
                    <option value="N">Participant</option>
                    <option value="Y">Staff</option>
                </select></td>
            <td><label class="staffonly">Full License</label></td>
            <td><select class="staffonly" name="staff_license">
                    <option value="Y">Yes</option>
                    <option value="N">No</option>
                </select></td>
        </tr>
        <tr>
            <td><label class="staffonly">Trade Skills</label></td>
            <td><input class="staffonly" type="text" name="staff_skills"></td>
             <td><label class="staffonly">Manual Qualified</label></td>
            <td><select class="staffonly" name="staff_manual">
                    <option value="Y">Yes</option>
                    <option value="N">No</option>
                </select></td>
        </tr>
        <tr>
            <td><label class="staffonly">Warrant</label></td>
            <td><select class="staffonly" name="staff_warrant">
                    <option value="None">None</option>
                    <option value="Keas">Keas</option>
                    <option value="Cubs">Cubs</option>
                    <option value="Scouts">Scouts</option>
                    <option value="Venturers">Venturers</option>
                    <option value="Zone">Zone</option>
                </select></td>
        </tr>

        <tr><td colspan="4" align="center"><br><h2>Medical and Emergency Details</h2></td></tr>
	<tr><td colspan=4><h2><br>Emergency Contact:</h2></td></tr>
	<tr>
		<td><label>Name</label></td>
		<td ><input type='text' maxlength='100' name='contact_name' required="required"/></td>
		<td><label>Relationship</label></td>
		<td><input type='text' maxlength='50' name='contact_relationship' required="required"/></td>
	</tr>
	<tr>
		<td><label>Phone</label></td>
		<td><input type='text' maxlength='50' name='contact_phone' required="required"/></td>
	</tr>
	<tr><td colspan=5><h2><br>Doctor:</h2></td></tr>
	<tr>
		<td><label>Name</label></td>
		<td nowrap><input type='text' maxlength='100' name='doctor_name' required="required"/></td>
		<td rowspan=2><label>Address</label></td>
		<td rowspan=2><textarea name='doctor_address' required="required"></textarea></td>
	</tr>
	<tr>
		<td><label>Phone</label></td>
		<td><input type='text' maxlength='50' name='doctor_phone' required="required"/></td>
	</tr>
        <tr><td colspan=5 class="formtext"><h2><br>Contact At Moot:</h2>(Present at moot for emergencies)</td></tr>
        <tr>
		<td><label>Name</label></td>
		<td ><input type='text' maxlength='100' name='moot_contact_name' required="required"/></td>
	</tr>
	<tr><td colspan=5><h2><br>Do you suffer any of the following:</h2></td></tr>
	<tr><td colspan=5><table cellpadding=4>
		<tr>
			<td><label>Asthma</label></td>
			<td><input type='checkbox' name='asthma'/></td>
			<td><label>Insect Allergy</label></td>
			<td><input type='checkbox' name='insect_allergy'/></td>
			<td><label>Hay Fever</label></td>
			<td><input type='checkbox' name='hay_fever'/></td>
			<td><label>Haemophilia</label></td>
			<td><input type='checkbox' name='haemophilia'/></td>
		</tr>
		<tr>
			<td><label>Fainting</label></td>
			<td><input type='checkbox' name='fainting'/></td>
			<td><label>Epilepsy/Convulsions</label></td>
			<td><input type='checkbox' name='epilepsy'/></td>
			<td><label>Heart Condition</label></td>
			<td><input type='checkbox' name='heart_condition'/></td>
			<td><label>Rheumatic Fever</label></td>
			<td><input type='checkbox' name='rheumatic_fever'/></td>
		</tr>
		<tr>
			<td><label>Diabetes</label></td>
			<td><input type='checkbox' name='diabetes'/></td>
			<td><label>Food Allergy</label></td>
			<td><input type='checkbox' name='food_allergy'/></td>
			<td><label>Penicillin Allergy</label></td>
			<td><input type='checkbox' name='penicillin_allergy'/></td>
			<td><label>Sleep Walking</label></td>
			<td><input type='checkbox' name='sleep_walking'/></td>
		</tr>
	</table></td></tr>
	<tr>
		<td><label>Other Medical Conditions</label></td>
		<td><textarea  name='conditions'></textarea></td>
		<td><label>Special Dietary Needs</label></td>
		<td><textarea name='dietary_requirements'></textarea></td>
	</tr>

    </table>
    <div style="color: #555; width: 500px; padding: 20px 0px;">
        This application is a true statement of my identity and health and I have
        read and accepted the <a id="tos_link" href="http://www.sm69thmoot.com/apply.html" target="_blank">Terms and Conditions</a>.
        
    </div>
    <button id="submit">Submit</button>
    <br><br>
</form>



<script type="text/javascript">
    $(function() {
        $(":date").dateinput({yearRange:[-60,15], value:"1980-1-1", selectors:true,format:"dd/mm/yyyy"});
        $("#submit").click(function() { setTimeout('alert("The form could not be submitted, please check that you\'ve filled out all mandatory fields.")',3000) });
        $("form").validator();
        $("label").parent("td").attr("align", "right");
        $(":range").rangeinput();

        $("#church_service").change(function() {
            if($(this).val() == "Y") {
                $(".denom").fadeIn();
            } else {
                $(".denom").fadeOut();
            }
        });

        $(".tours").change(function() {
            $(".tours > option").show();
            $(".tours").each(function() {
                if(!$(this).val() == '') {
                    $(".tours > option[value="+$(this).val()+"]").hide();
                }
            });
        });

        $("#staff").change(function() {
            if($(this).val() == 'Y') {
                $(".staffonly").fadeIn();
                $(".tours").attr("required", "");
            } else {
                $(".staffonly").fadeOut();
                $(".tours").attr("required", "required");
            }
        });

        
        
    });
    
</script>

<%@ include file="page_foot.jsp" %>







