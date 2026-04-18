package vn.edu.nlu.fit.datxedulich.model;

import java.io.Serializable;
import java.time.LocalDate;

public class Booking implements Serializable {
    private int bookingId;
    private int customerId;
    private String carName;
    private String route;
    private LocalDate bookingDate;
    private int totalPrice;
    private String status;

    public Booking() {}

    public Booking(int bookingId, int customerId, String carName, String route,
                   LocalDate bookingDate, int totalPrice, String status) {
        this.bookingId = bookingId;
        this.customerId = customerId;
        this.carName = carName;
        this.route = route;
        this.bookingDate = bookingDate;
        this.totalPrice = totalPrice;
        this.status = status;
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

    public LocalDate getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(LocalDate bookingDate) {
        this.bookingDate = bookingDate;
    }

    public int getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(int totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}