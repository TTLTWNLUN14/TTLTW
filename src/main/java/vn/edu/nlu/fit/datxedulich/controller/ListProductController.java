package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.Brand;
import vn.edu.nlu.fit.datxedulich.model.CarType;
import vn.edu.nlu.fit.datxedulich.services.BrandService;
import vn.edu.nlu.fit.datxedulich.services.CarTypeService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ListProductController", value = "/list-product")
public class ListProductController extends HttpServlet {

    private final CarTypeService ps = new CarTypeService();
    private final BrandService   bs = new BrandService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer brandId     = parseIntParam(request, "brandId");
        String  category    = emptyToNull(request.getParameter("category"));
        Integer seatingPlan = parseIntParam(request, "seatingPlan");
        String  fuel        = emptyToNull(request.getParameter("fuel"));
        Integer maxPriceKm  = parseIntParam(request, "maxPriceKm");

        List<CarType> list;

        boolean hasFilter = brandId != null || category != null
                || seatingPlan != null || fuel != null || maxPriceKm != null;

        if (hasFilter) {
            list = ps.filterCarTypes(brandId, category, seatingPlan, fuel, maxPriceKm);
        } else {
            list = ps.getListCarType();
        }

        List<Brand> brands = bs.getListBrand();

        request.setAttribute("list",           list);
        request.setAttribute("brands",         brands);
        request.setAttribute("selectedBrandId",  brandId);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("selectedSeat",     seatingPlan);
        request.setAttribute("selectedFuel",     fuel);
        request.setAttribute("selectedMaxPrice", maxPriceKm);

        request.getRequestDispatcher("/WEB-INF/views/list-cars.jsp").forward(request, response);
    }

    private Integer parseIntParam(HttpServletRequest req, String name) {
        String v = req.getParameter(name);
        if (v == null || v.isBlank()) return null;
        try { return Integer.parseInt(v.trim()); } catch (NumberFormatException e) { return null; }
    }

    private String emptyToNull(String s) {
        return (s == null || s.isBlank()) ? null : s.trim();
    }
}