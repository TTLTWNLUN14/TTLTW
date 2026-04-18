package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.Member;
import vn.edu.nlu.fit.datxedulich.model.User;
import vn.edu.nlu.fit.datxedulich.model.UserPreference;
import vn.edu.nlu.fit.datxedulich.services.MemberService;
import vn.edu.nlu.fit.datxedulich.services.UserPreferenceService;
import vn.edu.nlu.fit.datxedulich.services.ReviewService;
import vn.edu.nlu.fit.datxedulich.services.NotificationService;
import vn.edu.nlu.fit.datxedulich.dao.UserDAO;
import java.io.IOException;
import java.security.MessageDigest;

@WebServlet(name = "ProfileController", value = "/profile")
public class ProfileController extends HttpServlet {

    private final MemberService memberService = new MemberService();
    private final UserPreferenceService preferenceService = new UserPreferenceService();
    private final ReviewService reviewService = new ReviewService();
    private final NotificationService notificationService = new NotificationService();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("account_id");

        if (accountId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Member member = memberService.getMemberInfo(accountId);
            UserPreference preference = preferenceService.getPreference(accountId);
            int unreadCount = notificationService.getUnreadCount(accountId);

            request.setAttribute("member", member);
            request.setAttribute("bookingHistory", memberService.getBookingHistory(accountId));
            request.setAttribute("preference", preference);
            request.setAttribute("reviews", reviewService.getReviews(accountId));
            request.setAttribute("notifications", notificationService.getNotifications(accountId));
            request.setAttribute("unreadCount", unreadCount);

            request.getRequestDispatcher("/WEB-INF/views/profile.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Lỗi khi tải thông tin hồ sơ");
            e.printStackTrace();
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("account_id");

        if (accountId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("updateProfile".equals(action)) {
                Member member = memberService.getMemberInfo(accountId);
                if (member != null) {
                    member.setFullName(request.getParameter("fullName"));
                    member.setPhone(request.getParameter("phone"));
                    member.setEmail(request.getParameter("email"));
                    member.setAddress(request.getParameter("address"));
                    member.setCccd(request.getParameter("cccd"));
                    member.setGender(request.getParameter("gender"));

                    if (memberService.updateMemberInfo(member)) {
                        request.setAttribute("successMessage", "Cập nhật thông tin thành công!");
                    } else {
                        request.setAttribute("errorMessage", "Cập nhật thông tin thất bại!");
                    }
                }
            }
            else if ("updateSettings".equals(action)) {
                UserPreference preference = new UserPreference();
                preference.setAccountId(accountId);
                preference.setNotificationBooking("on".equals(request.getParameter("notificationBooking")));
                preference.setNotificationPromotion("on".equals(request.getParameter("notificationPromotion")));
                preference.setEmailWeekly("on".equals(request.getParameter("emailWeekly")));
                preference.setPreferenceLanguage("on".equals(request.getParameter("preferenceLanguage")));

                if (preferenceService.updatePreference(preference)) {
                    request.setAttribute("successMessage", "Cập nhật cài đặt thành công!");
                } else {
                    request.setAttribute("errorMessage", "Cập nhật cài đặt thất bại!");
                }
            }
            else if ("changePassword".equals(action)) {
                String oldPassword = request.getParameter("oldPassword");
                String newPassword = request.getParameter("newPassword");
                String confirmPassword = request.getParameter("confirmPassword");

                if (oldPassword == null || oldPassword.trim().isEmpty()) {
                    request.setAttribute("errorMessage", "Vui lòng nhập mật khẩu hiện tại!");
                } else if (newPassword == null || newPassword.length() < 6) {
                    request.setAttribute("errorMessage", "Mật khẩu mới phải có ít nhất 6 ký tự!");
                } else if (!newPassword.equals(confirmPassword)) {
                    request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp!");
                } else {

                    User currentUser = userDAO.findById(accountId);

                    if (currentUser == null) {
                        request.setAttribute("errorMessage", "Không tìm thấy tài khoản!");
                    } else {
                        String hashedOldPassword = hashPassword(oldPassword);

                        if (!hashedOldPassword.equals(currentUser.getPassword_hash())) {
                            request.setAttribute("errorMessage", "Mật khẩu hiện tại không đúng!");
                        } else {
                            String hashedNewPassword = hashPassword(newPassword);

                            if (userDAO.updatePassword(accountId, hashedNewPassword)) {
                                request.setAttribute("successMessage", "Đổi mật khẩu thành công!");
                            } else {
                                request.setAttribute("errorMessage", "Đổi mật khẩu thất bại!");
                            }
                        }
                    }
                }
            }
            else if ("markAllAsRead".equals(action)) {
                notificationService.markAllAsRead(accountId);
                request.setAttribute("successMessage", "Đánh dấu tất cả đã đọc!");
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            e.printStackTrace();
        }

        doGet(request, response);
    }

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
}