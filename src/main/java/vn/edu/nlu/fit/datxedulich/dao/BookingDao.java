package vn.edu.nlu.fit.datxedulich.dao;

import vn.edu.nlu.fit.datxedulich.model.Booking;

import java.util.List;
import java.util.stream.Collectors;

public class BookingDao extends BaseDao {

    // INSERT một booking, trả về bookingId mới được sinh ra
    public int insertBooking(Booking b) {
        return get().withHandle(h ->
                h.createUpdate(
                                "INSERT INTO bookings " +
                                        "(customer_id, type_id, voucher_id, pickup_province, dropoff_province, " +
                                        " pickup_date, return_date, km, days, base_price, member_discount, " +
                                        " voucher_discount, is_voucher_code, pay_type, total_price, " +
                                        " booker_name, booker_phone, booker_address, note, " +
                                        " status, payment_status, created_at, updated_at) " +
                                        "VALUES " +
                                        "(:customerId, :typeId, :voucherId, :pickupProvince, :dropoffProvince, " +
                                        " :pickupTime, :returnTime, :km, :days, :basePrice, :memberDiscount, " +
                                        " :voucherDiscount, :isVoucherCode, :payType, :totalPrice, " +
                                        " :bookerName, :bookerPhone, :bookerAddress, :note, " +
                                        " 'Chờ xác nhận', 'PENDING', NOW(), NOW())"
                        )
                        .bind("customerId",      b.getCustomerId())
                        .bind("typeId",          b.getTypeId())
                        .bind("voucherId",       b.getVoucherId())
                        .bind("pickupProvince",  b.getPickupProvince())
                        .bind("dropoffProvince", b.getDropoffProvince())
                        .bind("pickupTime",      b.getPickupTime())
                        .bind("returnTime",      b.getReturnTime())
                        .bind("km",              b.getKm())
                        .bind("days",            b.getDays())
                        .bind("basePrice",       b.getBasePrice())
                        .bind("memberDiscount",  b.getMemberDiscount())
                        .bind("voucherDiscount", b.getVoucherDiscount())
                        .bind("isVoucherCode",   b.getIsVoucherCode())
                        .bind("payType",         b.getPayType())
                        .bind("totalPrice",      b.getTotalPrice())
                        .bind("bookerName",      b.getBookerName())
                        .bind("bookerPhone",     b.getBookerPhone())
                        .bind("bookerAddress",   b.getBookerAddress())
                        .bind("note",            b.getNote())
                        .executeAndReturnGeneratedKeys("booking_id")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    // Load nhiều booking theo danh sách id — dùng cho payment.jsp và confirmation
    public List<Booking> getBookingsByIds(List<Integer> ids) {
        if (ids == null || ids.isEmpty()) return List.of();

        String placeholders = ids.stream()
                .map(i -> "?")
                .collect(Collectors.joining(", "));

        return get().withHandle(h -> {
            var q = h.createQuery(
                    "SELECT b.booking_id as bookingId, b.customer_id as customerId, b.type_id as typeId, " +
                            "       b.voucher_id as voucherId, " +
                            "       ct.type_name as carName, " +
                            "       b.pickup_province as pickupProvince, b.dropoff_province as dropoffProvince, " +
                            "       CONCAT(b.pickup_province, ' → ', b.dropoff_province) as route, " +
                            "       b.km, b.days, b.base_price as basePrice, b.member_discount as memberDiscount, " +
                            "       b.voucher_discount as voucherDiscount, b.is_voucher_code as isVoucherCode, " +
                            "       b.pay_type as payType, b.pickup_date as pickupTime, b.return_date as returnTime, " +
                            "       b.total_price as totalPrice, " +
                            "       b.booker_name as bookerName, b.booker_phone as bookerPhone, " +
                            "       b.booker_address as bookerAddress, b.note, " +
                            "       b.status, b.payment_status as paymentStatus, " +
                            "       DATE(b.pickup_date) as bookingDate, b.created_at as createdAt, b.updated_at as updatedAt " +
                            "FROM bookings b " +
                            "INNER JOIN car_types ct ON b.type_id = ct.type_id " +
                            "WHERE b.booking_id IN (" + placeholders + ")"
            );
            for (int i = 0; i < ids.size(); i++) {
                q = q.bind(i, ids.get(i));
            }
            return q.mapToBean(Booking.class).list();
        });
    }

    // Cập nhật payment_status cho nhiều booking cùng lúc
    public void updatePaymentStatus(List<Integer> bookingIds, String paymentStatus) {
        if (bookingIds == null || bookingIds.isEmpty()) return;

        String placeholders = bookingIds.stream()
                .map(i -> "?")
                .collect(Collectors.joining(", "));

        get().useHandle(h -> {
            var u = h.createUpdate(
                    "UPDATE bookings SET payment_status = ?, updated_at = NOW() WHERE booking_id IN (" + placeholders + ")"
            ).bind(0, paymentStatus);

            for (int i = 0; i < bookingIds.size(); i++) {
                u = u.bind(i + 1, bookingIds.get(i));
            }
            u.execute();
        });
    }

    // lấy 1 booking theo id
    public Booking getBookingById(int bookingId) {
        return get().withHandle(h ->
                h.createQuery(
                                "SELECT b.booking_id as bookingId, b.customer_id as customerId, b.type_id as typeId, " +
                                        "       b.voucher_id as voucherId, " +
                                        "       ct.type_name as carName, " +
                                        "       b.pickup_province as pickupProvince, b.dropoff_province as dropoffProvince, " +
                                        "       CONCAT(b.pickup_province, ' → ', b.dropoff_province) as route, " +
                                        "       b.km, b.days, b.base_price as basePrice, b.member_discount as memberDiscount, " +
                                        "       b.voucher_discount as voucherDiscount, b.is_voucher_code as isVoucherCode, " +
                                        "       b.pay_type as payType, b.pickup_date as pickupTime, b.return_date as returnTime, " +
                                        "       b.total_price as totalPrice, " +
                                        "       b.booker_name as bookerName, b.booker_phone as bookerPhone, " +
                                        "       b.booker_address as bookerAddress, b.note, " +
                                        "       b.status, b.payment_status as paymentStatus, " +
                                        "       DATE(b.pickup_date) as bookingDate, b.created_at as createdAt, b.updated_at as updatedAt " +
                                        "FROM bookings b " +
                                        "INNER JOIN car_types ct ON b.type_id = ct.type_id " +
                                        "WHERE b.booking_id = :id")
                        .bind("id", bookingId)
                        .mapToBean(Booking.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    // lấy danh sách booking của 1 khách hàng, mới nhất trước
    public List<Booking> getBookingsByCustomerId(int customerId) {
        return get().withHandle(h ->
                h.createQuery(
                                "SELECT b.booking_id as bookingId, b.customer_id as customerId, b.type_id as typeId, " +
                                        "       b.voucher_id as voucherId, " +
                                        "       ct.type_name as carName, " +
                                        "       b.pickup_province as pickupProvince, b.dropoff_province as dropoffProvince, " +
                                        "       CONCAT(b.pickup_province, ' → ', b.dropoff_province) as route, " +
                                        "       b.km, b.days, b.base_price as basePrice, b.member_discount as memberDiscount, " +
                                        "       b.voucher_discount as voucherDiscount, b.is_voucher_code as isVoucherCode, " +
                                        "       b.pay_type as payType, b.pickup_date as pickupTime, b.return_date as returnTime, " +
                                        "       b.total_price as totalPrice, " +
                                        "       b.booker_name as bookerName, b.booker_phone as bookerPhone, " +
                                        "       b.booker_address as bookerAddress, b.note, " +
                                        "       b.status, b.payment_status as paymentStatus, " +
                                        "       DATE(b.pickup_date) as bookingDate, b.created_at as createdAt, b.updated_at as updatedAt " +
                                        "FROM bookings b " +
                                        "INNER JOIN car_types ct ON b.type_id = ct.type_id " +
                                        "WHERE b.customer_id = :customerId " +
                                        "ORDER BY b.created_at DESC")
                        .bind("customerId", customerId)
                        .mapToBean(Booking.class)
                        .list()
        );
    }

    // lấy tất cả booking (dùng cho trang admin)
    public List<Booking> getAllBookings() {
        return get().withHandle(h ->
                h.createQuery(
                                "SELECT b.booking_id as bookingId, b.customer_id as customerId, b.type_id as typeId, " +
                                        "       b.voucher_id as voucherId, " +
                                        "       ct.type_name as carName, " +
                                        "       b.pickup_province as pickupProvince, b.dropoff_province as dropoffProvince, " +
                                        "       CONCAT(b.pickup_province, ' → ', b.dropoff_province) as route, " +
                                        "       b.km, b.days, b.base_price as basePrice, b.member_discount as memberDiscount, " +
                                        "       b.voucher_discount as voucherDiscount, b.is_voucher_code as isVoucherCode, " +
                                        "       b.pay_type as payType, b.pickup_date as pickupTime, b.return_date as returnTime, " +
                                        "       b.total_price as totalPrice, " +
                                        "       b.booker_name as bookerName, b.booker_phone as bookerPhone, " +
                                        "       b.booker_address as bookerAddress, b.note, " +
                                        "       b.status, b.payment_status as paymentStatus, " +
                                        "       DATE(b.pickup_date) as bookingDate, b.created_at as createdAt, b.updated_at as updatedAt " +
                                        "FROM bookings b " +
                                        "INNER JOIN car_types ct ON b.type_id = ct.type_id " +
                                        "ORDER BY b.created_at DESC")
                        .mapToBean(Booking.class)
                        .list()
        );
    }

    // tạo booking mới, trả về true nếu thành công
    public boolean createBooking(Booking b) {
        return insertBooking(b) > 0;
    }

    // cập nhật thông tin 1 booking
    public boolean updateBooking(Booking b) {
        int rows = get().withHandle(h ->
                h.createUpdate(
                                "UPDATE bookings SET " +
                                        "voucher_id = :voucherId, " +
                                        "pickup_province = :pickupProvince, " +
                                        "dropoff_province = :dropoffProvince, " +
                                        "pickup_date = :pickupTime, " +
                                        "return_date = :returnTime, " +
                                        "km = :km, " +
                                        "days = :days, " +
                                        "base_price = :basePrice, " +
                                        "member_discount = :memberDiscount, " +
                                        "voucher_discount = :voucherDiscount, " +
                                        "is_voucher_code = :isVoucherCode, " +
                                        "pay_type = :payType, " +
                                        "total_price = :totalPrice, " +
                                        "booker_name = :bookerName, " +
                                        "booker_phone = :bookerPhone, " +
                                        "booker_address = :bookerAddress, " +
                                        "note = :note, " +
                                        "status = :status, " +
                                        "payment_status = :paymentStatus, " +
                                        "updated_at = NOW() " +
                                        "WHERE booking_id = :bookingId")
                        .bind("voucherId",       b.getVoucherId())
                        .bind("pickupProvince",  b.getPickupProvince())
                        .bind("dropoffProvince", b.getDropoffProvince())
                        .bind("pickupTime",      b.getPickupTime())
                        .bind("returnTime",      b.getReturnTime())
                        .bind("km",              b.getKm())
                        .bind("days",            b.getDays())
                        .bind("basePrice",       b.getBasePrice())
                        .bind("memberDiscount",  b.getMemberDiscount())
                        .bind("voucherDiscount", b.getVoucherDiscount())
                        .bind("isVoucherCode",   b.getIsVoucherCode())
                        .bind("payType",         b.getPayType())
                        .bind("totalPrice",      b.getTotalPrice())
                        .bind("bookerName",      b.getBookerName())
                        .bind("bookerPhone",     b.getBookerPhone())
                        .bind("bookerAddress",   b.getBookerAddress())
                        .bind("note",            b.getNote())
                        .bind("status",          b.getStatus())
                        .bind("paymentStatus",   b.getPaymentStatus())
                        .bind("bookingId",       b.getBookingId())
                        .execute()
        );
        return rows > 0;
    }

    // xóa 1 booking theo id, trả về true nếu thành công
    public boolean deleteBooking(int bookingId) {
        int rows = get().withHandle(h ->
                h.createUpdate("DELETE FROM bookings WHERE booking_id = :id")
                        .bind("id", bookingId)
                        .execute()
        );
        return rows > 0;
    }
// list search booking
    public List<Booking> searchBookings(String keyword, String status,
                                        String dateFrom, String dateTo) {
        StringBuilder sql = new StringBuilder(
                "SELECT b.booking_id as bookingId, b.customer_id as customerId, b.type_id as typeId, " +
                        "       b.voucher_id as voucherId, " +
                        "       ct.type_name as carName, " +
                        "       b.pickup_province as pickupProvince, b.dropoff_province as dropoffProvince, " +
                        "       CONCAT(b.pickup_province, ' → ', b.dropoff_province) as route, " +
                        "       b.km, b.days, b.base_price as basePrice, b.member_discount as memberDiscount, " +
                        "       b.voucher_discount as voucherDiscount, b.is_voucher_code as isVoucherCode, " +
                        "       b.pay_type as payType, b.pickup_date as pickupTime, b.return_date as returnTime, " +
                        "       b.total_price as totalPrice, " +
                        "       b.booker_name as bookerName, b.booker_phone as bookerPhone, " +
                        "       b.booker_address as bookerAddress, b.note, " +
                        "       b.status, b.payment_status as paymentStatus, " +
                        "       DATE(b.pickup_date) as bookingDate, b.created_at as createdAt, b.updated_at as updatedAt " +
                        "FROM bookings b " +
                        "INNER JOIN car_types ct ON b.type_id = ct.type_id " +
                        "WHERE 1=1 "
        );

        if (keyword != null && !keyword.isBlank()) {
            sql.append("AND (b.booker_name LIKE :kw OR b.booker_phone LIKE :kw " +
                    "     OR CAST(b.booking_id AS CHAR) LIKE :kw " +
                    "     OR ct.type_name LIKE :kw) ");
        }
        if (status != null && !status.isBlank()) {
            sql.append("AND b.status = :status ");
        }
        if (dateFrom != null && !dateFrom.isBlank()) {
            sql.append("AND DATE(b.pickup_date) >= :dateFrom ");
        }
        if (dateTo != null && !dateTo.isBlank()) {
            sql.append("AND DATE(b.pickup_date) <= :dateTo ");
        }
        sql.append("ORDER BY b.created_at DESC");

        String finalSql = sql.toString();
        String kwParam  = (keyword != null && !keyword.isBlank()) ? "%" + keyword + "%" : null;

        return get().withHandle(h -> {
            var q = h.createQuery(finalSql);
            if (kwParam   != null) q = q.bind("kw",       kwParam);
            if (status    != null && !status.isBlank())   q = q.bind("status",   status);
            if (dateFrom  != null && !dateFrom.isBlank()) q = q.bind("dateFrom", dateFrom);
            if (dateTo    != null && !dateTo.isBlank())   q = q.bind("dateTo",   dateTo);
            return q.mapToBean(Booking.class).list();
        });
    }

// update status
    public boolean updateBookingStatus(int bookingId, String status) {
        int rows = get().withHandle(h ->
                h.createUpdate("UPDATE bookings SET status = :status, updated_at = NOW() " +
                                "WHERE booking_id = :id")
                        .bind("status", status)
                        .bind("id",     bookingId)
                        .execute()
        );
        return rows > 0;
    }
}