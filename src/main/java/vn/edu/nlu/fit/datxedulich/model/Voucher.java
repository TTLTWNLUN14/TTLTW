package vn.edu.nlu.fit.datxedulich.model;

import java.io.Serializable;
import java.sql.Date;

public class Voucher implements Serializable {
    private int voucherId;
    private String code;
    private String nameVoucher;
    private float discount;
    private int priceMaxDiscount;
    private float minOrder;
    private String minTier;
    private int usesLeft;
    private Date expiresAt;
    private boolean isActive;

    public Voucher() {

    }

    public Voucher(int voucherId, String code, String nameVoucher, float discount, int priceMaxDiscount, float minOrder, String minTier, int usesLeft, Date expiresAt, boolean isActive) {
        this.voucherId = voucherId;
        this.code = code;
        this.nameVoucher = nameVoucher;
        this.discount = discount;
        this.priceMaxDiscount = priceMaxDiscount;
        this.minOrder = minOrder;
        this.minTier = minTier;
        this.usesLeft = usesLeft;
        this.expiresAt = expiresAt;
        this.isActive = isActive;
    }

    public int getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(int voucherId) {
        this.voucherId = voucherId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getNameVoucher() {
        return nameVoucher;
    }

    public void setNameVoucher(String nameVoucher) {
        this.nameVoucher = nameVoucher;
    }

    public float getDiscount() {
        return discount;
    }

    public void setDiscount(float discount) {
        this.discount = discount;
    }

    public int getPriceMaxDiscount() {
        return priceMaxDiscount;
    }

    public void setPriceMaxDiscount(int priceMaxDiscount) {
        this.priceMaxDiscount = priceMaxDiscount;
    }

    public float getMinOrder() {
        return minOrder;
    }

    public void setMinOrder(float minOrder) {
        this.minOrder = minOrder;
    }

    public String getMinTier() {
        return minTier;
    }

    public void setMinTier(String minTier) {
        this.minTier = minTier;
    }

    public int getUsesLeft() {
        return usesLeft;
    }

    public void setUsesLeft(int usesLeft) {
        this.usesLeft = usesLeft;
    }

    public Date getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Date expiresAt) {
        this.expiresAt = expiresAt;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }
}
