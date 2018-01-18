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

<moot:moothead title='Graphs - Tour Popularity'>
    <moot:mootmenu selected='graphs'/>
</moot:moothead>

<moot:bodytable>

<h2>Tour Popularity</h2>

<table width='100%' cellpadding='0' cellspacing='0' border='0'>
	<tr>
		<td valign='top' width='12%'>
			<a href='/moot/pages/admin/graphs.jsp'><img src='/moot/images/back.png' height='16' width='16' border='0'></a>
			<a class='cmdlink' href='/moot/pages/admin/graphs.jsp'><span style='position:relative;top:-4px;'>Graphs Menu</span></a>
			<div style='line-height:8px;'>&nbsp;</div>
			This graphs show the number of people who 
			have requested a particular tour as their 
			first, second or third options. It also 
			shows people who have already been assigned
			to a tour.
			<div style='line-height:8px;'>&nbsp;</div>
			<b>Note:</b> Anyone assigned to a tour will 
			not appear in the counts for the tours they
			requested.
		</td>

		<td valign='top' width='80%'>
			<div align='center'><img src="/moot/servlet/graph/TourPopularity?type=admin"></div>
		</td>
	</tr>
</table>

</moot:bodytable>