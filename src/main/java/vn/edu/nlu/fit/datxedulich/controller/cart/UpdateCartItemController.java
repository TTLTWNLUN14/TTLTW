package vn.edu.nlu.fit.datxedulich.controller.cart;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.dao.CartDAO;
import vn.edu.nlu.fit.datxedulich.model.cart.Cart;

import java.io.IOException;

@WebServlet(name = "UpdateCartItemController", value = "/update-cart")
public class UpdateCartItemController extends HttpServlet {
    private final CartDAO cartDAO = new CartDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/my-shopping-cart");
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
                Integer accountId = (Integer) session.getAttribute("account_id");
                if (accountId != null) {
                    cartDAO.saveCart(accountId, cart);
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/my-shopping-cart");
    }
}