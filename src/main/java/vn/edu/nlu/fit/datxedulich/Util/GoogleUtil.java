public class GoogleUtils {

    private static final String CLIENT_ID = "YOUR_CLIENT_ID";
    private static final String CLIENT_SECRET = "YOUR_CLIENT_SECRET";
    private static final String REDIRECT_URI = "http://localhost:8080/YourApp/login-google-callback";


    public static String getToken(String code) { ... }


    public static GooglePojo getUserInfo(String accessToken) { ... }
}