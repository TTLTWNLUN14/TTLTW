package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "LogoutController", value = "/logout")
public class LogoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session != null) {
            session.removeAttribute("account_id");
            session.removeAttribute("username");
            session.removeAttribute("email");
            session.removeAttribute("full_name");
            session.removeAttribute("role_id");
            session.invalidate();
        }

        Cookie rememberMeCookie = new Cookie("rememberMe", "");
        rememberMeCookie.setMaxAge(0);
        rememberMeCookie.setPath("/");
        response.addCookie(rememberMeCookie);

        response.sendRedirect(request.getContextPath() + "/index.jsp");

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}