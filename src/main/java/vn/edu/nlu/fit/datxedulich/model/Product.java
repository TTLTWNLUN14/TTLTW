package vn.edu.nlu.fit.datxedulich.model;

import java.io.Serializable;

public class Product implements Serializable {
    private int id ;
    private String name ;
    private int priceKm ;
    private int priceDriver ;
    private String image;

    public Product() {
    }

    public Product(int id, String name, int priceKm, int priceDriver, String image) {
        this.id = id;
        this.name = name;
        this.priceKm = priceKm;
        this.priceDriver = priceDriver;
        this.image = image;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getPriceKm() {
        return priceKm;
    }

    public void setPriceKm(int priceKm) {
        this.priceKm = priceKm;
    }

    public double getPriceDriver() {
        return priceDriver;
    }

    public void setPriceDriver(int priceDriver) {
        this.priceDriver = priceDriver;
    }


    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
}
