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

<moot:moothead title='Reports'>
	<moot:mootmenu selected='reports'/>
</moot:moothead>

<moot:bodytable>

<h2>Reports</h2>

<% 
final String[] regions = new String[]{"All","Region1","Region2","Region3","Region4","Region5","Australia","Other"};
%>

<div id="additional_medical_conditions"></div>
<div style='line-height:8px;'>&nbsp;</div>
<div id="aus_contingent"></div>
<div style='line-height:8px;'>&nbsp;</div>
<div id="church_service"></div>
<div style='line-height:8px;'>&nbsp;</div>
<div id="crew_nums"></div>
<div style='line-height:8px;'>&nbsp;</div>
<div id="dietary_requirements"></div>
<div style='line-height:8px;'>&nbsp;</div>
<div id="email_list"></div>
<div style='line-height:8px;'>&nbsp;</div>
<div id="flight_arrivals"></div>
<div style='line-height:8px;'>&nbsp;</div>
<div id="individual_merchandise_orders"></div>
<div style='line-height:8px;'>&nbsp;</div>
<div id="medical_conditions"></div>
<div style='line-height:8px;'>&nbsp;</div>
<div id="merchandise_orders"></div>
<div style='line-height:8px;'>&nbsp;</div>
<div id="not_approved"></div>
<div style='line-height:8px;'>&nbsp;</div>
<div id="not_validated"></div>
<div style='line-height:8px;'>&nbsp;</div>
<div id="registrations"></div>
<div style='line-height:8px;'>&nbsp;</div>
<div id="require_tents"></div>
<div style='line-height:8px;'>&nbsp;</div>
<div id="service_skills"></div>
<div style='line-height:8px;'>&nbsp;</div>
<div id='tour_assignments'></div>
<div style='line-height:8px;'>&nbsp;</div>
<div id='warbirds_deposits'></div>
<div style='line-height:8px;'>&nbsp;</div>
<div id='wednesday_accomodation'></div>
<div style='line-height:8px;'>&nbsp;</div>

<script src='/moot/jscript/oplsajax.js'></script>
<script>

setNormal();

function setNormal() {
	setContent("additional_medical_conditions","<a href='#' onClick='additionalMedicalConditions(); return false;'>Additional Medical Conditions</a>");
        setContent("aus_contingent","<a href='#' onClick='ausContingent(); return false;'>Australian Contingent</a>");
	setContent("church_service","<a href='#' onClick='churchService(); return false;'>Church Service</a>");
	setContent("crew_nums","<a href='#' onClick='crewNums(); return false;'>Crew Numbers</a>");
	setContent("dietary_requirements","<a href='#' onClick='dietaryRequirements(); return false;'>Dietary Requirements</a>");
	setContent("email_list","<a href='#' onClick='emailList(); return false;'>Email List</a>");
	setContent("flight_arrivals","<a href='#' onClick='flightArrivals(); return false;'>Flight Arrivals</a>");
        setContent("individual_merchandise_orders","<a href='#' onClick='individualMerchandiseOrders(); return false;'>Individual Merchandise Orders</a>");
	setContent("medical_conditions","<a href='#' onClick='medicalConditions(); return false;'>Medical Conditions</a>");
	setContent("merchandise_orders","<a href='#' onClick='merchandiseOrders(); return false;'>Merchandise Orders</a>");
	setContent("not_approved","<a href='#' onClick='notApproved(); return false;'>Not Approved</a>");
	setContent("not_validated","<a href='#' onClick='notValidated(); return false;'>Not Validated</a>");
        setContent("registrations","<a href='#' onClick='registrations(); return false;'>Registrations</a>");
	setContent("require_tents","<a href='#' onClick='requireTents(); return false;'>Require Tents</a>");
        setContent("service_skills","<a href='#' onClick='serviceSkills(); return false;'>Service Skills</a>");
	setContent("tour_assignments","<a href='#' onClick='tourAssignments(); return false;'>Tour Assignments</a>");
	setContent("warbirds_deposits","<a href='#' onClick='warbirdsDeposits(); return false;'>Warbirds Deposits</a>");
        setContent("wednesday_accomodation","<a href='#' onClick='wednesdayAccomodation(); return false;'>Wednesday Accomodation</a>");
}

