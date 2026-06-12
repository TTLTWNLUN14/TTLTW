package vn.edu.nlu.fit.datxedulich.model;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class Booking implements Serializable {
    private int bookingId;
    private int customerId;
    private int typeId;
    private String carName;          // join từ car_types.type_name
    private String route;
    private String pickupProvince;   // tên tỉnh đón
    private String dropoffProvince;  // tên tỉnh đến
    private int km;
    private String pickupTime;
    private String returnTime;
    private int totalPrice;
    private String bookerName;
    private String bookerPhone;
    private String bookerAddress;
    private String note;
    private String status;           // Chờ xác nhận | Đang diễn ra | Hoàn thành | Đã hủy
    private String paymentStatus;    // PENDING | PAID | CANCELLED
    private LocalDate bookingDate;  // DATE(pickup_date) – dùng cho lịch sử
    private LocalDateTime createdAt;    // thời điểm INSERT
    public Booking() {
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getCarName() {
        return carName;
    }

    public void setCarName(String carName) {
        this.carName = carName;
    }

    public String getRoute() {
        return route;
    }

    public void setRoute(String route) {
        this.route = route;
    }

    public String getPickupProvince() {
        return pickupProvince;
    }

    public void setPickupProvince(String pickupProvince) {
        this.pickupProvince = pickupProvince;
    }

    public String getDropoffProvince() {
        return dropoffProvince;
    }

    public void setDropoffProvince(String dropoffProvince) {
        this.dropoffProvince = dropoffProvince;
    }

    public int getKm() {
        return km;
    }

    public void setKm(int km) {
        this.km = km;
    }

    public String getPickupTime() {
        return pickupTime;
    }

    public void setPickupTime(String pickupTime) {
        this.pickupTime = pickupTime;
    }

    public String getReturnTime() {
        return returnTime;
    }

    public void setReturnTime(String returnTime) {
        this.returnTime = returnTime;
    }

    public int getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(int totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getBookerName() {
        return bookerName;
    }

    public void setBookerName(String v) {
        this.bookerName = v;
    }

    public String getBookerPhone() {
        return bookerPhone;
    }

    public void setBookerPhone(String v) {
        this.bookerPhone = v;
    }

    public String getBookerAddress() {
        return bookerAddress;
    }

    public void setBookerAddress(String v) {
        this.bookerAddress = v;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String v) {
        this.note = v;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public LocalDate getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(LocalDate bookingDate) {
        this.bookingDate = bookingDate;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public int getTypeId() {
        return typeId;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
