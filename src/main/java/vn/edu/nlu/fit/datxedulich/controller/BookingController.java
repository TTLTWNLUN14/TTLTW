package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.services.BrandService;
import vn.edu.nlu.fit.datxedulich.services.ProductService;

import java.io.IOException;

@WebServlet(name = "BookingController", value = "/booking")
public class BookingController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BrandService brandService = new BrandService();
        ProductService productService = new ProductService();

        //  Lấy tham số từ URL trên JSP gửi về khi người dùng click
        String brandIdStr = request.getParameter("brandId");
        String productIdStr = request.getParameter("productId");
        String isDriverStr = request.getParameter("isDriver");

        //chuẩn bị các biến để lưu trữ trạng thái lựa chọn
        Integer selectedBrandId = null;
        Integer selectedProductId = null;

        request.getRequestDispatcher("/WEB-INF/views/booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}