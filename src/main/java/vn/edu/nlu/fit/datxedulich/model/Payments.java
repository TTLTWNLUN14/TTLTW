package vn.edu.nlu.fit.datxedulich.model;

import java.io.Serializable;
import java.util.Date;

public class Payments implements Serializable {
    private int paymentId;
    private int bookingId;
    private int accountId;
    private int price;
    private String method;
    private String payType;
    private String status;
    private Date paidAt;
    private int createdBy;

    public Payments() {
    }

    public Payments(int paymentId, int bookingId, int accountId, int price, String method, String payType, String status, Date paidAt, int createdBy) {
        this.paymentId = paymentId;
        this.bookingId = bookingId;
        this.accountId = accountId;
        this.price = price;
        this.method = method;
        this.payType = payType;
        this.status = status;
        this.paidAt = paidAt;
        this.createdBy = createdBy;
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public String getPayType() {
        return payType;
    }

    public void setPayType(String payType) {
        this.payType = payType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(Date paidAt) {
        this.paidAt = paidAt;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }
}