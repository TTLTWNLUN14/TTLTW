package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.dao.PaymentDAO;
import vn.edu.nlu.fit.datxedulich.model.Payment;
import vn.edu.nlu.fit.datxedulich.model.Voucher;

import java.util.List;

public class PaymentService {
    private final PaymentDAO paymentDAO = new PaymentDAO();

    public boolean createPayment(Payment payment) {
        return paymentDAO.createPayment(payment);
    }

    public List<Payment> getAllPayments() {
        return paymentDAO.getAllPayments();
    }

    public List<Payment> getPaymentsByAccountId(int accountId) {
        return paymentDAO.getPaymentsByAccount(accountId);
    }

    public boolean updatePaymentStatus(int paymentId, String status) {
        return paymentDAO.updatePaymentStatus(paymentId,status);
    }


}
