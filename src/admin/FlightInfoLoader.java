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

package admin;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import redcloud.db.DbConnect;
import redcloud.db.DbManager;

/**
 * Servlet implementation class FlightInfoLoader
 */
public class FlightInfoLoader extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public FlightInfoLoader() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String flight_type = request.getParameter("flight_type");
		
		String page_input;
		if(flight_type.equals("DA")) {
			page_input = getDomArr();
		} else {
			page_input = request.getParameter("page_input");
		}
		
		ArrayList<Flight> flights = extract(page_input);
		
		DbManager dbm = new DbManager("jdbc/moot");
		dbm.open();
		DbConnect dbc = dbm.createPreparedStatement("DELETE FROM flight WHERE flight_type=?");
		dbc.setString(1, flight_type);
		dbc.executeUpdate();
		dbc = dbm.createPreparedStatement("INSERT INTO flight SET flight_type=?, airline=?, number=?, other=?, scheduled=?, estimated=?, gate=?, status=?");
		
		for(Flight flight: flights) {
            flight.upload(dbc, flight_type);
        }
		dbc.end();
		dbm.close();
		
		response.sendRedirect("/moot/pages/admin/flight_info_load.jsp");
	}
	
	public static String getDomArr() {
        String result = null;

        try {
            URL url = new URL("http://www.christchurchairport.co.nz/TravellersAndServices/FlightsAndAirlineInformation/ArrivalsAndDepartures/");
            URLConnection conn = url.openConnection();

            BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuffer sb = new StringBuffer();
            String line;
            while ((line = rd.readLine()) != null) {
                sb.append(line);
            }
            rd.close();
            result = sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return result;
    }
	
	public static ArrayList<Flight> extract(String page) {
        Pattern p = Pattern.compile("<tr(?: class=\"alt\")?>\\s*<td>.*?alt=\"([\\w ]+)\".*?</td>\\s*<td>(.*?)</td>\\s*<td>(.*?)</td>\\s*<td class=\"time\">\\s*<abbr.*?>\\s*(.*?)\\s*</abbr>\\s*</td>\\s*<td class=\"time\">\\s*<abbr.*?>\\s*(.*?)\\s*</abbr>\\s*</td>\\s*<td>(.*?)</td>\\s*<td class=\"status .*?\">(.*?)</td>\\s*</tr>");
        Matcher m = p.matcher(page);
        ArrayList<Flight> list = new ArrayList<Flight>();
        while(m.find()) {
            Flight flight = new Flight();
            flight.airline = m.group(1);
            flight.number = m.group(2);
            flight.from = m.group(3);
            flight.scheduled = m.group(4);
            flight.estimated = m.group(5);
            flight.gate = m.group(6);
            flight.status = m.group(7);
            flight.clean();
            list.add(flight);
        }
        return list;
    }
	
	
	
	public static class Flight {
        String airline;
        String number;
        String from;
        String scheduled;
        String estimated;
        String gate;
        String status;

        
        @Override
        public String toString() {
            return String.format("Flight:\n\tAirline: %s\n\tNumber: %s\n\tTo/From: %s\n\tScheduled: %s\n\tEstimated: %s\n\tGate: %s\n\tStatus: %s\n\n", airline, number, from, scheduled, estimated, gate, status);
        }

        
        public void clean() {
            String[] parts = number.split("<br/?>");
            if(parts.length>1) {
                number = parts[0] + "/" + parts[1];
            }
            parts = from.split("<br/?>");
            if(parts.length>1) {
                from = parts[0] + "/" + parts[1];
            }
            parts = scheduled.split("&nbsp;");
            if(parts.length>1) {
                scheduled = parts[0] + " " + parts[1];
            }
            parts = estimated.split("&nbsp;");
            if(parts.length>1) {
                estimated = parts[0] + " " + parts[1];
            }
            parts = status.split("<br/?>");
            if(parts.length>1) {
                status = parts[0] + " " + parts[1];
            }
        }
        
        public void upload(DbConnect dbc, String type) {
        	String[] parts = number.split("/");
    		for(String part: parts) {
    			dbc.setString(1, type);
            	dbc.setString(2, airline);
            	dbc.setString(3, part);
            	dbc.setString(4, from);
            	dbc.setString(5, scheduled);
            	dbc.setString(6, estimated);
            	dbc.setString(7, gate);
            	dbc.setString(8, status);
            	dbc.executeRepetiveUpdate();
    		}
        }
    }

}
