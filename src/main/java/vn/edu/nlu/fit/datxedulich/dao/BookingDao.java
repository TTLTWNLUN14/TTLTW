package vn.edu.nlu.fit.datxedulich.dao;

import vn.edu.nlu.fit.datxedulich.model.Booking;

import java.util.List;

public class BookingDao  extends BaseDao{
    public Booking getBookingById(int bookingId) {
        return get().withHandle(h ->
                h.createQuery("SELECT booking_id AS bookingId, customer_id AS customerId, type_id AS typeId, " +
                                "voucher_id AS voucherId, is_driver AS isDriver, pickup_province AS pickupProvince, " +
                                "dropoff_province AS dropoffProvince, pickup_date AS pickupDate, pickup_time AS pickupTime, " +
                                "return_date AS returnDate, km, days, base_price AS basePrice, member_discount AS memberDiscount, " +
                                "voucher_discount AS voucherDiscount, total_price AS totalPrice, is_voucher_code AS isVoucherCode, " +
                                "pay_type AS payType, note, created_at AS createdAt, updated_at AS updatedAt " +
                                "FROM bookings WHERE booking_id = :bookingId")
                        .bind("bookingId", bookingId)
                        .mapToBean(Booking.class)
                        .first()
        );
    }

    public List<Booking> getBookingsByCustomerId(int customerId) {
        return get().withHandle(h ->
                h.createQuery("SELECT booking_id AS bookingId, customer_id AS customerId, type_id AS typeId, " +
                                "voucher_id AS voucherId, is_driver AS isDriver, pickup_province AS pickupProvince, " +
                                "dropoff_province AS dropoffProvince, pickup_date AS pickupDate, pickup_time AS pickupTime, " +
                                "return_date AS returnDate, km, days, base_price AS basePrice, member_discount AS memberDiscount, " +
                                "voucher_discount AS voucherDiscount, total_price AS totalPrice, is_voucher_code AS isVoucherCode, " +
                                "pay_type AS payType, note, created_at AS createdAt, updated_at AS updatedAt " +
                                "FROM bookings WHERE customer_id = :customerId ORDER BY booking_id DESC")
                        .bind("customerId", customerId)
                        .mapToBean(Booking.class)
                        .list()
        );
    }

    public boolean createBooking(Booking booking) {
        int rows = get().withHandle(h ->
                h.createUpdate("INSERT INTO bookings (customer_id, type_id, voucher_id, is_driver, " +
                                "pickup_province, dropoff_province, pickup_date, pickup_time, return_date, km, days, " +
                                "base_price, member_discount, voucher_discount, total_price, is_voucher_code, pay_type, note, created_at, updated_at) " +
                                "VALUES (:customerId, :typeId, :voucherId, :isDriver, :pickupProvince, :dropoffProvince, " +
                                ":pickupDate, :pickupTime, :returnDate, :km, :days, :basePrice, :memberDiscount, " +
                                ":voucherDiscount, :totalPrice, :isVoucherCode, :payType, :note, NOW(), NOW())")
                        .bindBean(booking)
                        .execute()
        );
        return rows > 0;
    }

    public boolean updateBooking(Booking booking) {
        int rows = get().withHandle(h ->
                h.createUpdate("UPDATE bookings SET customer_id = :customerId, type_id = :typeId, " +
                                "voucher_id = :voucherId, is_driver = :isDriver, pickup_province = :pickupProvince, " +
                                "dropoff_province = :dropoffProvince, pickup_date = :pickupDate, pickup_time = :pickupTime, " +
                                "return_date = :returnDate, km = :km, days = :days, base_price = :basePrice, " +
                                "member_discount = :memberDiscount, voucher_discount = :voucherDiscount, " +
                                "total_price = :totalPrice, is_voucher_code = :isVoucherCode, pay_type = :payType, " +
                                "note = :note, updated_at = NOW() WHERE booking_id = :bookingId")
                        .bindBean(booking)
                        .execute()
        );
        return rows > 0;
    }

    public boolean deleteBooking(int bookingId) {
        int rows = get().withHandle(h ->
                h.createUpdate("DELETE FROM bookings WHERE booking_id = :bookingId")
                        .bind("bookingId", bookingId)
                        .execute()
        );
        return rows > 0;
    }

    public List<Booking> getAllBookings() {
        return get().withHandle(h ->
                h.createQuery("SELECT booking_id AS bookingId, customer_id AS customerId, type_id AS typeId, " +
                                "voucher_id AS voucherId, is_driver AS isDriver, pickup_province AS pickupProvince, " +
                                "dropoff_province AS dropoffProvince, pickup_date AS pickupDate, pickup_time AS pickupTime, " +
                                "return_date AS returnDate, km, days, base_price AS basePrice, member_discount AS memberDiscount, " +
                                "voucher_discount AS voucherDiscount, total_price AS totalPrice, is_voucher_code AS isVoucherCode, " +
                                "pay_type AS payType, note, created_at AS createdAt, updated_at AS updatedAt " +
                                "FROM bookings ORDER BY booking_id DESC")
                        .mapToBean(Booking.class)
                        .list()
        );
    }
}
