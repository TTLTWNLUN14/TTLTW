package vn.edu.nlu.fit.datxedulich.model;

import java.io.Serializable;
import java.time.LocalDate;

public class Notification implements Serializable {
    private int notificationId;
    private int accountId;
    private String type;
    private String title;
    private String content;
    private String bookingCode;
    private LocalDate createdAt;
    private boolean isRead;

    public Notification() {}

    public Notification(int accountId, String type, String title, String content,
                        String bookingCode, LocalDate createdAt) {
        this.accountId = accountId;
        this.type = type;
        this.title = title;
        this.content = content;
        this.bookingCode = bookingCode;
        this.createdAt = createdAt;
        this.isRead = false;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }

    public LocalDate getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDate createdAt) {
        this.createdAt = createdAt;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getBookingCode() {
        return bookingCode;
    }

    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }
}