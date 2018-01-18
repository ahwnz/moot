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

public class MootReport extends TagSupport {

    private static final long serialVersionUID = 1L;
	
    private String name = "";

    @Override
    public int doStartTag() {
        try {
            StringBuffer sb = new StringBuffer();
            sb.append("<html><head>");
            sb.append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n");
            sb.append("<meta http-equiv=\"Cache-Control\" content=\"no-cache\">\n");
            sb.append("<meta http-equiv=\"Pragma\" content=\"no-Cache\">\n");
            sb.append("<meta http-equiv=\"Expires\" content=\"0\">\n");
            sb.append("<title>Smooth Moot - Reports - ");
            sb.append(name);
            sb.append("</title>\n");
            sb.append("<link rel=\"stylesheet\" href=\"/moot/layout/moot-admin.css\" type=\"text/css\">\n" );
            sb.append("</head><body><span style=\"text-align: center\">\n");
            pageContext.getOut().print(sb.toString());
        } catch (IOException e) {
                //NO-OP
        }

        return (EVAL_BODY_INCLUDE);
    }
	
	
    public int doEndTag() {
        try {
            pageContext.getOut().print("</span></body></html>");
        } catch (IOException e) {
                //NO-OP
        }
        return (EVAL_PAGE);
    }


    public String getName() {
            return name;
    }


    public void setName(String name) {
            this.name = name;
    }
	

}
