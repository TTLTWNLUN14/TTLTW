package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.dao.PaymentDAO;
import vn.edu.nlu.fit.datxedulich.model.Payment;
import vn.edu.nlu.fit.datxedulich.model.Voucher;
import vn.edu.nlu.fit.datxedulich.services.PaymentService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "PaymentController", value = "/payment")
public class PaymentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PaymentDAO paymentDAO = new PaymentDAO();
        
        String bookingId = request.getParameter("bookingId");
        String voucherId = request.getParameter("voucherId");
        String price     = request.getParameter("price");
        String km        = request.getParameter("km");

        request.setAttribute("bookingId", bookingId);
        request.setAttribute("voucherId", voucherId != null ? voucherId : 0);
        request.setAttribute("price",     price);
        request.setAttribute("km",        km);

        request.getRequestDispatcher("/WEB-INF/views/payment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            int voucherId = Integer.parseInt(request.getParameter("voucherId"));
            int price = Integer.parseInt(request.getParameter("price"));
            int km = Integer.parseInt(request.getParameter("km") != null ? request.getParameter("km") : "0");
            String method = request.getParameter("method");
            String payType = request.getParameter("payType");

            HttpSession session   = request.getSession();
            Integer accountId = (Integer) session.getAttribute("accountId");
            if (accountId == null) accountId = 1;

            Payment payment = new Payment();
            payment.setBookingId(bookingId);
            payment.setAccountId(accountId);
            payment.setVoucherId(voucherId);
            payment.setPrice(price);
            payment.setKm(km);
            payment.setMethod(method);
            payment.setPayType(payType);
            payment.setCreatedBy(accountId);

            if ("DEPOSIT".equalsIgnoreCase(payType)) {
                payment.setStatus("PENDING");
                PaymentService paymentService = new PaymentService();
                boolean created = paymentService.createPayment(payment);

                if (created) {
                    response.sendRedirect(request.getContextPath()
                            + "/payment-confirmation?payType=DEPOSIT&price=" + price);
                } else {
                    response.sendRedirect(request.getContextPath()
                            + "/payments?error=true&bookingId=" + bookingId + "&price=" + price + "&km=" + km);
                }

            } else {
                payment.setStatus("PENDING");
                PaymentService paymentService = new PaymentService();
                boolean created = paymentService.createPayment(payment);

                if (created) {
                    if ("TRANSFER".equalsIgnoreCase(method)) {
                        response.sendRedirect(request.getContextPath() + "/payment-qr?price=" + price);
                    } else {
                        response.sendRedirect(request.getContextPath()
                                + "/payment-confirmation?payType=ONLINE&method=CASH&price=" + price);
                    }
                } else {
                    response.sendRedirect(request.getContextPath()
                            + "/payments?error=true&bookingId=" + bookingId + "&price=" + price + "&km=" + km);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/payments?error=true");
        }
    }
}