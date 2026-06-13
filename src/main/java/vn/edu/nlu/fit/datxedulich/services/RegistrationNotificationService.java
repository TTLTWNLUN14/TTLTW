package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.model.Notification;

public class RegistrationNotificationService {
    private final NotificationService notificationService = new NotificationService();

    public void sendRegistrationNotification(int accountId, String fullName) {
        String title = "Đón chào bạn " + fullName;
        String content = "Tài khoản của bạn đã được tạo thành công. " +
                "Bây giờ bạn có thể đặt xe và tận hưởng các ưu đãi đặc biệt!";
        String icon = "fas fa-heart";
        String actionUrl = "/profile";

        notificationService.sendNotification(accountId, Notification.Type.REGISTRATION,
                title, content, null, icon, actionUrl);
    }

    public void sendWelcomeVoucherNotification(int accountId, int voucherDiscount, String voucherCode) {
        String title = "Nhận ngay voucher chào mừng " + voucherDiscount + "%";
        String content = "Mã voucher: " + voucherCode + " | Hạn sử dụng: 30 ngày";
        String icon = "fas fa-ticket-alt";
        String actionUrl = "/booking";

        notificationService.sendNotification(accountId, Notification.Type.PROMOTION,
                title, content, voucherCode, icon, actionUrl);
    }
}