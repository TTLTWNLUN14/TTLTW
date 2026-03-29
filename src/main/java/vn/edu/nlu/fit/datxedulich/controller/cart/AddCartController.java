package vn.edu.nlu.fit.datxedulich.controller.cart;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.CarType;
import vn.edu.nlu.fit.datxedulich.model.cart.Cart;
import vn.edu.nlu.fit.datxedulich.services.ProductService;

import java.io.IOException;

@WebServlet(name = "AddCartController", value = "/add-cart")
public class AddCartController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String isDriverStr = request.getParameter("isDriver");
        boolean isDriver = Boolean.parseBoolean(isDriverStr);
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
        }
        ProductService productService = new ProductService();
        CarType product = productService.getCarTypeById(productId);
        if(product!=null) {
            cart.addItem(product, quantity, isDriver);
            session.setAttribute("cart", cart);
            response.sendRedirect("list-product");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}