package vn.edu.nlu.fit.datxedulich.controller;

import vn.edu.nlu.fit.datxedulich.model.User;
import vn.edu.nlu.fit.datxedulich.services.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.Map;

@WebServlet(name = "LoginController", value = "/login")
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String loginError = request.getParameter("loginError");
        if (loginError != null) {
            request.setAttribute("loginError", loginError);
        }
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserService userService = new UserService();
        Map<String, Object> authResult = userService.authenticate(username, password);

        if ((Boolean) authResult.get("success")) {
            User user = (User) authResult.get("user");
            HttpSession session = request.getSession();
            session.setAttribute("account_id", user.getAccount_id());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("email", user.getEmail());
            session.setAttribute("full_name", user.getFull_name());
            session.setAttribute("role_id", user.getRole_id());
            session.setMaxInactiveInterval(30 * 60);

            response.sendRedirect(request.getContextPath() + "/index.jsp");

        } else {
            String errorMessage = URLEncoder.encode((String) authResult.get("message"), "UTF-8");
            response.sendRedirect(request.getContextPath() + "/login?loginError=" + errorMessage);
        }
    }
}