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

import javax.servlet.jsp.tagext.TagSupport;

public class NotHasRole extends TagSupport {

	private static final long serialVersionUID = 1L;
	
	private String role = "none";

	public int doStartTag() {
		if(!HasRole.hasRole(pageContext, role)) return (EVAL_BODY_INCLUDE);
		else return (SKIP_BODY);
	}
	
	public int doEndTag() {
		return (EVAL_PAGE);
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}
	
	
}
