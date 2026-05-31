package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.dao.MemberDAO;

import java.io.IOException;

@WebServlet(name = "CancelBookingController", value = "/cancel-booking")
public class CancelBookingController extends HttpServlet {

    private final MemberDAO memberDAO = new MemberDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer accountId = (Integer) session.getAttribute("account_id");
        String bookingIdStr = request.getParameter("bookingId");

        if (bookingIdStr != null && !bookingIdStr.isBlank()) {
            try {
                int bookingId = Integer.parseInt(bookingIdStr);
                memberDAO.cancelBooking(bookingId, accountId);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/my-shopping-cart?statusFilter=Đã hủy");
    }
}