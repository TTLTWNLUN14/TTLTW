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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BrandService brandService = new BrandService();

        // Toàn bộ danh sách để dành cho bộ lọc
        List<Brand> allBrands = brandService.getListBrand();
        request.setAttribute("allBrands", allBrands);

        // Lọc theo brandId nếu có filterBrandId
        String filterStr = request.getParameter("filterBrandId");
        List<Brand> listBrand;

        if (filterStr != null && !filterStr.isEmpty()) {
            try {
                int filterId = Integer.parseInt(filterStr);
                Brand found = brandService.getBrandById(filterId);
                listBrand = found != null
                        ? java.util.Collections.singletonList(found)
                        : java.util.Collections.emptyList();
                request.setAttribute("filterBrandId", filterId);
            } catch (NumberFormatException e) {
                listBrand = allBrands;
            }
        } else {
            listBrand = allBrands;
        }

        request.setAttribute("listBrand", listBrand);
        request.getRequestDispatcher("/WEB-INF/views/cars-brand-admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            try {
                int brandId = Integer.parseInt(request.getParameter("brandId"));
                BrandService brandService = new BrandService();
                brandService.deleteBrand(brandId);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        // Sau khi xóa redirect về trang danh sách
        response.sendRedirect(request.getContextPath() + "/brand-admin");
    }
}
