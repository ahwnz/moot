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
 * ReceiptGenerator Class
 */
public class ReceiptGenerator {
    
	private static final int[] YEAR = new int[12];
	static {
		YEAR[Calendar.JANUARY] 		= 2011;
		YEAR[Calendar.FEBRUARY] 	= 2011;
		YEAR[Calendar.MARCH] 		= 2011;
		YEAR[Calendar.APRIL] 		= 2011;
		YEAR[Calendar.MAY]              = 2011;
		YEAR[Calendar.JUNE] 		= 2011;
		YEAR[Calendar.JULY] 		= 2011;
		
		YEAR[Calendar.AUGUST] 		= 2010;
		YEAR[Calendar.SEPTEMBER] 	= 2010;
		YEAR[Calendar.OCTOBER]		= 2010;
            YEAR[Calendar.NOVEMBER]		= 2010;
		YEAR[Calendar.DECEMBER]		= 2010;
	}
	
    
    public ReceiptGenerator() {
        super();
    }

	
    protected void generate(final HttpServletResponse response, final Receipt receipt, final boolean images) throws IOException {

        final Document document = new Document();

        response.setContentType("application/pdf");
        try {
            PdfWriter.getInstance(document, response.getOutputStream());

            document.open();

            document.addAuthor("Alex Westphal, SM69TH Moot");
            document.addCreationDate();
            document.addTitle("SM69TH Moot Receipt");
            document.addSubject("SM69TH Moot Receipt");

            if(images) Standard.putImages(document);

            Standard.putOfficeInfo(document);
            Standard.putTitle(document, "Receipt");
            Standard.putGstNum(document);

            putDetails(document, receipt);
            document.add(new Paragraph("\n\n\n"));
            putTable(document, receipt);
            putThanks(document);

            document.close();
        } catch (DocumentException ex) {
            ex.printStackTrace();
            System.out.println("DocumentException: "+ex.getMessage());
        }

    }
	
	
	
    /**
     * Put the receipt details into the document
     * @param document Document to use
     * @param date Receipt issue date
     * @param receiptNo Receipt number
     * @param roverID Application number
     * @param dbm Database manager
     * @throws DocumentException
     */
    public void putDetails(final Document document, final Receipt receipt) throws DocumentException {

        final PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);

        final PdfPCell leftCell = new PdfPCell(getDetails1(receipt));
        leftCell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
        leftCell.setBorder(Rectangle.NO_BORDER);
        table.addCell(leftCell);

        final PdfPCell rightCell = new PdfPCell(getDetails2(receipt));
        rightCell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
        rightCell.setBorder(Rectangle.NO_BORDER);
        table.addCell(rightCell);

