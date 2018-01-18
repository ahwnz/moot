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

import java.awt.Color;
import java.io.IOException;
import java.util.Calendar;
import javax.servlet.http.HttpServletResponse;

import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import common.DisplayUtils;

/**
 * InvoiceGenerator Class
 */
public class InvoiceGenerator {
    
	private static final int[] YEAR = new int[12];
	static {
		YEAR[Calendar.JANUARY] 		= 2011;
		YEAR[Calendar.FEBRUARY] 	= 2011;
		YEAR[Calendar.MARCH] 		= 2011;
		YEAR[Calendar.APRIL] 		= 2011;
		YEAR[Calendar.MAY] 		= 2011;
		YEAR[Calendar.JUNE] 		= 2011;
		YEAR[Calendar.JULY] 		= 2011;
		
		YEAR[Calendar.AUGUST] 		= 2010;
		YEAR[Calendar.SEPTEMBER] 	= 2010;
		YEAR[Calendar.OCTOBER]		= 2010;
		YEAR[Calendar.NOVEMBER]		= 2010;
		YEAR[Calendar.DECEMBER]		= 2010;
	}
	
    
    public InvoiceGenerator() {
        super();
    }

	
    protected void generate(final HttpServletResponse response, final Invoice invoice, final boolean images) throws IOException {

        final Document document = new Document();

        response.setContentType("application/pdf");
        try {
            PdfWriter.getInstance(document, response.getOutputStream());

            document.open();

            document.addAuthor("Alex Westphal, SM69TH Moot");
            document.addCreationDate();
            document.addTitle("SM69TH Moot Invoice");
            document.addSubject("SM69TH Moot Invoice");

            if(images) Standard.putImages(document);

            Standard.putOfficeInfo(document);
            Standard.putTitle(document, "Invoice/Statement");
            Standard.putGstNum(document);

            putDetails(document, invoice);
            document.add(new Paragraph("\n\n"));
            putTable(document, invoice);
            putPaymentReminder(document);

            document.close();
        } catch (DocumentException ex) {
            ex.printStackTrace();
            System.out.println("DocumentException: "+ex.getMessage());
        }
    }
	
	
	
    /**
     * Put the Invoice details into the document
     * @param document Document to use
     * @param date Invoice issue date
     * @param InvoiceNo Invoice number
     * @param roverID Application number
     * @param dbm Database manager
     * @throws DocumentException
     */
    public void putDetails(final Document document, final Invoice invoice) throws DocumentException {

        final PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);

        final PdfPCell leftCell = new PdfPCell(getDetails1(invoice));
        leftCell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
        leftCell.setBorder(Rectangle.NO_BORDER);
        table.addCell(leftCell);

        final PdfPCell rightCell = new PdfPCell(getDetails2(invoice));
        rightCell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
        rightCell.setBorder(Rectangle.NO_BORDER);
        table.addCell(rightCell);

