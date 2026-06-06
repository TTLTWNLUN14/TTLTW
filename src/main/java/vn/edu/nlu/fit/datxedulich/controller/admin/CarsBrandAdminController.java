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

        List<Brand> allBrands = brandService.getListBrand();
        request.setAttribute("allBrands", allBrands);

        String country = request.getParameter("country");

        boolean hasFilter = (country != null && !country.isEmpty());
        List<Brand> listBrand = hasFilter
                ? brandService.filterBrands(country)
                : allBrands;

        request.setAttribute("listBrand", listBrand);
        request.setAttribute("selectedCountry", country);
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
                response.sendRedirect(request.getContextPath() + "/brand-admin?msg=deleted");
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/brand-admin");
    }
}
