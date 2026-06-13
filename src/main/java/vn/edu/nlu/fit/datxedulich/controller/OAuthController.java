package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.nlu.fit.datxedulich.model.User;
import vn.edu.nlu.fit.datxedulich.services.UserService;
import vn.edu.nlu.fit.datxedulich.dao.CartDAO;
import vn.edu.nlu.fit.datxedulich.model.cart.Cart;
import vn.edu.nlu.fit.datxedulich.controller.ConfigLoader;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.regex.*;

@WebServlet(name = "OAuthController",
        urlPatterns = {"/oauth/google", "/oauth/google/callback",
                "/oauth/facebook", "/oauth/facebook/callback"})
public class OAuthController extends HttpServlet {

    private static final String GOOGLE_AUTH_URL = "https://accounts.google.com/o/oauth2/v2/auth";
    private static final String GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token";
    private static final String GOOGLE_USER_INFO_URL = "https://www.googleapis.com/oauth2/v3/userinfo";

    private static final String FACEBOOK_AUTH_URL = "https://www.facebook.com/v19.0/dialog/oauth";
    private static final String FACEBOOK_TOKEN_URL = "https://graph.facebook.com/v19.0/oauth/access_token";
    private static final String FACEBOOK_USER_INFO_URL = "https://graph.facebook.com/me?fields=id,name,email";

