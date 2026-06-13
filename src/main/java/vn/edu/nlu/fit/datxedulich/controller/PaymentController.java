package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.dao.BookingDao;
import vn.edu.nlu.fit.datxedulich.model.Booking;
import vn.edu.nlu.fit.datxedulich.model.Payment;
import vn.edu.nlu.fit.datxedulich.services.PaymentService;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;


@WebServlet(name = "PaymentController", value = "/payments")
public class PaymentController extends HttpServlet {

    private final BookingDao bookingDAO = new BookingDao();
    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String bookingIdsParam = request.getParameter("bookingIds");
        if (bookingIdsParam == null || bookingIdsParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/my-shopping-cart");
            return;
        }

        List<Integer> bookingIds = parseIds(bookingIdsParam);
        if (bookingIds.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/my-shopping-cart");
            return;
        }

        List<Booking> bookings = bookingDAO.getBookingsByIds(bookingIds);
        int subtotal = bookings.stream().mapToInt(Booking::getTotalPrice).sum();

        session.setAttribute("pendingBookingIds", bookingIdsParam);

        request.setAttribute("bookings", bookings);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("grandTotal", subtotal);

        request.getRequestDispatcher("/WEB-INF/views/payment.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int accountId = (Integer) session.getAttribute("account_id");
        String bookingIdsParam = (String) session.getAttribute("pendingBookingIds");
        if (bookingIdsParam == null || bookingIdsParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/my-shopping-cart");
            return;
        }

        String acceptTerms = request.getParameter("acceptTerms");
        if (!"on".equals(acceptTerms)) {
            request.setAttribute("errorMsg", "Vui lòng đồng ý với điều khoản dịch vụ.");
            doGet(request, response);
            return;
        }

        String method = request.getParameter("method");
        if (method == null || method.isBlank()) method = "CASH";

        List<Integer> bookingIds = parseIds(bookingIdsParam);
        List<Booking> bookings = bookingDAO.getBookingsByIds(bookingIds);

        if (bookings.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/my-shopping-cart");
            return;
        }

        for (Booking b : bookings) {
            Payment payment = new Payment();
            payment.setBookingId(b.getBookingId());
            payment.setAccountId(accountId);
            payment.setPrice(b.getTotalPrice());
            payment.setMethod(method);
            payment.setPayType("FULL");
            payment.setStatus("PENDING");
            payment.setCreatedBy(accountId);

            paymentService.createPayment(payment);
        }

        bookingDAO.updatePaymentStatus(bookingIds, "PENDING");
        int grandTotal = bookings.stream().mapToInt(Booking::getTotalPrice).sum();
        session.setAttribute("paidBookingIds", bookingIdsParam);
        session.setAttribute("paymentMethod", method);
        session.setAttribute("paymentGrandTotal", grandTotal);
        session.removeAttribute("pendingBookingIds");

        if ("TRANSFER".equalsIgnoreCase(method)) {
            response.sendRedirect(request.getContextPath() + "/payment-qr");
        } else {
            response.sendRedirect(request.getContextPath() + "/payment-confirmation");
        }
    }

    private List<Integer> parseIds(String param) {
        return Arrays.stream(param.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .map(s -> {
                    try {
                        return Integer.parseInt(s);
                    } catch (NumberFormatException e) {
                        return null;
                    }
                })
                .filter(i -> i != null && i > 0)
                .collect(Collectors.toList());
    }
}
