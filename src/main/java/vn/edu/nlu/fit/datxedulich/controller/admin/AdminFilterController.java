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
        "/cars-admin/add",
        "/cars-admin/edit",
        "/booking-admin",
        "/admin/settings"
})
public class AdminFilterController implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // chưa đăng nhập -> về login
        if (session == null || session.getAttribute("account_id") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        Object roleObj = session.getAttribute("role_id");
        if (roleObj == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        int roleId = (Integer) roleObj;
        if (roleId > 1) {
            // không phải admin -> về index
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/index");
            return;
        }

        String requestURI = httpRequest.getRequestURI();
        if (requestURI.endsWith("/admin/settings")) {
            if (roleId != 0) {
                // Nếu là Admin thường (role_id == 1), thông báo lỗi và đẩy về dashboard
                session.setAttribute("flashMsg", "Bạn không có quyền truy cập chức năng này. Chỉ Super Admin mới được phép quản lý tài khoản quản trị.");
                session.setAttribute("flashType", "error");
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/admin/dashboard");
                return;
            }
        }
        chain.doFilter(request, response);
    }
}