function setContent(id, content) {
	document.getElementById(id).innerHTML = "<img src='/moot/images/dot_l.png' height='16' width='16' border='0'>"+content;
}



//Additional Medical Conditions Functions

function additionalMedicalConditions() {
	setNormal();
	document.getElementById("additional_medical_conditions").innerHTML = "<table cellpadding=2>"+
	"<tr><td><b>Additional Medical Conditions</b></td></tr>"+
	"<tr><td>Display the list of applicants with additional medical conditions.</td></tr>"+
	"<tr><td align='right'><button onClick='additionalMedicalConditionsSubmit(); return false;'>Generate Report</button></td></tr>";
}

function additionalMedicalConditionsSubmit() {
	window.location = "/moot/pages/admin/reports/additional_medical_conditions.jsp";
}



//Australian Contingent Functions

function ausContingent() {
	setNormal();
	document.getElementById("aus_contingent").innerHTML = "<table cellpadding=2>"+
	"<tr><td><b>Australian Contingent</b></td></tr>"+
	"<tr><td>Display the list of Australian application</td></tr>"+
	"<tr><td align='right'><button onClick='ausContingentSubmit(); return false;'>Generate Report</button></td></tr>";
}

function ausContingentSubmit() {
	window.location = "/moot/pages/admin/reports/australian_contingent.jsp";
}



//Church Service Functions

function churchService() {
	setNormal();
	document.getElementById("church_service").innerHTML = "<table cellpadding=2>"+
	"<tr><td><b>Church Service</b></td></tr>"+
	"<tr><td>Display the list of applicants wishing to attend a church service</td></tr>"+
	"<tr><td align='right'><button onClick='churchServiceSubmit(); return false;'>Generate Report</button></td></tr>";
}

function churchServiceSubmit() {
	window.location = "/moot/pages/admin/reports/church_service.jsp";
}



//Crew Nums Functions

function crewNums() {
	setNormal();
	document.getElementById("crew_nums").innerHTML = "<table cellpadding=2>"+
	"<tr><td><b>Crew Numbers</b></td></tr>"+
	"<tr><td>Display the number of applications per crew.</td></tr>"+
	"<tr><td align='right'><button onClick='crewNumsSubmit(); return false;'>Generate Report</button></td></tr>";
}

function crewNumsSubmit() {
	window.location = "/moot/pages/admin/reports/crew_nums.jsp";
}



//Dietary Requirements Functions

function dietaryRequirements() {
	setNormal();
	document.getElementById("dietary_requirements").innerHTML = "<table cellpadding=2>"+
	"<tr><td><b>Dietary Requirements</b></td></tr>"+
	"<tr><td>Display a list of applicants with special dietary requirements</td></tr>"+
	"<tr><td align='right'><button onClick='dietaryRequirementsSubmit(); return false;'>Generate Report</button></td></tr>";
}

function dietaryRequirementsSubmit() {
	window.location = "/moot/pages/admin/reports/dietary_requirements.jsp";
}



//Email List Functions

function emailList() {
	setNormal();
	document.getElementById("email_list").innerHTML = "<table cellpadding=2>"+
	"<tr><td colspan=2><b>Email List</b></td></tr>"+
	"<tr><td colspan=2>Display a list of all email addresses.</td></tr>"+
        "<tr><td>Additional addresses to include in the list.</td><td><textarea id=notinc></textarea></td></tr>"+
	"<tr><td colspan=2 align='right'><button onClick='emailListSubmit(); return false;'>Generate Report</button></td></tr>";
}

function emailListSubmit() {
        var notinc = document.getElementById("notinc").value;
	window.location = "/moot/pages/admin/reports/email_list.jsp?notinc="+notinc;
}



