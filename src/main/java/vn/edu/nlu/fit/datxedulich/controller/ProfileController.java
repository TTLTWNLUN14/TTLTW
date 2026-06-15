package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.Member;
import vn.edu.nlu.fit.datxedulich.model.User;
import vn.edu.nlu.fit.datxedulich.model.UserPreference;
import vn.edu.nlu.fit.datxedulich.model.Booking;
import vn.edu.nlu.fit.datxedulich.services.*;
import vn.edu.nlu.fit.datxedulich.utils.FileUploadUtil;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProfileController", value = "/profile")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 10
)
public class ProfileController extends HttpServlet {

    private final ProfileService profileService = new ProfileService();
    private final MemberService memberService = new MemberService();
    private final UserPreferenceService preferenceService = new UserPreferenceService();
    private final ReviewService reviewService = new ReviewService();
    private final NotificationService notificationService = new NotificationService();
    private final UserService userService = new UserService();

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
            List<Booking> bookingHistory = memberService.getBookingHistory(accountId);

            request.setAttribute("member", member);
            request.setAttribute("bookingHistory", bookingHistory);
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

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "updateProfile":
                    handleUpdateProfile(request, accountId, session);
                    break;
                case "updateAvatar":
                    handleUpdateAvatar(request, accountId, session);
                    break;
                case "updateSettings":
                    handleUpdateSettings(request, accountId, session);
                    break;
                case "changePassword":
                    handleChangePassword(request, accountId, session);
                    break;
                case "markAllAsRead":
                    notificationService.markAllAsRead(accountId);
                    session.setAttribute("successMessage", "Đánh dấu tất cả đã đọc!");
                    break;
                default:
                    session.setAttribute("errorMessage", "Hành động không hợp lệ!");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/profile");
    }

    private void handleUpdateProfile(HttpServletRequest request, int accountId, HttpSession session) throws Exception {
        Member memberData = new Member();
        memberData.setFullName(request.getParameter("fullName"));
        memberData.setPhone(request.getParameter("phone"));
        memberData.setEmail(request.getParameter("email"));
        memberData.setAddress(request.getParameter("address"));
        memberData.setCccd(request.getParameter("cccd"));
        memberData.setGender(request.getParameter("gender"));

        if (profileService.updateProfile(accountId, memberData)) {
            session.setAttribute("successMessage", "Cập nhật thông tin thành công!");
        } else {
            session.setAttribute("errorMessage", "Cập nhật thông tin thất bại!");
        }
    }
    private void handleUpdateAvatar(HttpServletRequest request, int accountId, HttpSession session) throws Exception {
        User user = (User) session.getAttribute("user");
        if (user == null) return;

        try {
            // 1. Lấy file ảnh từ form
            Part filePart = request.getPart("avatarFile");

            // 2. Sử dụng hàm saveFile bạn vừa cấu hình
            String relativePath = FileUploadUtil.saveFile(filePart, request);

            if (relativePath != null && !relativePath.isEmpty()) {

                // 3. Cập nhật vào Database
                boolean isUpdated = userService.updateAvatar(accountId, relativePath);

                if (isUpdated) {
                    // 4. Đồng bộ ngay lại Session
                    user.setAvatar(relativePath);
                    session.setAttribute("user", user);
                    session.setAttribute("successMessage", "Cập nhật ảnh đại diện thành công!");
                } else {
                    session.setAttribute("errorMessage", "Cập nhật đường dẫn vào cơ sở dữ liệu thất bại!");
                }
            } else {
                session.setAttribute("errorMessage", "Vui lòng chọn một file ảnh hợp lệ!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        }
    }
    private void handleUpdateSettings(HttpServletRequest request, int accountId, HttpSession session) throws Exception {
        UserPreference preference = new UserPreference();
        preference.setNotificationBooking("on".equals(request.getParameter("notificationBooking")));
        preference.setNotificationPromotion("on".equals(request.getParameter("notificationPromotion")));
        preference.setEmailWeekly("on".equals(request.getParameter("emailWeekly")));
        preference.setPreferenceLanguage("on".equals(request.getParameter("preferenceLanguage")));

        if (profileService.updateSettings(accountId, preference)) {
            session.setAttribute("successMessage", "Cập nhật cài đặt thành công!");
        } else {
            session.setAttribute("errorMessage", "Cập nhật cài đặt thất bại!");
        }
    }

    private void handleChangePassword(HttpServletRequest request, int accountId, HttpSession session) throws Exception {
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            throw new Exception("Mật khẩu xác nhận không khớp!");
        }

        if (profileService.changePassword(accountId, oldPassword, newPassword)) {
            session.setAttribute("successMessage", "Đổi mật khẩu thành công!");
        } else {
            session.setAttribute("errorMessage", "Đổi mật khẩu thất bại!");
        }
    }
}