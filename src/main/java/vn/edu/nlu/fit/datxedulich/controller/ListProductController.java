package vn.edu.nlu.fit.datxedulich.controller;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.CarType;
import vn.edu.nlu.fit.datxedulich.services.ProductService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ListProductController", value = "/list-product")
public class ListProductController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //lay brandid
        String brandIdStr = request.getParameter("brandId");

        ProductService ps = new ProductService();
        List<CarType> list = ps.getListProduct();

        // check co dung brandid k (bam tu trang brand)
        if (brandIdStr != null && !brandIdStr.isEmpty()) {
            try {
                int brandId = Integer.parseInt(brandIdStr);
                // Có brandId -> goi lay xe theo hang ma duoc chon
                list = ps.getProductsByBrandId(brandId);
            } catch (NumberFormatException e) {
                // nhap tren url sai -> all xe
                list = ps.getListProduct();
            }
        } else {
            // 0 co -> all xe
            list = ps.getListProduct();
        }
        request.setAttribute("list", list);
        request.getRequestDispatcher("/WEB-INF/views/list-cars.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}