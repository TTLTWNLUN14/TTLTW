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
                                        "(customer_id, type_id, pickup_province, dropoff_province, " +
                                        " pickup_date, return_date, km, total_price, " +
                                        " booker_name, booker_phone, booker_address, note, " +
                                        " status, payment_status, created_at) " +
                                        "VALUES " +
                                        "(:customerId, :typeId, :pickupProvince, :dropoffProvince, " +
                                        " :pickupTime, :returnTime, :km, :totalPrice, " +
                                        " :bookerName, :bookerPhone, :bookerAddress, :note, " +
                                        " 'Chờ xác nhận', 'PENDING', NOW())"
                        )
                        .bind("customerId", b.getCustomerId())
                        .bind("typeId", b.getTypeId())
                        .bind("pickupProvince", b.getPickupProvince())
                        .bind("dropoffProvince", b.getDropoffProvince())
                        .bind("pickupTime", b.getPickupTime())
                        .bind("returnTime", b.getReturnTime())
                        .bind("km", b.getKm())
                        .bind("totalPrice", b.getTotalPrice())
                        .bind("bookerName", b.getBookerName())
                        .bind("bookerPhone", b.getBookerPhone())
                        .bind("bookerAddress", b.getBookerAddress())
                        .bind("note", b.getNote())
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
                            "       ct.type_name as carName, " +
                            "       b.pickup_province as pickupProvince, b.dropoff_province as dropoffProvince, " +
                            "       CONCAT(b.pickup_province, ' → ', b.dropoff_province) as route, " +
                            "       b.km, b.pickup_date as pickupTime, b.return_date as returnTime, " +
                            "       b.total_price as totalPrice, " +
                            "       b.booker_name as bookerName, b.booker_phone as bookerPhone, " +
                            "       b.booker_address as bookerAddress, b.note, " +
                            "       b.status, b.payment_status as paymentStatus, " +
                            "       DATE(b.pickup_date) as bookingDate, b.created_at as createdAt " +
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
                    "UPDATE bookings SET payment_status = ? WHERE booking_id IN (" + placeholders + ")"
            ).bind(0, paymentStatus);

            for (int i = 0; i < bookingIds.size(); i++) {
                u = u.bind(i + 1, bookingIds.get(i));
            }
            u.execute();
        });
    }
}
