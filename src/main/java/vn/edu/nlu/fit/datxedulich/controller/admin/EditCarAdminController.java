package vn.edu.nlu.fit.datxedulich.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.Brand;
import vn.edu.nlu.fit.datxedulich.model.CarType;
import vn.edu.nlu.fit.datxedulich.services.BrandService;
import vn.edu.nlu.fit.datxedulich.services.CarTypeService;
import vn.edu.nlu.fit.datxedulich.utils.FileUploadUtil;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "EditCarAdminController", value = "/cars-admin/edit")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // > 1MB thì ghi tạm ra disk
        maxFileSize = 1024 * 1024 * 5,        // 5MB kích thước tối đa 1 file
        maxRequestSize = 1024 * 1024 * 10     // 10MB kích thước tối đa cả request
)
public class EditCarAdminController extends HttpServlet {

    private final BrandService brandService      = new BrandService();
    private final CarTypeService carTypeService  = new CarTypeService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String typeIdStr = request.getParameter("typeId");
        if (typeIdStr == null || typeIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cars-admin");
            return;
        }

        try {
            int typeId = Integer.parseInt(typeIdStr);
            CarType carType = carTypeService.getCarTypeById(typeId);

            if (carType == null) {
                response.sendRedirect(request.getContextPath() + "/cars-admin");
                return;
            }

            List<Brand> listBrand = brandService.getListBrand();
            request.setAttribute("carType", carType);
            request.setAttribute("listBrand", listBrand);

            request.getRequestDispatcher("/WEB-INF/views/edit-car-admin.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/cars-admin");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        CarType ct = buildCarTypeFromRequest(request);
        ct.setTypeId(Integer.parseInt(request.getParameter("typeId")));

        String oldImg = request.getParameter("oldImg");
        String newImg = FileUploadUtil.uploadFile(request, "imgFile", "cars");
        ct.setImg(newImg != null ? newImg : oldImg);

        carTypeService.updateCarType(ct);

        String brandIdStr = request.getParameter("brandId");
        String redirect = request.getContextPath() + "/cars-admin?msg=edit_ok";
        if (brandIdStr != null && !brandIdStr.isEmpty()) {
            redirect += "&brandId=" + brandIdStr;
        }
        response.sendRedirect(redirect);
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
        ct.setDescriptionType(request.getParameter("descriptionType"));
        ct.setCount(parseIntSafe(request.getParameter("count"), 0));

        return ct;
    }
    private int parseIntSafe(String value, int defaultVal) {
        if (value == null || value.isEmpty()) return defaultVal;
        try {
            return Integer.parseInt(value);
        }
        catch (NumberFormatException e) {
            return defaultVal;
        }
    }
}