//Flight Arrivals Functions

function flightArrivals() {
	setNormal();
	document.getElementById("flight_arrivals").innerHTML = "<table cellpadding=2>"+
	"<tr><td><b>Flight Arrivals</b></td></tr>"+
	"<tr><td>Display a list of flight arrivals.</td></tr>"+
	"<tr><td align='right'><button onClick='flightArrivalsSubmit(); return false;'>Generate Report</button></td></tr>";
}

function flightArrivalsSubmit() {
	window.location = "/moot/pages/admin/reports/flight_arrivals.jsp";
}

//Medical Conditions Functions

function individualMerchandiseOrders() {
	setNormal();
	document.getElementById("individual_merchandise_orders").innerHTML = "<table cellpadding=2>"+
	"<tr><td><b>Individual Merchandise Orders</b></td></tr>"+
	"<tr><td>Display a list of all merchandise orders by applicant</td></tr>"+
	"<tr><td align='right'><button onClick='individualMerchandiseOrdersSubmit(); return false;'>Generate Report</button></td></tr>";
}

function individualMerchandiseOrdersSubmit() {
	window.location = "/moot/pages/admin/reports/individual_merchandise_orders.jsp";
}


//Medical Conditions Functions

function medicalConditions() {
	setNormal();
	document.getElementById("medical_conditions").innerHTML = "<table cellpadding=2>"+
	"<tr><td><b>Medical Conditions</b></td></tr>"+
	"<tr><td>Display a list of the people with specific medical conditions.</td></tr>"+
	"<tr><td align='right'><button onClick='medicalConditionsSubmit(); return false;'>Generate Report</button></td></tr>";
}

function medicalConditionsSubmit() {
	window.location = "/moot/pages/admin/reports/medical_conditions.jsp";
}



//Merchadise Orders Functions

function merchandiseOrders() {
	setNormal();
	makeAjaxCall(displayMerchandiseOrders, "/moot/servlet/common/GetMerchandiseSelect", "");
}

function displayMerchandiseOrders(select) {
	document.getElementById("merchandise_orders").innerHTML = "<table cellpadding=2>"+
	"<tr><td><b>Merchandise Orders</b></td></tr>"+
	"<tr><td>Display a list of the merchandise orders by item.</td></tr>"+
	"<tr><td>Choose which item for which to display orders.</td></tr>"+
	"<tr><td align='right'>"+select+"</td></tr>"+
	"<tr><td align='right'><button onClick='merchandiseOrdersSubmit(); return false;'>Generate Report</button></td></tr>";
}

function merchandiseOrdersSubmit() {
	var mid = document.getElementById("mid").value;
	window.location = "/moot/pages/admin/reports/merchandise_orders.jsp?mid="+mid;
}



//Not Approved Functions

function notApproved() {
	setNormal();
	document.getElementById("not_approved").innerHTML = "<table cellpadding=2>"+
	"<tr><td><b>Not Approved</b></td></tr>"+
	"<tr><td>Display a list of all not approved application.</td></tr>"+
	"<tr><td>Choose which region to display.</td></tr>"+
	"<tr><td><select id='region'><%for(String region: regions) {%><option value='<%=region%>'><%=region%></option><%}%></select></td></tr>"+
	"<tr><td align='right'><button onClick='notApprovedSubmit(); return false;'>Generate Report</button></td></tr>";
	
}

function notApprovedSubmit() {
	var region = document.getElementById("region").value;
	if(region == "All") {
		window.location = "/moot/pages/admin/reports/not_approved.jsp";
	} else {
		window.location = "/moot/pages/admin/reports/not_approved.jsp?region="+region;
	}
}

//Not Validated Functions

function notValidated() {
	setNormal();
	document.getElementById("not_validated").innerHTML = "<table cellpadding=2>"+
	"<tr><td><b>Not Validated</b></td></tr>"+
	"<tr><td>Display a list of all not validated application.</td></tr>"+
	"<tr><td align='right'><button onClick='notValidatedSubmit(); return false;'>Generate Report</button></td></tr>";
}

