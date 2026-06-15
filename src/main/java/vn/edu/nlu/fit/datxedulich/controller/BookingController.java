package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.dao.BookingDao;
import vn.edu.nlu.fit.datxedulich.dao.CartDAO;
import vn.edu.nlu.fit.datxedulich.dao.MemberDAO;
import vn.edu.nlu.fit.datxedulich.model.Booking;
import vn.edu.nlu.fit.datxedulich.model.Brand;
import vn.edu.nlu.fit.datxedulich.model.CarType;
import vn.edu.nlu.fit.datxedulich.model.Member;
import vn.edu.nlu.fit.datxedulich.model.cart.Cart;
import vn.edu.nlu.fit.datxedulich.model.cart.CartItem;
import vn.edu.nlu.fit.datxedulich.services.BrandService;
import vn.edu.nlu.fit.datxedulich.services.CarTypeService;
import vn.edu.nlu.fit.datxedulich.services.ProvinceService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(name = "BookingController", value = "/booking")
public class BookingController extends HttpServlet {

    private final BookingDao bookingDAO = new BookingDao();
    private final CartDAO cartDAO = new CartDAO();
    private final MemberDAO memberDAO = new MemberDAO();
    private final CarTypeService carTypeService = new CarTypeService();
    private final BrandService brandService = new BrandService();
    private final ProvinceService provinceService = new ProvinceService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String[] selectedTypeIds = (String[]) session.getAttribute("selectedTypeIds");
        CartItem singleBookingItem = (CartItem) session.getAttribute("singleBookingItem");

        // quay lại giỏ từ booking-confirm
        if ("backToCart".equals(request.getParameter("action"))) {
            if (singleBookingItem != null) {
                int accountId = (Integer) session.getAttribute("account_id");
                Cart cart = (Cart) session.getAttribute("cart");
                if (cart == null) cart = new Cart();

                cart.addItem(singleBookingItem.getProduct(), singleBookingItem.getQuantity());
                CartItem saved = cart.get(singleBookingItem.getSelectedTypeId());
                if (saved != null) {
                    saved.setFromProvinceId(singleBookingItem.getFromProvinceId());
                    saved.setToProvinceId(singleBookingItem.getToProvinceId());
                    saved.setFromProvinceName(singleBookingItem.getFromProvinceName());
                    saved.setToProvinceName(singleBookingItem.getToProvinceName());
                    saved.setPickupTime(singleBookingItem.getPickupTime());
                    saved.setReturnTime(singleBookingItem.getReturnTime());
                    saved.setKm(singleBookingItem.getKm());
                    saved.setSelectedTypeId(singleBookingItem.getSelectedTypeId());
                    saved.setSelectedTypeName(singleBookingItem.getSelectedTypeName());
                    saved.setSelectedBrandId(singleBookingItem.getSelectedBrandId());
                    saved.setSelectedCategory(singleBookingItem.getSelectedCategory());
                    saved.setSelectedSeatingPlan(singleBookingItem.getSelectedSeatingPlan());
                }

                session.setAttribute("cart", cart);
                cartDAO.saveCart(accountId, cart);
                session.removeAttribute("singleBookingItem");
            }
            response.sendRedirect(request.getContextPath() + "/my-shopping-cart");
            return;
        }

        if ("1".equals(request.getParameter("bookNow"))) {
            createSingleBookingItem(request, session);
            renderSingleBookingConfirm(request, response, session);
            return;
        }
        if (singleBookingItem != null) {
            renderSingleBookingConfirm(request, response, session);
            return;
        }

        if (selectedTypeIds == null || selectedTypeIds.length == 0) {
            // không có đơn nào được chọn từ giỏ hàng -> hiển thị trang chọn xe để đặt 1 đơn nhập tay
            showCarSelectionForm(request, response);
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");
        List<CartItem> selectedItems = new ArrayList<>();

        if (cart != null) {
            for (String idStr : selectedTypeIds) {
                try {
                    CartItem ci = cart.get(Integer.parseInt(idStr));
                    if (ci != null) selectedItems.add(ci);
                } catch (NumberFormatException ignored) {
                }
            }
        }

        if (selectedItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/my-shopping-cart");
            return;
        }

        int accountId = (Integer) session.getAttribute("account_id");
        Member member = memberDAO.getMemberById(accountId);

        int grandTotal = selectedItems.stream().mapToInt(CartItem::getTotal).sum();

        request.setAttribute("selectedItems", selectedItems);
        request.setAttribute("grandTotal", grandTotal);
        request.setAttribute("member", member);

        request.getRequestDispatcher("/WEB-INF/views/booking-confirm.jsp")
                .forward(request, response);
    }

    // trang chọn xe để đặt 1 đơn nhập tay (không qua giỏ hàng) -> forward booking.jsp
    private void showCarSelectionForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer selBrandId = parseIntParam(request, "brandId");
        Integer selTypeId = parseIntParam(request, "typeId");