    private final UserService userService = new UserService();
    private final CartDAO cartDAO = new CartDAO();
    private static final int SESSION_TIMEOUT = 48 * 60;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/oauth/google".equals(path)) {
            handleGoogleAuth(request, response);
        } else if ("/oauth/google/callback".equals(path)) {
            handleGoogleCallback(request, response);
        } else if ("/oauth/facebook".equals(path)) {
            handleFacebookAuth(request, response);
        } else if ("/oauth/facebook/callback".equals(path)) {
            handleFacebookCallback(request, response);
        }
        System.out.println("🔍 User dir: " + System.getProperty("user.dir"));
        System.out.println("🔍 Project root: " + new File(".").getAbsolutePath());
        ConfigLoader.printLoadedKeys();
    }

    private void handleGoogleAuth(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String googleClientId = ConfigLoader.get("GOOGLE_CLIENT_ID");
        String googleRedirectUri = ConfigLoader.get("GOOGLE_REDIRECT_URI");

        if (googleClientId == null || googleClientId.startsWith("YOUR_")) {
            redirectWithError(request, response, "error",
                    "Google chưa được cấu hình");
            return;
        }

        String state = UUID.randomUUID().toString();
        request.getSession().setAttribute("google_oauth_state", state);

        String authUrl = GOOGLE_AUTH_URL
                + "?client_id=" + encode(googleClientId)
                + "&redirect_uri=" + encode(googleRedirectUri)
                + "&response_type=code"
                + "&scope=" + encode("openid email profile")
                + "&state=" + state
                + "&access_type=offline"
                + "&prompt=select_account";

        response.sendRedirect(authUrl);
    }

    private void handleGoogleCallback(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String code = request.getParameter("code");
        String state = request.getParameter("state");

        if (request.getParameter("error") != null) {
            redirectWithError(request, response, "oauthError",
                    "Google OAuth Error: " + request.getParameter("error_description"));
            return;
        }

        String savedState = (String) request.getSession().getAttribute("google_oauth_state");
        if (savedState == null || !savedState.equals(state)) {
            redirectWithError(request, response, "oauthError", "State không khớp (có thể là tấn công CSRF)");
            return;
        }

        try {
            String googleClientId = ConfigLoader.get("GOOGLE_CLIENT_ID");
            String googleClientSecret = ConfigLoader.get("GOOGLE_CLIENT_SECRET");
            String googleRedirectUri = ConfigLoader.get("GOOGLE_REDIRECT_URI");

            String tokenResponse = sendPost(GOOGLE_TOKEN_URL, ""
                    + "code=" + encode(code)
                    + "&client_id=" + encode(googleClientId)
                    + "&client_secret=" + encode(googleClientSecret)
                    + "&redirect_uri=" + encode(googleRedirectUri)
                    + "&grant_type=authorization_code");

            String accessToken = extractJsonValue(tokenResponse, "access_token");
            if (accessToken == null || accessToken.isEmpty()) {
                redirectWithError(request, response, "oauthError", "Không thể lấy access token từ Google");
                return;
            }

            String userInfoResponse = sendGet(GOOGLE_USER_INFO_URL + "?access_token=" + accessToken);
            String email = extractJsonValue(userInfoResponse, "email");
            String name = extractJsonValue(userInfoResponse, "name");
            String googleId = extractJsonValue(userInfoResponse, "sub");

            if (email == null || email.isEmpty()) {
                redirectWithError(request, response, "oauthError", "Không thể lấy email từ Google");
                return;
            }

            var result = userService.loginOrRegisterOAuth("google", googleId, email, name);
            if ((Boolean) result.get("success")) {
                User user = (User) result.get("user");
                setSessionAndRedirect(request, response, user);
            } else {
                redirectWithError(request, response, "oauthError", (String) result.get("message"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            redirectWithError(request, response, "oauthError", "Lỗi hệ thống: " + e.getMessage());
        }
    }

    private void handleFacebookAuth(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String facebookAppId = ConfigLoader.get("FACEBOOK_APP_ID");
        String facebookRedirectUri = ConfigLoader.get("FACEBOOK_REDIRECT_URI");

        if (facebookAppId == null || facebookAppId.startsWith("YOUR_")) {
            redirectWithError(request, response, "error",
                    "Facebook OAuth chưa được cấu hình. Vui lòng thiết lập FACEBOOK_APP_ID trong .env");
            return;
        }

        String state = UUID.randomUUID().toString();
        request.getSession().setAttribute("facebook_oauth_state", state);

        String authUrl = FACEBOOK_AUTH_URL
                + "?client_id=" + encode(facebookAppId)
                + "&redirect_uri=" + encode(facebookRedirectUri)
                + "&state=" + state
                + "&scope=" + encode("email public_profile")
                + "&response_type=code";

        response.sendRedirect(authUrl);
    }

    private void handleFacebookCallback(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String code = request.getParameter("code");
        String state = request.getParameter("state");

        if (request.getParameter("error") != null) {
            redirectWithError(request, response, "oauthError",
                    "Facebook OAuth Error: " + request.getParameter("error_description"));
            return;
        }

        String savedState = (String) request.getSession().getAttribute("facebook_oauth_state");
        if (savedState == null || !savedState.equals(state)) {
            redirectWithError(request, response, "oauthError", "State không khớp (có thể là tấn công CSRF)");
            return;
        }

        try {
            String facebookAppId = ConfigLoader.get("FACEBOOK_APP_ID");
            String facebookAppSecret = ConfigLoader.get("FACEBOOK_APP_SECRET");
            String facebookRedirectUri = ConfigLoader.get("FACEBOOK_REDIRECT_URI");

            String tokenResponse = sendGet(""
                    + FACEBOOK_TOKEN_URL
                    + "?client_id=" + encode(facebookAppId)
                    + "&client_secret=" + encode(facebookAppSecret)
                    + "&redirect_uri=" + encode(facebookRedirectUri)
                    + "&code=" + encode(code));

            String accessToken = extractJsonValue(tokenResponse, "access_token");
            if (accessToken == null || accessToken.isEmpty()) {
                redirectWithError(request, response, "oauthError", "Không thể lấy access token từ Facebook");
                return;
            }

            String userInfoResponse = sendGet(FACEBOOK_USER_INFO_URL
                    + "&access_token=" + encode(accessToken));
            String facebookId = extractJsonValue(userInfoResponse, "id");
            String email = extractJsonValue(userInfoResponse, "email");
            String name = extractJsonValue(userInfoResponse, "name");

            if (facebookId == null || facebookId.isEmpty()) {
                redirectWithError(request, response, "oauthError", "Không thể lấy Facebook ID");
                return;
            }

            if (email == null || email.isEmpty()) {
                email = "facebook_" + facebookId + "@autocars.vn";
            }

            var result = userService.loginOrRegisterOAuth("facebook", facebookId, email, name);
            if ((Boolean) result.get("success")) {
                User user = (User) result.get("user");
                setSessionAndRedirect(request, response, user);
            } else {
                redirectWithError(request, response, "oauthError", (String) result.get("message"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            redirectWithError(request, response, "oauthError", "Lỗi hệ thống: " + e.getMessage());
        }
    }

    private String sendGet(String url) throws IOException {
        HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Accept", "application/json");

        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                response.append(line);
            }
            return response.toString();
        }
    }

    private String sendPost(String url, String data) throws IOException {
        HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setRequestProperty("Accept", "application/json");
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(data.getBytes(StandardCharsets.UTF_8));
        }

        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                response.append(line);
            }
            return response.toString();
        }
    }

    private String extractJsonValue(String json, String key) {
        Pattern pattern = Pattern.compile("\"" + key + "\"\\s*:\\s*\"([^\"]*)\"");
        Matcher matcher = pattern.matcher(json);
        if (matcher.find()) {
            return matcher.group(1);
        }
        return null;
    }

    private String encode(String value) throws UnsupportedEncodingException {
        return URLEncoder.encode(value, "UTF-8");
    }

    private void redirectWithError(HttpServletRequest request, HttpServletResponse response,
                                   String paramName, String errorMessage) throws IOException {
        try {
            response.sendRedirect(request.getContextPath() + "/login?"
                    + paramName + "=" + URLEncoder.encode(errorMessage, "UTF-8"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    private void setSessionAndRedirect(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        HttpSession session = request.getSession();
        session.setAttribute("account_id", user.getAccount_id());
        session.setAttribute("username", user.getUsername());
        session.setAttribute("email", user.getEmail());
        session.setAttribute("full_name", user.getFull_name());
        session.setAttribute("role_id", user.getRole_id());
        session.setMaxInactiveInterval(SESSION_TIMEOUT * 60);

        try {
            Cart dbCart = cartDAO.loadCart(user.getAccount_id());
            if (dbCart != null && !dbCart.getItems().isEmpty()) {
                Cart sessionCart = (Cart) session.getAttribute("cart");
                if (sessionCart != null && !sessionCart.getItems().isEmpty()) {
                    for (var item : sessionCart.getItems()) {
                        dbCart.addItem(item.getProduct(), item.getQuantity());
                    }
                    cartDAO.saveCart(user.getAccount_id(), dbCart);
                }
                session.setAttribute("cart", dbCart);
            }
        } catch (Exception e) {
            System.err.println("Không thể load cart từ DB: " + e.getMessage());
        }

        System.out.println(" Đăng nhập thành công " + user.getUsername());
        response.sendRedirect(request.getContextPath() + "/index");
    }
}
