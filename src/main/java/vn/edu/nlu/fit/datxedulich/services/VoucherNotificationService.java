package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.model.Notification;
import java.util.List;

public class VoucherNotificationService {
    private final NotificationService notificationService = new NotificationService();

    public void sendPromotionNotification(int accountId, String voucherCode,
                                          int discountPercent, String description) {
        String title = "Ưu đãi mới: Giảm " + discountPercent + "%";
        String content = "Mã: " + voucherCode + " | " + description;

        notificationService.sendNotification(accountId, Notification.Type.PROMOTION,
                title, content, voucherCode);
    }

    public void sendVoucherExpiringNotification(int accountId, String voucherCode,
                                                int daysRemaining) {
        String title = "Voucher sắp hết hạn";
        String content = String.format(
                "Mã: %s | Hạn sử dụng: %d ngày | Sử dụng ngay để không mất ưu đãi",
                voucherCode, daysRemaining
        );

        notificationService.sendNotification(accountId, Notification.Type.VOUCHER_EXPIRING,
                title, content, voucherCode);
    }

    public void sendBulkPromotionNotifications(String voucherCode, int discountPercent,
                                               String description, List<Integer> accountIds) {
        for (Integer accountId : accountIds) {
            sendPromotionNotification(accountId, voucherCode, discountPercent, description);
        }
    }
}