package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.model.Notification;

public class PaymentNotificationService {
    private final NotificationService notificationService = new NotificationService();

    public void sendPaymentSuccessNotification(int accountId, String bookingCode,
                                               double amount, String carInfo) {
        String title = "Thanh toán thành công";
        String content = String.format(
                "Mã đặt xe: %s | Số tiền: %.0f VND | Xe: %s | " +
                        "Chi tiết được gửi vào email của bạn",
                bookingCode, amount, carInfo
        );
        String icon = "fas fa-check-circle";
        String actionUrl = "/profile?tab=bookings";

        notificationService.sendNotification(accountId, Notification.Type.PAYMENT,
                title, content, bookingCode, icon, actionUrl);
    }

    public void sendPaymentFailedNotification(int accountId, String bookingCode, String reason) {
        String title = "Thanh toán thất bại";
        String content = String.format(
                "Mã đặt xe: %s | Lý do: %s | Vui lòng thử lại",
                bookingCode, reason
        );
        String icon = "fas fa-times-circle";
        String actionUrl = "/profile?tab=bookings";

        notificationService.sendNotification(accountId, Notification.Type.PAYMENT,
                title, content, bookingCode, icon, actionUrl);
    }

    public void sendBookingConfirmationNotification(int accountId, String bookingCode,
                                                    String pickupLocation, String pickupTime) {
        String title = "Xác nhận đặt xe";
        String content = String.format(
                "Mã đặt xe: %s | Điểm đón: %s | Thời gian: %s",
                bookingCode, pickupLocation, pickupTime
        );
        String icon = "fas fa-car";
        String actionUrl = "/profile?tab=bookings";

        notificationService.sendNotification(accountId, Notification.Type.BOOKING,
                title, content, bookingCode, icon, actionUrl);
    }
}