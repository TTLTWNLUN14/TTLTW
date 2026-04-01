package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.dao.UserDAO;
import vn.edu.nlu.fit.datxedulich.model.User;

import java.util.regex.Pattern;

public class UserService {
    private UserDAO userDAO = new UserDAO();
     public User authenticate(String username, String password) throws Exception {
         if (
                 username==null||username.trim().isEmpty()||
                 password==null||password.trim().isEmpty()){
             throw new IllegalArgumentException("Tên đăng nhập và mật khẩu không được để trống");
         }
         User user = userDAO.findByUserName(username);

         if (user == null) {
             throw new Exception("Tên đăng nhập không tồn tại");
         }

         if (user.getIsActive() != null && !user.getIsActive().equals("active")) {
             throw new Exception("Tài khoản của bạn không hoạt động");
         }
         if (!user.getPassWordHash().equals(password)) {
             throw new Exception("Mật khẩu không chính xác");
         }

         return user;
     }
     public boolean register(String userName,String passWordHash,String email,String fullName,String corfirmPassWord) throws Exception {
         if (userName == null || userName.trim().isEmpty() ||
                 passWordHash == null || passWordHash.trim().isEmpty() ||
                 email == null || email.trim().isEmpty() ||
                 fullName == null || fullName.trim().isEmpty()||
          corfirmPassWord == null || corfirmPassWord.trim().isEmpty()) {
             throw new IllegalArgumentException("Tất cả các trường phải được điền");

     }
         if (!corfirmPassWord.equals(corfirmPassWord)) {
             throw new Exception("Mật khẩu xác nhận không khớp");
         }
         if (userName.length() < 3 || userName.length() > 20) {
             throw new Exception("Tên đăng nhập phải từ 3 đến 20 ký tự");
         }
         if (passWordHash.length() < 6) {
             throw new Exception("Mật khẩu phải ít nhất 6 ký tự");
         }
         if (!isValidEmail(email)) {
             throw new Exception("Email không hợp lệ");
         }
         if (userDAO.isUsernameExists(userName)) {
             throw new Exception("Tên đăng nhập đã được sử dụng");
         }
         if (userDAO.isEmailExists(email)) {
             throw new Exception("Email đã được sử dụng");
         }
         User newUser = new User();
         newUser.setUsername(userName);
         newUser.setPassWordHash(passWordHash);
         newUser.setEmail(email);
         newUser.setFullName(fullName);
         newUser.setIsActive("active");

         return userDAO.create(newUser);


   }
    public boolean updateProfile(int userId, String email, String fullName) throws Exception {
        if (email == null || email.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty()) {
            throw new IllegalArgumentException("Email và họ tên không được để trống");
        }

        if (!isValidEmail(email)) {
            throw new Exception("Email không hợp lệ");
        }

        User user = userDAO.findById(userId);
        if (user == null) {
            throw new Exception("Người dùng không tồn tại");
        }

        user.setEmail(email);
        user.setFullName(fullName);

        return userDAO.update(user);
    }
    public boolean changePassword(int userId, String oldPassword, String newPassword, String confirmPassword) throws Exception {
        if (newPassword == null || newPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("Mật khẩu mới không được để trống");
        }

        if (newPassword.length() < 6) {
            throw new Exception("Mật khẩu mới phải ít nhất 6 ký tự");
        }

        if (!newPassword.equals(confirmPassword)) {
            throw new Exception("Xác nhận mật khẩu không khớp");
        }

        User user = userDAO.findById(userId);
        if (user == null) {
            throw new Exception("Người dùng không tồn tại");
        }

        if (!user.getPassWordHash().equals(oldPassword)) {
            throw new Exception("Mật khẩu cũ không đúng");
        }

        user.setPassWordHash(newPassword);
        return userDAO.update(user);
    }


    private boolean isValidEmail(String email) {
         String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
         Pattern pattern = Pattern.compile(emailRegex);
         return pattern.matcher(email).matches();
     }
 }
