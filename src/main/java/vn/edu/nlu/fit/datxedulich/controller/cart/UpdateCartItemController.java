package vn.edu.nlu.fit.datxedulich.controller.cart;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.cart.Cart;

import java.io.IOException;

@WebServlet(name = "UpdateCartItemController", value = "/update-cart")
public class UpdateCartItemController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart!=null) {
            if(quantity>=1){
                cart.updateItem(productId, quantity);
                session.setAttribute("cart", cart);
            }
        }
        response.sendRedirect("my-shopping-cart");
    }

}