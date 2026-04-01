package vn.edu.nlu.fit.datxedulich.dao;

import vn.edu.nlu.fit.datxedulich.model.Member;
import vn.edu.nlu.fit.datxedulich.model.Product;
import java.util.List;

public class MemberDAO extends BaseDao {


    public Member getMemberById(int accountId) {
        return get().withHandle(h ->
                h.createQuery("SELECT a.account_id as memberId, " + "a.full_name, a.email, a.phone, a.birthday as dob, " + "a.gender, a.cccd, a.address, " + "c.member as memberTier, c.points, " + "0 as totalTrips, 0 as totalSpent, a.first_login as joinDate " + "FROM accounts a " + "LEFT JOIN customers c ON a.account_id = c.account_id " + "WHERE a.account_id = :accountId")
                        .bind("accountId", accountId)
                        .mapToBean(Member.class)
                        .findFirst()
                        .orElse(null)
        );
    }


    public boolean updateMember(Member member) {
        try {
            get().useHandle(h ->
                    h.createUpdate("UPDATE accounts SET " + "full_name = :fullName, email = :email, " + "phone = :phone, birthday = :dob, gender = :gender, " + "cccd = :cccd, address = :address " + "WHERE account_id = :memberId")
                            .bind("fullName", member.getFullName())
                            .bind("email", member.getEmail())
                            .bind("phone", member.getPhone())
                            .bind("dob", member.getDob())
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

    public List<Product> getMemberBookingHistory(int accountId) {
        return get().withHandle(h ->
                h.createQuery("SELECT b.booking_id as bookingId, " + "b.customer_id, ct.type_name as carName, " + "CONCAT(b.pickup_province, ' → ', b.dropoff_province) as route, " + "b.pickup_date as bookingDate, b.total_price as totalPrice, " + "'Hoàn thành' as status " + "FROM bookings b " + "INNER JOIN customers c ON b.customer_id = c.customer_id " + "INNER JOIN car_types ct ON b.type_id = ct.type_id " + "WHERE c.account_id = :accountId " + "ORDER BY b.pickup_date DESC").bind("accountId", accountId).mapToBean(Product.class).list()
        );
    }


    public void deleteBooking(int bookingId) {
        try {
            get().useHandle(h ->
                    h.createUpdate("DELETE FROM bookings WHERE booking_id = :bookingId").bind("bookingId", bookingId).execute()
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public void deleteAllBookings(int accountId) {
        try {
            get().useHandle(h ->
                    h.createUpdate("DELETE FROM bookings WHERE customer_id IN " + "(SELECT customer_id FROM customers WHERE account_id = :accountId)").bind("accountId", accountId).execute()
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}