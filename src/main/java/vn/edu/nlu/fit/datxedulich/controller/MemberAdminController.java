package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.MemberAdmin;
import vn.edu.nlu.fit.datxedulich.services.MemberAdminService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "MemberAdminController", value = "/admin/members")
public class MemberAdminController extends HttpServlet {

    private final MemberAdminService service = new MemberAdminService();

    private boolean isAdmin(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        Integer roleId = (Integer) session.getAttribute("role_id");
        if (roleId == null || roleId != 3) {
            res.sendRedirect(req.getContextPath() + "/index.jsp");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        if (!isAdmin(req, res)) return;

        List<MemberAdmin> members = service.getAllMembers();
        req.setAttribute("members", members);
        req.setAttribute("totalMembers", service.countAllMembers());

        String editId = req.getParameter("editId");
        if (editId != null && !editId.isBlank()) {
            try {
                MemberAdmin editing = service.getMemberById(Integer.parseInt(editId));
                req.setAttribute("editingMember", editing);
            } catch (NumberFormatException ignored) {}
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/member-admin.jsp")
           .forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        if (!isAdmin(req, res)) return;

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        try {
            if ("update".equals(action)) {
                int customerId = Integer.parseInt(req.getParameter("customerId"));
                String memberTier = req.getParameter("memberTier");
                int points = Integer.parseInt(req.getParameter("points"));

                boolean ok = service.updateMember(customerId, memberTier, points);
                req.getSession().setAttribute(
                    "flashMsg", ok ? "Cập nhật thành viên thành công!" : "Cập nhật thất bại!"
                );
                req.getSession().setAttribute("flashType", ok ? "success" : "error");

            } else if ("toggleStatus".equals(action)) {
                int customerId = Integer.parseInt(req.getParameter("customerId"));
                boolean lock   = "true".equals(req.getParameter("lock"));

                boolean ok = service.toggleStatus(customerId, lock);
                String msg = lock
                    ? (ok ? "Đã khóa tài khoản thành viên." : "Khóa tài khoản thất bại!")
                    : (ok ? "Đã mở khóa tài khoản thành viên." : "Mở khóa thất bại!");
                req.getSession().setAttribute("flashMsg",  msg);
                req.getSession().setAttribute("flashType", ok ? "success" : "error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("flashMsg",  "Lỗi hệ thống: " + e.getMessage());
            req.getSession().setAttribute("flashType", "error");
        }

        res.sendRedirect(req.getContextPath() + "/admin/members");
    }
}
