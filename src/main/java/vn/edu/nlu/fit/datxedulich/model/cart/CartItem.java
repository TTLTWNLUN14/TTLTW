package vn.edu.nlu.fit.datxedulich.model.cart;

import vn.edu.nlu.fit.datxedulich.model.CarType;

import java.io.Serializable;

public class CartItem implements Serializable {

    private int quantity;
    private boolean isDriver;
    private int price;       // priceKm của xe
    private CarType carType; // xe gốc được thêm vào giỏ

    // --- Thông tin chi tiết do người dùng điền trong giỏ hàng ---
    private int selectedBrandId;    // hãng xe đã chọn trong detail
    private int selectedTypeId;     // xe đã chọn trong detail (có thể khác xe gốc)
    private String selectedTypeName;
    private String selectedCategory;
    private int selectedSeatingPlan;

    private int fromProvinceId;     // điểm đón
    private String fromProvinceName;
    private int toProvinceId;       // điểm tới
    private String toProvinceName;
    private int km;                 // khoảng cách tra từ DB

    private String pickupTime;      // datetime-local
    private String returnTime;

    private String email;
    private String phone;

    public CartItem() {}

    public CartItem(int quantity, boolean isDriver, CarType carType) {
        this.quantity = quantity;
        this.isDriver = isDriver;
        this.price = carType.getPriceKm();
        this.carType = carType;
        // Mặc định chọn xe gốc
        this.selectedTypeId  = carType.getTypeId();
        this.selectedTypeName = carType.getTypeName();
        this.selectedCategory = carType.getCategory();
        this.selectedSeatingPlan = carType.getSeatingPlan();
        this.selectedBrandId = carType.getBrandId();
        this.km = 0;
    }

    // Tổng tiền = priceKm * km * số lượng
    public int getTotal() {
        return price * km * quantity;
    }

    // -------- getters / setters --------

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public boolean isDriver() { return isDriver; }
    public void setDriver(boolean driver) { isDriver = driver; }

    public int getPrice() { return price; }
    public void setPrice(int price) { this.price = price; }

    public CarType getProduct() { return carType; }
    public void setProduct(CarType carType) { this.carType = carType; }

    public void upQuantity(int quantity) { this.quantity += quantity; }

    public int getSelectedBrandId() { return selectedBrandId; }
    public void setSelectedBrandId(int selectedBrandId) { this.selectedBrandId = selectedBrandId; }

    public int getSelectedTypeId() { return selectedTypeId; }
    public void setSelectedTypeId(int selectedTypeId) { this.selectedTypeId = selectedTypeId; }

    public String getSelectedTypeName() { return selectedTypeName; }
    public void setSelectedTypeName(String selectedTypeName) { this.selectedTypeName = selectedTypeName; }

    public String getSelectedCategory() { return selectedCategory; }
    public void setSelectedCategory(String selectedCategory) { this.selectedCategory = selectedCategory; }

    public int getSelectedSeatingPlan() { return selectedSeatingPlan; }
    public void setSelectedSeatingPlan(int selectedSeatingPlan) { this.selectedSeatingPlan = selectedSeatingPlan; }

    public int getFromProvinceId() { return fromProvinceId; }
    public void setFromProvinceId(int fromProvinceId) { this.fromProvinceId = fromProvinceId; }

    public String getFromProvinceName() { return fromProvinceName; }
    public void setFromProvinceName(String fromProvinceName) { this.fromProvinceName = fromProvinceName; }

    public int getToProvinceId() { return toProvinceId; }
    public void setToProvinceId(int toProvinceId) { this.toProvinceId = toProvinceId; }

    public String getToProvinceName() { return toProvinceName; }
    public void setToProvinceName(String toProvinceName) { this.toProvinceName = toProvinceName; }

    public int getKm() { return km; }
    public void setKm(int km) { this.km = km; }

    public String getPickupTime() { return pickupTime; }
    public void setPickupTime(String pickupTime) { this.pickupTime = pickupTime; }

    public String getReturnTime() { return returnTime; }
    public void setReturnTime(String returnTime) { this.returnTime = returnTime; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
}
