package vn.edu.nlu.fit.datxedulich.dao;

import vn.edu.nlu.fit.datxedulich.model.Notification;
import java.time.LocalDateTime;
import java.util.List;

public class NotificationDAO extends BaseDao {

    public List<Notification> getNotificationsByAccountId(int accountId) {
        return get().withHandle(h -> h.createQuery(
                "SELECT notif_id as notificationId, account_id as accountId, type, title, content, " +
                        "booking_id as bookingCode, created_at as createdAt, is_read as isRead, icon, action_url as actionUrl " +
                        "FROM notifications WHERE account_id = :accountId ORDER BY created_at DESC LIMIT 50"
        ).bind("accountId", accountId).mapToBean(Notification.class).list());
    }

    public int getUnreadCount(int accountId) {
        Integer count = get().withHandle(h -> h.createQuery(
                "SELECT COUNT(*) FROM notifications WHERE account_id = :accountId AND is_read = 0"
        ).bind("accountId", accountId).mapTo(Integer.class).findFirst().orElse(0));
        return count != null ? count : 0;
    }

    public void markAsRead(int notificationId) {
        try {
            get().useHandle(h -> h.createUpdate(
                    "UPDATE notifications SET is_read = 1 WHERE notif_id = :id"
            ).bind("id", notificationId).execute());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void markAllAsRead(int accountId) {
        try {
            get().useHandle(h -> h.createUpdate(
                    "UPDATE notifications SET is_read = 1 WHERE account_id = :accountId"
            ).bind("accountId", accountId).execute());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void createNotification(int accountId, String type, String title, String content,
                                   String bookingCode, String icon, String actionUrl) {
        try {
            get().useHandle(h -> h.createUpdate(
                            "INSERT INTO notifications (account_id, type, title, content, booking_id, icon, action_url, created_at, is_read) " +
                                    "VALUES (:accountId, :type, :title, :content, :bookingCode, :icon, :actionUrl, NOW(), 0)"
                    )
                    .bind("accountId", accountId)
                    .bind("type", type)
                    .bind("title", title)
                    .bind("content", content)
                    .bind("bookingCode", bookingCode)
                    .bind("icon", icon)
                    .bind("actionUrl", actionUrl)
                    .execute());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteOldNotifications(int daysOld) {
        try {
            get().useHandle(h -> h.createUpdate(
                    "DELETE FROM notifications WHERE created_at < DATE_SUB(NOW(), INTERVAL :days DAY)"
            ).bind("days", daysOld).execute());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}