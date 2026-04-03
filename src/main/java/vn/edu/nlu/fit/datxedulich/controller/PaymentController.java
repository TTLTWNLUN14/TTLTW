package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.Payment;
import vn.edu.nlu.fit.datxedulich.model.cart.Cart;
import vn.edu.nlu.fit.datxedulich.services.PaymentService;

import java.io.IOException;

@WebServlet(name = "PaymentController", value = "/payments")
public class PaymentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        request.setAttribute("cart", cart);
        request.getRequestDispatcher("/WEB-INF/views/payment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            int price = Integer.parseInt(request.getParameter("price"));
            String method = request.getParameter("method");
            String payType = request.getParameter("payType");

            Payment payment = new Payment();
            payment.setBookingId(bookingId);
            payment.setAccountId(1);
            payment.setPrice(price);
            payment.setPayType(payType);
            payment.setMethod(method);
            payment.setStatus("PENDING");
            payment.setCreatedBy(1);

            PaymentService paymentService = new PaymentService();
            paymentService.createPayment(payment);

            if ("TRANSFER".equalsIgnoreCase(method)) {
                response.sendRedirect(request.getContextPath() + "/payment-qr");
            } else {
                response.sendRedirect(request.getContextPath() + "/payment-confirmation");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}