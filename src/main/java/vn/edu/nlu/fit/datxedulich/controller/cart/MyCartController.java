package vn.edu.nlu.fit.datxedulich.controller.cart;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.Brand;
import vn.edu.nlu.fit.datxedulich.model.CarType;
import vn.edu.nlu.fit.datxedulich.model.Province;
import vn.edu.nlu.fit.datxedulich.model.cart.Cart;
import vn.edu.nlu.fit.datxedulich.model.cart.CartItem;
import vn.edu.nlu.fit.datxedulich.services.BrandService;
import vn.edu.nlu.fit.datxedulich.services.ProductService;
import vn.edu.nlu.fit.datxedulich.services.ProvinceService;

import java.io.IOException;
import java.util.*;

@WebServlet(name = "MyCartController", value = "/my-shopping-cart")
public class MyCartController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BrandService brandService    = new BrandService();
        ProvinceService provinceService = new ProvinceService();
        ProductService productService   = new ProductService();

        List<Brand>    brands    = brandService.getListBrand();
        List<Province> provinces = provinceService.getAllProvinces();

        request.setAttribute("brands",    brands);
        request.setAttribute("provinces", provinces);

        // Với mỗi item trong giỏ: nếu đã chọn hãng thì load danh sách xe của hãng đó
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        // Map List- xe theo hãng đang chọn của item đó
        Map<Integer, List<CarType>> carsMap = new HashMap<>();

        if (cart != null) {
            for (CartItem item : cart.getItems()) {
                int brandId = item.getSelectedBrandId();
                if (brandId > 0 && !carsMap.containsKey(brandId)) {
                    List<CarType> carsOfBrand = productService.getProductsByBrandId(brandId);
                    carsMap.put(brandId, carsOfBrand);
                }
            }
        }

        request.setAttribute("carsMap", carsMap);
        request.getRequestDispatcher("/WEB-INF/views/shopping-cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}
