package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.Voucher;
import vn.edu.nlu.fit.datxedulich.services.VoucherService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "VoucherController", value = "/voucher")
public class VoucherController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String redirect = request.getParameter("redirect");
        String bookingId = request.getParameter("bookingId");
        String priceStr = request.getParameter("price");
        double price = (priceStr != null) ? Double.parseDouble(priceStr) : 0;
        String km = request.getParameter("km");

        VoucherService voucherService = new VoucherService();
        List<Voucher>   vouchers = voucherService.getAvailableVouchers(price);

        request.setAttribute("vouchers", vouchers);
        request.setAttribute("bookingId", bookingId);
        request.setAttribute("price", price);
        request.setAttribute("km", km);

        request.getRequestDispatcher("/WEB-INF/views/voucher.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int voucherId = Integer.parseInt(request.getParameter("voucherId"));
        String redirect = request.getParameter("redirect");
        String bookingId = request.getParameter("bookingId");
        String price = request.getParameter("price");
        String km = request.getParameter("km");

        response.sendRedirect(request.getContextPath() + "/" + redirect + "?voucherId=" + voucherId + "&bookingId=" + bookingId + "&price=" + price + "&km=" + km);
    }
}
