package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.dao.PaymentsDAO;
import vn.edu.nlu.fit.datxedulich.model.Payments;

import java.util.List;

public class PaymentService {
    private PaymentsDAO paymentsDAO = new PaymentsDAO();

    public boolean createPayment(Payments payment) {
        return paymentsDAO.createPayment(payment);
    }

    public List<Payments> getAllPayments() {
        return paymentsDAO.getAllPayments();
    }

    public List<Payments> getPaymentsByAccountId(int accountId) {
        return paymentsDAO.getPaymentsByAccount(accountId);
    }

    public boolean updatePaymentStatus(int paymentId, String status) {
        return paymentsDAO.updatePaymentStatus(paymentId,status);
    }
}
