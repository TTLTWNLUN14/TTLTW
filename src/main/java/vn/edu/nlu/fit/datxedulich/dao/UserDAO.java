package vn.edu.nlu.fit.datxedulich.dao;

import vn.edu.nlu.fit.datxedulich.model.User;
import java.util.List;

public class UserDAO extends BaseDao {

    public User findByUsername(String username) {
        try {
            return get().withHandle(h ->
                    h.createQuery("SELECT * FROM accounts WHERE username = :username").bind("username", username).mapToBean(User.class).findFirst().orElse(null)
            );
        } catch (Exception e) {
            System.err.println("Lỗi khi tìm người dùng bằng username: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public User findByEmail(String email) {
        try {
            return get().withHandle(h ->
                    h.createQuery("SELECT * FROM accounts WHERE email = :email").bind("email", email).mapToBean(User.class).findFirst().orElse(null)
            );
        } catch (Exception e) {
            System.err.println("Lỗi khi tìm người dùng bằng email: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public User findById(int accountId) {
        try {
            return get().withHandle(h ->
                    h.createQuery("SELECT * FROM accounts WHERE account_id = :account_id").bind("account_id", accountId).mapToBean(User.class).findFirst().orElse(null)
            );
        } catch (Exception e) {
            System.err.println("Lỗi khi tìm người dùng bằng ID: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public List<User> findAll() {
        try {
            return get().withHandle(h ->
                    h.createQuery("SELECT * FROM accounts ORDER BY account_id DESC").mapToBean(User.class).list()
            );
        } catch (Exception e) {
            System.err.println("Lỗi khi lấy danh sách người dùng: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    public boolean create(User user) {
        try {
            int rows = get().withHandle(h ->
                    h.createUpdate(
                                    "INSERT INTO accounts (email, password_hash, role_id, full_name, username, phone, is_active, first_login) " +
                                            "VALUES (:email, :password_hash, :role_id, :full_name, :username, :phone, :is_active, NOW())"
                            ).bindBean(user).execute()
            );
            System.out.println(" Tạo người dùng thành công: " + user.getUsername());
            return rows > 0;
        } catch (Exception e) {
            System.err.println(" Lỗi khi tạo người dùng: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(User user) {
        try {
            int rows = get().withHandle(h ->
                    h.createUpdate(
                                    "UPDATE accounts SET email = :email, password_hash = :password_hash, " +
                                            "full_name = :full_name, phone = :phone, cccd = :cccd, birthday = :birthday, " +
                                            "gender = :gender, address = :address, is_active = :is_active WHERE account_id = :account_id"
                            ).bindBean(user).execute()
            );
            System.out.println(" Cập nhật người dùng thành công: " + user.getAccount_id());
            return rows > 0;
        } catch (Exception e) {
            System.err.println(" Lỗi khi cập nhật người dùng: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateLastLogin(int accountId) {
        try {
            int rows = get().withHandle(h ->
                    h.createUpdate("UPDATE accounts SET last_login = NOW() WHERE account_id = :account_id").bind("account_id", accountId).execute()
            );
            return rows > 0;
        } catch (Exception e) {
            System.err.println("Lỗi khi cập nhật last_login: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updatePassword(int accountId, String newPassword) {
        try {
            int rows = get().withHandle(h ->
                    h.createUpdate("UPDATE accounts SET password_hash = :password_hash WHERE account_id = :account_id")
                            .bind("password_hash", newPassword)
                            .bind("account_id", accountId)
                            .execute()
            );
            System.out.println(" Cập nhật mật khẩu thành công cho account_id: " + accountId);
            return rows > 0;
        } catch (Exception e) {
            System.err.println(" Lỗi khi cập nhật mật khẩu: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean isUsernameExists(String username) {
        return findByUsername(username) != null;
    }

    public boolean isEmailExists(String email) {
        return findByEmail(email) != null;
    }

    public boolean delete(int accountId) {
        try {
            int rows = get().withHandle(h ->
                    h.createUpdate("DELETE FROM accounts WHERE account_id = :account_id").bind("account_id", accountId).execute()
            );
            System.out.println(" Xóa người dùng thành công: " + accountId);
            return rows > 0;
        } catch (Exception e) {
            System.err.println(" Lỗi khi xóa người dùng: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    public boolean updateAvatar(int accountId, String avatarPath) {
        try {
            int rows = get().withHandle(h ->
                    h.createUpdate("UPDATE accounts SET avatar = :avatar, updated_at = NOW() WHERE account_id = :account_id")
                            .bind("avatar", avatarPath)
                            .bind("account_id", accountId)
                            .execute()
            );
            System.out.println("✓ Cập nhật avatar thành công: " + accountId);
            return rows > 0;
        } catch (Exception e) {
            System.err.println("Lỗi khi cập nhật avatar: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
