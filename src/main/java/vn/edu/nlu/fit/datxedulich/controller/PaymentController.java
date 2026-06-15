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
            bookingIdsParam = (String) session.getAttribute("pendingBookingIds");
            if (bookingIdsParam == null || bookingIdsParam.isBlank()) {
                response.sendRedirect(request.getContextPath() + "/my-shopping-cart");
                return;
            }
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

        Integer appliedVoucherId = (Integer) session.getAttribute("appliedVoucherId");
        Double appliedDiscount = (Double) session.getAttribute("appliedDiscount");
        Long appliedPriceMaxDiscount = (Long) session.getAttribute("appliedPriceMaxDiscount");

        long appliedDiscountAmount = 0;
        if (appliedVoucherId != null && appliedDiscount != null && appliedPriceMaxDiscount != null) {
            appliedDiscountAmount = (long) (subtotal * appliedDiscount);
            if (appliedDiscountAmount > appliedPriceMaxDiscount) {
                appliedDiscountAmount = appliedPriceMaxDiscount;
            }
            request.setAttribute("appliedDiscountAmount", appliedDiscountAmount);
        }

        int grandTotal = (int) (subtotal - appliedDiscountAmount);
        request.setAttribute("grandTotal", grandTotal);

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
        String method = request.getParameter("method");

        if (!"on".equals(acceptTerms)) {
            request.setAttribute("errorMsg", "Vui lòng đồng ý với điều khoản dịch vụ.");
            doGet(request, response);
            return;
        }
        if (method == null || method.isBlank()) {
            request.setAttribute("errorMsg", "Vui lòng chọn phương thức thanh toán.");
            doGet(request, response);
            return;
        }
        List<Integer> bookingIds = parseIds(bookingIdsParam);
        List<Booking> bookings = bookingDAO.getBookingsByIds(bookingIds);

        if (bookings.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/my-shopping-cart");
            return;
        }

        Integer appliedVoucherId = (Integer) session.getAttribute("appliedVoucherId");
        Double appliedDiscount = (Double) session.getAttribute("appliedDiscount");
        Long appliedPriceMaxDiscount = (Long) session.getAttribute("appliedPriceMaxDiscount");

        int subtotal = bookings.stream().mapToInt(Booking::getTotalPrice).sum();
        long totalDiscountAmount = 0;

        if (appliedVoucherId != null && appliedDiscount != null && appliedPriceMaxDiscount != null) {
            totalDiscountAmount = (long) (subtotal * appliedDiscount);
            if (totalDiscountAmount > appliedPriceMaxDiscount) {
                totalDiscountAmount = appliedPriceMaxDiscount;
            }
        }

        for (Booking b : bookings) {
            Payment payment = new Payment();
            payment.setBookingId(b.getBookingId());
            payment.setAccountId(accountId);

            int bookingCount = bookings.size();
            long discountForThisBooking = 0;
            if (totalDiscountAmount > 0) {
                discountForThisBooking = totalDiscountAmount / bookingCount;
                if (bookings.indexOf(b) == bookingCount - 1) {
                    discountForThisBooking = totalDiscountAmount - (discountForThisBooking * (bookingCount - 1));
                }
                payment.setVoucherId(appliedVoucherId);
            }

            int finalPrice = (int) (b.getTotalPrice() - discountForThisBooking);
            if (finalPrice < 0) finalPrice = 0;

            payment.setPrice(finalPrice);
            payment.setMethod(method);
            payment.setPayType("FULL");
            payment.setStatus("PENDING");
            payment.setCreatedBy(accountId);

            paymentService.createPayment(payment);
        }

        bookingDAO.updatePaymentStatus(bookingIds, "PENDING");

        session.setAttribute("paidBookingIds", bookingIdsParam);
        session.setAttribute("paymentMethod", method);
        session.setAttribute("paymentGrandTotal", subtotal - totalDiscountAmount);
        session.removeAttribute("pendingBookingIds");

        session.removeAttribute("appliedVoucherId");
        session.removeAttribute("appliedVoucherCode");
        session.removeAttribute("appliedVoucherName");
        session.removeAttribute("appliedDiscount");
        session.removeAttribute("appliedPriceMaxDiscount");

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