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

/**
 * Class to represent a pair of objects.
 *
 * @param <A> Type of first object
 * @param <B> Type of second object
 */
public class Pair<A, B> {

	
    private A a;
    private B b;



    /**
     * Pair Constructor
     * @param a First element
     * @param b Second element
     */
    public Pair(final A a, final B b) {
        this.a = a;
        this.b = b;
    }



    /**
     * Get the first element of the Pair
     * @return The first element of the pair.
     */
    public A getA() {
        return a;
    }



    /**
     * Get the second element of the Pair
     * @return The second element of the Pair
     */
    public B getB() {
        return b;
    }



    /**
     * Set the first element of the Pair.
     * @param a First element
     */
    public void setA(final A a) {
        this.a = a;
    }



    /**
     * Set the second element of the Pair.
     * @param b Second Element
     */
    public void setB(final B b) {
        this.b = b;
    }



    /**
     * Clone the pair.
     * @return a copy of the Pair
     */
    @Override
    public Pair<A,B> clone() {
        return new Pair<A,B>(a, b);
    }



    @Override
    public String toString() {
        return "Pair("+a.toString()+", "+b.toString()+")";
    }


    /**
     * Reverse the Pair
     * @return a reverse of the Pair
     */
    public Pair<B,A> reverse() {
        return new Pair<B,A>(b, a);
    }

}
