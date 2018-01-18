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
import java.awt.GradientPaint;
import java.awt.Paint;
import java.awt.image.BufferedImage;
import java.io.IOException;

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
import org.jfree.chart.title.LegendTitle;
import org.jfree.data.category.CategoryDataset;
import org.jfree.data.category.DefaultCategoryDataset;

import redcloud.db.DbConnect;
import redcloud.db.DbManager;

import com.keypoint.PngEncoder;

/**
 * Servlet implementation class TourPopularity
 */
public class TourPopularity extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TourPopularity() {
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
		
		final CategoryDataset dataset = createDataset();
		
		final JFreeChart chart = ChartFactory.createBarChart(
				"", 						//Title
				"Tour", 					//Domain Label
				"Count",		 			//Range Label
				dataset, 					//Dataset
				PlotOrientation.VERTICAL, 	//Orientation
				true,						//Legend
				false,						//Tooltip
				false						//URL
		);
		

		final ColorSelector selector = new ColorSelector(request.getParameter("type"));
		final Color chartGridColor = selector.getChartGridColor();
		final Color h2Color = selector.getH2Color();
		
		
		chart.setBackgroundPaint(selector.getBackgroundColor());

		//Configure Plot Area
		final CategoryPlot plot = chart.getCategoryPlot();
		plot.setBackgroundPaint(selector.getChartColor());
		plot.setDomainGridlinePaint(chartGridColor);
		plot.setRangeGridlinePaint(chartGridColor);
		
		//Configure Legend
		final LegendTitle legend = chart.getLegend();
		legend.setBorder(0, 0, 0, 0);
		
		BarRenderer renderer = (BarRenderer) plot.getRenderer();
        renderer.setDrawBarOutline(false);
        
        //Setup Series Colors
        Color color1 = Color.decode("#fdf200");
        Color color2 = Color.decode("#f59710");
        Color color3 = Color.decode("#eb1f25");
        Color color4 = Color.decode("#002699");
        
        GradientPaint gradient1 = new GradientPaint(0, 0, color1, 0, 0, color1.darker());
        GradientPaint gradient2 = new GradientPaint(0, 0, color2, 0, 0, color2.darker());
        GradientPaint gradient3 = new GradientPaint(0, 0, color3, 0, 0, color3.darker());
        GradientPaint gradient4 = new GradientPaint(0, 0, color4, 0, 0, color4.darker());
        
        renderer.setSeriesPaint(0, gradient1);
        renderer.setSeriesPaint(1, gradient2);
        renderer.setSeriesPaint(2, gradient3);
        renderer.setSeriesPaint(3, gradient4);
		
		
		//Configure domain axis
		final CategoryAxis domainAxis = plot.getDomainAxis();
		domainAxis.setTickLabelPaint(h2Color);
		domainAxis.setCategoryLabelPositions(CategoryLabelPositions.UP_45);
		domainAxis.setTickLabelFont(domainAxis.getTickLabelFont().deriveFont(Font.BOLD, 14));
		domainAxis.setLabelPaint(h2Color);
		domainAxis.setLabelFont(domainAxis.getLabelFont().deriveFont(Font.BOLD, 14));

		//Configure range axis
		final NumberAxis rangeAxis = (NumberAxis) plot.getRangeAxis();
		rangeAxis.setStandardTickUnits(NumberAxis.createIntegerTickUnits());
		rangeAxis.setTickLabelPaint(h2Color);
		rangeAxis.setLabelPaint(h2Color);
		rangeAxis.setLabelFont(rangeAxis.getLabelFont().deriveFont(Font.BOLD, 14));
		
		
		//final BarRenderer renderer = new CustomRenderer();
		//renderer.setDrawBarOutline(false);
		//plot.setRenderer(renderer);
		
		
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
	private CategoryDataset createDataset() {
		
		final DbManager dbm = new DbManager("jdbc/moot");
		dbm.open();
		final DbConnect dbc1 = dbm.doQuery("SELECT tour_id, tour_name FROM tour");
		final DbConnect dbc2 = dbm.createPreparedStatement("SELECT COUNT(rover_id) FROM rover WHERE tour_pref_1 = ? AND tour_assigned = 0");
		final DbConnect dbc3 = dbm.createPreparedStatement("SELECT COUNT(rover_id) FROM rover WHERE tour_pref_2 = ? AND tour_assigned = 0");
		final DbConnect dbc4 = dbm.createPreparedStatement("SELECT COUNT(rover_id) FROM rover WHERE tour_pref_3 = ? AND tour_assigned = 0");
		final DbConnect dbc5 = dbm.createPreparedStatement("SELECT COUNT(rover_id) FROM rover WHERE tour_assigned = ?");
		
		final DefaultCategoryDataset dataset = new DefaultCategoryDataset();
		
		while(dbc1.next()) {
			final int tour_id = dbc1.getInt("tour_id");
			final String tour_name = dbc1.getString("tour_name");
			dbc2.setInt(1, tour_id);
			dbc3.setInt(1, tour_id);
			dbc4.setInt(1, tour_id);
			dbc5.setInt(1, tour_id);
			dbc2.executeQuery();
			dbc3.executeQuery();
			dbc4.executeQuery();
			dbc5.executeQuery();
			
			if(dbc2.next()) {
				dataset.addValue(dbc2.getInt(1), "First Preference", tour_name);
			}
			if(dbc3.next()) {
				dataset.addValue(dbc3.getInt(1), "Second Preference", tour_name);
			}
			if(dbc4.next()) {
				dataset.addValue(dbc4.getInt(1),"Third Preference", tour_name);
			}
			if(dbc5.next()) {
				dataset.addValue(dbc5.getInt(1), "Assigned Tour", tour_name);
			}
		}
		
		dbc1.endQuery();
		dbc2.endQuery();
		dbc3.endQuery();
		dbc4.endQuery();
		dbc5.endQuery();
		dbm.close();
		
		return dataset;

	}
	
	public static class CustomRenderer extends BarRenderer {

		private static final long serialVersionUID = 1L;

        @Override
        public Paint getItemPaint(final int row, final int column) {
            switch(row) {
            case 0: 
            	return Color.decode("#fdf200");
            case 1: 
            	return Color.decode("#f59710");
            case 2: 
            	return Color.decode("#eb1f25");
            case 3: 
            	return Color.decode("#002699");
            default:
            	return Color.BLACK;
            }
        }
    }

}
