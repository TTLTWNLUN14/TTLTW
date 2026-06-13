package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.dao.BookingDao;
import vn.edu.nlu.fit.datxedulich.model.Booking;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "PaymentConfirmationController", value = "/payment-confirmation")
public class PaymentConfirmationController extends HttpServlet {

    private final BookingDao bookingDAO = new BookingDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String paidIdsParam = (String) session.getAttribute("paidBookingIds");
        if (paidIdsParam == null || paidIdsParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/my-shopping-cart");
            return;
        }

        List<Integer> bookingIds = Arrays.stream(paidIdsParam.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .map(Integer::parseInt)
                .collect(Collectors.toList());

        List<Booking> bookings = bookingDAO.getBookingsByIds(bookingIds);

        Integer paymentGrandTotal = (Integer) session.getAttribute("paymentGrandTotal");
        int grandTotal = (paymentGrandTotal != null) ? paymentGrandTotal
                : bookings.stream().mapToInt(Booking::getTotalPrice).sum();
        String method = (String) session.getAttribute("paymentMethod");

        request.setAttribute("bookings", bookings);
        request.setAttribute("grandTotal", grandTotal);
        request.setAttribute("method", method);

        // Xóa session sau khi đã hiển thị (tránh reload load lại)
        session.removeAttribute("paidBookingIds");
        session.removeAttribute("paymentMethod");
        session.removeAttribute("paymentGrandTotal");

        request.getRequestDispatcher("/WEB-INF/views/payment-confirmation.jsp")
                .forward(request, response);
    }
}
