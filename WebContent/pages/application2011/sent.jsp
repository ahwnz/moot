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

<%@ page import="java.util.Random" %>

<h1>Application Sent</h1>

<%
int app_id = Integer.parseInt(request.getParameter("appid"));

int ob_id = (256*1025*((new Random()).nextInt(4096)))+app_id;
%>
<br>
Thank you for your application, SM69TH moot will be in contact regarding payment of your moot fees.  In the meantime please arrange the payment of your moot
deposit of $100.  Check out the frequently asked questions on everything you need to know about moot and moot payments. Your Application number is
<code><%=app_id%></code>. This is your number for all moot issues until the start of moot.
<a href='/moot/pages/application2011/merch_order.jsp?appid=<%=ob_id%>' target='_blank'>You can order your SM69TH, Moot Merchandise here.</a><br>

<%@ include file="page_foot.jsp" %>
