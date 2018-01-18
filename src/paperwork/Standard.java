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

import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.Image;
import com.lowagie.text.Paragraph;
import java.awt.Color;
import java.io.IOException;

public abstract class Standard {

    public static final String IMAGE_DIR = "/moot/images/";

    /**
     * Put the images into the document
     * @param document Document to use
     * @throws DocumentException
     */
    protected static void putImages(final Document document) throws DocumentException {
        try {
            final Image banner = Image.getInstance(IMAGE_DIR+"banner.png");
            banner.scaleToFit(524, 100);
            document.add(banner);

            final Image footer = Image.getInstance(IMAGE_DIR+"footer.png");
            footer.scaleToFit(524, 100);
            footer.setAbsolutePosition(36, 40);
            document.add(footer);

            final Image watermark = Image.getInstance(IMAGE_DIR+"watermark.png");
            watermark.scaleToFit(524, 600);
            watermark.setAbsolutePosition(36, 200);
            document.add(watermark);

            }  catch (IOException ex) {
                ex.printStackTrace();
                System.out.println("IOException: "+ex.getMessage());
            }
    }



    /**
     * Put office info into the document
     * @param document Document to use
     * @throws DocumentException
     */
    protected static void putOfficeInfo(final Document document) throws DocumentException {
        final Chunk chunk = new Chunk(
        "PO Box 1286\n" +
        "Hamilton 3240\n" +
        "www.sm69thmoot.com");

        final Font font = new Font();
        font.setColor(Color.LIGHT_GRAY);
        chunk.setFont(font);

        final Paragraph paragraph = new Paragraph(chunk);
        paragraph.setAlignment(Paragraph.ALIGN_RIGHT);
        document.add(paragraph);
    }



    /**
     * Put the title into the document
     * @param document Document to use
     * @param title Title to put
     * @throws DocumentException
     */
    protected static void putTitle(final Document document, final String title) throws DocumentException {
        final Chunk chunk = new Chunk(title);

        final Font font = new Font();
        font.setSize(20);
        font.setStyle(Font.BOLD);
        chunk.setFont(font);

        final Paragraph paragraph = new Paragraph(chunk);
        paragraph.setAlignment(Paragraph.ALIGN_LEFT);
        document.add(paragraph);
    }



    /**
     * Put the gst number into the document
     * @param document Document to use
     * @throws DocumentException
     */
    protected static void putGstNum(final Document document) throws DocumentException {
        final Chunk chunk = new Chunk("GST No: 10-149-134\n\n");

        final Font font = new Font();
        font.setStyle(Font.BOLD);
        chunk.setFont(font);

        final Paragraph paragraph = new Paragraph(chunk);
        paragraph.setAlignment(Paragraph.ALIGN_RIGHT);
        document.add(paragraph);
    }
}
