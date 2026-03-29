package vn.edu.nlu.fit.datxedulich.dao;

import vn.edu.nlu.fit.datxedulich.model.Payments;

import java.util.List;

public class PaymentsDAO extends BaseDao {

    public boolean createPayment(Payments payment) {
        return get().withHandle(handle ->
                handle.createUpdate("INSERT INTO payments (booking_id, account_id, price, km, method, pay_type, status, paid_at, created_by)" +
                                "VALUES (:booking_id, :account_id, :price, :km, :method, :pay_type, :status, :paid_at, :created_by)")
                        .bindBean(payment)
                        .execute() > 0
        );
    }

    public List<Payments> getPaymentsByAccount (int accountId) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM payments WHERE account_id = :accountId ORDER BY paid_at DESC")
                        .bind("accountId", accountId)
                        .mapToBean(Payments.class)
                        .list()
        );
    }

    public List<Payments> getAllPayments() {
        return get().withHandle(handle ->
          handle.createQuery("SELECT payment_id AS paymentId, booking_id AS bookingId, account_id AS accountId, " +
                  "price, km, method, pay_type AS payType, status, paid_at AS paidAt, created_by AS createdBy" +
                  "FROM payments ORDER BY payment_id DESC")
                  .mapToBean(Payments.class)
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

    public boolean updatePayment(Payments payment) {
        return get().withHandle(handle ->
                handle.createUpdate("UPDATE payments SET booking_id = :bookingId, account_id = :accountId, " +
                                "price = :price, method = :method, pay_type = :payType, status = :status " +
                                "WHERE payment_id = :paymentId")
                        .bindBean(payment)
                        .execute() > 0
        );
    }
}
