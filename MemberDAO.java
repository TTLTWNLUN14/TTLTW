package vn.edu.nlu.fit.datxedulich.dao;

import vn.edu.nlu.fit.datxedulich.model.Member;
import vn.edu.nlu.fit.datxedulich.model.Booking;
import java.util.List;

public class MemberDAO extends BaseDao {

    public Member getMemberById(int accountId) {
        return get().withHandle(h ->
                h.createQuery(
                                "SELECT a.account_id as memberId, a.full_name as fullName, a.email, " +
                                        "a.phone, a.birthday, a.gender, a.cccd, a.address, " +
                                        "COALESCE(c.member, 'BRONZE') as memberTier, COALESCE(c.points, 0) as points, " +
                                        "COALESCE((SELECT COUNT(*) FROM bookings b WHERE b.customer_id = c.customer_id), 0) as totalTrips, " +
                                        "COALESCE((SELECT SUM(b.total_price) FROM bookings b WHERE b.customer_id = c.customer_id), 0) as totalSpent, " +
                                        "DATE(a.first_login) as joinDate " +
                                        "FROM accounts a " +
                                        "LEFT JOIN customers c ON a.account_id = c.account_id " +
                                        "WHERE a.account_id = :accountId"
                        )
                        .bind("accountId", accountId)
                        .mapToBean(Member.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public boolean updateMember(Member member) {
        try {
            get().useHandle(h ->
                    h.createUpdate(
                                    "UPDATE accounts SET full_name = :fullName, email = :email, " +
                                            "phone = :phone, birthday = :birthday, gender = :gender, " +
                                            "cccd = :cccd, address = :address WHERE account_id = :memberId"
                            )
                            .bind("fullName", member.getFullName())
                            .bind("email", member.getEmail())
                            .bind("phone", member.getPhone())
                            .bind("birthday", member.getBirthday())
                            .bind("gender", member.getGender())
                            .bind("cccd", member.getCccd())
                            .bind("address", member.getAddress())
                            .bind("memberId", member.getMemberId())
                            .execute()
            );
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Booking> getMemberBookingHistory(int accountId) {
        return get().withHandle(h ->
                h.createQuery(
                                "SELECT b.booking_id as bookingId, b.customer_id as customerId, " +
                                        "ct.type_name as carName, " +
                                        "CONCAT(b.pickup_province, ' → ', b.dropoff_province) as route, " +
                                        "DATE(b.pickup_date) as bookingDate, b.total_price as totalPrice, " +
                                        "CASE WHEN b.return_date < NOW() THEN 'Hoàn thành' " +
                                        "WHEN b.pickup_date > NOW() THEN 'Chờ xác nhận' ELSE 'Đang diễn ra' END as status " +
                                        "FROM bookings b " +
                                        "INNER JOIN customers c ON b.customer_id = c.customer_id " +
                                        "INNER JOIN car_types ct ON b.type_id = ct.type_id " +
                                        "WHERE c.account_id = :accountId " +
                                        "ORDER BY b.pickup_date DESC"
                        )
                        .bind("accountId", accountId)
                        .mapToBean(Booking.class)
                        .list()
        );
    }

    public boolean updatePassword(int accountId, String newPassword) {
        try {
            get().useHandle(h ->
                    h.createUpdate("UPDATE accounts SET password_hash = :password WHERE account_id = :accountId")
                            .bind("password", newPassword)
                            .bind("accountId", accountId)
                            .execute()
            );
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public void deleteBooking(int bookingId) {
        try {
            get().useHandle(h ->
                    h.createUpdate("DELETE FROM bookings WHERE booking_id = :bookingId")
                            .bind("bookingId", bookingId)
                            .execute()
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteAllBookings(int accountId) {
        try {
            get().useHandle(h ->
                    h.createUpdate(
                                    "DELETE FROM bookings WHERE customer_id IN " +
                                            "(SELECT customer_id FROM customers WHERE account_id = :accountId)"
                            )
                            .bind("accountId", accountId)
                            .execute()
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}