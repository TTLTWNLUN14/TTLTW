package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.nlu.fit.datxedulich.model.User;
import vn.edu.nlu.fit.datxedulich.services.UserService;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.regex.*;

@WebServlet(name = "OAuthController",
        urlPatterns = {"/oauth/google", "/oauth/google/callback",
                "/oauth/facebook", "/oauth/facebook/callback"})
public class OAuthController extends HttpServlet {

    private static final String GOOGLE_CLIENT_ID = "YOUR_GOOGLE_CLIENT_ID";
    private static final String GOOGLE_CLIENT_SECRET = "YOUR_GOOGLE_CLIENT_SECRET";
    private static final String GOOGLE_REDIRECT_URI = "http://localhost:8080/AutoCars/oauth/google/callback";
    private static final String GOOGLE_AUTH_URL = "https://accounts.google.com/o/oauth2/v2/auth";
    private static final String GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token";
    private static final String GOOGLE_USER_INFO_URL = "https://www.googleapis.com/oauth2/v3/userinfo";

    private static final String FACEBOOK_APP_ID = "YOUR_FACEBOOK_APP_ID";
    private static final String FACEBOOK_APP_SECRET = "YOUR_FACEBOOK_APP_SECRET";
    private static final String FACEBOOK_REDIRECT_URI = "http://localhost:8080/AutoCars/oauth/facebook/callback";
    private static final String FACEBOOK_AUTH_URL = "https://www.facebook.com/v19.0/dialog/oauth";
    private static final String FACEBOOK_TOKEN_URL = "https://graph.facebook.com/v19.0/oauth/access_token";
    private static final String FACEBOOK_USER_INFO_URL = "https://graph.facebook.com/me?fields=id,name,email";

