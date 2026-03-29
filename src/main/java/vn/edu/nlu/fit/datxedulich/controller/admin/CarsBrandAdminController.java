package vn.edu.nlu.fit.datxedulich.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.Brand;
import vn.edu.nlu.fit.datxedulich.services.BrandService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CarsBrandAdminController", value = "/brand-admin")
public class CarsBrandAdminController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
        BrandService brandService = new BrandService();

        // Lấy danh sách tất cả hãng xe từ DB
        List<Brand> listBrand = brandService.getListBrand();

        // Đưa vào request attribute để JSP đọc bằng ${listBrand}
        request.setAttribute("listBrand", listBrand);

        // Forward sang JSP để hiển thị (không redirect vì cần giữ attribute)
        request.getRequestDispatcher("/WEB-INF/views/cars-brand-admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}