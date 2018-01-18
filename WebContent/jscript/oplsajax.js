/**
 * Copyright (c) 2009-2010, Redcloud Development, Ltd. All rights reserved
 * @author Alex Westphal
 */

function newXMLHttpRequest() {
  var xmlreq = false;
  if (window.XMLHttpRequest) {
    xmlreq = new XMLHttpRequest();
  } else if (window.ActiveXObject) {
    try {
      xmlreq = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e1) {
      try {
        xmlreq = new ActiveXObject("Microsoft.XMLHTTP");
      } catch (e2) {
		// failure
      }
    }
  }
  if (!xmlreq)
  	alert("Unable to create required XMLHttpRequest object");
  return xmlreq;
}
function getReadyStateHandler(req, responseXmlHandler) {
  return function () {
    if (req.readyState == 4) {
      if (req.status == 200) {
        responseXmlHandler(req.responseText);
      } else {
        alert("ReadStateHandler Error: "+req.status+" - "+req.statusText);
      }
    }
  }
}
function makeAjaxCall(responseXmlHandler, targetServlet, args) {
	var req = newXMLHttpRequest();
  	var handlerFunction = getReadyStateHandler(req, responseXmlHandler);
  	req.onreadystatechange = handlerFunction;
  	req.open("POST", targetServlet, true);
  	req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
  	req.send(args);
  	return true;
 }
  	