package vn.edu.nlu.fit.datxedulich.dao;

import vn.edu.nlu.fit.datxedulich.model.Payment;
import vn.edu.nlu.fit.datxedulich.model.Voucher;

import java.util.List;

public class PaymentDAO extends BaseDao {

    public boolean createPayment(Payment payment) {
        return get().withHandle(handle ->
                handle.createUpdate("INSERT INTO payments (booking_id, account_id, voucher_id, price, km, method, pay_type, status, paid_at, created_by)" +
                                "VALUES (:booking_id, :account_id, :voucher_id, :price, :km, :method, :pay_type, :status, :paid_at, :created_by)")
                        .bindBean(payment)
                        .execute() > 0
        );
    }


    public List<Payment> getPaymentsByAccount (int accountId) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM payments WHERE account_id = :accountId ORDER BY paid_at DESC")
                        .bind("accountId", accountId)
                        .mapToBean(Payment.class)
                        .list()
        );
    }

    public List<Payment> getAllPayments() {
        return get().withHandle(handle ->
          handle.createQuery("SELECT payment_id AS paymentId, booking_id AS bookingId, account_id AS accountId, voucher_id AS voucherId, " +
                  "price, km, method, pay_type AS payType, status, paid_at AS paidAt, created_by AS createdBy " +
                  "FROM payments ORDER BY payment_id DESC")
                  .mapToBean(Payment.class)
                  .list()
        );
    }

    public boolean updatePaymentStatus(int paymentId, String status ) {
        return get().withHandle(handle ->
                handle.createUpdate("UPDATE payments SET status = :status, paid_at = CURRENT_TIMESTAMP WHERE payment_id = :paymentId")
                        .bind("status", status)
                        .bind("paymentId", paymentId)
                        .execute() > 0
                );
    }

    public boolean deletePayment(int paymentId) {
        return get().withHandle(handle ->
                handle.createUpdate("DELETE FROM payments WHERE payment_id = :paymentId")
                        .bind("paymentId", paymentId)
                        .execute() > 0
        );
    }

    public boolean updatePayment(Payment payment) {
        return get().withHandle(handle ->
                handle.createUpdate("UPDATE payments SET booking_id = :bookingId, account_id = :accountId, voucher_id = :voucherId, " +
                                "price = :price, method = :method, pay_type = :payType, status = :status " +
                                "WHERE payment_id = :paymentId")
                        .bindBean(payment)
                        .execute() > 0
        );
    }

    public List<Voucher> getActiveVouchers(double orderPrice) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM voucher WHERE is_active = TRUE " +
                                "AND uses_left > 0 " +
                                "AND expires_at >= NOW() " +
                                "AND min_order <= :orderPrice")
                        .bind("orderPrice", orderPrice)
                        .mapToBean(Voucher.class)
                        .list()
        );
    }

    public boolean validateVoucher(int voucherId, double orderPrice) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM voucher WHERE voucher_id = :voucherId " +
                                "AND is_active = TRUE AND uses_left > 0 AND expires_at >= NOW() AND min_order <= :orderPrice")
                        .bind("voucherId", voucherId)
                        .bind("orderPrice", orderPrice)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    public boolean reduceVoucherUsage(int voucherId) {
        return get().withHandle(handle ->
                handle.createUpdate("UPDATE voucher SET uses_left = uses_left - 1 WHERE voucher_id = :voucherId AND uses_left > 0")
                        .bind("voucherId", voucherId)
                        .execute() > 0
        );
    }
}