        List<Brand> brands = brandService.getListBrand();

        Map<Integer, List<CarType>> carsMap = new HashMap<>();
        if (selBrandId != null && selBrandId > 0) {
            carsMap.put(selBrandId, carTypeService.getCarTypesByBrandId(selBrandId));
        }

        CarType selCar = null;
        if (selTypeId != null && selTypeId > 0) {
            selCar = carTypeService.getCarTypeById(selTypeId);
            // nếu chưa có brandId nhưng đã có typeId -> tự suy ra brand để hiển thị select
            if (selCar != null && selBrandId == null) {
                int brandId = selCar.getBrandId();
                if (brandId > 0) {
                    selBrandId = brandId;
                    carsMap.put(selBrandId, carTypeService.getCarTypesByBrandId(selBrandId));
                }
            }
        }

        request.setAttribute("brands", brands);
        request.setAttribute("provinces", provinceService.getAllProvinces());
        request.setAttribute("carsMap", carsMap);
        request.setAttribute("selBrandId", selBrandId != null ? selBrandId : 0);
        request.setAttribute("selTypeId", selTypeId != null ? selTypeId : 0);
        request.setAttribute("selCar", selCar);

        request.getRequestDispatcher("/WEB-INF/views/booking.jsp")
                .forward(request, response);
    }

    private Integer parseIntParam(HttpServletRequest request, String name) {
        String v = request.getParameter(name);
        if (v == null || v.isBlank()) return null;
        try {
            return Integer.parseInt(v.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private void createSingleBookingItem(HttpServletRequest request, HttpSession session)
            throws IOException {

        Integer typeId = parseIntParam(request, "productId");
        if (typeId == null) typeId = parseIntParam(request, "typeId");

        if (typeId == null || typeId <= 0) return;

        CarType product = carTypeService.getCarTypeById(typeId);
        if (product == null) return;

        Integer quantity = parseIntParam(request, "quantity");
        CartItem item = new CartItem(quantity != null && quantity > 0 ? quantity : 1, product);

        Integer fromProvinceId = parseIntParam(request, "fromProvinceId");
        Integer toProvinceId = parseIntParam(request, "toProvinceId");
        String fromProvinceName = request.getParameter("fromProvinceName");
        String toProvinceName = request.getParameter("toProvinceName");
        String pickupTime = request.getParameter("pickupTime");
        String returnTime = request.getParameter("returnTime");

        if (fromProvinceId != null && fromProvinceId > 0) item.setFromProvinceId(fromProvinceId);
        if (toProvinceId != null && toProvinceId > 0) item.setToProvinceId(toProvinceId);
        if (fromProvinceName != null && !fromProvinceName.isBlank()) item.setFromProvinceName(fromProvinceName);
        if (toProvinceName != null && !toProvinceName.isBlank()) item.setToProvinceName(toProvinceName);
        if (pickupTime != null && !pickupTime.isBlank()) item.setPickupTime(pickupTime);
        if (returnTime != null && !returnTime.isBlank()) item.setReturnTime(returnTime);

        if (item.getFromProvinceId() > 0 && item.getToProvinceId() > 0
                && item.getFromProvinceId() != item.getToProvinceId()) {
            item.setKm(provinceService.getDistance(item.getFromProvinceId(), item.getToProvinceId()));
        }

        session.setAttribute("singleBookingItem", item);
        session.removeAttribute("selectedTypeIds");
    }

    private void renderSingleBookingConfirm(HttpServletRequest request, HttpServletResponse response,
                                            HttpSession session)
            throws ServletException, IOException {

        CartItem item = (CartItem) session.getAttribute("singleBookingItem");
        if (item == null) {
            response.sendRedirect(request.getContextPath() + "/booking");
            return;
        }

        int accountId = (Integer) session.getAttribute("account_id");
        Member member = memberDAO.getMemberById(accountId);

        List<CartItem> selectedItems = new ArrayList<>();
        selectedItems.add(item);

        request.setAttribute("selectedItems", selectedItems);
        request.setAttribute("grandTotal", item.getTotal());
        request.setAttribute("member", member);

        request.getRequestDispatcher("/WEB-INF/views/booking-confirm.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String step = request.getParameter("step");
        if ("2".equals(step)) {
            handleStep2(request, response, session);
        } else {
            handleStep1(request, response, session);
        }
    }

    //  nhận selectedItems từ giỏ hàng → lưu session → redirect GET
    private void handleStep1(HttpServletRequest request, HttpServletResponse response,
                             HttpSession session) throws IOException {

        String[] items = request.getParameterValues("selectedItems");
        if (items == null || items.length == 0) {
            response.sendRedirect(request.getContextPath()
                    + "/my-shopping-cart?error=no_item_selected");
            return;
        }

        session.setAttribute("selectedTypeIds", items);
        response.sendRedirect(request.getContextPath() + "/booking");
    }

    // validate form → INSERT bookings → xóa cart items → redirect thanh toán
    private void handleStep2(HttpServletRequest request, HttpServletResponse response,
                             HttpSession session) throws ServletException, IOException {

        String bookerName = request.getParameter("bookerName");
        String bookerPhone = request.getParameter("bookerPhone");
        String bookerAddress = request.getParameter("bookerAddress");
        String note = request.getParameter("note");

        // validate
        if (bookerName == null || bookerName.isBlank()
                || bookerPhone == null || bookerPhone.isBlank()
                || bookerAddress == null || bookerAddress.isBlank()) {
            request.setAttribute("errorMsg", "Vui lòng điền đầy đủ Họ tên, SĐT và Địa chỉ đón.");
            doGet(request, response);
            return;
        }

        if (!bookerPhone.trim().matches("\\d{10}")) {
            request.setAttribute("errorMsg", "Số điện thoại không hợp lệ (cần đúng 10 chữ số).");
            doGet(request, response);
            return;
        }

        int accountId = (Integer) session.getAttribute("account_id");

        int customerId = getCustomerId(accountId);
        if (customerId == -1) {
            request.setAttribute("errorMsg", "Không tìm thấy thông tin khách hàng. Vui lòng đăng nhập lại.");
            doGet(request, response);
            return;
        }

        CartItem singleItem = (CartItem) session.getAttribute("singleBookingItem");

        if (singleItem != null) {
            Booking booking = buildBooking(singleItem, customerId, bookerName, bookerPhone, bookerAddress, note);
            int newId = bookingDAO.insertBooking(booking);

            session.removeAttribute("singleBookingItem");

            response.sendRedirect(request.getContextPath()
                    + "/payments?bookingIds=" + newId);
            return;
        }

        String[] selectedTypeIds = (String[]) session.getAttribute("selectedTypeIds");

        if (selectedTypeIds == null || selectedTypeIds.length == 0) {
            response.sendRedirect(request.getContextPath() + "/my-shopping-cart");
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            response.sendRedirect(request.getContextPath() + "/my-shopping-cart");
            return;
        }

        // INSERT từng CartItem thành 1 Booking row
        List<Integer> newBookingIds = new ArrayList<>();
        List<Integer> bookedTypeIds = new ArrayList<>();

        for (String idStr : selectedTypeIds) {
            try {
                int typeId = Integer.parseInt(idStr);
                CartItem ci = cart.get(typeId);
                if (ci == null) continue;

                Booking booking = buildBooking(ci, customerId, bookerName, bookerPhone, bookerAddress, note);

                int newId = bookingDAO.insertBooking(booking);
                newBookingIds.add(newId);
                bookedTypeIds.add(typeId);

            } catch (NumberFormatException ignored) {
            }
        }

        if (newBookingIds.isEmpty()) {
            request.setAttribute("errorMsg", "Đã có lỗi khi tạo đơn. Vui lòng thử lại.");
            doGet(request, response);
            return;
        }

        for (int typeId : bookedTypeIds) {
            cart.removeItem(typeId);
        }
        session.setAttribute("cart", cart);
        cartDAO.removeBookedItems(accountId, bookedTypeIds);

        // clean session
        session.removeAttribute("selectedTypeIds");

        // redirect sang trang thanh toán
        String bookingIdsParam = newBookingIds.stream()
                .map(String::valueOf)
                .collect(Collectors.joining(","));

        response.sendRedirect(request.getContextPath()
                + "/payments?bookingIds=" + bookingIdsParam);
    }

    private int getCustomerId(int accountId) {
        return memberDAO.ensureCustomerExists(accountId);
    }

    private Booking buildBooking(CartItem ci, int customerId, String bookerName,
                                 String bookerPhone, String bookerAddress, String note) {
        Booking booking = new Booking();
        booking.setCustomerId(customerId);
        booking.setTypeId(ci.getSelectedTypeId());
        booking.setVoucherId(null);   // không dùng voucher → NULL, tránh lỗi FK
        booking.setPickupProvince(
                ci.getFromProvinceName() != null ? ci.getFromProvinceName() : "");
        booking.setDropoffProvince(
                ci.getToProvinceName() != null ? ci.getToProvinceName() : "");
        // Truyền null thay vì chuỗi rỗng
        String pickupTime = ci.getPickupTime();
        String returnTime = ci.getReturnTime();
        booking.setPickupTime((pickupTime  != null && !pickupTime.isBlank())  ? pickupTime  : null);
        booking.setReturnTime((returnTime != null && !returnTime.isBlank()) ? returnTime : null);
        booking.setKm(ci.getKm());
        booking.setTotalPrice(ci.getTotal());
        booking.setBookerName(bookerName.trim());
        booking.setBookerPhone(bookerPhone.trim());
        booking.setBookerAddress(bookerAddress.trim());
        booking.setNote(note != null ? note.trim() : "");
        return booking;
    }
}