function notValidatedSubmit() {
	window.location = "/moot/pages/admin/reports/not_validated.jsp";
}

//Require Tents Functions

function requireTents() {
	setNormal();
	document.getElementById("require_tents").innerHTML = "<table cellpadding=2>"+
	"<tr><td><b>Require Tents</b></td></tr>"+
	"<tr><td>Display a list of applicants that require tents by crew.</td></tr>"+
	"<tr><td align='right'><button onClick='requireTentsSubmit(); return false;'>Generate Report</button></td></tr>";
}

function requireTentsSubmit() {
	window.location = "/moot/pages/admin/reports/require_tents.jsp";
}



//Registrations Functions

function registrations() {
	setNormal();
	document.getElementById("registrations").innerHTML = "<table cellpadding=2>"+
	"<tr><td><b>Registrations</b></td></tr>"+
	"<tr><td>Display a list of all registered and not registered people</td></tr>"+
	"<tr><td align='right'><button onClick='registrationsSubmit(); return false;'>Generate Report</button></td></tr>";
}

function registrationsSubmit() {
	window.location = "/moot/pages/admin/reports/registrations.jsp";
}


//Service Skills Functions

function serviceSkills() {
	setNormal();
	document.getElementById("service_skills").innerHTML = "<table cellpadding=2>"+
	"<tr><td><b>Service Skills</b></td></tr>"+
	"<tr><td>Display a list of all people with specific skills</td></tr>"+
	"<tr><td align='right'><button onClick='serviceSkillsSubmit(); return false;'>Generate Report</button></td></tr>";
}

function serviceSkillsSubmit() {
	window.location = "/moot/pages/admin/reports/service_skills.jsp";
}


//Tour Assignments Functions

function tourAssignments() {
	setNormal();
	makeAjaxCall(displayTourAssignments, "/moot/servlet/common/GetTourSelect", "");
}

function displayTourAssignments(select) {
	document.getElementById("tour_assignments").innerHTML = "<table cellpadding=2>"+
	"<tr><td><b>Tour Assignments</b></td></tr>"+
	"<tr><td>Display a list of the people assigned to a specific tour.</td></tr>"+
	"<tr><td>Choose which tour for which to display assignments.</td></tr>"+
	"<tr><td align='right'>"+select+"</td></tr>"+
	"<tr><td align='right'><button onClick='tourAssignmentsSubmit(); return false;'>Generate Report</button></td></tr>";
}

function tourAssignmentsSubmit() {
	var tid = document.getElementById("tid").value;
	window.location = "/moot/pages/admin/reports/tour_assignments.jsp?tid="+tid;
}



//Warbirds Deposits Functions

function warbirdsDeposits() {
	setNormal();
	document.getElementById("warbirds_deposits").innerHTML = "<table cellpadding=2>"+
	"<tr><td><b>Warbirds Deposits</b></td></tr>"+
	"<tr><td>Display a list of people assigned to warbirds and their payment status.</td></tr>"+
	"<tr><td align='right'><button onClick='warbirdsDepositsSubmit(); return false;'>Generate Report</button></td></tr>";
}

function warbirdsDepositsSubmit() {
	window.location = "/moot/pages/admin/reports/warbirds_deposits.jsp";
}

//Wednesday Accomodation Functions

function wednesdayAccomodation() {
	setNormal();
	document.getElementById("wednesday_accomodation").innerHTML = "<table cellpadding=2>"+
	"<tr><td><b>Wednesday Accomodation</b></td></tr>"+
	"<tr><td>Display the list of applicants requiring wednesday night accomodation.</td></tr>"+
	"<tr><td align='right'><button onClick='churchWednesdayAccomodation(); return false;'>Generate Report</button></td></tr>";
}

function churchWednesdayAccomodation() {
	window.location = "/moot/pages/admin/reports/wednesday_accomodation.jsp";
}


</script>

</moot:bodytable>
</html>