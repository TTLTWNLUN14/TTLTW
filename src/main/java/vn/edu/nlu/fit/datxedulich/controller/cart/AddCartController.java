package vn.edu.nlu.fit.datxedulich.controller.cart;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.dao.CartDAO;
import vn.edu.nlu.fit.datxedulich.model.CarType;
import vn.edu.nlu.fit.datxedulich.model.cart.Cart;
import vn.edu.nlu.fit.datxedulich.services.ProductService;

import java.io.IOException;

@WebServlet(name = "AddCartController", value = "/add-cart")
public class AddCartController extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String productIdStr = request.getParameter("productId");
        String quantityStr  = request.getParameter("quantity");
        String isDriverStr  = request.getParameter("isDriver");
        String from         = request.getParameter("from");
        String typeIdStr    = request.getParameter("typeId");

        if (productIdStr == null || productIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/list-product");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);
            int quantity  = (quantityStr != null && !quantityStr.isEmpty())
                    ? Integer.parseInt(quantityStr) : 1;
            boolean isDriver = Boolean.parseBoolean(isDriverStr);

            HttpSession session = request.getSession();
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null) cart = new Cart();

            ProductService productService = new ProductService();
            CarType product = productService.getCarTypeById(productId);

            if (product != null) {
                cart.addItem(product, quantity, isDriver);
                session.setAttribute("cart", cart);
                Integer accountId = (Integer) session.getAttribute("account_id");
                if (accountId != null) {
                    cartDAO.saveCart(accountId, cart);
                }
            }

            if ("detail".equals(from) && typeIdStr != null) {
                response.sendRedirect(request.getContextPath()
                        + "/list-product/product?typeId=" + typeIdStr + "&added=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/list-product");
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