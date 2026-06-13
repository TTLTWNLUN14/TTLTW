package vn.edu.nlu.fit.datxedulich.controller;

import vn.edu.nlu.fit.datxedulich.services.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.Map;

@WebServlet(name = "RegisterController", value = "/register")
public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String fullName = request.getParameter("fullName");

        System.out.println("=== REGISTER REQUEST ===");
        System.out.println("Username: " + username);
        System.out.println("Email: " + email);
        System.out.println("Phone: " + phone);
        System.out.println("Full Name: " + fullName);

        String validation = validateInput(username, password, confirmPassword, email, phone, fullName);
        if (validation != null) {
            System.out.println(" Validation Error: " + validation);
            String errorMessage = URLEncoder.encode(validation, "UTF-8");
            request.setAttribute("registerError", validation);
            request.setAttribute("registerFullName", fullName);
            request.setAttribute("registerUsername", username);
            request.setAttribute("registerPhone", phone);
            request.setAttribute("registerEmail", email);
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }

        try {
            UserService userService = new UserService();
            Map<String, Object> registerResult = userService.register(username, password, confirmPassword, email, phone, fullName);

            System.out.println("Register Result: " + registerResult);

            if ((Boolean) registerResult.get("success")) {
                System.out.println("✓ Đăng ký thành công: " + username);
                request.setAttribute("registerSuccess", registerResult.get("message"));
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            } else {
                System.out.println(" Đăng ký thất bại: " + registerResult.get("message"));
                request.setAttribute("registerError", registerResult.get("message"));
                request.setAttribute("registerFullName", fullName);
                request.setAttribute("registerUsername", username);
                request.setAttribute("registerPhone", phone);
                request.setAttribute("registerEmail", email);
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.err.println(" Exception in RegisterController: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("registerError", "Lỗi hệ thống: " + e.getMessage());
            request.setAttribute("registerFullName", fullName);
            request.setAttribute("registerUsername", username);
            request.setAttribute("registerPhone", phone);
            request.setAttribute("registerEmail", email);
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }

    private String validateInput(String username, String password, String confirmPassword,
                                 String email, String phone, String fullName) {
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty()) {
            return "Vui lòng điền đầy đủ thông tin";
        }
        username = username.trim();
        if (username.length() < 3 || username.length() > 20) {
            return "Tên đăng nhập phải từ 3 đến 20 ký tự";
        }
        if (username.contains(" ")) {
            return "Tên đăng nhập không được chứa khoảng trắng";
        }
        if (password.length() < 6) {
            return "Mật khẩu phải ít nhất 6 ký tự";
        }
        if (!password.equals(confirmPassword)) {
            return "Mật khẩu xác nhận không khớp";
        }
        if (!phone.matches("^\\d{9,11}$")) {
            return "Số điện thoại không hợp lệ (9-11 chữ số)";
        }
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            return "Email không hợp lệ";
        }
        if (fullName.trim().length() < 3) {
            return "Họ và tên phải có ít nhất 3 ký tự";
        }
        return null;
    }
}