    private final UserService userService = new UserService();

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
    }

    private void handleGoogleAuth(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (GOOGLE_CLIENT_ID.startsWith("YOUR_")) {
            redirectWithError(request, response,
                    "Google OAuth chưa được cấu hình. Vui lòng cập nhật GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET trong OAuthController.java");
            return;
        }

        String state = UUID.randomUUID().toString();
        request.getSession().setAttribute("google_oauth_state", state);

        String authUrl = GOOGLE_AUTH_URL
                + "?client_id=" + encode(GOOGLE_CLIENT_ID)
                + "&redirect_uri=" + encode(GOOGLE_REDIRECT_URI)
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
            redirectWithError(request, response, "Đăng nhập Google bị huỷ.");
            return;
        }

        HttpSession session = request.getSession();
        String savedState = (String) session.getAttribute("google_oauth_state");
        if (savedState == null || !savedState.equals(state)) {
            redirectWithError(request, response, "Yêu cầu không hợp lệ (state mismatch).");
            return;
        }
        session.removeAttribute("google_oauth_state");

        try {
            String tokenResponse = postRequest(GOOGLE_TOKEN_URL,
                    "code=" + encode(code)
                            + "&client_id=" + encode(GOOGLE_CLIENT_ID)
                            + "&client_secret=" + encode(GOOGLE_CLIENT_SECRET)
                            + "&redirect_uri=" + encode(GOOGLE_REDIRECT_URI)
                            + "&grant_type=authorization_code");

            String accessToken = extractField(tokenResponse, "access_token");
            if (accessToken == null || accessToken.isEmpty()) {
                redirectWithError(request, response, "Không lấy được access_token từ Google.");
                return;
            }

            String userInfo = getRequestWithBearer(GOOGLE_USER_INFO_URL, accessToken);
            String googleId = extractField(userInfo, "sub");
            String email = extractField(userInfo, "email");
            String name = extractField(userInfo, "name");

            if (email == null || email.isEmpty()) {
                redirectWithError(request, response,
                        "Google không trả về email. Kiểm tra lại phạm vi quyền.");
                return;
            }

            Map<String, Object> result = userService.loginOrRegisterOAuth(
                    "google", googleId != null ? googleId : "", email, name);

            if (!(Boolean) result.get("success")) {
                redirectWithError(request, response, (String) result.get("message"));
                return;
            }
            applySession(session, (User) result.get("user"));
            response.sendRedirect(request.getContextPath() + "/index");

        } catch (Exception e) {
            e.printStackTrace();
            redirectWithError(request, response, "Lỗi đăng nhập Google: " + e.getMessage());
        }
    }

    private void handleFacebookAuth(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (FACEBOOK_APP_ID.startsWith("YOUR_")) {
            redirectWithError(request, response,
                    "Facebook OAuth chưa được cấu hình");
            return;
        }

        String state = UUID.randomUUID().toString();
        request.getSession().setAttribute("facebook_oauth_state", state);

        String authUrl = FACEBOOK_AUTH_URL
                + "?client_id=" + encode(FACEBOOK_APP_ID)
                + "&redirect_uri=" + encode(FACEBOOK_REDIRECT_URI)
                + "&scope=" + encode("email,public_profile")
                + "&state=" + state
                + "&response_type=code";

        response.sendRedirect(authUrl);
    }

    private void handleFacebookCallback(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String code = request.getParameter("code");
        String state = request.getParameter("state");

        if (request.getParameter("error") != null) {
            redirectWithError(request, response, "Đăng nhập Facebook bị huỷ.");
            return;
        }

        HttpSession session = request.getSession();
        String savedState = (String) session.getAttribute("facebook_oauth_state");
        if (savedState == null || !savedState.equals(state)) {
            redirectWithError(request, response, "Yêu cầu không hợp lệ (state mismatch).");
            return;
        }
        session.removeAttribute("facebook_oauth_state");

        try {
            String tokenResponse = getRequest(FACEBOOK_TOKEN_URL
                    + "?client_id=" + encode(FACEBOOK_APP_ID)
                    + "&client_secret=" + encode(FACEBOOK_APP_SECRET)
                    + "&redirect_uri=" + encode(FACEBOOK_REDIRECT_URI)
                    + "&code=" + encode(code));

            String accessToken = extractField(tokenResponse, "access_token");
            if (accessToken == null || accessToken.isEmpty()) {
                redirectWithError(request, response, "Không lấy được token từ Facebook.");
                return;
            }

            String userInfo = getRequest(FACEBOOK_USER_INFO_URL + "&access_token=" + encode(accessToken));
            String facebookId = extractField(userInfo, "id");
            String email = extractField(userInfo, "email");
            String name = extractField(userInfo, "name");

            if (email == null || email.isEmpty()) {
                email = "fb_" + facebookId + "@facebook-noemail.com";
            }

            Map<String, Object> result = userService.loginOrRegisterOAuth(
                    "facebook", facebookId != null ? facebookId : "", email, name);

            if (!(Boolean) result.get("success")) {
                redirectWithError(request, response, (String) result.get("message"));
                return;
            }

            applySession(session, (User) result.get("user"));
            response.sendRedirect(request.getContextPath() + "/index");

        } catch (Exception e) {
            e.printStackTrace();
            redirectWithError(request, response, "Lỗi đăng nhập Facebook: " + e.getMessage());
        }
    }

    private String getRequest(String url) throws IOException {
        HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(10000);
        conn.setReadTimeout(10000);
        return readResponse(conn);
    }

    private String getRequestWithBearer(String url, String token) throws IOException {
        HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(10000);
        conn.setReadTimeout(10000);
        conn.setRequestProperty("Authorization", "Bearer " + token);
        return readResponse(conn);
    }

    private String postRequest(String url, String body) throws IOException {
        HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setConnectTimeout(10000);
        conn.setReadTimeout(10000);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

        try (OutputStream os = conn.getOutputStream()) {
            os.write(body.getBytes(StandardCharsets.UTF_8));
        }
        return readResponse(conn);
    }

    private String readResponse(HttpURLConnection conn) throws IOException {
        int code = conn.getResponseCode();
        InputStream is = (code >= 200 && code < 300) ? conn.getInputStream() : conn.getErrorStream();

        try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            return sb.toString();
        }
    }

    private String extractField(String json, String fieldName) {
        if (json == null || fieldName == null) return null;

        try {
            Pattern pattern = Pattern.compile("\"" + Pattern.quote(fieldName) + "\"\\s*:\\s*\"((?:[^\"\\\\]|\\\\.)*)\"");
            Matcher matcher = pattern.matcher(json);

            if (matcher.find()) {
                String value = matcher.group(1);
                return value.replace("\\\"", "\"")
                        .replace("\\\\", "\\")
                        .replace("\\/", "/")
                        .replace("\\n", "\n")
                        .replace("\\r", "\r")
                        .replace("\\t", "\t");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    private String encode(String str) throws UnsupportedEncodingException {
        return URLEncoder.encode(str, "UTF-8");
    }

    private void applySession(HttpSession session, User user) {
        session.setAttribute("account_id", user.getAccount_id());
        session.setAttribute("username", user.getUsername());
        session.setAttribute("email", user.getEmail());
        session.setAttribute("full_name", user.getFull_name());
        session.setAttribute("role_id", user.getRole_id());
        session.setMaxInactiveInterval(48 * 60 * 60);
    }

    private void redirectWithError(HttpServletRequest request, HttpServletResponse response, String message)
            throws IOException {
        request.getSession().setAttribute("oauthError", message);
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
