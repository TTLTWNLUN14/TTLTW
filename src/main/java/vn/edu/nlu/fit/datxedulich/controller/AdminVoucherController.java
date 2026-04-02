package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.Voucher;
import vn.edu.nlu.fit.datxedulich.services.VoucherService;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "AdminVoucherController", value = "/admin-voucher")
public class AdminVoucherController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        VoucherService voucherService = new VoucherService();
        HttpSession session = request.getSession();
        if (session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        List<Voucher> vouchers = voucherService.getAllVouchers();
        request.setAttribute("listVouchers", vouchers);
        request.getRequestDispatcher("/WEB-INF/views/voucher-admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        VoucherService voucherService = new VoucherService();
        HttpSession session = request.getSession();
        if (session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        try {
            if ("create".equals(action)) {
                Voucher voucher = new Voucher();
                voucher.setCode(request.getParameter("code"));
                voucher.setNameVoucher(request.getParameter("nameVoucher"));
                voucher.setDiscount(Float.parseFloat(request.getParameter("discount")));
                voucher.setPriceMaxDiscount(Integer.parseInt(request.getParameter("priceMaxDiscount")));
                voucher.setMinOrder(Float.parseFloat(request.getParameter("minOrder")));
                voucher.setMinTier(request.getParameter("minTier"));
                voucher.setUsesLeft(Integer.parseInt(request.getParameter("usesLeft")));
                voucher.setExpiresAt(Date.valueOf(request.getParameter("expiresAt")));
                voucher.setActive("on".equals(request.getParameter("isActive")));
                voucherService.addVoucher(voucher);
            } else if ("update".equals(action)) {
                Voucher voucher = new Voucher();
                voucher.setVoucherId(Integer.parseInt(request.getParameter("voucherId")));
                voucher.setCode(request.getParameter("code"));
                voucher.setNameVoucher(request.getParameter("nameVoucher"));
                voucher.setDiscount(Float.parseFloat(request.getParameter("discount")));
                voucher.setPriceMaxDiscount(Integer.parseInt(request.getParameter("priceMaxDiscount")));
                voucher.setMinOrder(Float.parseFloat(request.getParameter("minOrder")));
                voucher.setMinTier(request.getParameter("minTier"));
                voucher.setUsesLeft(Integer.parseInt(request.getParameter("usesLeft")));
                voucher.setExpiresAt(Date.valueOf(request.getParameter("expiresAt")));
                voucher.setActive("on".equals(request.getParameter("isActive")));
                voucherService.updateVoucher(voucher);
            } else if ("delete".equals(action)) {
                int voucherId = Integer.parseInt(request.getParameter("voucherId"));
                voucherService.deleteVoucher(voucherId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/voucher?error=true");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/admin/voucher");
    }
}
