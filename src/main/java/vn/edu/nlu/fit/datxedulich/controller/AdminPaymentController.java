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
        List<Payments> list = paymentsDAO.getAllPayments();

        request.setAttribute("listPayments", list);
        request.getRequestDispatcher("/admin/admin-payments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int paymentId = Integer.parseInt(request.getParameter("paymentId"));
        String action = request.getParameter("action");

        PaymentsDAO paymentsDAO = new PaymentsDAO();
        if (action.equals("approve")) {
            paymentsDAO.updatePaymentStatus(paymentId, "Success");
        } else {
            paymentsDAO.updatePaymentStatus(paymentId, "Failure");
        }

        response.sendRedirect(request.getContextPath() + "/admin/payments");
    }
}