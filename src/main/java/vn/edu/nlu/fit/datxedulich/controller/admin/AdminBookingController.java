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

    private static final int PAGE_SIZE = 10;
    private final BookingDao bookingDao = new BookingDao();
    private final CarTypeDao carTypeDao = new CarTypeDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = trim(request.getParameter("keyword"));
        String status = trim(request.getParameter("status"));
        String dateFrom = trim(request.getParameter("dateFrom"));
        String dateTo = trim(request.getParameter("dateTo"));

        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isBlank()) {
            try {
                page = Math.max(1, Integer.parseInt(pageStr));
            } catch (NumberFormatException ignored) {
            }
        }

        boolean hasFilter = keyword != null || status != null || dateFrom != null || dateTo != null;

        List<Booking> listBookings;
        int totalItems;

        if (hasFilter) {
            List<Booking> allFiltered = bookingDao.searchBookings(keyword, status, dateFrom, dateTo);
            totalItems = allFiltered.size();
            int from = (page - 1) * PAGE_SIZE;
            int to = Math.min(from + PAGE_SIZE, totalItems);
            listBookings = (from < totalItems) ? allFiltered.subList(from, to) : List.of();
        } else {
            totalItems = bookingDao.countBookings();
            listBookings = bookingDao.getBookingsPaged(page, PAGE_SIZE);
        }

        int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);

        List<CarType> listCarTypes = carTypeDao.getListCarType();

        request.setAttribute("listBookings", listBookings);
        request.setAttribute("listCarTypes", listCarTypes);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", PAGE_SIZE);
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

        String pageStr = request.getParameter("page");
        String keyword = request.getParameter("keyword");
        String filterSt = request.getParameter("filterStatus");
        String filterFrom = request.getParameter("filterDateFrom");
        String filterTo = request.getParameter("filterDateTo");

        try {
            switch (action == null ? "" : action) {

                case "delete": {
                    int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                    bookingDao.deleteBooking(bookingId);
                    response.sendRedirect(buildRedirect(request, "deleted",
                            pageStr, keyword, filterSt, filterFrom, filterTo));
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
                    response.sendRedirect(buildRedirect(request, "edit_ok",
                            pageStr, keyword, filterSt, filterFrom, filterTo));
                    return;
                }

                case "createReplacement": {
                    int originalId = Integer.parseInt(request.getParameter("originalBookingId"));
                    Booking orig = bookingDao.getBookingById(originalId);
                    if (orig == null) break;

                    // kiểm tra trạng thái là̀ đã hủy và chưa tạo đơn bù thay thế
                    if (!"Đã hủy".equals(orig.getStatus()) || (orig.getNote() != null && orig.getNote().contains("Đã tạo đơn bù thay thế"))) {
                        response.sendRedirect(request.getContextPath() + "/booking-admin?msg=replace_err");
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
                    rep.setTotalPrice((int) Math.round(orig.getTotalPrice() * 0.8));
                    rep.setBookerName(orig.getBookerName());
                    rep.setBookerPhone(orig.getBookerPhone());
                    rep.setBookerAddress(orig.getBookerAddress());
                    rep.setNote("Đơn bù – thay thế đơn #" + originalId + " (đã hủy). Giảm 20% ưu đãi.");

                    boolean isCreated = bookingDao.createBooking(rep);
                    if (isCreated) {
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

    private String buildRedirect(HttpServletRequest req, String msg,
                                 String page, String keyword,
                                 String status, String dateFrom, String dateTo) {
        StringBuilder url = new StringBuilder(req.getContextPath())
                .append("/booking-admin?msg=").append(msg);
        if (page != null && !page.isBlank()) url.append("&page=").append(page);
        if (keyword != null && !keyword.isBlank()) url.append("&keyword=").append(keyword);
        if (status != null && !status.isBlank()) url.append("&status=").append(status);
        if (dateFrom != null && !dateFrom.isBlank()) url.append("&dateFrom=").append(dateFrom);
        if (dateTo != null && !dateTo.isBlank()) url.append("&dateTo=").append(dateTo);
        return url.toString();
    }
}
