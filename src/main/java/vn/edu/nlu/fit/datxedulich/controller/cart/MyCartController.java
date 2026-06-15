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

    private static final int PAGE_SIZE = 10;
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
                List<Booking> allHistory = memberDAO.getMemberBookingHistory(accountId);

                String statusFilter = request.getParameter("statusFilter");
                if (statusFilter != null && !statusFilter.isBlank() && !"all".equals(statusFilter)) {
                    allHistory = allHistory.stream()
                            .filter(b -> statusFilter.equals(b.getStatus()))
                            .collect(Collectors.toList());
                }

                // Phân trang
                int page = 1;
                String pageStr = request.getParameter("historyPage");
                if (pageStr != null && !pageStr.isBlank()) {
                    try {
                        page = Math.max(1, Integer.parseInt(pageStr));
                    } catch (NumberFormatException ignored) {
                    }
                }

                int totalItems = allHistory.size();
                int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);
                int from = (page - 1) * PAGE_SIZE;
                int to = Math.min(from + PAGE_SIZE, totalItems);
                List<Booking> pageHistory = (from < totalItems)
                        ? allHistory.subList(from, to)
                        : List.of();

                request.setAttribute("bookingHistory", pageHistory);
                request.setAttribute("statusFilter", statusFilter != null ? statusFilter : "all");
                request.setAttribute("historyTotalItems", totalItems);
                request.setAttribute("historyTotalPages", totalPages);
                request.setAttribute("historyPage", page);

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("bookingHistory", List.of());
                request.setAttribute("statusFilter", "all");
                request.setAttribute("historyTotalItems", 0);
                request.setAttribute("historyTotalPages", 0);
                request.setAttribute("historyPage", 1);
            }
        } else {
            request.setAttribute("bookingHistory", List.of());
            request.setAttribute("statusFilter", "all");
            request.setAttribute("historyTotalItems", 0);
            request.setAttribute("historyTotalPages", 0);
            request.setAttribute("historyPage", 1);
        }

        request.getRequestDispatcher("/WEB-INF/views/shopping-cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}