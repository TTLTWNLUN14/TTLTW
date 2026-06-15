package vn.edu.nlu.fit.datxedulich.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.Brand;
import vn.edu.nlu.fit.datxedulich.services.BrandService;
import vn.edu.nlu.fit.datxedulich.utils.FileUploadUtil;

import java.io.IOException;

@WebServlet(name = "AddBrandController", value = "/add-brand")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // > 1MB thì ghi tạm ra disk
        maxFileSize = 1024 * 1024 * 5,        // 5MB: kích thước tối đa 1 file
        maxRequestSize = 1024 * 1024 * 10     // 10MB: kích thước tối đa cả request
)
public class AddBrandAdminController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/add-brand-admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Bắt buộc set encoding trước khi đọc parameter, tránh lỗi tiếng Việt
        request.setCharacterEncoding("UTF-8");

        // Đọc form
        Brand brand = new Brand();
        brand.setBrandName(request.getParameter("brandName"));
        brand.setCountry(request.getParameter("country"));
        brand.setDescriptionBrand(request.getParameter("descriptionBrand"));

        // Upload ảnh logo -> lưu vào assets/uploads/brands
        String logoPath = FileUploadUtil.uploadFile(request, "logoFile", "brands");
        brand.setLogo(logoPath);

        BrandService brandService = new BrandService();
        brandService.insertBrand(brand);

        // sau khi post xong → chuyen ve về brand-admin
        response.sendRedirect(request.getContextPath() + "/brand-admin");
    }
}