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

package graph;

import java.awt.Color;

public class ColorSelector {
	
	private final boolean type;

	protected ColorSelector(String typeStr) {
		if(! (typeStr.equals("admin") || typeStr.equals("application"))) {
			throw new IllegalArgumentException("Invalid value for type: "+typeStr);
		}
		type = typeStr.equals("admin");
	}
	
	public Color getBackgroundColor() {
		return type ? Color.WHITE : Color.decode("#000046");
	}
	
	public Color getChartColor() {
		return Color.decode("#666666");
	}
	
	public Color getChartGridColor() {
		return Color.WHITE;
	}
	
	public Color getH2Color() {
		return type ? Color.BLACK : Color.decode("#666666");
	}
	
	public Color[] getDefaultBarColors() {
		return new Color[] {	
				Color.decode("#fdf200"), 	//Yellow
				Color.decode("#83c1ff"), 	//Light blue
				Color.decode("#f59710"), 	//Orange
				Color.decode("#eb1f25"), 	//Red
				Color.decode("#002699") 	//Blue
		};
	}
	
	
}
