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

    private static final int PAGE_SIZE = 9;
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

        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isBlank()) {
            try { page = Math.max(1, Integer.parseInt(pageStr)); }
            catch (NumberFormatException ignored) {}
        }

        boolean hasFilter = brandId != null || category != null
                || seatingPlan != null || fuel != null || maxPriceKm != null;

        List<CarType> list;
        int totalItems;

        if (hasFilter) {
            List<CarType> allFiltered = ps.filterCarTypes(brandId, category, seatingPlan, fuel, maxPriceKm);
            totalItems = allFiltered.size();
            int from = (page - 1) * PAGE_SIZE;
            int to   = Math.min(from + PAGE_SIZE, totalItems);
            list = (from < totalItems) ? allFiltered.subList(from, to) : List.of();
        } else {
            totalItems = ps.countCarTypes();
            list = ps.getCarTypesPaged(page, PAGE_SIZE);
        }

        int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);

        List<Brand> brands = bs.getListBrand();

        request.setAttribute("list",            list);
        request.setAttribute("brands",          brands);
        request.setAttribute("currentPage",     page);
        request.setAttribute("totalPages",      totalPages);
        request.setAttribute("totalItems",      totalItems);
        request.setAttribute("pageSize",        PAGE_SIZE);

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