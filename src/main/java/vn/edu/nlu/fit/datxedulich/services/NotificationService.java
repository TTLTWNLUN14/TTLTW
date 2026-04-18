package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.dao.NotificationDAO;
import vn.edu.nlu.fit.datxedulich.model.Notification;
import java.util.List;

public class NotificationService {
    private final NotificationDAO notificationDAO = new NotificationDAO();

    public List<Notification> getNotifications(int accountId) {
        return notificationDAO.getNotificationsByAccountId(accountId);
    }

    public int getUnreadCount(int accountId) {
        return notificationDAO.getUnreadCount(accountId);
    }

    public void markAsRead(int notificationId) {
        notificationDAO.markAsRead(notificationId);
    }

    public void markAllAsRead(int accountId) {
        notificationDAO.markAllAsRead(accountId);
    }
}