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

package common;


import java.util.Comparator;

/**
 *
 * @author alexanderw
 */
public class ComparablePair<A extends Comparable<A>, B> extends Pair<A, B> implements Comparable<ComparablePair<A,B>> {

    /**
     * ComparablePair Constructor
     * @param a First element
     * @param b Second Element
     */
    public ComparablePair(A a, B b) {
        super(a, b);
    }


    /**
     * Compare the Pair to another Pair
     * @param other
     * @return
     */
    public int compareTo(ComparablePair<A,B> other) {
        return this.getA().compareTo(other.getA());
    }


    public final CPComparator comparator = new CPComparator();



    public class CPComparator implements Comparator<ComparablePair<A, B>> {

        /**
         * Compare two ComparablePair's
         * @param pair1 First Pair
         * @param pair2 Second Pair
         * @return 
         */
        public int compare(ComparablePair<A,B> pair1, ComparablePair<A,B> pair2) {
            return pair1.compareTo(pair2);
        }



    }


}

