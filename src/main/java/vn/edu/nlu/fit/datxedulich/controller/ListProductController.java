package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.Brand;
import vn.edu.nlu.fit.datxedulich.model.CarType;
import vn.edu.nlu.fit.datxedulich.services.BrandService;
import vn.edu.nlu.fit.datxedulich.services.ProductService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ListProductController", value = "/list-product")
public class ListProductController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String brandIdStr = request.getParameter("brandId");

        ProductService ps = new ProductService();
        BrandService bs   = new BrandService();

        List<CarType> list;

        if (brandIdStr != null && !brandIdStr.isEmpty()) {
            try {
                int brandId = Integer.parseInt(brandIdStr);
                list = ps.getProductsByBrandId(brandId);
            } catch (NumberFormatException e) {
                list = ps.getListCarType();
            }
        } else {
            list = ps.getListCarType();
        }
        List<Brand> brands = bs.getListBrand();
        request.setAttribute("list", list);
        request.setAttribute("brands", brands);
        request.getRequestDispatcher("/WEB-INF/views/list-cars.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}
