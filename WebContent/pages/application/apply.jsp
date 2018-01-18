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

<%@ include file="page_head.jsp" %>

<h1>Application Form</h1>



<form action='/moot/servlet/application/ApplicationSubmit' method='POST'>

<%@ page import="redcloud.db.*" %>
<%@ page import="java.util.ArrayList" %>

<%
if(true || request.getParameter("can")!=null && request.getParameter("can").startsWith("y")) {

final int INPUT_WIDTH = 25;
final int TA_COLS=29;
DbManager dbm = new DbManager("jdbc/moot");
dbm.open();
%>
<br>
This form is for New Zealand applications only, for international applications please use the <a href='http://www.heromoot.com/media/inter_app.pdf'>international application form</a>.
<p>
Permission from your Regional Rover Leader to attend Hero Moot 2010 is not required to fill out this form. Your Regional Rover Leader
will be contacted by Hero Moot Administration to obtain their consent.
<br>
<table cellpadding=4>
	<tr><td colspan=5 align='center'><h2>Personal Details</h2></td></tr>
	<tr>
		<td nowrap><h2>First Name</h2></td>
		<td><input type='text' size='<%=INPUT_WIDTH%>' maxlength='50' name='first_name' id='first_name'></input></td>
		<td>&nbsp;&nbsp;</td>
		<td nowrap><h2>Last Name</h2></td>
		<td><input type='text' size='<%=INPUT_WIDTH%>' maxlength='50' name='last_name' id='last_name'></input></td>
	</tr>
	<tr>
		<td nowrap><h2>Nickname</h2></td>
		<td><input type='text' size='<%=INPUT_WIDTH%>' maxlength='50' name='nickname' id='nickname'></input></td>
		<td>&nbsp;&nbsp;</td>
		<td nowrap><h2>Date of Birth</h2></td>
		<td nowrap>
			<select name='date_of_birth_day' id='date_of_birth_day'>
				<option value='' selected>-day-</option>
				<%for(int i=1; i<=31; i++) { %>
					<option value='<%=i%>'><%=i%></option>
				<% } %>
			</select>
			<select name='date_of_birth_month' id='date_of_birth_month'>
				<option value='' selected>-month-</option>
				<option value='0'>Jan</option>
				<option value='1'>Feb</option>
				<option value='2'>Mar</option>
				<option value='3'>Apr</option>
				<option value='4'>May</option>
				<option value='5'>Jun</option>
				<option value='6'>Jul</option>
				<option value='7'>Aug</option>
				<option value='8'>Sep</option>
				<option value='9'>Oct</option>
				<option value='10'>Nov</option>
				<option value='11'>Dec</option>
			</select>
			<select name='date_of_birth_year' id='date_of_birth_year'>
				<option value='' selected>-year-</option>
				<%for(int i=1970; i<=2008; i++) { %>
					<option value='<%=i%>'><%=i%></option>
				<% } %>
			</select>
		</td>
	</tr>
	<tr>
		<td><h2>Address</h2></td>
		<td><textarea cols='<%=TA_COLS%>' name='address' id='address'></textarea></td>
		<td>&nbsp;&nbsp;</td>
		<td><h2>Sex</h2></td>
		<td><table>
			<tr>
				<td><h3 class='radio'>&nbsp;Yes Please</h3></td>
				<td><input type='radio' name='sex_radio' id='sex_please' value='Please'></input></td>
				<td><h3>Male</h3></td>
				<td><input type='radio' name='sex_radio' id='sex_male' value='Male'></input></td>
			</tr>
			<tr>
				<td><h3>&nbsp;Not Sure</h3></td>
				<td><input type='radio' name='sex_radio' id='sex_undecided' value='Undecided'></input></td>
				<td><h3>Female</h3></td>
				<td><input type='radio' name='sex_radio' id='sex_female' value='Female'></input></td>
			</tr>
		</table></td>
	</tr>
	<tr>
		<td nowrap><h2>Home Phone</h2></td>
		<td><input type='text' size='<%=INPUT_WIDTH%>' maxlength='50' name='home_phone' id='home_phone'></input></td>
		<td>&nbsp;&nbsp;</td>
		<td nowrap><h2>Mobile</h2></td>
		<td><input type='text' size='<%=INPUT_WIDTH%>' maxlength='50' name='mobile_phone' id='mobile_phone'></input></td>
	</tr>
	<tr>
		<td nowrap><h2>Work Phone</h2></td>
		<td><input type='text' size='<%=INPUT_WIDTH%>' maxlength='50' name='work_phone' id='work_phone'></input></td>
		<td>&nbsp;&nbsp;</td>
		<td nowrap><h2>Email</h2></td>
		<td><input type='text' size='<%=INPUT_WIDTH%>' maxlength='50' name='email' id='email'></input></td>
	</tr>
	<tr><td colspan=5><div class="padding"> </div></td></tr>
	
	<tr><td colspan=5 align='center'><h2>Rover Details</h2></td></tr>
	<tr>
		<td><h2>Crew</h2></td>
		<td><input type='text' size='<%=INPUT_WIDTH%>' maxlength='50' name='rover_crew' id='rover_crew'></input></td>
		<td>&nbsp;&nbsp;</td>
		<td rowspan=2><h2>Status</h2></td>
		<td rowspan=2><table> 
			<tr>
				<td><h3>Full Rover</h3></td>
				<td><input type='radio' name='rover_status' id='rover_status_full' value='Full'></input></td>
				<td><h3>Associate</h3></td>
				<td><input type='radio' name='rover_status' id='rover_status_associate' value='Associate'></input></td>
			</tr>
			<tr>
				<td><h3>Squire</h3></td>
				<td><input type='radio' name='rover_status' id='rover_status_squire' value='Squire'></input></td>
				<td><h3>Young Leader</h3></td>
				<td><input type='radio' name='rover_status' id='rover_status_leader' value='Leader'></input></td>
			</tr>
		</table></td>
	</tr>
	<tr>
		<td><h2>Region</h2></td>
		<td><select name='region' id='region'>
			<option value='' selected>- select -</option>
			<option value='Region1'>Upper North Island</option>
			<option value='Region2'>Central North Island</option>
			<option value='Region3'>Lower North Island</option>
			<option value='Region4'>Upper South Island</option>
			<option value='Region5'>Lower South Island</option>
		</select></td>
		<td>&nbsp;&nbsp;</td>
	</tr>
	<tr><td colspan=5><div class="padding"> </div></td></tr>
	<tr><td colspan=5 align='center'><h2>Accommodation</h2></td></tr>
	<tr>
		<td colspan=5 align='center'><table>
			<tr>
				<td><h3>Assign to Tent</h3></td>
				<td><input type='radio' name='accommodation_radio' id='accommodation_tent' value='Tent'></input></td>
				<td><h3>Bringing Own Tent</h3></td>
				<td><input type='radio' name='accommodation_radio' id='accommodation_own' value='Own'></input></td>
			</tr>
		</table></td>
	</tr>
	<tr><td colspan=5><div class="padding"> </div></td></tr>
	<tr><td colspan=5 align='center'><h2>Transport</h2></td></tr>
	<tr>
		<td><h2>Type</h2></td>
		<td colspan=4><table cellpadding=4><tr>
				<td><h3>&nbsp;Plane</h3></td>
				<td><input type='radio' name='transport_radio' id='transport_plane' value='Plane'></input></td>
				<td><h3>&nbsp;Bus</h3></td>
				<td><input type='radio' name='transport_radio' id='transport_bus' value='Bus'></input></td>
				<td><h3>&nbsp;Train</h3></td>
				<td><input type='radio' name='transport_radio' id='transport_train' value='Train'></input></td>
				<td><h3>&nbsp;Own to Christchurch</h3></td>
				<td><input type='radio' name='transport_radio' id='transport_own_ch' value='OwnChch' checked></input></td>
		</tr></table></td>
	</tr>
	<tr>
		<td><h2>&nbsp;Arrival</h2></td>
		<td colspan=4><input type='text' size='70' maxlength='250' name='transport_specific_arrival' id='transport_specific_arrival'></input></td>
	</tr>
	<tr>
		<td><h2>&nbsp;Departure</h2></td>
		<td colspan=4><input type='text' size='70' maxlength='250' name='transport_specific_departure' id='transport_specific_departure'></input></td>
	</tr>
	<tr>
		<td></td><td colspan=4>Please keep us up to date with your transport arrangements: transport@heromoot.com</td>
	</tr>
	<tr>
		<td><h2>Church Service</h2></td>
		<td colspan=4>
		<br>Do you want to attend a church service on Easter Sunday.
		<table>
			<tr>
				<td><h3>&nbsp;Yes</h3></td>
				<td><input type='radio' name='church_service_radio' id='church_service_yes'></input></td>
				<td><h3>&nbsp;No</h3></td>
				<td><input type='radio' name='church_service_radio' id='church_service_no' checked></input></td>
		</table></td>
	</tr>
	<tr>
		<td rowspan=2><h2>Service Project</h2></td>
		<td colspan=4>
			We know that alongside your superhero powers, many of you have skills that could be useful on our service project. 
			Please tick if you are competent at any of the following:
		</td>
	</tr>
	<tr><td colspan=4><table><tr><h2>
		<td><h2>Builder</h2></td>
		<td><input type='checkbox' name='builder' id='builder'></input></td>
		<td><h2>Electrician</h2></td>
		<td><input type='checkbox' name='electrician' id='electrician'></input></td>
		<td><h2>Plumber</h2></td>
		<td><input type='checkbox' name='plumbing' id='plumbing'></input></td>
		<td><h2>Painter</h2></td>
		<td><input type='checkbox' name='painter' id='painter'></input></td>
		<td><h2>Gardening</h2></td>
		<td><input type='checkbox' name='gardening' id='gardening'></input></td>
		<td><h2>Welding</h2><td>
		<td><input type='checkbox' name='welding' id='welding'></input></td>
	</tr></table></td></tr>
	<tr>
		<td><h2>Other Skills</h2></td>
		<td colspan=5><input type='text' size='70' maxlength='200' name='service_skills' id='service_skills'></input></td>
	</tr>
	<tr><td></td></tr>
	<tr><td colspan=5><div class="padding"></div></td></tr>
	<tr><td colspan=5 align='center'><h2>Offsite Tours</h2></td></tr>
	
	<% 
	DbConnect dbc = dbm.doQuery("SELECT tour_id, tour_name FROM tour ORDER BY tour_name");
	ArrayList<Integer> idList = new ArrayList<Integer>();
	ArrayList<String> nameList = new ArrayList<String>();
	while(dbc.next()) {
		idList.add(dbc.getInt("tour_id"));
		nameList.add(dbc.getString("tour_name"));
	}
	dbc.endQuery();
	%>
	
	<tr>
		<td><h2>1st Choice</h2></td>
		<td><select name='tour_pref_1' id='tour_pref_1'>
			<option value=''>- select -</option>
			<%for(int i=0; i<idList.size(); i++) { %>
				<option value='<%=idList.get(i)%>'><%=nameList.get(i)%></option>
			<%} %></select></td>
		<td>&nbsp;&nbsp;</td>	
		
		<td colspan=2 rowspan=3>
		Please select three offsite tours in order of preference. We will endeavor to allocate everyone to their first choice, however you will be allocated
		a tour on a first come, first served basis only once full payment has been recieved. <a href="http://www.heromoot.com/tours.html" target='_blank'>More Information</a>
		</td>
	</tr>
	<tr>	
		<td><h2>2nd Choice</h2></td>
		<td><select name='tour_pref_2' id='tour_pref_2'>
			<option value=''>- select -</option>
			<%for(int i=0; i<idList.size(); i++) { %>
				<option value='<%=idList.get(i)%>'><%=nameList.get(i)%></option>
			<%} %>
		</select></td>
	</tr>
	<tr>		
		<td><h2>3rd Choice</h2></td>
		<td><select name='tour_pref_3' id='tour_pref_3'>
			<option value=''>- select -</option>
			<%for(int i=0; i<idList.size(); i++) { %>
				<option value='<%=idList.get(i)%>'><%=nameList.get(i)%></option>
			<%} %>
			</select></td>		
	</tr>
	<tr><td colspan=5><div class="padding"></div></td></tr>
	
	<tr><td colspan=5 align='center'><h2>Medical and Emergency Details</h2></td></tr>
	<tr><td colspan=5><h2><br>Contact:</h2></td></tr>
	<tr>
		<td><h2>Name</h2></td>
		<td nowrap><input type='text' size='<%=INPUT_WIDTH%>' maxlength='100' name='contact_name' id='contact_name'></input></td>
		<td>&nbsp;&nbsp;</td>
		<td rowspan=2><h2>Address</h2></td>
		<td rowspan=2><textarea cols=<%=TA_COLS%> name='contact_address' id='contact_address'></textarea></td>
	</tr>
	<tr>
		<td><h2>Phone</h2></td>
		<td><input type='text' size='<%=INPUT_WIDTH%>' maxlength='50' name='contact_phone' id='contact_phone'></input></td>
		<td>&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td><h2>Relationship</h2></td>
		<td><input type='text' size='<%=INPUT_WIDTH%>' maxlength='50' name='contact_relationship' id='contact_relationship'></input></td>
		<td>&nbsp;&nbsp;</td>
	</tr>
	<tr><td colspan=5><h2><br>Doctor:</h2></td></tr>
	<tr>
		<td><h2>Name</h2></td>
		<td nowrap><input type='text' size='<%=INPUT_WIDTH%>' maxlength='100' name='doctor_name' id='doctor_name'></input></td>
		<td>&nbsp;&nbsp;</td>
		<td rowspan=2><h2>Address</h2></td>
		<td rowspan=2><textarea cols=<%=TA_COLS%> name='doctor_address' id='doctor_address'></textarea></td>
	</tr>
	<tr>
		<td><h2>Phone</h2></td>
		<td><input type='text' size='<%=INPUT_WIDTH%>' maxlength='50' name='doctor_phone' id='doctor_phone'></input></td>
		<td>&nbsp;&nbsp;</td>
	</tr>
	<tr><td colspan=5><h2><br>Do you suffer any of the following:</h2></td></tr>
	<tr><td colspan=5><table cellpadding=4>
		<tr>
			<td><h2>Asthma</h2></td>
			<td><input type='checkbox' name='asthma' id='asthma'></input></td>
			<td><h2>Insect Allergy</h2></td>
			<td><input type='checkbox' name='insect_allergy' id='insect_allergy'></input></td>
			<td><h2>Hay Fever</h2></td>
			<td><input type='checkbox' name='hay_fever' id='hay_fever'></input></td>
			<td><h2>Haemophilia</h2></td>
			<td><input type='checkbox' name='haemophilia' id='haemophilia'></input></td>
		</tr>
		<tr>
			<td><h2>Fainting</h2></td>
			<td><input type='checkbox' name='fainting' id='fainting'></input></td>
			<td><h2>Epilepsy/Convulsions</h2></td>
			<td><input type='checkbox' name='epilepsy' id='epilepsy'></input></td>
			<td><h2>Heart Condition</h2></td>
			<td><input type='checkbox' name='heart_condition' id='heart_condition'></input></td>
			<td><h2>Rheumatic Fever</h2></td>
			<td><input type='checkbox' name='rheumatic_fever' id='rheumatic_fever'></input></td>
		</tr>
		<tr>
			<td><h2>Diabetes</h2></td>
			<td><input type='checkbox' name='diabetes' id='diabetes'></input></td>
			<td><h2>Food Allergy</h2></td>
			<td><input type='checkbox' name='food_allergy' id='food_allergy'></input></td>
			<td><h2>Penicillin Allergy</h2></td>
			<td><input type='checkbox' name='penicillin_allergy' id='penicillin_allergy'></input></td>
			<td><h2>Sleep Walking</h2></td>
			<td><input type='checkbox' name='sleep_walking' id='sleep_walking'></input></td>
		</tr>
	</table></td></tr>
	<tr>
		<td><h2>Other Medical Conditions</h2></td>
		<td><textarea cols='<%=TA_COLS%>' name='conditions'></textarea></td>
		<td>&nbsp;&nbsp;</td>
		<td><h2>Special Dietary Needs</h2></td>
		<td><textarea cols='<%=TA_COLS%>' name='dietary_requirements'></textarea></td>
	</tr>
	<tr><td colspan=5><div class="padding"></div></td></tr>
	<tr><td colspan=5 align='center'><h2>Privacy Act</h2></td></tr>
	<tr><td colspan=5>
		In compliance with the Privacy Act 1993 the following is brought to your attention:<br>
		&nbsp;&nbsp;This application form collects information about you.
		<ul>
     		<li>To decide whether you may be included in the event detailed above.</li>
     		<li>To make arrangements for your participation and welfare should you be included.</li>
     		<li>The information is being colllected for Scouts New Zeland and will be used by the organisers of the 
     		event. It will form part of a directory of Scout personel and membership records and is available to your
     		Crew, Zone and Region. It may be used to inform you of Scouts New Zealand events and opportunities to 
     		support the Association's work after the event.</li>
     		<li>Photos taken at Hero Moot may be used for Scouting and Rovering promotional purposes.</li>
     		<li>The information will be held and stored electronically by the Hero Moot Organising Committee on
     		behalf of Scouts New Zealand.</li>
     		<li>You have the right of access to and correction of this information subject to the provisions of the
     		Privacy Act 1993.</li>
     		<li>We reserve the right to to display or publish the sex you selected on this form.</li>
     		<li>It is intended the information you provide in the medical and emergency be used by those responsible
     		for your welfare at the event with access restricted accordingly. It will be destroyed after the event.</li>
    		
        </ul>
	</td></tr>
	<tr><td colspan=5><div class="padding"></div></td></tr>
	<tr><td colspan=5><span style='color:red' id='alert_space'></span></td></tr>
	<tr><td colspan=5 align='center'><h2>Declaration</h2></td></tr>
	<tr><td colspan=5>
        The above is a true statement of my identity and health. I do not know of any other physical, mental or
		emotional problems. I agree to advise the Moot Organising Committee and the National Office as soon as
		possible if I develop any illness or am exposed to any infectious disease before departure. In the event of my
		suffering accident or illness while travelling to, participating in, or returning from Hero Moot, I agree that
		any necessary medical attention may be arranged on my behalf.
		
	</td></tr>
	<tr><td colspan=5 align='center'><a href='#' onClick='doSubmit(); return false;'>I Agree Submit</a></td></tr>
	
</table>

<input type='hidden' name='sex' id='sex'></input>
<input type='hidden' name='rover_status' id='rover_status'></input>
<input type='hidden' name='accommodation' id='accommodation'></input>
<input type='hidden' name='transport_type' id='transport_type'></input>
<input type='hidden' name='church_service' id='church_service'></input>

</form>


<script>
	
	function doSubmit() {
		setAlert("");
		checkEmpty("Please enter your first name.","first_name")
		checkEmpty("Please enter your last name.","last_name");

		checkEmpty("Please enter your birthday.", "date_of_birth_day");
		checkEmpty("Please enter your birthmonth.", "date_of_birth_month");
		checkEmpty("Please enter your birthyear.", "date_of_birth_year");
		
		
		checkEmpty("Please enter an address.","address");
		checkEmpty("Please enter an email address.", "email");
		checkEmpty("Please select your region.", "region");
		
		checkSex();
		checkRoverStatus();
		checkTours();
		checkAccommodation();
		checkTransport();
		checkChurchService();
		
		checkEmpty("Please enter an emergency contact name.", "contact_name");
		checkEmpty("Please enter the emergency contact phone number.", "contact_phone");
		checkEmpty("Please enter the emergency contact address.", "contact_address");
		checkEmpty("Please enter the emergency contact persons relationship to you.", "contact_relationship");

		checkEmpty("Please enter your doctor's name.", "doctor_name");
		checkEmpty("Please enter your doctor's phone number.", "doctor_phone");
		checkEmpty("Please enter your doctor's address.", "doctor_address");

		if(document.getElementById("alert_space").innerHTML=="") {
			document.forms[0].submit();
		}
	}

	function setAlert(alertStr) {
		document.getElementById("alert_space").innerHTML=alertStr;
	}

	function checkEmpty(message, id) {
		var isEmpty = document.getElementById(id).value=="";
		if(isEmpty) {
			setAlert(document.getElementById("alert_space").innerHTML+"<br>"+message);
		}
		return isEmpty;
	}

	function checkSex() {
		if(document.getElementById("sex_please").checked) {
			setAlert(document.getElementById("alert_space").innerHTML+"<br>"+"We know you what sex, but please select a sex.");
		} else if(document.getElementById("sex_undecided").checked) {
			document.getElementById("sex").value = "Undecided";
		} else if(document.getElementById("sex_male").checked) {
			document.getElementById("sex").value = "Male";
		} else if(document.getElementById("sex_female").checked) {
			document.getElementById("sex").value = "Female";
		} else {
			setAlert(document.getElementById("alert_space").innerHTML+"<br>Please select your sex.");
		}
	}

	function checkRoverStatus() {
		if(document.getElementById("rover_status_full").checked) {
			document.getElementById("rover_status").value = "Full";
		} else if(document.getElementById("rover_status_associate").checked) {
			document.getElementById("rover_status").value = "Associate";
		} else if(document.getElementById("rover_status_squire").checked) {
			document.getElementById("rover_status").value = "Squire";
		} else if(document.getElementById("rover_status_leader").checked) {
			document.getElementById("rover_status").value = "Leader";
		} else {
			setAlert(document.getElementById("alert_space").innerHTML+"<br>Please select your status as a rover.");
		}
	}

	function checkAccommodation() {
		if(document.getElementById("accommodation_tent").checked) {
			document.getElementById("accommodation").value = "Tent";
		} else if(document.getElementById("accommodation_own").checked) {
			document.getElementById("accommodation").value = "Own";
		} else {
			setAlert(document.getElementById("alert_space").innerHTML+"<br>Please select an accommodation option.");
		}
	}

	function checkTransport() {
		if(document.getElementById("transport_plane").checked) {
			document.getElementById("transport_type").value = "Plane";
		} else if(document.getElementById("transport_bus").checked) {
			document.getElementById("transport_type").value = "Bus";
		} else if(document.getElementById("transport_train").checked) {
			document.getElementById("transport_type").value = "Train";
		} else if(document.getElementById("transport_own_ch").checked) {
			document.getElementById("transport_type").value = "OwnChch";
		}
	}

	function checkChurchService() {
		if(document.getElementById("church_service_yes").checked) {
			document.getElementById("church_service").value = "Y";
		} else if(document.getElementById("church_service_no").checked) {
			document.getElementById("church_service").value = "N";
		}
	}

	function checkTours() {
		if (checkEmpty("Please select your 1st preference tour.", "tour_pref_1") && 
			checkEmpty("Please select your 2nd preference tour.", "tour_pref_2") && 
			checkEmpty("Please select your 3rd preference tour.", "tour_pref_3")) {
		} else if(document.getElementById("tour_pref_1").value==document.getElementById("tour_pref_2").value) {
			setAlert(document.getElementById("alert_space").innerHTML+"<br>Your first and second tour preferences are the same, please change one.");
		} else if(document.getElementById("tour_pref_1").value==document.getElementById("tour_pref_3").value) {
			setAlert(document.getElementById("alert_space").innerHTML+"<br>Your first and third tour preferences are the same, please change one.");
		} else if(document.getElementById("tour_pref_2").value==document.getElementById("tour_pref_3").value) {
			setAlert(document.getElementById("alert_space").innerHTML+"<br>Your second and third tour preferences are the same, please change one.");
		} else if((!document.getElementById("sex_female").checked) &&
            (document.getElementById("tour_pref_1").value==11 ||
            document.getElementById("tour_pref_2").value==11 ||
            document.getElementById("tour_pref_3").value==11)) {
            setAlert(document.getElementById("alert_space").innerHTML+"<br>The Bond Girl Tour is girls only, please select a different tour.");
            }
	}

</script>

<%
//dbm.close();
} else {
%>
    Applications are now closed.
<% } %>

<%@ include file="page_foot.jsp" %>