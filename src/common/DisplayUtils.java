
package common;


public abstract class DisplayUtils {

    public static String displayAmount(int amount) {
        if(0 == amount) return "0";
        return String.format("%d.%02d", amount/100, amount%100);
    }

    public static int parseAmount(String str) {
        if(str.contains(".")) {
            String[] parts = str.split("\\.");
            return Integer.parseInt(parts[0])*100 + Integer.parseInt(parts[1]);
        } else {
            return Integer.parseInt(str)*100;
        }
    }
}
