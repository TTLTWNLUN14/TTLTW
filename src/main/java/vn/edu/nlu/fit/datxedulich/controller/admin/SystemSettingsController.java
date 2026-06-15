package vn.edu.nlu.fit.datxedulich.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import vn.edu.nlu.fit.datxedulich.model.User;
import vn.edu.nlu.fit.datxedulich.services.AdminAccountService;

import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Quản lý tài khoản quản trị (Super Admin / Admin) - Cài đặt hệ thống.
 * CHỈ Super Admin (role_id = 0) mới được truy cập chức năng này.
 * Admin thông thường (role_id = 1) sẽ bị chuyển hướng về Dashboard.
 */
@WebServlet(name = "SystemSettingsController", value = "/admin/settings")
public class SystemSettingsController extends HttpServlet {

    private final AdminAccountService service = new AdminAccountService();

    // role_id của Super Admin
    private static final int ROLE_SUPER_ADMIN = 0;

    /**
     * Kiểm tra quyền truy cập: phải đăng nhập VÀ là Super Admin (role_id = 0).
     * Admin thông thường (role_id = 1) hoặc chưa đăng nhập sẽ bị từ chối.
     */
    private boolean checkSuperAdmin(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("account_id") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return false;
        }

        Object roleObj = session.getAttribute("role_id");
        if (roleObj == null || !(roleObj instanceof Integer) || (Integer) roleObj != ROLE_SUPER_ADMIN) {
            // Đăng nhập rồi nhưng không phải Super Admin -> không có quyền, đưa về Dashboard
            session.setAttribute("flashMsg", "Bạn không có quyền truy cập chức năng này. Chỉ Super Admin mới được phép quản lý tài khoản quản trị.");
            session.setAttribute("flashType", "error");
            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return false;
        }

        return true;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        if (!checkSuperAdmin(req, res)) return;

        HttpSession session = req.getSession();
        String flashMsg = (String) session.getAttribute("flashMsg");
        String flashType = (String) session.getAttribute("flashType");
        session.removeAttribute("flashMsg");
        session.removeAttribute("flashType");

        List<User> admins = service.getAllAdmins();
        req.setAttribute("admins", admins);
        req.setAttribute("totalAdmins", admins.size());
        req.setAttribute("totalSuperAdmins", service.countSuperAdmins());
        req.setAttribute("flashMsg", flashMsg);
        req.setAttribute("flashType", flashType);

        String editId = req.getParameter("editId");
        if (editId != null && !editId.isBlank()) {
            try {
                User editing = service.getAdminById(Integer.parseInt(editId));
                req.setAttribute("editingAdmin", editing);
            } catch (NumberFormatException ignored) {
            }
        }

        req.getRequestDispatcher("/WEB-INF/views/settings-admin.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        if (!checkSuperAdmin(req, res)) return;

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        int currentAccountId = (Integer) session.getAttribute("account_id");
        String action = req.getParameter("action");

        try {
            Map<String, Object> result;

            switch (action == null ? "" : action) {

                case "create" -> {
                    String username = req.getParameter("username");
                    String email = req.getParameter("email");
                    String password = req.getParameter("password");
                    String fullName = req.getParameter("fullName");
                    String phone = req.getParameter("phone");

                    // Super Admin chỉ được phép tạo tài khoản Admin (role_id = 1),
                    // KHÔNG được tạo thêm Super Admin mới.
                    result = service.createAdmin(username, email, password, fullName, phone, 1);
                }

                case "update" -> {
                    int accountId = Integer.parseInt(req.getParameter("accountId"));
                    String email = req.getParameter("email");
                    String fullName = req.getParameter("fullName");
                    String phone = req.getParameter("phone");
                    Integer roleId = parseIntOrNull(req.getParameter("roleId"));
                    boolean isActive = "true".equals(req.getParameter("isActive"));
                    String newPassword = req.getParameter("newPassword");

                    result = service.updateAdmin(accountId, email, fullName, phone, roleId, isActive, newPassword);
                }

                case "toggleStatus" -> {
                    int accountId = Integer.parseInt(req.getParameter("accountId"));
                    boolean lock = "true".equals(req.getParameter("lock"));

                    result = service.toggleStatus(accountId, lock, currentAccountId);
                }

                case "delete" -> {
                    int accountId = Integer.parseInt(req.getParameter("accountId"));
                    result = service.deleteAdmin(accountId, currentAccountId);
                }

                default -> {
                    result = Map.of("success", false, "message", "Hành động không hợp lệ.");
                }
            }

            session.setAttribute("flashMsg", result.get("message"));
            session.setAttribute("flashType", Boolean.TRUE.equals(result.get("success")) ? "success" : "error");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flashMsg", "Lỗi hệ thống: " + e.getMessage());
            session.setAttribute("flashType", "error");
        }

        res.sendRedirect(req.getContextPath() + "/admin/settings");
    }

    private Integer parseIntOrNull(String s) {
        if (s == null || s.isBlank()) return null;
        try {
            return Integer.parseInt(s.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}