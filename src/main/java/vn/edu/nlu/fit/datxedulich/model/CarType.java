package vn.edu.nlu.fit.datxedulich.model;

import java.io.Serializable;

public class CarType implements Serializable {
    private int typeId;
    private int brandId;
    private String typeName;
    private String category;       // SUV, Sedan, MPV, Pickup...
    private int seatingPlan;       // số chỗ ngồi
    private String fuel;           // Xăng, Điện, Hybrid, Diesel
    private int priceDirver;       // giá thuê có tài xế (giữ đúng tên DB)
    private int priceKm;           // giá theo km
    private int priceDay;          // giá theo ngày
    private String img;            // URL ảnh xe
    private String descriptionType;
    private int count;             // số xe có sẵn
    private boolean isActive;

    public CarType() {
    }

    public int getTypeId() {
        return typeId;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public int getBrandId() {
        return brandId;
    }

    public void setBrandId(int brandId) {
        this.brandId = brandId;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getSeatingPlan() {
        return seatingPlan;
    }

    public void setSeatingPlan(int seatingPlan) {
        this.seatingPlan = seatingPlan;
    }

    public String getFuel() {
        return fuel;
    }

    public void setFuel(String fuel) {
        this.fuel = fuel;
    }

    public int getPriceDirver() {
        return priceDirver;
    }

    public void setPriceDirver(int priceDirver) {
        this.priceDirver = priceDirver;
    }

    public int getPriceKm() {
        return priceKm;
    }

    public void setPriceKm(int priceKm) {
        this.priceKm = priceKm;
    }

    public int getPriceDay() {
        return priceDay;
    }

    public void setPriceDay(int priceDay) {
        this.priceDay = priceDay;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }

    public String getDescriptionType() {
        return descriptionType;
    }

    public void setDescriptionType(String descriptionType) {
        this.descriptionType = descriptionType;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

}