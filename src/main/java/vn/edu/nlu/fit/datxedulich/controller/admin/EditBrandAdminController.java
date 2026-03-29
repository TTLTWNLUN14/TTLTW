package vn.edu.nlu.fit.datxedulich.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.Brand;
import vn.edu.nlu.fit.datxedulich.services.BrandService;

import java.io.IOException;


@WebServlet(name = "EditBrandController", value = "/edit-brand")
public class EditBrandAdminController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Đọc brandId từ query param
        String brandIdParam = request.getParameter("brandId");
        if (brandIdParam == null || brandIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/brand-admin");
            return;
        }

        int brandId = Integer.parseInt(brandIdParam);
        BrandService brandService = new BrandService();

        // Lấy thông tin hãng xe từ db để điền sẵn vào form
        Brand brand = brandService.getBrandById(brandId);
        if (brand == null) {
            response.sendRedirect(request.getContextPath() + "/brand-admin");
            return;
        }

        // Đưa vào request để JSP đọc bằng ${brand}
        request.setAttribute("brand", brand);

        // Forward sang trang form sửa hãng xe
        request.getRequestDispatcher("/WEB-INF/views/edit-brand-admin.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Bắt buộc set encoding trước khi đọc parameter, tránh lỗi tiếng Việt
        request.setCharacterEncoding("UTF-8");

        // Đọc các field từ form
        Brand brand = new Brand();
        brand.setBrandId(Integer.parseInt(request.getParameter("brandId")));
        brand.setBrandName(request.getParameter("brandName"));
        brand.setLogo(request.getParameter("logo"));
        brand.setCountry(request.getParameter("country"));
        brand.setDescriptionBrand(request.getParameter("descriptionBrand"));
        // checkbox isActive: nếu tick thì gửi "true", không tick thì null
        brand.setIsActive("true".equals(request.getParameter("isActive")));

        BrandService brandService = new BrandService();
        brandService.updateBrand(brand);

        // PRG Pattern: sau khi POST xử lý xong → redirect về danh sách
        response.sendRedirect(request.getContextPath() + "/brand-admin");
    }
}