package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.dao.PaymentsDAO;
import vn.edu.nlu.fit.datxedulich.model.Payments;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminPaymentController", value = "/admin/payments")
public class AdminPaymentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PaymentsDAO paymentsDAO = new PaymentsDAO();
        List<Payments> paymentsList = paymentsDAO.getAllPayments();

        request.setAttribute("listPayments", paymentsList);
        request.getRequestDispatcher("/admin/admin-payments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        PaymentsDAO paymentsDAO = new PaymentsDAO();

        try {
            if ("approve".equals(action)) {
                int paymentId = Integer.parseInt(request.getParameter("paymentId"));
                paymentsDAO.updatePaymentStatus(paymentId, "SUCCESS");

            } else if ("reject".equals(action)) {
                int paymentId = Integer.parseInt(request.getParameter("paymentId"));
                paymentsDAO.updatePaymentStatus(paymentId, "FAILED");

            } else if ("delete".equals(action)) {
                int paymentId = Integer.parseInt(request.getParameter("paymentId"));
                paymentsDAO.deletePayment(paymentId);

            } else if ("create".equals(action)) {
                Payments payments = new Payments();
                payments.setBookingId(Integer.parseInt(request.getParameter("bookingId")));
                payments.setAccountId(Integer.parseInt(request.getParameter("accountId")));
                payments.setPrice(Integer.parseInt(request.getParameter("price")));
                payments.setMethod(request.getParameter("method"));
                payments.setPayType(request.getParameter("payType"));
                payments.setStatus(request.getParameter("status"));
                payments.setCreatedBy(1);
                paymentsDAO.createPayment(payments);

            } else if ("update".equals(action)) {
                Payments payments = new Payments();
                payments.setPaymentId(Integer.parseInt(request.getParameter("paymentId")));
                payments.setBookingId(Integer.parseInt(request.getParameter("bookingId")));
                payments.setAccountId(Integer.parseInt(request.getParameter("accountId")));
                payments.setPrice(Integer.parseInt(request.getParameter("price")));
                payments.setMethod(request.getParameter("method"));
                payments.setPayType(request.getParameter("payType"));
                payments.setStatus(request.getParameter("status"));
                paymentsDAO.updatePayment(payments);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/payments?error=true");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/admin/payments");
    }
}