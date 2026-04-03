package vn.edu.nlu.fit.datxedulich.dao;

import vn.edu.nlu.fit.datxedulich.model.Notification;
import java.util.List;

public class NotificationDAO extends BaseDao {

    public List<Notification> getNotificationsByAccountId(int accountId) {
        return get().withHandle(h -> h.createQuery("SELECT notif_id as notificationId, account_id as accountId, " + "type, title, content, booking_id as bookingCode, " + "DATE(created_at) as createdAt, is_read as isRead " + "FROM notifications " + "WHERE account_id = :accountId " + "ORDER BY created_at DESC " + "LIMIT 50").bind("accountId", accountId).mapToBean(Notification.class).list()
        );
    }

    public int getUnreadCount(int accountId) {
        return get().withHandle(h -> h.createQuery("SELECT COUNT(*) FROM notifications WHERE account_id = :accountId AND is_read = 0").bind("accountId", accountId).mapTo(Integer.class).findFirst().orElse(0)
        );
    }

    public void markAsRead(int notificationId) {
        try {
            get().useHandle(h ->h.createUpdate("UPDATE notifications SET is_read = 1 WHERE notif_id = :id").bind("id", notificationId).execute());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void markAllAsRead(int accountId) {
        try {
            get().useHandle(h -> h.createUpdate("UPDATE notifications SET is_read = 1 WHERE account_id = :accountId").bind("accountId", accountId).execute());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}