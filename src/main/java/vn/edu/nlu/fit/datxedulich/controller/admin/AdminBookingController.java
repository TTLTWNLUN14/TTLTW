package vn.edu.nlu.fit.datxedulich.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.dao.BookingDao;
import vn.edu.nlu.fit.datxedulich.dao.CarTypeDao;
import vn.edu.nlu.fit.datxedulich.model.Booking;
import vn.edu.nlu.fit.datxedulich.model.CarType;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminBookingController", value = "/booking-admin")
public class AdminBookingController extends HttpServlet {

    private final BookingDao bookingDao = new BookingDao();
    private final CarTypeDao carTypeDao = new CarTypeDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = trim(request.getParameter("keyword"));
        String status = trim(request.getParameter("status"));
        String dateFrom = trim(request.getParameter("dateFrom"));
        String dateTo = trim(request.getParameter("dateTo"));

        List<Booking> allBookings = bookingDao.getAllBookings();
        List<Booking> listBookings = bookingDao.searchBookings(keyword, status, dateFrom, dateTo);
        List<CarType> listCarTypes = carTypeDao.getListCarType();

        request.setAttribute("allBookings", allBookings);
        request.setAttribute("listBookings", listBookings);
        request.setAttribute("listCarTypes", listCarTypes);
        request.setAttribute("filterKeyword", keyword);
        request.setAttribute("filterStatus", status);
        request.setAttribute("filterDateFrom", dateFrom);
        request.setAttribute("filterDateTo", dateTo);

        request.getRequestDispatcher("/WEB-INF/views/booking-admin.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = trim(request.getParameter("action"));

        try {
            switch (action == null ? "" : action) {

                case "updateStatus": {
                    int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                    String newStatus = request.getParameter("newStatus");
                    bookingDao.updateBookingStatus(bookingId, newStatus);
                    response.sendRedirect(request.getContextPath()
                            + "/booking-admin?msg=status_ok&bookingId=" + bookingId);
                    return;
                }

                case "delete": {
                    int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                    bookingDao.deleteBooking(bookingId);
                    response.sendRedirect(request.getContextPath()
                            + "/booking-admin?msg=deleted");
                    return;
                }

                case "edit": {
                    int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                    Booking b = bookingDao.getBookingById(bookingId);
                    if (b == null) break;

                    b.setBookerName(request.getParameter("bookerName"));
                    b.setBookerPhone(request.getParameter("bookerPhone"));
                    b.setBookerAddress(request.getParameter("bookerAddress"));
                    b.setPickupProvince(request.getParameter("pickupProvince"));
                    b.setDropoffProvince(request.getParameter("dropoffProvince"));
                    b.setPickupTime(request.getParameter("pickupTime"));
                    b.setReturnTime(request.getParameter("returnTime"));
                    b.setNote(request.getParameter("note"));

                    String statusParam = request.getParameter("status");
                    if (statusParam != null && !statusParam.isEmpty()) b.setStatus(statusParam);

                    String totalPriceStr = request.getParameter("totalPrice");
                    if (totalPriceStr != null && !totalPriceStr.isEmpty()) {
                        b.setTotalPrice(Integer.parseInt(totalPriceStr.replace(",", "").replace(".", "")));
                    }

                    bookingDao.updateBooking(b);
                    response.sendRedirect(request.getContextPath()
                            + "/booking-admin?msg=edit_ok");
                    return;
                }

                case "createReplacement": {
                    int originalId = Integer.parseInt(request.getParameter("originalBookingId"));
                    Booking orig = bookingDao.getBookingById(originalId);
                    if (orig == null) break;

                    // kiểm tra trạng thái là̀ đã hủy và chưa tạo đơn bù thay thế
                    if (!"Đã hủy".equals(orig.getStatus()) || (orig.getNote() != null && orig.getNote().contains("Đã tạo đơn bù thay thế"))) {
                        response.sendRedirect(request.getContextPath()
                                + "/booking-admin?msg=replace_err");
                        return;
                    }

                    Booking rep = new Booking();
                    rep.setCustomerId(orig.getCustomerId());
                    rep.setTypeId(orig.getTypeId());
                    rep.setVoucherId(null);
                    rep.setPickupProvince(orig.getPickupProvince());
                    rep.setDropoffProvince(orig.getDropoffProvince());
                    rep.setPickupTime(orig.getPickupTime());
                    rep.setReturnTime(orig.getReturnTime());
                    rep.setKm(orig.getKm());
                    rep.setDays(orig.getDays());
                    rep.setBasePrice(orig.getBasePrice());
                    rep.setMemberDiscount(orig.getMemberDiscount());
                    rep.setVoucherDiscount(0);
                    rep.setIsVoucherCode(null);
                    rep.setPayType(orig.getPayType());
                    int discountedPrice = (int) Math.round(orig.getTotalPrice() * 0.8);
                    rep.setTotalPrice(discountedPrice);

                    rep.setBookerName(orig.getBookerName());
                    rep.setBookerPhone(orig.getBookerPhone());
                    rep.setBookerAddress(orig.getBookerAddress());
                    rep.setNote("Đơn bù – thay thế đơn #" + originalId + " (đã hủy). Giảm 20% ưu đãi.");

                    boolean isCreated = bookingDao.createBooking(rep);

                    if (isCreated) {
                        // đánh dấu đơn đã tạo đơn bù để tránh tạo thêm đơn
                        String oldNote = orig.getNote() != null ? orig.getNote() : "";
                        orig.setNote(oldNote + " [Hệ thống: Đã tạo đơn bù thay thế]");
                        bookingDao.updateBooking(orig);

                        response.sendRedirect(request.getContextPath() + "/booking-admin?msg=replace_ok");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/booking-admin?msg=error");
                    }
                    return;
                }

                default:
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/booking-admin?msg=error");
    }

    private String trim(String s) {
        return (s == null || s.isBlank()) ? null : s.trim();
    }
}