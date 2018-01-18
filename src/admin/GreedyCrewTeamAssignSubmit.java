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

import common.Pair;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import redcloud.db.DbConnect;
import redcloud.db.DbManager;

public class GreedyCrewTeamAssignSubmit extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        final int team_count = Integer.parseInt(request.getParameter("team_count"));

        final DbManager dbm = new DbManager("jdbc/moot");
        dbm.open();
        dbm.doUpdate("DELETE FROM rover_team");

        final DbConnect dbc1 = dbm.doQuery("SELECT rover_id, rover_crew FROM rover WHERE valid='Y'");
        final DbConnect dbc2 = dbm.createPreparedStatement("INSERT INTO rover_team VALUES (null,?,?)");

        final Map<String, List<Integer>> crewMap = new HashMap<String, List<Integer>>();

        int count = 0;
        while(dbc1.next()) {
            final String rover_crew = dbc1.getString("rover_crew");
            if(crewMap.containsKey(rover_crew)) {
                crewMap.get(rover_crew).add(dbc1.getInt("rover_id"));
            } else {
                final List<Integer> roverList = new ArrayList<Integer>();
                roverList.add(dbc1.getInt("rover_id"));
                crewMap.put(rover_crew, roverList);
            }
            count++;
        }

        int team_size = count/team_count;
        if(team_size*team_count != count) team_size++;

        final List<Pair<String, List<Integer>>> crewList = new ArrayList<Pair<String, List<Integer>>>();

        for(Entry<String, List<Integer>> entry: crewMap.entrySet()) {
            String crew_name = entry.getKey();
            List<Integer> roverList = entry.getValue();

            while(roverList.size() > team_size) {
                List<Integer> roverList2 = new ArrayList<Integer>();
                for(int i=0; i<team_size; i++) {
                    roverList2.add(roverList.remove(0));
                }
                crewList.add(new Pair<String, List<Integer>>(crew_name, roverList2));
                Collections.sort(roverList2);
            }

            crewList.add(new Pair<String, List<Integer>>(crew_name, roverList));
            Collections.sort(roverList);
        }

        final Comparator<Pair<String, List<Integer>>> comparator = new CrewComparator();
       Collections.sort(crewList, comparator);

        final Team[] teams = new Team[team_count];
        for(int i=0; i<team_count; i++) {
            teams[i] = new Team(i);
        }

        for(Pair<String, List<Integer>> crew: crewList) {
            List<Integer> roverList = crew.getB();
            for(Team team: teams) {
                if(team.size() + roverList.size() <= team_size) {
                    for(int rover: roverList) {
                        team.add(rover);
                    }
                    break;
                }
            }
        }

        for(Team team: teams) {
            for(int rover: team) {
                dbc2.setInt(1, rover);
                dbc2.setInt(2, team.team_num);
                dbc2.executeRepetiveUpdate();
            }
        }

        dbc1.endQuery();
        dbc2.endQuery();
        dbm.close();

        response.sendRedirect("/moot/pages/admin/team_members.jsp");
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private class CrewComparator implements Comparator<Pair<String, List<Integer>>> {

        @Override
        public int compare(Pair<String, List<Integer>> pair1, Pair<String, List<Integer>> pair2) {
            return new Integer(pair2.getB().size()).compareTo(pair1.getB().size());
        }
    }

    private class Team extends ArrayList<Integer> {

        public final int team_num;

        public Team(final int team_num) {
            this.team_num = team_num;
        }

    }
}
