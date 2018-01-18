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
import java.awt.Font;
import java.awt.Paint;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.CategoryAxis;
import org.jfree.chart.axis.CategoryLabelPositions;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.renderer.category.BarRenderer;
import org.jfree.data.category.CategoryDataset;
import org.jfree.data.category.DefaultCategoryDataset;

import redcloud.db.DbConnect;
import redcloud.db.DbManager;


import com.keypoint.PngEncoder;
import common.Pair;

/**
 * Servlet implementation class ChartViewer
 */
public class CrewChart extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CrewChart() {
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
		
		final Pair<CategoryDataset, Integer> dataset = createDataset();
		
		final JFreeChart chart = ChartFactory.createBarChart(
				"", 						//Title
				"Total="+dataset.getB(), 	//Domain Label
				"Number Applied", 			//Range Label
				dataset.getA(), 			//Dataset
				PlotOrientation.VERTICAL, 	//Orientation
				false,						//Legend
				false,						//Tooltip
				false						//URL
		);
		

		final ColorSelector selector = new ColorSelector(request.getParameter("type"));
		final Paint[] colors = selector.getDefaultBarColors();
		final Color chartGridColor = selector.getChartGridColor();
		final Color h2Color = selector.getH2Color();
		
		
		chart.setBackgroundPaint(selector.getBackgroundColor());

		//Configure Plot Area
		final CategoryPlot plot = chart.getCategoryPlot();
		plot.setBackgroundPaint(selector.getChartColor());
		plot.setDomainGridlinePaint(chartGridColor);
		plot.setRangeGridlinePaint(chartGridColor);
		
		//Configure domain axis
		final CategoryAxis domainAxis = plot.getDomainAxis();
		domainAxis.setTickLabelPaint(h2Color);
		domainAxis.setCategoryLabelPositions(CategoryLabelPositions.UP_90);
		domainAxis.setTickLabelFont(domainAxis.getTickLabelFont().deriveFont(Font.BOLD, 14));
		domainAxis.setLabelPaint(h2Color);
		domainAxis.setLabelFont(domainAxis.getLabelFont().deriveFont(Font.BOLD, 14));

		//Configure range axis
		final NumberAxis rangeAxis = (NumberAxis) plot.getRangeAxis();
		rangeAxis.setStandardTickUnits(NumberAxis.createIntegerTickUnits());
		rangeAxis.setTickLabelPaint(h2Color);
		rangeAxis.setLabelPaint(h2Color);
		rangeAxis.setLabelFont(rangeAxis.getLabelFont().deriveFont(Font.BOLD, 14));
		
		
		final BarRenderer renderer = new CustomRenderer(colors);
		renderer.setDrawBarOutline(false);
		plot.setRenderer(renderer);
		
		
		//Send Image
		response.setContentType( "image/png" );
		final BufferedImage buff = chart.createBufferedImage(640, 400, null);
		final PngEncoder encoder = new PngEncoder(buff, false, 0, 9);
		response.getOutputStream().write(encoder.pngEncode());
	}
	
	
	/**
	 * Create the dataset for the chart
	 * @return The dataset
	 */
	private Pair<CategoryDataset,Integer> createDataset() {
		

		final DbManager dbm = new DbManager("jdbc/moot");
		dbm.open();
		final DbConnect dbc = dbm.doQuery("SELECT rover_crew, region FROM rover WHERE valid = 'Y' AND region <> 'Australia' AND region <> 'Other'");
		
		
		final Map<String, Set<String>> regionMap = new HashMap<String, Set<String>>();
		final Map<String, Integer> numMap = new HashMap<String, Integer>();
		
		final String[] regions = new String[]{"Region1","Region2","Region3","Region4","Region5"};
		
		for(String region: regions) {
			regionMap.put(region, new HashSet<String>());
		}
		
		int total = 0;
		
		while(dbc.next()) {
			String rover_crew = dbc.getString("rover_crew");
			String region = dbc.getString("region");
			
			regionMap.get(region).add(rover_crew);
			
			if(numMap.containsKey(rover_crew)) {
				numMap.put(rover_crew, numMap.get(rover_crew)+1);
			} else {
				numMap.put(rover_crew, 1);
			}
			total++;
		}
		
		dbc.endQuery();
		dbm.close();
		
		final DefaultCategoryDataset dataset = new DefaultCategoryDataset();
		
		for(String region: regions) {
			for(String rover_crew: regionMap.get(region)) {
				dataset.addValue(numMap.get(rover_crew), "Rover Crew", rover_crew);
			}
		}
		
		
		return new Pair<CategoryDataset, Integer>(dataset, total);

	}
	
	public static class CustomRenderer extends BarRenderer {

		private static final long serialVersionUID = 1L;
		
		final private Paint[] colors;

        public CustomRenderer(final Paint[] colors) {
            this.colors = colors;
        }

        @Override
        public Paint getItemPaint(final int row, final int column) {
            return this.colors[column % this.colors.length];
        }
    }

}
