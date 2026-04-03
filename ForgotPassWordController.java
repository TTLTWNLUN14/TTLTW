package vn.edu.nlu.fit.datxedulich.controller;

import vn.edu.nlu.fit.datxedulich.dao.UserDAO;
import vn.edu.nlu.fit.datxedulich.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.MessageDigest;

@WebServlet(name = "ForgotPassWordController", value = "/forgot")
public class ForgotPassWordController extends HttpServlet {

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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");
        UserDAO userDAO = new UserDAO();

        try {
            if ("sendOtp".equals(action)) {
                handleSendOtp(request, response, out, userDAO);
            } else if ("verifyOtp".equals(action)) {
                handleVerifyOtp(request, response, out);
            } else if ("resetPassword".equals(action)) {
                handleResetPassword(request, response, out, userDAO);
            } else {
                out.print("{\"success\":false,\"message\":\"Hành động không hợp lệ\"}");
            }
        } catch (Exception e) {
            out.print("{\"success\":false,\"message\":\"Lỗi: " + e.getMessage().replace("\"", "\\\"") + "\"}");
            e.printStackTrace();
        }
        out.flush();
    }

    private void handleSendOtp(HttpServletRequest request, HttpServletResponse response, PrintWriter out, UserDAO userDAO) {
        String emailOrUsername = request.getParameter("emailOrUsername");

        if (emailOrUsername == null || emailOrUsername.trim().isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Vui lòng nhập email hoặc tên đăng nhập\"}");
            return;
        }

        User user = null;
        if (emailOrUsername.contains("@")) {
            user = userDAO.findByEmail(emailOrUsername);
        } else {
            user = userDAO.findByUsername(emailOrUsername);
        }

        if (user == null) {
            out.print("{\"success\":false,\"message\":\"Không tìm thấy tài khoản\"}");
            return;
        }

        String otp = String.format("%06d", (int) (Math.random() * 1000000));

        HttpSession session = request.getSession();
        session.setAttribute("forgotUserId", user.getAccount_id());
        session.setAttribute("forgotOtp", otp);
        session.setAttribute("forgotOtpTime", System.currentTimeMillis());

        System.out.println("=== OTP FOR USER " + user.getUsername() + " ===");
        System.out.println("OTP: " + otp);
        System.out.println("Email: " + user.getEmail());
        System.out.println("==================================");

        out.print("{\"success\":true,\"message\":\"Mã xác nhận đã gửi đến email của bạn\"}");
    }

    private void handleVerifyOtp(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        String otp = request.getParameter("otp");

        if (otp == null || otp.trim().isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Vui lòng nhập mã xác nhận\"}");
            return;
        }

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("forgotUserId");
        String storedOtp = (String) session.getAttribute("forgotOtp");
        Long otpTime = (Long) session.getAttribute("forgotOtpTime");

        if (storedOtp == null || userId == null) {
            out.print("{\"success\":false,\"message\":\"Mã xác nhận đã hết hiệu lực. Vui lòng gửi lại\"}");
            return;
        }

        if (System.currentTimeMillis() - otpTime > 10 * 60 * 1000) {
            session.removeAttribute("forgotOtp");
            out.print("{\"success\":false,\"message\":\"Mã xác nhận đã hết hiệu lực\"}");
            return;
        }

        if (!storedOtp.equals(otp)) {
            out.print("{\"success\":false,\"message\":\"Mã xác nhận không đúng\"}");
            return;
        }

        session.setAttribute("forgotOtpVerified", true);

        out.print("{\"success\":true,\"message\":\"Mã xác nhận chính xác\"}");
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response, PrintWriter out, UserDAO userDAO) {
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword == null || newPassword.trim().isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Vui lòng nhập mật khẩu mới\"}");
            return;
        }

        if (newPassword.length() < 6) {
            out.print("{\"success\":false,\"message\":\"Mật khẩu phải ít nhất 6 ký tự\"}");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            out.print("{\"success\":false,\"message\":\"Mật khẩu xác nhận không khớp\"}");
            return;
        }

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("forgotUserId");
        Boolean otpVerified = (Boolean) session.getAttribute("forgotOtpVerified");

        if (userId == null || otpVerified == null || !otpVerified) {
            out.print("{\"success\":false,\"message\":\"Vui lòng xác thực OTP trước\"}");
            return;
        }

        String hashedPassword = hashPassword(newPassword);

        boolean updated = userDAO.updatePassword(userId, hashedPassword);

        if (updated) {
            session.removeAttribute("forgotUserId");
            session.removeAttribute("forgotOtp");
            session.removeAttribute("forgotOtpTime");
            session.removeAttribute("forgotOtpVerified");

            out.print("{\"success\":true,\"message\":\"Mật khẩu đã được cập nhật thành công\"}");
        } else {
            out.print("{\"success\":false,\"message\":\"Cập nhật mật khẩu thất bại\"}");
        }
    }
}