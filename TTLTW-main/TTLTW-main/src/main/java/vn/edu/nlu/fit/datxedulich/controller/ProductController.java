package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.Product;
import vn.edu.nlu.fit.datxedulich.services.ProductService;

import java.io.IOException;

@WebServlet(name = "ProductController", value = "/list-product/product")
public class ProductController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        ProductService service = new ProductService();
        Product p = service.getProduct(id);
        request.setAttribute("product", p);
        request.getRequestDispatcher("/WEB-INF/views/car-detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}