package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Cookie;
import vn.edu.nlu.fit.datxedulich.model.User;
import vn.edu.nlu.fit.datxedulich.services.UserService;
import java.io.IOException;
import java.net.URLEncoder;
import java.net.URLDecoder;
import java.security.MessageDigest;

@WebServlet(name = "LoginController", value = "/login")
public class LoginController extends HttpServlet {

    private final UserService userService = new UserService();
    private static final int SESSION_TIMEOUT = 48 * 60;
    private static final int COOKIE_MAX_AGE = 48 * 60 * 60;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String rememberMeCookie = getCookieValue(request, "rememberMe");
        if (rememberMeCookie != null && !rememberMeCookie.isEmpty()) {
            try {
                String decodedData = URLDecoder.decode(rememberMeCookie, "UTF-8");
                String[] parts = decodedData.split("\\|");

                if (parts.length == 2) {
                    String username = parts[0];
                    String password = parts[1];

                    var result = userService.authenticate(username, password);
                    if ((Boolean) result.get("success")) {
                        User user = (User) result.get("user");
                        setSessionAndRedirect(request, response, user);
                        return;
                    }
                }
            } catch (Exception e) {
                deleteCookie(response, "rememberMe");
                e.printStackTrace();
            }
        }
        String loginError = request.getParameter("loginError");
        if (loginError != null) {
            request.setAttribute("loginError", URLDecoder.decode(loginError, "UTF-8"));
        }

        String oauthError = request.getParameter("oauthError");
        if (oauthError != null) {
            request.setAttribute("oauthError", URLDecoder.decode(oauthError, "UTF-8"));
        }

        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        System.out.println(" Yêu cầu đăng nhập: " + username);

        var result = userService.authenticate(username, password);

        if ((Boolean) result.get("success")) {
            User user = (User) result.get("user");

            setSessionAndRedirect(request, response, user);

            if ("on".equals(rememberMe) || "true".equals(rememberMe)) {
                try {
                    String cookieData = username + "|" + password;
                    String encodedData = URLEncoder.encode(cookieData, "UTF-8");

                    Cookie rememberMeCookie = new Cookie("rememberMe", encodedData);
                    rememberMeCookie.setMaxAge(COOKIE_MAX_AGE);
                    rememberMeCookie.setPath("/");
                    rememberMeCookie.setHttpOnly(true);
                    rememberMeCookie.setSecure(false);
                    response.addCookie(rememberMeCookie);
                    System.out.println("✓ Đã lưu cookie 'Ghi nhớ đăng nhập'");
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        } else {
            String errorMessage = URLEncoder.encode((String) result.get("message"), "UTF-8");
            System.out.println(" Đăng nhập thất bại: " + result.get("message"));
            response.sendRedirect(request.getContextPath() + "/login?loginError=" + errorMessage);
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

        System.out.println("✓ Đăng nhập thành công! User: " + user.getUsername());
        response.sendRedirect(request.getContextPath() + "/index");
    }

    private String getCookieValue(HttpServletRequest request, String cookieName) {
        if (request.getCookies() != null) {
            for (Cookie cookie : request.getCookies()) {
                if (cookieName.equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

    private void deleteCookie(HttpServletResponse response, String cookieName) {
        Cookie cookie = new Cookie(cookieName, "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
    }
}
