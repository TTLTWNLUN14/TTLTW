package vn.edu.nlu.fit.datxedulich.controller;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.Product;
import vn.edu.nlu.fit.datxedulich.services.ProductService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ListProductController", value = "/list-product")
public class ListProductController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ProductService ps = new ProductService();
        List<Product> list = ps.getListProduct();
        request.setAttribute("list", list);
        request.getRequestDispatcher("/WEB-INF/views/list-cars.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}