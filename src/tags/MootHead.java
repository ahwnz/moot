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

public class MootHead extends TagSupport {

	private static final long serialVersionUID = 1L;
	
	private String title = "";

    @Override
	public int doStartTag() {
		
		StringBuilder buff = new StringBuilder();
		
		buff.append("<head>\n");
		buff.append("<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>\n");
        buff.append("<meta name=\"Author\" content=\"Alex Westphal\">");
        buff.append("<meta name=\"Owner\" content=\"Redcloud Development, Ltd.\">");
		buff.append("<meta http-equiv='Cache-Control' content='no-cache'>\n");
		buff.append("<meta http-equiv='Pragma' content='no-Cache'>\n");
		buff.append("<meta http-equiv='Expires' content='0'>\n");
		if(title.length()>0) {
                    buff.append("<title>SM69TH Moot - ");
                    buff.append(title);
                    buff.append("</title>\n");
                }
		buff.append("<link rel='stylesheet' href='/moot/layout/moot-admin.css' type='text/css'>\n");
        buff.append("<script src='/moot/jscript/jquery-1.4.min.js'></script>");
        buff.append("<script>$(document).ready(function() { $('#bodydiv').fadeIn('slow');});</script>");
		buff.append("</head>\n");
		
		try {
			pageContext.getOut().print(buff.toString());
		} catch (IOException e) {
			//NO-OP
		}
		
		return (EVAL_BODY_INCLUDE);
	}
	
	
	public int doEndTag() {
		return (EVAL_PAGE);
	}


	public String getTitle() {
		return title;
	}


	public void setTitle(String title) {
		this.title = title;
	}
	

}
