package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.Brand;
import vn.edu.nlu.fit.datxedulich.model.CarType;
import vn.edu.nlu.fit.datxedulich.model.Province;
import vn.edu.nlu.fit.datxedulich.services.BrandService;
import vn.edu.nlu.fit.datxedulich.services.CarTypeService;
import vn.edu.nlu.fit.datxedulich.services.ProvinceService;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@WebServlet(name = "BookingController", value = "/booking")
public class BookingController extends HttpServlet {

    private final BrandService    brandService    = new BrandService();
    private final CarTypeService  carTypeService  = new CarTypeService();
    private final ProvinceService provinceService = new ProvinceService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int     selBrandId  = parseIntParam(request, "brandId",  0);
        int     selTypeId   = parseIntParam(request, "typeId",   0);
        boolean selIsDriver = !"false".equalsIgnoreCase(
                request.getParameter("isDriver"));

        List<Brand>    brands    = brandService.getListBrand();
        List<Province> provinces = provinceService.getAllProvinces();

        Map<Integer, List<CarType>> carsMap = new HashMap<>();
        for (Brand b : brands) {
            List<CarType> cars = carTypeService.getCarTypesByBrandId(b.getBrandId());
            if (!cars.isEmpty()) {
                carsMap.put(b.getBrandId(), cars);
            }
        }

        CarType selCar = null;
        if (selTypeId > 0) {
            selCar = carTypeService.getCarTypeById(selTypeId);

            if (selCar != null) {
                if (selBrandId == 0) selBrandId = selCar.getBrandId();
            }
        }

        request.setAttribute("brands",      brands);
        request.setAttribute("carsMap",     carsMap);
        request.setAttribute("provinces",   provinces);
        request.setAttribute("selBrandId",  selBrandId);
        request.setAttribute("selTypeId",   selTypeId);
        request.setAttribute("selCar",      selCar);
        request.setAttribute("selIsDriver", selIsDriver);

        request.getRequestDispatcher("/WEB-INF/views/booking.jsp")
                .forward(request, response);
    }

    private int parseIntParam(HttpServletRequest req, String name, int def) {
        String v = req.getParameter(name);
        if (v == null || v.isBlank()) return def;
        try { return Integer.parseInt(v.trim()); } catch (NumberFormatException e) { return def; }
    }
}
