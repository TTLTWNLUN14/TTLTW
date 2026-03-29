package vn.edu.nlu.fit.datxedulich.model.cart;


import vn.edu.nlu.fit.datxedulich.model.CarType;

import java.io.Serializable;

public class CartItem implements Serializable {

    private int quantity;
    private boolean isDriver;
    private int price;
    private CarType carType;

    public CartItem() {
    }

    public CartItem(int quantity, boolean isDriver,  CarType carType) {
        this.quantity = quantity;
        this.isDriver = isDriver;
        this.price = isDriver? carType.getPriceKm():carType.getPriceDay();
        this.carType = carType;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public boolean isDriver() {
        return isDriver;
    }

    public void setDriver(boolean driver) {
        isDriver = driver;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public CarType getProduct() {
        return carType;
    }

    public void setProduct(CarType carType) {
        this.carType = carType;
    }

    public void upQuantity(int quantity) {
        this.quantity += quantity;
    }
    public int getTotal() {
        return price * quantity;
    }
}
