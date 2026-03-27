package vn.edu.nlu.fit.datxedulich.model;

import java.io.Serializable;

public class Brand implements Serializable {
    private int brandId;
    private String brandName;
    private String urlLogo;
    private String country;
    private String description;
    private boolean isActive;

    public Brand() {}

    public Brand(int brandId, String brandName, String urlLogo, String country, String description, boolean isActive) {
        this.brandId = brandId;
        this.brandName = brandName;
        this.urlLogo = urlLogo;
        this.country = country;
        this.description = description;
        this.isActive = isActive;
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

    public String getUrlLogo() {
        return urlLogo;
    }

    public void setUrlLogo(String urlLogo) {
        this.urlLogo = urlLogo;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }
}
