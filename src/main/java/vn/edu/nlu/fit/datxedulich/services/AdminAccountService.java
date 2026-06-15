package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.dao.AdminAccountDAO;
import vn.edu.nlu.fit.datxedulich.model.User;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Service xử lý nghiệp vụ quản lý tài khoản quản trị (Super Admin / Admin).
 * Chức năng này CHỈ dành cho Super Admin (role_id = 0).
 */
public class AdminAccountService {

    private final AdminAccountDAO adminAccountDAO = new AdminAccountDAO();
    private final UserService userService = new UserService();

    public List<User> getAllAdmins() {
        return adminAccountDAO.getAllAdmins();
    }

    public User getAdminById(int accountId) {
        return adminAccountDAO.getAdminById(accountId);
    }

    public int countSuperAdmins() {
        return adminAccountDAO.countSuperAdmins();
    }

    // Tạo tài khoản quản trị mới (Super Admin hoặc Admin)
    public Map<String, Object> createAdmin(String username, String email, String password,
                                           String fullName, String phone, Integer roleId) {
        Map<String, Object> result = new HashMap<>();

        if (isBlank(username) || isBlank(email) || isBlank(password) || isBlank(fullName)) {
            return fail(result, "Vui lòng điền đầy đủ các trường bắt buộc.");
        }
        if (roleId == null || (roleId != 0 && roleId != 1)) {
            return fail(result, "Vai trò không hợp lệ.");
        }
        if (password.length() < 6) {
            return fail(result, "Mật khẩu phải có ít nhất 6 ký tự.");
        }
        if (adminAccountDAO.isUsernameExists(username)) {
            return fail(result, "Tên đăng nhập đã tồn tại.");
        }
        if (adminAccountDAO.isEmailExists(email)) {
            return fail(result, "Email đã được sử dụng.");
        }

        User user = new User();
        user.setUsername(username.trim());
        user.setEmail(email.trim());
        user.setPassword_hash(userService.hashPassword(password));
        user.setRole_id(roleId);
        user.setFull_name(fullName.trim());
        user.setPhone(phone);
        user.setIs_active(true);

        boolean ok = adminAccountDAO.createAdmin(user);
        result.put("success", ok);
        result.put("message", ok ? "Tạo tài khoản quản trị thành công!" : "Tạo tài khoản thất bại!");
        return result;
    }

    // Cập nhật thông tin tài khoản quản trị (và đổi mật khẩu nếu có nhập mật khẩu mới)
    public Map<String, Object> updateAdmin(int accountId, String email, String fullName, String phone,
                                           Integer roleId, boolean isActive, String newPassword) {
        Map<String, Object> result = new HashMap<>();

        if (isBlank(email) || isBlank(fullName)) {
            return fail(result, "Vui lòng điền đầy đủ các trường bắt buộc.");
        }
        if (roleId == null || (roleId != 0 && roleId != 1)) {
            return fail(result, "Vai trò không hợp lệ.");
        }

        User existing = adminAccountDAO.getAdminById(accountId);
        if (existing == null) {
            return fail(result, "Không tìm thấy tài khoản quản trị.");
        }

        // Không cho nâng quyền Admin lên Super Admin (chỉ tài khoản Super Admin có sẵn mới giữ được quyền này)
        if (existing.getRole_id() != 0 && roleId == 0) {
            return fail(result, "Không thể nâng quyền tài khoản Admin lên Super Admin.");
        }

        // Không cho hạ quyền hoặc khóa Super Admin cuối cùng của hệ thống
        boolean demoting = existing.getRole_id() == 0 && (roleId != 0 || !isActive);
        if (demoting && adminAccountDAO.countSuperAdmins() <= 1) {
            return fail(result, "Không thể hạ quyền hoặc khóa Super Admin cuối cùng của hệ thống.");
        }

        User user = new User();
        user.setAccount_id(accountId);
        user.setEmail(email.trim());
        user.setFull_name(fullName.trim());
        user.setPhone(phone);
        user.setRole_id(roleId);
        user.setIs_active(isActive);

        boolean ok = adminAccountDAO.updateAdmin(user);

        if (ok && !isBlank(newPassword)) {
            if (newPassword.length() < 6) {
                result.put("success", true);
                result.put("message", "Cập nhật tài khoản thành công, nhưng mật khẩu mới quá ngắn (tối thiểu 6 ký tự) nên chưa được thay đổi.");
                return result;
            }
            adminAccountDAO.updatePassword(accountId, userService.hashPassword(newPassword));
        }

        result.put("success", ok);
        result.put("message", ok ? "Cập nhật tài khoản thành công!" : "Cập nhật thất bại!");
        return result;
    }

    // Khóa / mở khóa tài khoản quản trị
    public Map<String, Object> toggleStatus(int accountId, boolean lock, int currentAccountId) {
        Map<String, Object> result = new HashMap<>();

        if (accountId == currentAccountId) {
            return fail(result, "Không thể tự khóa tài khoản đang đăng nhập.");
        }

        User existing = adminAccountDAO.getAdminById(accountId);
        if (existing == null) {
            return fail(result, "Không tìm thấy tài khoản quản trị.");
        }
        if (existing.getRole_id() == 0 && lock && adminAccountDAO.countSuperAdmins() <= 1) {
            return fail(result, "Không thể khóa Super Admin cuối cùng của hệ thống.");
        }

        boolean ok = adminAccountDAO.toggleStatus(accountId, !lock);
        result.put("success", ok);
        result.put("message", ok
                ? (lock ? "Đã khóa tài khoản." : "Đã mở khóa tài khoản.")
                : "Cập nhật trạng thái thất bại!");
        return result;
    }

    // Xóa tài khoản quản trị
    public Map<String, Object> deleteAdmin(int accountId, int currentAccountId) {
        Map<String, Object> result = new HashMap<>();

        if (accountId == currentAccountId) {
            return fail(result, "Không thể tự xóa tài khoản đang đăng nhập.");
        }

        User existing = adminAccountDAO.getAdminById(accountId);
        if (existing == null) {
            return fail(result, "Không tìm thấy tài khoản quản trị.");
        }
        if (existing.getRole_id() == 0 && adminAccountDAO.countSuperAdmins() <= 1) {
            return fail(result, "Không thể xóa Super Admin cuối cùng của hệ thống.");
        }

        boolean ok = adminAccountDAO.deleteAdmin(accountId);
        result.put("success", ok);
        result.put("message", ok ? "Đã xóa tài khoản quản trị." : "Xóa thất bại!");
        return result;
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    private Map<String, Object> fail(Map<String, Object> result, String message) {
        result.put("success", false);
        result.put("message", message);
        return result;
    }
}