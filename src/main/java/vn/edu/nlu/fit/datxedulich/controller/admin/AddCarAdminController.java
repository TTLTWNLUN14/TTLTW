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

@WebServlet(name = "AddCarAdminController", value = "/cars-admin/add")
public class AddCarAdminController extends HttpServlet {

    private final BrandService brandService      = new BrandService();
    private final CarTypeService carTypeService  = new CarTypeService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ds xe
        List<Brand> listBrand = brandService.getListBrand();
        request.setAttribute("listBrand", listBrand);

        // neu goi tu hang thi lay hang do ra
        String brandIdStr = request.getParameter("brandId");
        if (brandIdStr != null && !brandIdStr.isEmpty()) {
            try {
                request.setAttribute("selectedBrandId", Integer.parseInt(brandIdStr));
            } catch (NumberFormatException ignored) { }
        }

        request.getRequestDispatcher("/WEB-INF/views/add-car-admin.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        CarType ct = buildCarTypeFromRequest(request);
        ct.setIsActive(true);

        carTypeService.insertCarType(ct);

        response.sendRedirect(request.getContextPath() + "/cars-admin");
    }

    private CarType buildCarTypeFromRequest(HttpServletRequest request) {
        CarType ct = new CarType();
        ct.setBrandId(Integer.parseInt(request.getParameter("brandId")));
        ct.setTypeName(request.getParameter("typeName"));
        ct.setCategory(request.getParameter("category"));

        ct.setSeatingPlan(parseIntSafe(request.getParameter("seatingPlan"), 0));
        ct.setFuel(request.getParameter("fuel"));
        ct.setPriceKm(parseIntSafe(request.getParameter("priceKm"), 0));
        ct.setPriceDay(parseIntSafe(request.getParameter("priceDay"), 0));
        ct.setImg(request.getParameter("img"));
        ct.setDescriptionType(request.getParameter("descriptionType"));
        ct.setCount(parseIntSafe(request.getParameter("count"), 0));

        return ct;
    }

    private int parseIntSafe(String value, int defaultVal) {
        if (value == null || value.isEmpty()) return defaultVal;
        try { return Integer.parseInt(value); }
        catch (NumberFormatException e) { return defaultVal; }
    }
}
