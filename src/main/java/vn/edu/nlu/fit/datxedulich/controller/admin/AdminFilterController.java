package vn.edu.nlu.fit.datxedulich.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {
        "/brand-admin",
        "/add-brand",
        "/edit-brand",
        "/cars-admin",
        "/cars-admin/*"
})
public class AdminFilterController implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  httpRequest  = (HttpServletRequest)  request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // Chưa đăng nhập → về trang login
        if (session == null || session.getAttribute("account_id") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        // Đã đăng nhập nhưng không phải admin → về trang chủ
        String role = (String) session.getAttribute("role");
        if (!"admin".equals(role)) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/home");
            return;
        }

        chain.doFilter(request, response);
    }

}