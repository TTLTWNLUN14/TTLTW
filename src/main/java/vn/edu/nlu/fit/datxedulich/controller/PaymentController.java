package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.dao.PaymentsDAO;
import vn.edu.nlu.fit.datxedulich.model.Payments;

import java.io.IOException;

@WebServlet(name = "PaymentController", value = "/payments")
public class PaymentController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        int price = Integer.parseInt(request.getParameter("price"));
        String method = request.getParameter("method");
        String payType = request.getParameter("payType");

        Payments payments = new Payments();
        payments.setBookingId(bookingId);
        payments.setAccountId(1);
        payments.setPrice(price);
        payments.setPayType(payType);
        payments.setMethod(method);
        payments.setStatus("PENDING");
        payments.setCreatedBy(1);

        PaymentsDAO paymentsDAO = new PaymentsDAO();
        paymentsDAO.createPayment(payments);

        response.sendRedirect(request.getContextPath() + "/payments_confirmation.html");
    }
}