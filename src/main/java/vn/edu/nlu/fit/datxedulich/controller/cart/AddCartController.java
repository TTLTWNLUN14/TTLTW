package vn.edu.nlu.fit.datxedulich.controller.cart;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.dao.CartDAO;
import vn.edu.nlu.fit.datxedulich.model.CarType;
import vn.edu.nlu.fit.datxedulich.model.cart.Cart;
import vn.edu.nlu.fit.datxedulich.model.cart.CartItem;
import vn.edu.nlu.fit.datxedulich.services.ProductService;
import vn.edu.nlu.fit.datxedulich.services.ProvinceService;

import java.io.IOException;

@WebServlet(name = "AddCartController", value = "/add-cart")
public class AddCartController extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");
        String from = request.getParameter("from");
        String typeIdStr = request.getParameter("typeId");

        String fromProvinceIdStr = request.getParameter("fromProvinceId");
        String toProvinceIdStr = request.getParameter("toProvinceId");
        String fromProvinceName = request.getParameter("fromProvinceName");
        String toProvinceName = request.getParameter("toProvinceName");
        String pickupTime = request.getParameter("pickupTime");
        String returnTime = request.getParameter("returnTime");

        if (productIdStr == null || productIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/list-product");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);
            int quantity = (quantityStr != null && !quantityStr.isEmpty())
                    ? Integer.parseInt(quantityStr) : 1;

            HttpSession session = request.getSession();
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null) cart = new Cart();

            ProductService productService = new ProductService();
            CarType product = productService.getCarTypeById(productId);

            if (product != null) {
                cart.addItem(product, quantity);

                CartItem item = cart.get(productId);
                if (item != null) {
                    boolean hasRoute = false;

                    if (fromProvinceIdStr != null && !fromProvinceIdStr.isEmpty()) {
                        item.setFromProvinceId(Integer.parseInt(fromProvinceIdStr));
                        hasRoute = true;
                    }
                    if (toProvinceIdStr != null && !toProvinceIdStr.isEmpty()) {
                        item.setToProvinceId(Integer.parseInt(toProvinceIdStr));
                        hasRoute = true;
                    }
                    if (fromProvinceName != null && !fromProvinceName.isEmpty()) {
                        item.setFromProvinceName(fromProvinceName);
                    }
                    if (toProvinceName != null && !toProvinceName.isEmpty()) {
                        item.setToProvinceName(toProvinceName);
                    }
                    if (pickupTime != null && !pickupTime.isEmpty()) {
                        item.setPickupTime(pickupTime);
                    }
                    if (returnTime != null && !returnTime.isEmpty()) {
                        item.setReturnTime(returnTime);
                    }

                    if (hasRoute && item.getFromProvinceId() > 0 && item.getToProvinceId() > 0
                            && item.getFromProvinceId() != item.getToProvinceId()) {
                        ProvinceService provinceService = new ProvinceService();
                        item.setKm(provinceService.getDistance(item.getFromProvinceId(), item.getToProvinceId()));
                    }
                }

                session.setAttribute("cart", cart);
                Integer accountId = (Integer) session.getAttribute("account_id");
                if (accountId != null) {
                    try {
                        cartDAO.saveCart(accountId, cart);
                    } catch (Exception e) {
                        System.err.println("Lỗi lưu giỏ hàng vào DB: " + e.getMessage());
                        e.printStackTrace();
                    }
                }
            }

            // check ajax request
            boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

            if (isAjax) {
                // tra json về -> lấy tổng sl trong gio
                int cartSize = (cart != null) ? cart.getTotalQuantity() : 0;
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": true, \"cartCount\": " + cartSize + "}");
            } else {
                if ("detail".equals(from) && typeIdStr != null) {
                    response.sendRedirect(request.getContextPath()
                            + "/list-product/product?typeId=" + typeIdStr + "&added=1");
                } else {
                    response.sendRedirect(request.getContextPath() + "/list-product");
                }
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/list-product");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}