package vn.edu.nlu.fit.datxedulich.model;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class Booking implements Serializable {
    private int bookingId;
    private int customerId;
    private int typeId;
    private int voucherId;
    private String isDriver;
    private String pickupProvince;
    private String dropoffProvince;
    private LocalDateTime pickupDate;
    private LocalTime pickupTime;
    private LocalDateTime returnDate;
    private int km;
    private int days;
    private int basePrice;
    private float memberDiscount;
    private float voucherDiscount;
    private int totalPrice;
    private String isVoucherCode;
    private String payType;
    private String note;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Booking() {}

    public Booking(int bookingId, int customerId, int typeId, int voucherId, String isDriver, String pickupProvince, String dropoffProvince, LocalDateTime pickupDate, LocalTime pickupTime, LocalDateTime returnDate, int km, int days, int basePrice, float memberDiscount, float voucherDiscount, int totalPrice, String isVoucherCode, String payType, String note, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.bookingId = bookingId;
        this.customerId = customerId;
        this.typeId = typeId;
        this.voucherId = voucherId;
        this.isDriver = isDriver;
        this.pickupProvince = pickupProvince;
        this.dropoffProvince = dropoffProvince;
        this.pickupDate = pickupDate;
        this.pickupTime = pickupTime;
        this.returnDate = returnDate;
        this.km = km;
        this.days = days;
        this.basePrice = basePrice;
        this.memberDiscount = memberDiscount;
        this.voucherDiscount = voucherDiscount;
        this.totalPrice = totalPrice;
        this.isVoucherCode = isVoucherCode;
        this.payType = payType;
        this.note = note;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
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

    public int getTypeId() {
        return typeId;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public int getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(int voucherId) {
        this.voucherId = voucherId;
    }

    public String getIsDriver() {
        return isDriver;
    }

    public void setIsDriver(String isDriver) {
        this.isDriver = isDriver;
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

    public LocalDateTime getPickupDate() {
        return pickupDate;
    }

    public void setPickupDate(LocalDateTime pickupDate) {
        this.pickupDate = pickupDate;
    }

    public LocalTime getPickupTime() {
        return pickupTime;
    }

    public void setPickupTime(LocalTime pickupTime) {
        this.pickupTime = pickupTime;
    }

    public LocalDateTime getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(LocalDateTime returnDate) {
        this.returnDate = returnDate;
    }

    public int getKm() {
        return km;
    }

    public void setKm(int km) {
        this.km = km;
    }

    public int getDays() {
        return days;
    }

    public void setDays(int days) {
        this.days = days;
    }

    public int getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(int basePrice) {
        this.basePrice = basePrice;
    }

    public float getMemberDiscount() {
        return memberDiscount;
    }

    public void setMemberDiscount(float memberDiscount) {
        this.memberDiscount = memberDiscount;
    }

    public float getVoucherDiscount() {
        return voucherDiscount;
    }

    public void setVoucherDiscount(float voucherDiscount) {
        this.voucherDiscount = voucherDiscount;
    }

    public int getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(int totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getIsVoucherCode() {
        return isVoucherCode;
    }

    public void setIsVoucherCode(String isVoucherCode) {
        this.isVoucherCode = isVoucherCode;
    }

    public String getPayType() {
        return payType;
    }

    public void setPayType(String payType) {
        this.payType = payType;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}