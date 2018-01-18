/**     ______________________________________
 *     / ____________________________________ \
 *    / /     /        \     /         \     \ \
 *   / /     /          \   /           \     \ \
 *  / /     / _   _   ___\ /____     ___ \     \ \
 * / /     / | | | | |  _| |  _ \   / _ \ \     \ \
 * \ \    /  | |_| | | |_  | |_| | / / \ \ \    / /
 *  \ \  /   |  _  | |  _| | _  /  | | | |  \  / /
 *   \ \/    | | | | | |_  | |\ \  \ \_/ /   \/ /
 *    \ \    |_| |_| |___| |_| \_\  \___/    / /
 *     \ \            _       _             / /
 *      \ \          / \     / \           / /
 *       \ \        /   \   /   \         / /
 *        \ \      /     \ /     \       / /
 *         \ \    /    M O O T    \     / /
 *          \ \__/_________________\___/ /
 *           \_____Canterbury 2010______/
 * 
 * Copyright (c) 2009-2010, Redcloud Development, Ltd. All rights reserved
 * @author Alex Westphal
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

package tags;

import java.io.IOException;

import javax.servlet.jsp.tagext.TagSupport;

public class MootMenu extends TagSupport {

	private static final long serialVersionUID = 1L;
	
	private String selected = "";

    @Override
	public int doStartTag() {
		
		StringBuffer buff = new StringBuffer();
		
		buff.append("<table align='center' width='980' cellpadding='0' cellspacing='0' border='0'>\n");
		buff.append("<tr height=50>\n");
		buff.append("<td width='220'><a href='http://www.scouts.org.nz/' target='_blank' title='Scouts'><img src='/moot/images/ScoutsLogo2.png' width='187' height='45' border='0'></a></td>\n");
		buff.append("<td valign='top'><h1>SM69TH Moot Admin</h1></td>\n");
		buff.append("<td align='right' valign='top'></td>\n");
		buff.append("</tr>\n");
		buff.append("<tr>\n");
		buff.append("<td colspan=3>\n");
		buff.append("<table width='100%' cellpadding='0' cellspacing='0' border='0' style='margin-top:3px;'>\n");
		buff.append("<tr height='3'>\n");
		buff.append("<td width='16.67%' style='line-height:2px;'><div id='menubarkea'>&nbsp;</div></td>\n");
		buff.append("<td width='16.67%' style='background-color:#ffcf1d; line-height:2px;'><div style='line-height:2px;'>&nbsp;</div></td>\n");
		buff.append("<td width='16.66%' style='background-color:#00703c; line-height:2px;'><div style='line-height:2px;'>&nbsp;</div></td>\n");
		buff.append("<td width='16.66%' style='background-color:#98002e; line-height:2px;'><div style='line-height:2px;'>&nbsp;</div></td>\n");
		buff.append("<td width='16.67%' style='background-color:#ee3424; line-height:2px;'><div style='line-height:2px;'>&nbsp;</div></td>\n");
		buff.append("<td width='16.67%' style='line-height:2px;'><div id='menubarleader'>&nbsp;</div></td>\n");
		buff.append("</tr>\n");
		buff.append("</table>\n");
		
		buff.append("<div id='menubar'>\n");
		
		buff.append("<a "+(selected.equals("admin")?"class='select' ":"")+"href='/moot/pages/admin/administration.jsp?order=&oc=a' title='Administration'>Administration</a>\n");
		buff.append("<span class='menuspacer'>&nbsp;</span>\n");
		
		if(HasRole.hasRole(pageContext,"mootadmin,mootfinance")) {
			buff.append("<a "+(selected.equals("payments")?"class='select' ":"")+"href='/moot/pages/admin/payments.jsp?order=&oc=a' title='Payments'>Payments</a>\n");
			buff.append("<span class='menuspacer'>&nbsp;</span>\n");
		}
		
		
		if(HasRole.hasRole(pageContext,"mootadmin,mootfinance,moottransport")) {
			buff.append("<a "+(selected.equals("transport")?"class='select' ":"")+"href='/moot/pages/admin/transport.jsp?order=&oc=a' title='Transport'>Transport</a>\n");
			buff.append("<span class='menuspacer'>&nbsp;</span>\n");
		}
		
		if(HasRole.hasRole(pageContext,"mootadmin,mootfinance,mootoffsite")) {
			buff.append("<a "+(selected.equals("tours")?"class='select' ":"")+"href='/moot/pages/admin/tours.jsp?order=&oc=a' title='Tours'>Tours</a>\n");
			buff.append("<span class='menuspacer'>&nbsp;</span>\n");
		}
		
		if(HasRole.hasRole(pageContext,"mootadmin,mootfinance,mootmerchandise")) {
			buff.append("<a "+(selected.equals("merchandise")?"class='select' ":"")+"href='/moot/pages/admin/merchandise.jsp?order=&oc=a' title='Merchandise'>Merchandise</a>\n");
			buff.append("<span class='menuspacer'>&nbsp;</span>\n");
		}

        if(HasRole.hasRole(pageContext,"mootadmin,mootonsite")) {
            buff.append("<a "+(selected.equals("teams")?"class='select' ":"")+"href='/moot/pages/admin/team_members.jsp' title='Teams'>Teams</a>\n");
            buff.append("<span class='menuspacer'>&nbsp;</span>\n");
        }
        
		buff.append("<a "+(selected.equals("medical")?"class='select' ":"")+"href='/moot/pages/admin/medical.jsp?order=&oc=a' title='Medical'>Medical</a>\n");
		buff.append("<span class='menuspacer'>&nbsp;</span>\n");
		buff.append("<a "+(selected.equals("reports")?"class='select' ":"")+"href='/moot/pages/admin/reports.jsp' target='_blank' title='Reports'>Reports</a>\n");
		buff.append("<span class='menuspacer'>&nbsp;</span>\n");
		buff.append("<a "+(selected.equals("graphs")?"class='select' ":"")+"href='/moot/pages/admin/graphs.jsp' title='Graphs'>Graphs</a>\n");
		buff.append("<span class='menuspacer'>&nbsp;</span>\n");
		
		if(HasRole.hasRole(pageContext,"mootadmin,mootfinance")) {
			buff.append("<a "+(selected.equals("utils")?"class='select' ":"")+"href='/moot/pages/admin/utilities.jsp' title='Utilities'>Utilities</a>\n");
		}
		
		buff.append("</div>");
		buff.append("</td>");
		buff.append("</tr>");
		buff.append("</table>");
		
		buff.append("<div style='line-height:8px;'>&nbsp;</div>\n");
		
		try {
			pageContext.getOut().print(buff.toString());
		} catch (IOException e) {
			//NO-OP
		}
		
		return (EVAL_BODY_INCLUDE);
	}
	
	
    @Override
	public int doEndTag() {
		return (EVAL_PAGE);
	}
	
	public String getSelected() {
		return selected;
	}

	public void setSelected(String selected) {
		this.selected = selected;
	}

}
