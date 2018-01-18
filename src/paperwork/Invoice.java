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

import application.Constants;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import redcloud.db.DbConnect;
import redcloud.db.DbManager;

/**
 * Invoice Class
 */
public class Invoice {

    private Calendar date = Calendar.getInstance();
    private int applicationId = 0;
    private int invoiceNo = 0;
    private String name = "";
    private String roverCrew = "";
    private String address = "";
    private int total = 0;
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

    public int getInvoiceNo() {
        return invoiceNo;
    }

    public String getRoverCrew() {
        return roverCrew;
    }

    public int getTotal() {
        return total;
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

    public void setInvoiceNo(final int invoiceNo) {
        this.invoiceNo = invoiceNo;
    }

    public void setRoverCrew(final String roverCrew) {
        this.roverCrew = roverCrew;
        if(!roverCrew.toLowerCase().contains("rover crew")) {
            this.roverCrew += " Rover Crew";
        }
    }

    public void setTotal(final int total) {
        this.total = total;
    }

    public static Invoice build(final DbManager dbm, final int application_id) {
        final String sqlStmt1 = "SELECT CONCAT(first_name,' ',last_name) AS full_name, rover_crew, address, apply_date, staff, tour_assigned, late_fee FROM rover WHERE rover_id=?";
        final String sqlStmt2 = "SELECT item_cost, item_name, quantity  FROM rover_merchandise r JOIN merchandise m ON r.item_id=m.item_id WHERE rover_id=?";
        final String sqlStmt3 = "SELECT payment_id, payment_for, method, amount, date FROM payment WHERE rover_id=?";
        final String sqlStmt4 = "SELECT tour_name, tour_cost FROM tour WHERE tour_id = ?";

        final DbConnect dbc1 = dbm.createPreparedStatement(sqlStmt1);
        final DbConnect dbc2 = dbm.createPreparedStatement(sqlStmt2);
        final DbConnect dbc3 = dbm.createPreparedStatement(sqlStmt3);
        dbc1.setInt(1, application_id);
        dbc2.setInt(1, application_id);
        dbc3.setInt(1, application_id);
        dbc1.executeQuery();
        dbc2.executeQuery();
        dbc3.executeQuery();

        final Invoice result = new Invoice();
        if(dbc1.next()) {
            result.setApplicationId(application_id);
            result.setName(dbc1.getString("full_name"));
            result.setRoverCrew(dbc1.getString("rover_crew"));
            result.setAddress(dbc1.getString("address"));
            boolean staff = dbc1.getString("staff").equals("Y");
            Calendar date = Calendar.getInstance();//dbc1.getDate("apply_date");

            while(dbc2.next()) {
                final int quantity = dbc2.getInt("quantity");
                if(quantity > 0) {
                    final Invoice.Line item = new Invoice.Line();
                    int amount = quantity*dbc2.getInt("item_cost");
                    item.setDate(date);
                    item.setQuantity(quantity);
                    item.setDescription(dbc2.getString("item_name"));
                    item.setAmount(amount);
                    result.lines.add(item);
                    result.total += amount;
                }
            }
            dbc2.endQuery();

            final Invoice.Line fee = new Invoice.Line();
            fee.setDate(date);
            fee.setQuantity(1);
            fee.setDescription("Main Fee"+(staff?" (Staff)":""));
            fee.setTrasactionNo(0);
            fee.setAmount(staff?Constants.STAFF_FEE:Constants.MOOT_FEE);
            result.lines.add(fee);
            result.total += staff?Constants.STAFF_FEE:Constants.MOOT_FEE;

            if(dbc1.getString("late_fee").equals("Y")) {
                final Invoice.Line late = new Invoice.Line();
                late.setDate(date);
                late.setQuantity(1);
                late.setDescription("Late Fee");
                late.setTrasactionNo(0);
                late.setAmount(Constants.LATE_FEE);
                result.lines.add(late);
                result.total += Constants.LATE_FEE;
            fee.setQuantity(1);
            }

            final int tour_id = dbc1.getInt("tour_assigned");
            if(tour_id > 0) {
                final DbConnect dbc4 = dbm.createPreparedStatement(sqlStmt4);
                dbc4.setInt(1, tour_id);
                dbc4.executeQuery();
                if(dbc4.next()) {
                    final Invoice.Line tour = new Invoice.Line();
                    tour.setDate(date);
                    tour.setQuantity(1);
                    tour.setDescription(dbc4.getString("tour_name"));
                    final int tour_cost = dbc4.getInt("tour_cost");
                    tour.setAmount(tour_cost);
                    result.lines.add(tour);
                    result.total += tour_cost;
                }
                dbc4.endQuery();
            }

            while(dbc3.next()) {

                final Invoice.Line payment = new Invoice.Line();
                payment.setDate(dbc3.getDate("date"));
                payment.setDescription(String.format("Payment (%s) by %s", dbc3.getString("payment_for"), dbc3.getString("method")));
                payment.setTrasactionNo(dbc3.getInt("payment_id"));
                final int amount = dbc3.getInt("amount");
                payment.setAmount(amount);
                payment.setIsPayment(true);
                result.lines.add(payment);
                result.total -= amount;
            }
            dbc3.endQuery();
        }

        dbc1.endQuery();

        return result;
    }




    public static class Line {

        private Calendar date;
        private int quantity;
        private String description;
        private int trasactionNo;
        private int amount;
        private boolean isPayment;

        public Line(final Calendar date, final int quantity,
                    final String description, final int transactionNo,
                    final int amount, boolean isPayment) {

            this.date = date;
            this.quantity = quantity;
            this.description = description;
            this.trasactionNo = transactionNo;
            this.amount = amount;
            this.isPayment = isPayment;
        }

        public Line() {}

        public int getAmount() {
            return amount;
        }

        public Calendar getDate() {
            return date;
        }

        public String getDescription() {
            return description;
        }

        public int getQuantity() {
            return quantity;
        }

        public int getTrasactionNo() {
            return trasactionNo;
        }

        public boolean getIsPayment() {
            return isPayment;
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

        public void setQuantity(int quantity) {
            this.quantity = quantity;
        }

        public void setTrasactionNo(int trasactionNo) {
            this.trasactionNo = trasactionNo;
        }

        public void setIsPayment(boolean isPayment) {
            this.isPayment = isPayment;
        }
    }

}
