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

    private final BrandService   brandService   = new BrandService();
    private final CarTypeService carTypeService = new CarTypeService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Brand> listBrand = brandService.getListBrand();
        request.setAttribute("listBrand", listBrand);

        Integer brandId     = parseIntParam(request, "brandId");
        String  category    = emptyToNull(request.getParameter("category"));
        Integer seatingPlan = parseIntParam(request, "seatingPlan");

        List<CarType> listCarType;

        boolean hasFilter = brandId != null || category != null || seatingPlan != null;

        if (hasFilter) {
            // fuel và maxPriceKm không có trong admin, truyền null
            listCarType = carTypeService.filterCarTypes(brandId, category, seatingPlan, null, null);
        } else {
            listCarType = carTypeService.getListCarType();
        }

        request.setAttribute("selectedBrandId",   brandId);
        request.setAttribute("selectedCategory",  category);
        request.setAttribute("selectedSeat",      seatingPlan);

        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("msg", msg);

        request.setAttribute("listCarType", listCarType);
        request.getRequestDispatcher("/WEB-INF/views/cars-admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action     = request.getParameter("action");
        String brandIdStr = request.getParameter("brandId");
        String category   = request.getParameter("category");
        String seatStr    = request.getParameter("seatingPlan");

        String msg = "";
        if ("delete".equals(action)) {
            try {
                int typeId  = Integer.parseInt(request.getParameter("typeId"));
                boolean deleted = carTypeService.deleteCarType(typeId);
                msg = deleted ? "delete_ok" : "delete_fail";
            } catch (NumberFormatException e) {
                e.printStackTrace();
                msg = "delete_fail";
            }
        }

        // Giữ lại cả 3 filter khi redirect sau xóa
        StringBuilder redirectUrl = new StringBuilder(
                request.getContextPath() + "/cars-admin?msg=" + msg);
        if (brandIdStr != null && !brandIdStr.isEmpty())
            redirectUrl.append("&brandId=").append(brandIdStr);
        if (category != null && !category.isEmpty())
            redirectUrl.append("&category=").append(category);
        if (seatStr != null && !seatStr.isEmpty())
            redirectUrl.append("&seatingPlan=").append(seatStr);

        response.sendRedirect(redirectUrl.toString());
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