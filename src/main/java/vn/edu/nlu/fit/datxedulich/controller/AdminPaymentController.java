package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.dao.PaymentDAO;
import vn.edu.nlu.fit.datxedulich.model.Payment;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminPaymentController", value = "/admin-payment")
public class AdminPaymentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PaymentDAO paymentDAO = new PaymentDAO();
        List<Payment> paymentList = paymentDAO.getAllPayments();

        request.setAttribute("listPayments", paymentList);
        request.getRequestDispatcher("/WEB-INF/views/payment-admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        PaymentDAO paymentDAO = new PaymentDAO();

        HttpSession session = request.getSession();
        Integer adminId = (Integer) session.getAttribute("adminId");
        if (adminId == null) adminId = 1;

        try {
            if ("create".equals("action")) {
                Payment payment = new Payment();
                payment.setBookingId(Integer.parseInt(request.getParameter("bookingId")));
                payment.setAccountId(Integer.parseInt(request.getParameter("accountId")));
                payment.setVoucherId(Integer.parseInt(request.getParameter("voucherId")));
                payment.setPrice(Integer.parseInt(request.getParameter("price")));
                payment.setKm(request.getParameter("km") != null && ! request.getParameter("km").isEmpty() ? Integer.parseInt(request.getParameter("km")) : 0);
                payment.setMethod(request.getParameter("method"));
                payment.setPayType(request.getParameter("payType"));
                payment.setStatus(request.getParameter("status") != null ? request.getParameter("status") : "PENDING");
                payment.setCreatedBy(adminId);
                paymentDAO.createPayment(payment);
            } else if ("update".equals(action)) {
                Payment payment = new Payment();
                payment.setPaymentId(Integer.parseInt(request.getParameter("paymentId")));
                payment.setBookingId(Integer.parseInt(request.getParameter("bookingId")));
                payment.setAccountId(Integer.parseInt(request.getParameter("accountId")));
                payment.setVoucherId(Integer.parseInt(request.getParameter("voucherId")));
                payment.setPrice(Integer.parseInt(request.getParameter("price")));
                payment.setKm(request.getParameter("km") != null && ! request.getParameter("km").isEmpty() ? Integer.parseInt(request.getParameter("km")) : 0);
                payment.setMethod(request.getParameter("method"));
                payment.setPayType(request.getParameter("payType"));
                payment.setStatus(request.getParameter("status"));
                paymentDAO.updatePayment(payment);
            } else if ("delete".equals(action)) {
                int paymentId = Integer.parseInt(request.getParameter("paymentId"));
                paymentDAO.deletePayment(paymentId);
            } else if ("approve".equals(action)) {
                int paymentId = Integer.parseInt(request.getParameter("paymentId"));
                paymentDAO.updatePaymentStatus(paymentId,"SUCCESS");
            } else if ("reject".equals(action)) {
                int paymentId = Integer.parseInt(request.getParameter("paymentId"));
                paymentDAO.updatePaymentStatus(paymentId,"FAIL");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/payment?error=true");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/admin-payment");
    }
}