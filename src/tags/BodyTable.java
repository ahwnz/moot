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

public class BodyTable extends TagSupport {

	private static final long serialVersionUID = 1L;
	
	private String title = "";

    @Override
	public int doStartTag() {
		try {
			pageContext.getOut().print("<body>\n" +
                    "<div style='line-height:8px;'>&nbsp;</div>\n" +
                    "<div class='under'>\n" +
                    "<table align='center' width='980' cellpadding='0' cellspacing='0' border='0'><tr><td valign='top'>\n" +
                    "<table align='center'><tr><td><div class='overfinger' id='finger'></div></td></tr></table>\n" +
                    "<div id='bodydiv' style='display: none;'>");
		} catch (IOException e) {
			//NO-OP
		}
		
		return (EVAL_BODY_INCLUDE);
	}
	
	
    @Override
	public int doEndTag() {
		try {
			pageContext.getOut().print("</div></td>\n</tr><tr height='25'><td align='right' valign='bottom'><span style='font-size:10px;color:#808080;'>&copy; 2010, Redcloud Development, Ltd. All rights reserved.</span></td>\n</tr></table>\n</div></body>");
		} catch (IOException e) {
			//NO-OP
		}
		return (EVAL_PAGE);
	}


	public String getTitle() {
		return title;
	}


	public void setTitle(String title) {
		this.title = title;
	}
	

}
