package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.dao.BookingDao;
import vn.edu.nlu.fit.datxedulich.dao.CartDAO;
import vn.edu.nlu.fit.datxedulich.dao.MemberDAO;
import vn.edu.nlu.fit.datxedulich.model.Booking;
import vn.edu.nlu.fit.datxedulich.model.Member;
import vn.edu.nlu.fit.datxedulich.model.cart.Cart;
import vn.edu.nlu.fit.datxedulich.model.cart.CartItem;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CancelBookingController", value = "/cancel-booking")
public class CancelBookingController extends HttpServlet {

    private final MemberDAO memberDAO = new MemberDAO();
    private final BookingDao bookingDAO = new BookingDao();
    private final CartDAO cartDAO = new CartDAO();

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
        String bookingIdStr = request.getParameter("bookingId");
        String encodedStatus = java.net.URLEncoder.encode("Đã hủy", "UTF-8");

        try {
            if (bookingIdStr != null && !bookingIdStr.isBlank()) {
                int bookingId = Integer.parseInt(bookingIdStr);
                memberDAO.cancelBooking(bookingId, accountId);

            } else {
                cancelFromConfirmPage(request, session, accountId);
            }
        } catch (Exception e) {
            System.err.println("[CancelBooking] Lỗi: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/my-shopping-cart?statusFilter=" + encodedStatus);
    }

    // Insert các booking với status mặc định rồi UPDATE thành 'Đã hủy',
    // sau đó dọn cart items khỏi session + DB
    private void cancelFromConfirmPage(HttpServletRequest request,
                                       HttpSession session, int accountId) {

        int customerId = memberDAO.ensureCustomerExists(accountId);
        if (customerId == -1) return;

        // Dùng thông tin member làm booker (các cột NOT NULL trong DB)
        Member member = memberDAO.getMemberById(accountId);
        String bookerName    = (member != null && member.getFullName() != null
                && !member.getFullName().isBlank())
                ? member.getFullName() : "N/A";
        String bookerPhone   = (member != null && member.getPhone() != null
                && !member.getPhone().isBlank())
                ? member.getPhone() : "0000000000";

        CartItem singleItem = (CartItem) session.getAttribute("singleBookingItem");

        if (singleItem != null) {
            // Book Now flow
            Booking b = buildBooking(singleItem, customerId, bookerName, bookerPhone);
            int newId = bookingDAO.insertBooking(b);
            memberDAO.cancelBooking(newId, accountId);
            session.removeAttribute("singleBookingItem");

        } else {
            // Cart flow
            String[] selectedTypeIds = (String[]) session.getAttribute("selectedTypeIds");
            Cart cart = (Cart) session.getAttribute("cart");
            if (selectedTypeIds == null || cart == null) return;

            List<Integer> bookedTypeIds = new ArrayList<>();
            for (String idStr : selectedTypeIds) {
                int typeId;
                try { typeId = Integer.parseInt(idStr); }
                catch (NumberFormatException ignored) { continue; }

                CartItem ci = cart.get(typeId);
                if (ci == null) continue;

                try {
                    Booking b = buildBooking(ci, customerId, bookerName, bookerPhone);
                    int newId = bookingDAO.insertBooking(b);
                    memberDAO.cancelBooking(newId, accountId);
                    bookedTypeIds.add(typeId);
                } catch (Exception e) {
                    System.err.println("[CancelBooking] Lỗi insert typeId=" + typeId + ": " + e.getMessage());
                }
            }

            for (int typeId : bookedTypeIds) cart.removeItem(typeId);
            session.setAttribute("cart", cart);
            if (!bookedTypeIds.isEmpty()) cartDAO.removeBookedItems(accountId, bookedTypeIds);
            session.removeAttribute("selectedTypeIds");
        }
    }

    private Booking buildBooking(CartItem ci, int customerId,
                                 String bookerName, String bookerPhone) {
        Booking b = new Booking();
        b.setCustomerId(customerId);
        b.setTypeId(ci.getSelectedTypeId());
        b.setVoucherId(null);
        b.setPickupProvince(ci.getFromProvinceName() != null ? ci.getFromProvinceName() : "");
        b.setDropoffProvince(ci.getToProvinceName() != null ? ci.getToProvinceName() : "");
        String pt = ci.getPickupTime(), rt = ci.getReturnTime();
        b.setPickupTime(pt != null && !pt.isBlank() ? pt : null);
        b.setReturnTime(rt != null && !rt.isBlank() ? rt : null);
        b.setKm(ci.getKm());
        b.setTotalPrice(ci.getTotal());
        b.setBookerName(bookerName);
        b.setBookerPhone(bookerPhone);
        b.setBookerAddress("N/A");
        b.setNote("");
        return b;
    }
}