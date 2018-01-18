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

package paperwork;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import redcloud.db.DbConnect;
import redcloud.db.DbManager;

/**
 * Receipt Class
 */
public class Receipt {

    private Calendar date = Calendar.getInstance();
    private int applicationId = 0;
    private int receiptNo = 0;
    private String name = "";
    private String roverCrew = "";
    private String address = "";
    private List<Line> lines = new ArrayList<Line>();


    public String getAddress() {
        return address;
    }

    public int getApplicationId() {
        return applicationId;
    }

    public Calendar getDate() {
        return date;
    }

    public List<Line> getLines() {
        return lines;
    }

    public String getName() {
        return name;
    }

    public int getReceiptNo() {
        return receiptNo;
    }

    public String getRoverCrew() {
        return roverCrew;
    }

    public void setAddress(final String address) {
        this.address = address;
    }

    public void setApplicationId(final int applicationId) {
        this.applicationId = applicationId;
    }

    public void setDate(final Calendar date) {
        this.date = date;
    }

    public void setLines(final List<Line> lines) {
        this.lines = lines;
    }

    public void setName(final String name) {
        this.name = name;
    }

    public void setReceiptNo(final int receiptNo) {
        this.receiptNo = receiptNo;
    }

    public void setRoverCrew(final String roverCrew) {
        this.roverCrew = roverCrew;
        if(!roverCrew.toLowerCase().contains("rover crew")) {
            this.roverCrew += " Rover Crew";
        }
    }

    public static Receipt build(final DbManager dbm, final int application_id) {
        final String sqlStmt = "SELECT CONCAT(first_name,' ',last_name) AS full_name, rover_crew, address FROM rover WHERE rover_id=?";

        final DbConnect dbc = dbm.createPreparedStatement(sqlStmt);
        dbc.setInt(1, application_id);
        dbc.executeQuery();

        final Receipt result = new Receipt();
        if(dbc.next()) {
            result.setApplicationId(application_id);
            result.setName(dbc.getString("full_name"));
            result.setRoverCrew(dbc.getString("rover_crew"));
            result.setAddress(dbc.getString("address"));
        }

        dbc.endQuery();

        return result;
    }




    public static class Line {

        private Calendar date;
        private String description;
        private String method;
        private int trasactionNo;
        private int amount;

        public Line(final Calendar date, final String description,
                    final int transactionNo, final String method,
                    final int amount) {
            
            this.date = date;
            this.description = description;
            this.trasactionNo = transactionNo;
            this.method = method;
            this.amount = amount;
        }

        public int getAmount() {
            return amount;
        }

        public Calendar getDate() {
            return date;
        }

        public String getDescription() {
            return description;
        }

        public String getMethod() {
            return method;
        }

        public int getTrasactionNo() {
            return trasactionNo;
        }

        public void setAmount(int amount) {
            this.amount = amount;
        }

        public void setDate(Calendar date) {
            this.date = date;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public void setMethod(String method) {
            this.method = method;
        }

        public void setTrasactionNo(int trasactionNo) {
            this.trasactionNo = trasactionNo;
        }


    }

}
