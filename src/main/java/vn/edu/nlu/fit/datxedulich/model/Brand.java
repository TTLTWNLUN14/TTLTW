package vn.edu.nlu.fit.datxedulich.model;

import java.io.Serializable;

public class Brand implements Serializable {
    private int brandId;
    private String brandName;
    private String logo;
    private String country;
    private String descriptionBrand;

    public Brand() {
    }

    public Brand(int brandId, String brandName, String logo,
                 String country, String descriptionBrand) {
        this.brandId = brandId;
        this.brandName = brandName;
        this.logo = logo;
        this.country = country;
        this.descriptionBrand = descriptionBrand;
    }

    public int getBrandId() {
        return brandId;
    }

    public void setBrandId(int brandId) {
        this.brandId = brandId;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getLogo() {
        return logo;
    }

    public void setLogo(String logo) {
        this.logo = logo;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getDescriptionBrand() {
        return descriptionBrand;
    }

    public void setDescriptionBrand(String descriptionBrand) {
        this.descriptionBrand = descriptionBrand;
    }

    public void setIsActive(boolean b) {
    }
}