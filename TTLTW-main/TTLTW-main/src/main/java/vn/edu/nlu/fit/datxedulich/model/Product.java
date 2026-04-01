package vn.edu.nlu.fit.datxedulich.model;

import java.io.Serializable;

public class Product implements Serializable {
    private int id ;
    private int brandId;
    private String name ;
    private int priceKm ;
    private int priceDay ;
    private String image;
    private boolean status;

    public Product() {
    }

    public Product(int id, int brandId,String name, int priceKm, int priceDay, String image) {
        this.id = id;
        this.brandId = brandId;
        this.name = name;
        this.priceKm = priceKm;
        this.priceDay = priceDay;
        this.image = image;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getBrandId() {
        return brandId;
    }
    public void setBrandId(int brandId) {
        this.brandId = brandId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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


    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
}
