package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.dao.PaymentDAO;
import vn.edu.nlu.fit.datxedulich.model.Payment;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminPaymentController", value = "/admin/payments")
public class AdminPaymentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PaymentDAO paymentDAO = new PaymentDAO();
        List<Payment> paymentList = paymentDAO.getAllPayments();

        request.setAttribute("listPayments", paymentList);
        request.getRequestDispatcher("/admin/admin-payments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        PaymentDAO paymentDAO = new PaymentDAO();

        try {
            if ("approve".equals(action)) {
                int paymentId = Integer.parseInt(request.getParameter("paymentId"));
                paymentDAO.updatePaymentStatus(paymentId, "SUCCESS");

            } else if ("reject".equals(action)) {
                int paymentId = Integer.parseInt(request.getParameter("paymentId"));
                paymentDAO.updatePaymentStatus(paymentId, "FAILED");

            } else if ("delete".equals(action)) {
                int paymentId = Integer.parseInt(request.getParameter("paymentId"));
                paymentDAO.deletePayment(paymentId);

            } else if ("create".equals(action)) {
                Payment payment = new Payment();
                payment.setBookingId(Integer.parseInt(request.getParameter("bookingId")));
                payment.setAccountId(Integer.parseInt(request.getParameter("accountId")));
                payment.setPrice(Integer.parseInt(request.getParameter("price")));
                payment.setMethod(request.getParameter("method"));
                payment.setPayType(request.getParameter("payType"));
                payment.setStatus(request.getParameter("status"));
                payment.setCreatedBy(1);
                paymentDAO.createPayment(payment);

            } else if ("update".equals(action)) {
                Payment payment = new Payment();
                payment.setPaymentId(Integer.parseInt(request.getParameter("paymentId")));
                payment.setBookingId(Integer.parseInt(request.getParameter("bookingId")));
                payment.setAccountId(Integer.parseInt(request.getParameter("accountId")));
                payment.setPrice(Integer.parseInt(request.getParameter("price")));
                payment.setMethod(request.getParameter("method"));
                payment.setPayType(request.getParameter("payType"));
                payment.setStatus(request.getParameter("status"));
                paymentDAO.updatePayment(payment);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/payments?error=true");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/admin/payments");
    }
}