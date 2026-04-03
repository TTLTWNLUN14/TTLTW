package vn.edu.nlu.fit.datxedulich.controller.cart;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.dao.CarTypeDao;
import vn.edu.nlu.fit.datxedulich.model.CarType;
import vn.edu.nlu.fit.datxedulich.model.cart.Cart;
import vn.edu.nlu.fit.datxedulich.model.cart.CartItem;
import vn.edu.nlu.fit.datxedulich.services.ProvinceService;

import java.io.IOException;

@WebServlet(name = "UpdateCartDetailController", value = "/update-cart-detail")
public class UpdateCartDetailController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            response.sendRedirect(request.getContextPath() + "/my-shopping-cart");
            return;
        }

        int productId = Integer.parseInt(request.getParameter("productId"));
        CartItem item = cart.get(productId);
        if (item == null) {
            response.sendRedirect(request.getContextPath() + "/my-shopping-cart");
            return;
        }

        // --- thông tin xe ---
        String brandIdStr      = request.getParameter("brandId");
        String selectedTypeIdStr = request.getParameter("selectedTypeId");

        if (brandIdStr != null && !brandIdStr.isEmpty()) {
            item.setSelectedBrandId(Integer.parseInt(brandIdStr));
        }

        if (selectedTypeIdStr != null && !selectedTypeIdStr.isEmpty()) {
            int selTypeId = Integer.parseInt(selectedTypeIdStr);
            item.setSelectedTypeId(selTypeId);
            // lấy thông tin xe được chọn từ db
            CarTypeDao ctDao = new CarTypeDao();
            CarType ct = ctDao.getCarTypeById(selTypeId);
            if (ct != null) {
                item.setSelectedTypeName(ct.getTypeName());
                item.setSelectedCategory(ct.getCategory());
                item.setSelectedSeatingPlan(ct.getSeatingPlan());
                item.setPrice(ct.getPriceKm()); // cập nhật giá theo xe mới chọn
            }
        }

        // --- Điểm đón / Điểm tới → tra km ---
        String fromIdStr = request.getParameter("fromProvinceId");
        String toIdStr   = request.getParameter("toProvinceId");
        String fromName  = request.getParameter("fromProvinceName");
        String toName    = request.getParameter("toProvinceName");

        if (fromIdStr != null && !fromIdStr.isEmpty()) {
            item.setFromProvinceId(Integer.parseInt(fromIdStr));
        }
        if (toIdStr != null && !toIdStr.isEmpty()) {
            item.setToProvinceId(Integer.parseInt(toIdStr));
        }
        if (fromName != null) item.setFromProvinceName(fromName);
        if (toName   != null) item.setToProvinceName(toName);

        // tra khoảng cách từ db
        if (item.getFromProvinceId() > 0 && item.getToProvinceId() > 0
                && item.getFromProvinceId() != item.getToProvinceId()) {
            ProvinceService ps = new ProvinceService();
            int km = ps.getDistance(item.getFromProvinceId(), item.getToProvinceId());
            item.setKm(km);
        } else {
            item.setKm(0);
        }

        // --- thời gian ---
        String pickupTime = request.getParameter("pickupTime");
        String returnTime = request.getParameter("returnTime");
        if (pickupTime != null) item.setPickupTime(pickupTime);
        if (returnTime != null) item.setReturnTime(returnTime);

        // --- thông tin cá nhân ---
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        if (email != null) item.setEmail(email);
        if (phone != null) item.setPhone(phone);

        session.setAttribute("cart", cart);
        response.sendRedirect(request.getContextPath() + "/my-shopping-cart?openDetailId=" + productId);
    }
}
