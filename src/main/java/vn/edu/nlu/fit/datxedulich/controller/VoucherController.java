package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.dao.VoucherDAO;
import vn.edu.nlu.fit.datxedulich.model.Voucher;
import vn.edu.nlu.fit.datxedulich.services.VoucherService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "VoucherController", value = "/voucher")
public class VoucherController extends HttpServlet {
    private final VoucherService voucherService = new VoucherService();
    private final VoucherDAO voucherDAO = new VoucherDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        List<Voucher> vouchers = voucherService.getAllVouchers();
        request.setAttribute("vouchers", vouchers);
        request.getRequestDispatcher("/WEB-INF/views/voucher.jsp").forward(request, response);
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

        String voucherIdStr = request.getParameter("voucherId");
        String action = request.getParameter("action");

        if ("apply".equals(action)) {
            if (voucherIdStr == null || voucherIdStr.isBlank()) {
                request.setAttribute("errorMsg", "Vui lòng chọn mã giảm giá.");
                request.getRequestDispatcher("/WEB-INF/views/voucher.jsp").forward(request, response);
                return;
            }

            int voucherId;
            try {
                voucherId = Integer.parseInt(voucherIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMsg", "Dữ liệu không hợp lệ.");
                request.getRequestDispatcher("/WEB-INF/views/voucher.jsp").forward(request, response);
                return;
            }

            Voucher voucher = voucherDAO.getVoucherById(voucherId);

            if (voucher == null) {
                request.setAttribute("errorMsg", "Mã giảm giá không tồn tại.");
                request.getRequestDispatcher("/WEB-INF/views/voucher.jsp").forward(request, response);
                return;
            }

            String validationMsg = validateVoucher(voucher);
            if (validationMsg != null) {
                request.setAttribute("errorMsg", validationMsg);
                request.getRequestDispatcher("/WEB-INF/views/voucher.jsp").forward(request, response);
                return;
            }

            session.setAttribute("appliedVoucherId", voucher.getVoucherId());
            session.setAttribute("appliedVoucherCode", voucher.getCode());
            session.setAttribute("appliedVoucherName", voucher.getNameVoucher());
            session.setAttribute("appliedDiscount", voucher.getDiscount());
            session.setAttribute("appliedPriceMaxDiscount", voucher.getPriceMaxDiscount());

            String bookingIdsParam = (String) session.getAttribute("pendingBookingIds");
            if (bookingIdsParam != null && !bookingIdsParam.isBlank()) {
                response.sendRedirect(request.getContextPath() + "/payments?bookingIds=" + bookingIdsParam);
            } else {
                response.sendRedirect(request.getContextPath() + "/payments");
            }
            return;
        }
        response.sendRedirect(request.getContextPath() + "/voucher");
    }

    private String validateVoucher(Voucher voucher) {
        if (!voucher.isActive()) {
            return "Mã giảm giá này đã bị vô hiệu hóa.";
        }
        if (voucher.isExpired()) {
            return "Mã giảm giá này đã hết hạn.";
        }
        if (voucher.getUsesLeft() <= 0) {
            return "Mã giảm giá này đã hết lượt sử dụng.";
        }
        return null;
    }

    private String formatCurrency(long amount) {
        return String.format("%,VND", amount).replace(",", ".");
    }
}