        document.add(table);
    }
	
	
	
    /**
     * Get the payee details paragraph
     * @param invoice Invoice to use
     * @return Details paragraph
     */
    public Paragraph getDetails1(final Invoice invoice) {

        final Chunk chunk1 = new Chunk(String.format("%s\n%s\n%s", invoice.getName(), invoice.getRoverCrew(), invoice.getAddress()));
        final Font font2 = new Font();
        font2.setColor(Color.DARK_GRAY);
        chunk1.setFont(font2);

        final Paragraph paragraph = new Paragraph();
        paragraph.add(chunk1);
        paragraph.setAlignment(Paragraph.ALIGN_LEFT);

        return paragraph;
    }
	
	
	
    /**
     * Get the Invoice details paragraph
     * @param invoice Invoice to use
     * @return Details paragraph
     */
    public Paragraph getDetails2(final Invoice invoice) {
        final Font font1 = new Font();
        font1.setStyle(Font.BOLD);

        final Font font2 = new Font();
        font2.setColor(Color.DARK_GRAY);

        final Paragraph paragraph = new Paragraph();
        paragraph.setAlignment(Paragraph.ALIGN_RIGHT);

        final Chunk chunk1 = new Chunk("Date: ");
        chunk1.setFont(font1);
        paragraph.add(chunk1);

        final Chunk chunk2 = new Chunk(String.format("%td %<tB %<tY", invoice.getDate()));
        chunk2.setFont(font2);
        paragraph.add(chunk2);

        final Chunk chunk3 = new Chunk("\n\nInvoice/Statement Number: ");
        chunk3.setFont(font1);
        paragraph.add(chunk3);

        final Chunk chunk4 = new Chunk(String.format("%05d", invoice.getInvoiceNo()));
        chunk4.setFont(font2);
        paragraph.add(chunk4);

        final Chunk chunk5 = new Chunk("\nApplication Number: ");
        chunk5.setFont(font1);
        paragraph.add(chunk5);

        final Chunk chunk6 = new Chunk(String.format("%05d", invoice.getApplicationId()));
        chunk6.setFont(font2);
        paragraph.add(chunk6);

        return paragraph;
    }
	
	
	
    /**
     * Put the payments table into the document
     * @param document Document to use
     * @param invoice Invoice to use
     * @throws DocumentException
     */
    public void putTable(final Document document, final Invoice invoice) throws DocumentException {

        final float[] colsWidth = new float[]{1f,1f,2.5f,1.3f,1f};
        final PdfPTable table = new PdfPTable(colsWidth);
        table.setWidthPercentage(100);

        putHead(table);

        int space = 12;
        for(Invoice.Line line: invoice.getLines()) {
            putRow(table, line);
            space--;
        }

        putSpace(table, space);
        putFoot(table, invoice.getTotal());
        document.add(table);

    }
	
	
	
    /**
     * Put the table head into the table
     * <p>
     * Layout:
     * <code>
     *  ________________________________________________________________
     * |      |             |                |                |        |
     * | Date |  Quantity   |   Description  | Transaction No | Amount |
     * |______|_____________|________________|________________|________|
     * |      |             |                |                |        |
     * </code>
     *
     * @param table Table to use
     */
    public void putHead(final PdfPTable table) {

        final Font font = new Font();
        font.setStyle(Font.BOLD);

        final PdfPCell dateHead = new PdfPCell(new Paragraph("Date", font));
        dateHead.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
        dateHead.setBackgroundColor(Color.LIGHT_GRAY);
        table.addCell(dateHead);

        final PdfPCell descriptionHead = new PdfPCell(new Paragraph("Quantity", font));
        descriptionHead.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
        descriptionHead.setBackgroundColor(Color.LIGHT_GRAY);
        table.addCell(descriptionHead);

        final PdfPCell transNoHead = new PdfPCell(new Paragraph("Description", font));
        transNoHead.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
        transNoHead.setBackgroundColor(Color.LIGHT_GRAY);
        table.addCell(transNoHead);

        final PdfPCell methodHead = new PdfPCell(new Paragraph("Transaction No", font));
        methodHead.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
        methodHead.setBackgroundColor(Color.LIGHT_GRAY);
        table.addCell(methodHead);

        final PdfPCell amountHead = new PdfPCell(new Paragraph("Amount", font));
        amountHead.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
        amountHead.setBackgroundColor(Color.LIGHT_GRAY);
        table.addCell(amountHead);
    }
	
	
	
    /**
     * Put a row into the table
     * <p>
     * Layout:
     * <code>
     * |......|.............|................|................|........|
     * |      |             |                |                |        |
     * |{Date}| {Quantity}  | {Description}  |{Transaction No}|{Amount}|
     * |......|.............|................|................|........|
     * |      |             |                |                |        |
     * </code>
     *
     * @param table Table to use
     * @param row Row to add
     */
    public void putRow(final PdfPTable table, final Invoice.Line line) {

        final PdfPCell dateCell = new PdfPCell(new Paragraph(String.format("%td/%<tm/%d", line.getDate(), YEAR[line.getDate().get(Calendar.MONTH)])));
        dateCell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
        dateCell.setBorderWidthBottom(0);
        dateCell.setBorderWidthTop(0);
        table.addCell(dateCell);

        String quantity = line.getQuantity()==0?"":""+line.getQuantity();
        final PdfPCell quantityCell = new PdfPCell(new Paragraph(quantity));
        quantityCell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
                quantityCell.setBorderWidthBottom(0);
        quantityCell.setBorderWidthTop(0);
        table.addCell(quantityCell);

        final PdfPCell descriptionCell = new PdfPCell(new Paragraph(line.getDescription()));
        descriptionCell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
        descriptionCell.setBorderWidthBottom(0);
        descriptionCell.setBorderWidthTop(0);
        table.addCell(descriptionCell);

        String transactionNo = line.getTrasactionNo()==0?"":String.format("%05d", line.getTrasactionNo());
        final PdfPCell transactionNoCell = new PdfPCell(new Paragraph(transactionNo));
        transactionNoCell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
        transactionNoCell.setBorderWidthBottom(0);
        transactionNoCell.setBorderWidthTop(0);
        table.addCell(transactionNoCell);

        String amount = "$"+DisplayUtils.displayAmount(line.getAmount());
        if(line.getIsPayment()) amount = "["+amount+"]";
        final PdfPCell amountCell = new PdfPCell(new Paragraph(amount));
        amountCell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
        amountCell.setBorderWidthBottom(0);
        amountCell.setBorderWidthTop(0);
        table.addCell(amountCell);
    }
	
	
	
    /**
     * Put vertical space into the table
     * <p>
     * Layout:
     * <code>
     * |......|.............|................|................|........|
     * |      |             |                |                |        |
     * |      |             |                |                |        |
     * |......|.............|................|................|........|
     * |      |             |                |                |        |
     * </code>
     *
     * @param table Table to use
     * @param space Amount of space
     */
    public void putSpace(final PdfPTable table , final int space) {
        String space_str = "";
        for(int i=0; i<space; i++) space_str += '\n';

        final PdfPCell emptyCell = new PdfPCell(new Paragraph(space_str));
        emptyCell.setBorderWidthBottom(0);
        emptyCell.setBorderWidthTop(0);
        table.addCell(emptyCell);
        table.addCell(emptyCell);
        table.addCell(emptyCell);
        table.addCell(emptyCell);
        table.addCell(emptyCell);
    }
	
	
	
    /**
     * Put the foot into the table
     * <p>
     * Layout:
     * <code>
     * |______|_____________|________________|________________|________|
     * .      .             .                |                |        |
     * .      .             .                |   Total Owing  | Amount |
     * ......................................|________________|________|
     * </code>
     *
     * @param table
     * @param total
     */
    public void putFoot(final PdfPTable table, final int total) {

        final Font font = new Font();
        font.setStyle(Font.BOLD);

        final PdfPCell cell1 = new PdfPCell(new Paragraph());
        cell1.setBorderWidthBottom(0);
        cell1.setBorderWidthLeft(0);
        cell1.setBorderWidthRight(0);
        table.addCell(cell1);

        final PdfPCell cell2 = new PdfPCell(new Paragraph());
        cell2.setBorderWidthBottom(0);
        cell2.setBorderWidthLeft(0);
        cell2.setBorderWidthRight(0);
        table.addCell(cell2);

        final PdfPCell cell3 = new PdfPCell(new Paragraph());
        cell3.setBorderWidthBottom(0);
        cell3.setBorderWidthLeft(0);
        table.addCell(cell3);

        final PdfPCell cell4 = new PdfPCell(new Paragraph("Total Owing:", font));
        cell4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
        cell4.setBackgroundColor(Color.LIGHT_GRAY);
        table.addCell(cell4);

        final PdfPCell cell5 = new PdfPCell(new Paragraph("$"+DisplayUtils.displayAmount(total), font));
        cell5.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);

        table.addCell(cell5);
    }
	
	
	
    /**
     * Put Received with thanks message into the document
     * @param document Document to use
     * @throws DocumentException
     */
    public void putPaymentReminder(final Document document) throws DocumentException {

        final Chunk chunk1 = new Chunk("\n\nReminder Payment in full is due by the 15th February 2011.");
        final Chunk chunk2 = new Chunk("\n\nThe Scout Association of New Zealand\nRover Moot Account - 06-0501-0090411-12");
        final Font font = new Font();
        font.setStyle(Font.BOLD);
        chunk1.setFont(font);
        chunk2.setFont(font);

        final Paragraph paragraph1 = new Paragraph(chunk1);
        final Paragraph paragraph2 = new Paragraph(chunk2);
        paragraph1.setAlignment(Paragraph.ALIGN_CENTER);
        paragraph2.setAlignment(Paragraph.ALIGN_CENTER);

        document.add(paragraph1);
        document.add(paragraph2);
    }
	

}
