package vn.edu.nlu.fit.datxedulich.model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Notification implements Serializable {
    private int notificationId;
    private int accountId;
    private String type;
    private String title;
    private String content;
    private String bookingCode;
    private LocalDateTime createdAt;
    private boolean isRead;

    public Notification() {}

    public Notification(int accountId, String type, String title, String content,
                        String bookingCode, LocalDateTime createdAt) {
        this.accountId = accountId;
        this.type = type;
        this.title = title;
        this.content = content;
        this.bookingCode = bookingCode;
        this.createdAt = createdAt;
        this.isRead = false;
    }

    public static class Type {
        public static final String REGISTRATION = "REGISTRATION";
        public static final String PAYMENT = "PAYMENT";
        public static final String BOOKING = "BOOKING";
        public static final String PROMOTION = "PROMOTION";
        public static final String VOUCHER_EXPIRING = "VOUCHER_EXPIRING";
        public static final String BOOKING_REMINDER = "BOOKING_REMINDER";
        public static final String PROFILE_UPDATE = "PROFILE_UPDATE";
    }

    public int getNotificationId() { return notificationId; }
    public void setNotificationId(int notificationId) { this.notificationId = notificationId; }

    public int getAccountId() { return accountId; }
    public void setAccountId(int accountId) { this.accountId = accountId; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getBookingCode() { return bookingCode; }
    public void setBookingCode(String bookingCode) { this.bookingCode = bookingCode; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }
}