
package common;

import application.Constants;
import redcloud.common.Mailer;

/**
 *
 * @author alexanderw
 */
public class EmailTest {

    public static void main(String[] args) {
        Mailer mailer = new Mailer();
        boolean open = mailer.openSSLConnection(Constants.MAIL_SERVER, Constants.MAIL_USER, Constants.MAIL_PASSWORD, Constants.MAIL_PORT);
        if(open) {
            String body = "Hi Alex,<br>"
                    + "<br>"
                    + "Please click one of the below buttons:<br>"
                    + "<button>Yes</button><button>Maybe</button><button>No</button><br>"
                    + "<br>"
                    + "Thanks,<br>"
                    + "Alex";

            mailer.sendHtmlMessage(Constants.MAIL_USER, Constants.MAIL_REPLY_TO, "alexanderwnz@gmail.com", "Button Test Email", body);
            mailer.closeConnection();
        } else {
            System.err.println(mailer.getErrorMsg());
            System.err.println("Error: Not Sent");
        }
    }
}
