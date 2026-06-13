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
        "/cars-admin/edit"
})
public class AdminFilterController implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  httpRequest  = (HttpServletRequest)  request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // chưa đăng nhập -> về login
        if (session == null || session.getAttribute("account_id") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        // check superadmin = 0 admin =1
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

        chain.doFilter(request, response);
    }

}