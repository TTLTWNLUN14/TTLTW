package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "PaymentQRController", value = "/payment-qr")
public class PaymentQRController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String price = request.getParameter("price");
        request.setAttribute("price", price);

        request.getRequestDispatcher("/WEB-INF/views/payment-qr.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}