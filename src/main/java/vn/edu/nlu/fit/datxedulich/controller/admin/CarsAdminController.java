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

        String msg = "";
        if ("delete".equals(action)) {
            try {
                int typeId = Integer.parseInt(request.getParameter("typeId"));
                // FIX: gọi deleteCarType mới — tự xử lý FK conflict bên trong
                boolean deleted = carTypeService.deleteCarType(typeId);
                msg = deleted ? "delete_ok" : "delete_fail";
            } catch (NumberFormatException e) {
                e.printStackTrace();
                msg = "delete_fail";
            }
        }

        String redirectUrl = request.getContextPath() + "/cars-admin?msg=" + msg;
        if (brandIdStr != null && !brandIdStr.isEmpty()) {
            redirectUrl += "&brandId=" + brandIdStr;
        }
        response.sendRedirect(redirectUrl);
    }
}