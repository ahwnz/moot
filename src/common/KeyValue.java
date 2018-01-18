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

import redcloud.db.DbConnect;
import redcloud.db.DbManager;


public class KeyValue {

    private final DbManager dbm;

    public KeyValue(DbManager dbm) {
        this.dbm = dbm;
    }

    public void put(String key, String value) {
        final DbConnect dbc;
        if(null == get(key)) dbc = dbm.createPreparedStatement("INSERT INTO key_value SET field_value=?, field_key=?");
        else dbc = dbm.createPreparedStatement("UPDATE key_value SET field_value = ? WHERE field_key=?");

        dbc.setString(1, value);
        dbc.setString(2, key);
        dbc.executeUpdate();
    }

    public String get(String key) {
        DbConnect dbc = dbm.createPreparedStatement("SELECT field_value FROM key_value WHERE field_key = ?");
        dbc.setString(1, key);
        dbc.executeQuery();

        String result = null;
        if(dbc.next()) result = dbc.getString("field_value");
        else result = null;
        dbc.endQuery();
        return result;
    }

    public int getInt(String key) {
        try {
            return Integer.parseInt(get(key));
        } catch(NumberFormatException ex) {
            return -1;
        }
    }
}
