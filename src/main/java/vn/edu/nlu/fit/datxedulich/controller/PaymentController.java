package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.dao.PaymentsDAO;
import vn.edu.nlu.fit.datxedulich.model.Payments;
import vn.edu.nlu.fit.datxedulich.services.PaymentService;

import java.io.IOException;

@WebServlet(name = "PaymentController", value = "/payments")
public class PaymentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/payment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            int price = Integer.parseInt(request.getParameter("price"));
            int km = Integer.parseInt(request.getParameter("km") != null ? request.getParameter("km") : "0");
            String method = request.getParameter("method");
            String payType = request.getParameter("payType");
            Payments payments = new Payments();
            payments.setBookingId(bookingId);
            payments.setAccountId(1);
            payments.setPrice(price);
            payments.setKm(km);
            payments.setPayType(payType);
            payments.setMethod(method);
            payments.setStatus("PENDING");
            payments.setCreatedBy(1);

            PaymentService paymentService = new PaymentService();
            paymentService.createPayment(payments);

            if ("TRANSFER".equalsIgnoreCase(method)) {
                response.sendRedirect(request.getContextPath() + "/assets/html/payment_qr.html");
            } else {
                response.sendRedirect(request.getContextPath() + "/assets/html/payment_confirmation.html");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}