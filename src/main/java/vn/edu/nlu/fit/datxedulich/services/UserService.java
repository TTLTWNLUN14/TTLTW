package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.dao.UserDAO;
import vn.edu.nlu.fit.datxedulich.model.User;
import java.security.MessageDigest;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

public class UserService {

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : messageDigest) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Map<String, Object> authenticate(String username, String password) {
        Map<String, Object> result = new HashMap<>();
        UserDAO userDAO = new UserDAO();

        try {
            if (username == null || username.isEmpty() ||
                    password == null || password.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "Vui lòng nhập tên đăng nhập và mật khẩu");
                return result;
            }

            User user = userDAO.findByUsername(username);

            if (user == null) {
                result.put("success", false);
                result.put("message", "Tên đăng nhập không tồn tại");
                return result;
            }

            if (!user.isIs_active()) {
                result.put("success", false);
                result.put("message", "Tài khoản của bạn đã bị vô hiệu hóa");
                return result;
            }

            String hashedPassword = hashPassword(password);

            if (!user.getPassword_hash().equals(hashedPassword)) {
                result.put("success", false);
                result.put("message", "Mật khẩu không chính xác");
                return result;
            }

            userDAO.updateLastLogin(user.getAccount_id());
            result.put("success", true);
            result.put("message", "Đăng nhập thành công");
            result.put("user", user);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi hệ thống: " + e.getMessage());
            e.printStackTrace();
        }

        return result;
    }

    public Map<String, Object> register(String username, String password, String confirmPassword,
                                        String email, String phone, String fullName) {
        Map<String, Object> result = new HashMap<>();
        UserDAO userDAO = new UserDAO();

        try {
            if (username == null || username.trim().isEmpty() ||
                    password == null || password.trim().isEmpty() ||
                    email == null || email.trim().isEmpty() ||
                    phone == null || phone.trim().isEmpty() ||
                    fullName == null || fullName.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "Tất cả các phải được điền");
                return result;
            }
            username = username.trim();
            email = email.trim();
            phone = phone.trim();
            fullName = fullName.trim();

            if (!password.equals(confirmPassword)) {
                result.put("success", false);
                result.put("message", "Mật khẩu xác nhận không khớp");
                return result;
            }

            if (username.length() < 3 || username.length() > 20) {
                result.put("success", false);
                result.put("message", "Tên đăng nhập phải từ 3 đến 20 ký tự");
                return result;
            }

            if (password.length() < 6) {
                result.put("success", false);
                result.put("message", "Mật khẩu phải ít nhất 6 ký tự");
                return result;
            }

            if (!isValidEmail(email)) {
                result.put("success", false);
                result.put("message", "Email không hợp lệ");
                return result;
            }

            if (!isValidPhone(phone)) {
                result.put("success", false);
                result.put("message", "Số điện thoại không hợp lệ (phải là số, từ 9-11 ký tự)");
                return result;
            }

            if (userDAO.isUsernameExists(username)) {
                result.put("success", false);
                result.put("message", "Tên đăng nhập đã được sử dụng");
                return result;
            }

            if (userDAO.isEmailExists(email)) {
                result.put("success", false);
                result.put("message", "Email đã được sử dụng");
                return result;
            }

            String hashedPassword = hashPassword(password);

            User newUser = new User(email, hashedPassword, 2, fullName, username, phone);
            newUser.setIs_active(true);

            boolean created = userDAO.create(newUser);
            if (created) {
                result.put("success", true);
                result.put("message", "Đăng ký thành công! Vui lòng đăng nhập.");
            } else {
                result.put("success", false);
                result.put("message", "Đăng ký thất bại, vui lòng thử lại");
            }

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi hệ thống: " + e.getMessage());
            e.printStackTrace();
        }

        return result;
    }

    private boolean isValidEmail(String email) {
        String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
        Pattern pattern = Pattern.compile(emailRegex);
        return pattern.matcher(email).matches();
    }

    private boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        String phoneRegex = "^\\d{9,11}$";
        Pattern pattern = Pattern.compile(phoneRegex);
        return pattern.matcher(phone).matches();
    }

    public User getUserById(int accountId) {
        UserDAO userDAO = new UserDAO();
        return userDAO.findById(accountId);
    }
}