package vn.edu.nlu.fit.datxedulich.controller.cart;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.cart.Cart;

import java.io.IOException;

@WebServlet(name = "RemoveItemController", value = "/del-item")
public class RemoveItemController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart != null) {
            cart.removeItem(productId);
            session.setAttribute("cart", cart);
        }
        response.sendRedirect(request.getContextPath() + "/my-shopping-cart");
    }
}
