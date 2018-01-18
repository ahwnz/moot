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

package application;

import java.util.Random;

public class Constants {
	
	public static final String SERVER_URL = "http://www.nelsonzone.org.nz";
	
	public static final String MAIL_SERVER = "smtp.googlemail.com";
	public static final String MAIL_USER = "moot.noreply@gmail.com";
	public static final String MAIL_PASSWORD = "rovermoot";
        public static final String MAIL_PORT = "465";
	public static final String MAIL_FROM = "Moot No Reply <moot.noreply@gmail.com>";
	public static final String MAIL_REPLY_TO = "questions@sm69thmoot.com";
	
	public static final String ADMIN_NAME = "Pip";
	public static final String ADMIN_EMAIL = "questions@sm69thmoot.com";

        public static final String TEST_EMAIL = "alex@redcloud.co.nz";
	
	public static final String REGION_1_RRL_NAME = "Cherie Marshall";
	public static final String REGION_1_RRL_EMAIL = "cherie.b@clear.net.nz";
	public static final String REGION_2_RRL_NAME = "Damian Hayes";
	public static final String REGION_2_RRL_EMAIL = "amarshall@ihug.co.nz";
	public static final String REGION_3_RRL_NAME = "Mike Pearman";
	public static final String REGION_3_RRL_EMAIL = "pearmanator@gmail.com";
	public static final String REGION_4_RRL_NAME = "Josh Samson";
	public static final String REGION_4_RRL_EMAIL = "themiloman@yahoo.com";
	public static final String REGION_5_RRL_NAME = "Hermann Veltman";
	public static final String REGION_5_RRL_EMAIL = "veltmans@xtra.co.nz";
	
	public static final int ROLE_ID_ROOT = 7;
	public static final int ROLE_ID_ADMIN = 6;
	public static final int ROLE_ID_FINANCE = 5;
	public static final int ROLE_ID_TRANSPORT = 4;
	public static final int ROLE_ID_MERCHANDISE = 3;
	public static final int ROLE_ID_OFFSITE = 2;
	public static final int ROLE_ID_OTHER = 1;
	
	public static final int MOOT_FEE = 35000;
	public static final int STAFF_FEE = 22500;
    public static final int LATE_FEE = 2500;
	
	public static final int ID_MOD = 256*1025;
	
	public static long obscureID(int app_id) {
		return (ID_MOD*((new Random()).nextInt(4096)))+app_id;
	}
	
	public static int clearID(long cid) {
		return (int) (cid%ID_MOD);
	}
	
}
