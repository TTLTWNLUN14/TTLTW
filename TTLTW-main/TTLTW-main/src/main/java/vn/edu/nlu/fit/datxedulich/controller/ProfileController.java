package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.Member;
import vn.edu.nlu.fit.datxedulich.services.MemberService;
import java.io.IOException;

@WebServlet(name = "ProfileController", value = "/profile")
public class ProfileController extends HttpServlet {

    private final MemberService memberService = new MemberService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        Integer accountId = (Integer) session.getAttribute("account_id");

        if (accountId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Member member = memberService.getMemberInfo(accountId);

        request.setAttribute("member", member);
        request.setAttribute("bookingHistory", memberService.getBookingHistory(accountId));

        request.getRequestDispatcher("/WEB-INF/views/profile.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("account_id");

        if (accountId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            Member member = memberService.getMemberInfo(accountId);

            if (member != null) {
                member.setFullName(request.getParameter("fullName"));
                member.setPhone(request.getParameter("phone"));
                member.setEmail(request.getParameter("email"));
                member.setAddress(request.getParameter("address"));
                member.setCccd(request.getParameter("cccd"));
                member.setGender(request.getParameter("gender"));

                memberService.updateMemberInfo(member);
                request.setAttribute("successMessage", "Cập nhật thông tin thành công!");
            }
        }
        else if ("deleteBooking".equals(action)) {
            try {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                memberService.deleteBooking(bookingId);
                request.setAttribute("successMessage", "Xóa đơn hàng thành công!");
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "ID đơn hàng không hợp lệ!");
            }
        }

        doGet(request, response);
    }
}