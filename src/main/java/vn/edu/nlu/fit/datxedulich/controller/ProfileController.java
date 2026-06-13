package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.Member;
import vn.edu.nlu.fit.datxedulich.model.UserPreference;
import vn.edu.nlu.fit.datxedulich.services.*;
import java.io.IOException;

@WebServlet(name = "ProfileController", value = "/profile")
public class ProfileController extends HttpServlet {

    private final ProfileService profileService = new ProfileService();
    private final MemberService memberService = new MemberService();
    private final UserPreferenceService preferenceService = new UserPreferenceService();
    private final ReviewService reviewService = new ReviewService();
    private final NotificationService notificationService = new NotificationService();

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
            // Load all profile data
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
            request.setAttribute("errorMessage", "Lỗi khi tải thông tin hồ sơ: " + e.getMessage());
            e.printStackTrace();
            try {
                request.getRequestDispatcher("/WEB-INF/views/profile.jsp")
                        .forward(request, response);
            } catch (Exception ex) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
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
            switch (action) {
                case "updateProfile":
                    handleUpdateProfile(request, accountId);
                    break;
                case "updateSettings":
                    handleUpdateSettings(request, accountId);
                    break;
                case "changePassword":
                    handleChangePassword(request, accountId);
                    break;
                case "markAllAsRead":
                    notificationService.markAllAsRead(accountId);
                    request.setAttribute("successMessage", "Đánh dấu tất cả đã đọc!");
                    break;
                default:
                    request.setAttribute("errorMessage", "Hành động không hợp lệ!");
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            e.printStackTrace();
        }

        doGet(request, response);
    }

    /**
     * Handle profile update
     */
    private void handleUpdateProfile(HttpServletRequest request, int accountId) throws Exception {
        Member memberData = new Member();
        memberData.setFullName(request.getParameter("fullName"));
        memberData.setPhone(request.getParameter("phone"));
        memberData.setEmail(request.getParameter("email"));
        memberData.setAddress(request.getParameter("address"));
        memberData.setCccd(request.getParameter("cccd"));
        memberData.setGender(request.getParameter("gender"));

        if (profileService.updateProfile(accountId, memberData)) {
            request.setAttribute("successMessage", "Cập nhật thông tin thành công!");
        } else {
            request.setAttribute("errorMessage", "Cập nhật thông tin thất bại!");
        }
    }

    /**
     * Handle notification settings update
     */
    private void handleUpdateSettings(HttpServletRequest request, int accountId) throws Exception {
        UserPreference preference = new UserPreference();
        preference.setNotificationBooking("on".equals(request.getParameter("notificationBooking")));
        preference.setNotificationPromotion("on".equals(request.getParameter("notificationPromotion")));
        preference.setEmailWeekly("on".equals(request.getParameter("emailWeekly")));
        preference.setPreferenceLanguage("on".equals(request.getParameter("preferenceLanguage")));

        if (profileService.updateSettings(accountId, preference)) {
            request.setAttribute("successMessage", "Cập nhật cài đặt thành công!");
        } else {
            request.setAttribute("errorMessage", "Cập nhật cài đặt thất bại!");
        }
    }

    /**
     * Handle password change
     */
    private void handleChangePassword(HttpServletRequest request, int accountId) throws Exception {
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            throw new Exception("Mật khẩu xác nhận không khớp!");
        }

        if (profileService.changePassword(accountId, oldPassword, newPassword)) {
            request.setAttribute("successMessage", "Đổi mật khẩu thành công!");
        } else {
            request.setAttribute("errorMessage", "Đổi mật khẩu thất bại!");
        }
    }
}