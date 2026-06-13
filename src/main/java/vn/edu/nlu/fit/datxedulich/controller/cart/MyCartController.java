package vn.edu.nlu.fit.datxedulich.controller.cart;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.dao.CartDAO;
import vn.edu.nlu.fit.datxedulich.dao.MemberDAO;
import vn.edu.nlu.fit.datxedulich.model.Booking;
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
import java.util.stream.Collectors;

@WebServlet(name = "MyCartController", value = "/my-shopping-cart")
public class MyCartController extends HttpServlet {

    private final MemberDAO memberDAO = new MemberDAO();
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BrandService brandService = new BrandService();
        ProvinceService provinceService = new ProvinceService();
        ProductService productService = new ProductService();

        List<Brand> brands = brandService.getListBrand();
        List<Province> provinces = provinceService.getAllProvinces();

        request.setAttribute("brands", brands);
        request.setAttribute("provinces", provinces);

        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("account_id");
        Cart cart = (Cart) session.getAttribute("cart");

        // FIX: nếu đã đăng nhập mà session cart null thì load lại từ DB
        if (accountId != null && cart == null) {
            try {
                cart = cartDAO.loadCart(accountId);
                session.setAttribute("cart", cart);
            } catch (Exception e) {
                e.printStackTrace();
                cart = new Cart();
            }
        }

        Map<Integer, List<CarType>> carsMap = new HashMap<>();
        if (cart != null) {
            for (CartItem item : cart.getItems()) {
                int brandId = item.getSelectedBrandId();
                if (brandId > 0 && !carsMap.containsKey(brandId)) {
                    carsMap.put(brandId, productService.getProductsByBrandId(brandId));
                }
            }
        }
        request.setAttribute("carsMap", carsMap);

        if (accountId != null) {
            try {
                List<Booking> bookingHistory = memberDAO.getMemberBookingHistory(accountId);

                String statusFilter = request.getParameter("statusFilter");
                if (statusFilter != null && !statusFilter.isBlank() && !"all".equals(statusFilter)) {
                    bookingHistory = bookingHistory.stream()
                            .filter(b -> statusFilter.equals(b.getStatus()))
                            .collect(Collectors.toList());
                }

                request.setAttribute("bookingHistory", bookingHistory);
                request.setAttribute("statusFilter", statusFilter != null ? statusFilter : "all");

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("bookingHistory", List.of());
                request.setAttribute("statusFilter", "all");
            }
        } else {
            request.setAttribute("bookingHistory", List.of());
            request.setAttribute("statusFilter", "all");
        }

        request.getRequestDispatcher("/WEB-INF/views/shopping-cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}