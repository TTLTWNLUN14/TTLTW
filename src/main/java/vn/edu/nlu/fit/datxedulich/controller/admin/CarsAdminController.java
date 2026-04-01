package vn.edu.nlu.fit.datxedulich.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.Brand;
import vn.edu.nlu.fit.datxedulich.model.CarType;
import vn.edu.nlu.fit.datxedulich.services.BrandService;
import vn.edu.nlu.fit.datxedulich.services.CarTypeService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CarsAdminController", value = "/cars-admin")
public class CarsAdminController extends HttpServlet {

    private final BrandService brandService     = new BrandService();
    private final CarTypeService carTypeService = new CarTypeService();

    // --------------- GET --------------
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Brand> listBrand = brandService.getListBrand();
        request.setAttribute("listBrand", listBrand);

        String brandIdStr = request.getParameter("brandId");
        List<CarType> listCarType;

        if (brandIdStr != null && !brandIdStr.isEmpty()) {
            try {
                int brandId = Integer.parseInt(brandIdStr);
                listCarType = carTypeService.getCarTypesByBrandId(brandId);
                request.setAttribute("selectedBrandId", brandId);
            } catch (NumberFormatException e) {
                listCarType = carTypeService.getListCarType();
            }
        } else {
            listCarType = carTypeService.getListCarType();
        }

        request.setAttribute("listCarType", listCarType);
        request.getRequestDispatcher("/WEB-INF/views/cars-admin.jsp")
                .forward(request, response);
    }

    // delete
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int typeId = Integer.parseInt(request.getParameter("typeId"));
            carTypeService.deleteCarType(typeId);
        }

        response.sendRedirect(request.getContextPath() + "/cars-admin");
    }
}