        document.add(table);
    }
	
	
	
    /**
     * Get the payee details paragraph
     * @param receipt Receipt
     * @return Details paragraph
     */
    public Paragraph getDetails1(final Receipt receipt) {

        final Chunk chunk1 = new Chunk("Recieved from:\n\n");
        final Font font1 = new Font();
        font1.setStyle(Font.BOLD);
        chunk1.setFont(font1);

        final Chunk chunk2 = new Chunk(String.format("%s\n%s\n%s", receipt.getName(), receipt.getRoverCrew(), receipt.getAddress()));
        final Font font2 = new Font();
        font2.setColor(Color.DARK_GRAY);
        chunk2.setFont(font2);

        final Paragraph paragraph = new Paragraph();
        paragraph.add(chunk1);
        paragraph.add(chunk2);
        paragraph.setAlignment(Paragraph.ALIGN_LEFT);

        return paragraph;
    }
	
	
	
    /**
     * Get the receipt details paragraph
     * @param receipt Receipt
     * @return Details paragraph
     */
    public Paragraph getDetails2(final Receipt receipt) {
        final Font font1 = new Font();
        font1.setStyle(Font.BOLD);

        final Font font2 = new Font();
        font2.setColor(Color.DARK_GRAY);

        final Paragraph paragraph = new Paragraph();
        paragraph.setAlignment(Paragraph.ALIGN_RIGHT);

        final Chunk chunk1 = new Chunk("Date: ");
        chunk1.setFont(font1);
        paragraph.add(chunk1);

        final Chunk chunk2 = new Chunk(String.format("%td %<tB %<tY", receipt.getDate()));
        chunk2.setFont(font2);
        paragraph.add(chunk2);

        final Chunk chunk3 = new Chunk("\n\nReceipt Number: ");
        chunk3.setFont(font1);
        paragraph.add(chunk3);

        final Chunk chunk4 = new Chunk(String.format("%05d", receipt.getReceiptNo()));
        chunk4.setFont(font2);
        paragraph.add(chunk4);

        final Chunk chunk5 = new Chunk("\nApplication Number: ");
        chunk5.setFont(font1);
        paragraph.add(chunk5);

        final Chunk chunk6 = new Chunk(String.format("%05d", receipt.getApplicationId()));
        chunk6.setFont(font2);
        paragraph.add(chunk6);

        return paragraph;
    }
	
	
	
    /**
     * Put the payments table into the document
     * @param document Document to use
     * @param receipt Receipt to use
     * @throws DocumentException
     */
    public void putTable(final Document document, final Receipt receipt) throws DocumentException {

        final float[] colsWidth = new float[]{1f,2f,1.3f,1.3f,1f};
        final PdfPTable table = new PdfPTable(colsWidth);
        table.setWidthPercentage(100);

        putHead(table);

        int total = 0, space = 12;
        for(Receipt.Line line: receipt.getLines()) {
            putRow(table, line);
            total += line.getAmount();
            space--;
        }

        putSpace(table, space);
        putFoot(table, total);
        document.add(table);

    }
	
	
	
    /**
     * Put the table head into the table
     * <p>
     * Layout:
     * <code>
     *  ________________________________________________________________
     * |      |             |                |                |        |
     * | Date | Description | Transaction No | Payment Method | Amount |
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

        final PdfPCell descriptionHead = new PdfPCell(new Paragraph("Description", font));
        descriptionHead.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
        descriptionHead.setBackgroundColor(Color.LIGHT_GRAY);
        table.addCell(descriptionHead);

        final PdfPCell transNoHead = new PdfPCell(new Paragraph("Transaction No", font));
        transNoHead.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
        transNoHead.setBackgroundColor(Color.LIGHT_GRAY);
        table.addCell(transNoHead);
        
        final PdfPCell methodHead = new PdfPCell(new Paragraph("Payment Method", font));
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
     * |{Date}|{Description}|{Transaction No}|{Payment Method}|{Amount}|
     * |......|.............|................|................|........|
     * |      |             |                |                |        |
     * </code>
     *
     * @param table Table to use
     * @param row Row to add
     */
    public void putRow(final PdfPTable table, final Receipt.Line line) {

        final PdfPCell dateCell = new PdfPCell(new Paragraph(String.format("%td/%<tm/%d", line.getDate(), YEAR[line.getDate().get(Calendar.MONTH)])));
        dateCell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
        dateCell.setBorderWidthBottom(0);
        dateCell.setBorderWidthTop(0);
        table.addCell(dateCell);

        final PdfPCell descriptionCell = new PdfPCell(new Paragraph(line.getDescription()));
        descriptionCell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
                descriptionCell.setBorderWidthBottom(0);
        descriptionCell.setBorderWidthTop(0);
        table.addCell(descriptionCell);

        final PdfPCell transactionNoCell = new PdfPCell(new Paragraph(String.format("%05d", line.getTrasactionNo())));
        transactionNoCell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
        transactionNoCell.setBorderWidthBottom(0);
        transactionNoCell.setBorderWidthTop(0);
        table.addCell(transactionNoCell);

        final PdfPCell paymentMethodCell = new PdfPCell(new Paragraph(line.getMethod()));
        paymentMethodCell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
        paymentMethodCell.setBorderWidthBottom(0);
        paymentMethodCell.setBorderWidthTop(0);
        table.addCell(paymentMethodCell);

        final PdfPCell amountCell = new PdfPCell(new Paragraph("$"+DisplayUtils.displayAmount(line.getAmount())));
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
     * .      .             .                |     Total      | Amount |
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

        final PdfPCell cell4 = new PdfPCell(new Paragraph("Total", font));
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
    public void putThanks(final Document document) throws DocumentException {

        final Chunk chunk = new Chunk("\nReceived with thanks");
        final Font font = new Font();
        font.setSize(20);
        font.setStyle(Font.BOLD);

        chunk.setFont(font);

        final Paragraph paragraph = new Paragraph(chunk);
        paragraph.setAlignment(Paragraph.ALIGN_CENTER);

        document.add(paragraph);
    }
	

}
