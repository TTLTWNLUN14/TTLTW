package vn.edu.nlu.fit.datxedulich.model.cart;

import vn.edu.nlu.fit.datxedulich.model.Product;

import java.io.Serializable;

public class CartItem implements Serializable {

    private int quantity;
    private boolean isDriver;
    private int price;
    private Product product;

    public CartItem() {
    }

    public CartItem(int quantity, boolean isDriver,  Product product) {
        this.quantity = quantity;
        this.isDriver = isDriver;
        this.price = isDriver? product.getPriceKm():product.getPriceDay();
        this.product = product;
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

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public void upQuantity(int quantity) {
        this.quantity += quantity;
    }
    public int getTotal() {
        return price * quantity;
    }
}
