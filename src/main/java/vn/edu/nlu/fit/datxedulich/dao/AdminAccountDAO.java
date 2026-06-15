package vn.edu.nlu.fit.datxedulich.dao;

import vn.edu.nlu.fit.datxedulich.model.User;

import java.util.List;

/**
 * DAO quản lý các tài khoản quản trị hệ thống (Super Admin: role_id = 0, Admin: role_id = 1).
 * Chỉ Super Admin mới được phép sử dụng các thao tác trong DAO này (kiểm tra ở Controller).
 */
public class AdminAccountDAO extends BaseDao {

    // Lấy toàn bộ tài khoản quản trị (Super Admin + Admin)
    public List<User> getAllAdmins() {
        return get().withHandle(h -> h.createQuery(
                        "SELECT * FROM accounts WHERE role_id IN (0,1) ORDER BY role_id ASC, account_id ASC")
                .mapToBean(User.class)
                .list());
    }

    public User getAdminById(int accountId) {
        return get().withHandle(h -> h.createQuery(
                        "SELECT * FROM accounts WHERE account_id = :id AND role_id IN (0,1)")
                .bind("id", accountId)
                .mapToBean(User.class)
                .findFirst()
                .orElse(null));
    }

    public boolean createAdmin(User user) {
        try {
            int rows = get().withHandle(h -> h.createUpdate(
                            "INSERT INTO accounts (email, username, password_hash, role_id, full_name, phone, is_active, first_login) " +
                                    "VALUES (:email, :username, :password_hash, :role_id, :full_name, :phone, :is_active, NOW())")
                    .bindBean(user)
                    .execute());
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateAdmin(User user) {
        try {
            int rows = get().withHandle(h -> h.createUpdate(
                            "UPDATE accounts SET email = :email, full_name = :full_name, phone = :phone, " +
                                    "role_id = :role_id, is_active = :is_active " +
                                    "WHERE account_id = :account_id AND role_id IN (0,1)")
                    .bindBean(user)
                    .execute());
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updatePassword(int accountId, String hashedPassword) {
        try {
            int rows = get().withHandle(h -> h.createUpdate(
                            "UPDATE accounts SET password_hash = :pwd WHERE account_id = :id AND role_id IN (0,1)")
                    .bind("pwd", hashedPassword)
                    .bind("id", accountId)
                    .execute());
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean toggleStatus(int accountId, boolean isActive) {
        try {
            int rows = get().withHandle(h -> h.createUpdate(
                            "UPDATE accounts SET is_active = :active WHERE account_id = :id AND role_id IN (0,1)")
                    .bind("active", isActive)
                    .bind("id", accountId)
                    .execute());
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteAdmin(int accountId) {
        try {
            int rows = get().withHandle(h -> h.createUpdate(
                            "DELETE FROM accounts WHERE account_id = :id AND role_id IN (0,1)")
                    .bind("id", accountId)
                    .execute());
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Tổng số Super Admin hiện có trong hệ thống (dùng để chặn xóa/hạ quyền Super Admin cuối cùng)
    public int countSuperAdmins() {
        return get().withHandle(h -> h.createQuery(
                        "SELECT COUNT(*) FROM accounts WHERE role_id = 0")
                .mapTo(Integer.class)
                .one());
    }

    public boolean isUsernameExists(String username) {
        return get().withHandle(h -> h.createQuery(
                        "SELECT COUNT(*) FROM accounts WHERE username = :username")
                .bind("username", username)
                .mapTo(Integer.class)
                .one()) > 0;
    }

    public boolean isEmailExists(String email) {
        return get().withHandle(h -> h.createQuery(
                        "SELECT COUNT(*) FROM accounts WHERE email = :email")
                .bind("email", email)
                .mapTo(Integer.class)
                .one()) > 0;
    }
}