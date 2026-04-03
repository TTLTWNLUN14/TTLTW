package vn.edu.nlu.fit.datxedulich.dao;

import vn.edu.nlu.fit.datxedulich.model.Brand;

import java.util.List;

public class BrandDao extends BaseDao {

    // all hãng xe
    public List<Brand> getListBrand() {
        return get().withHandle(h -> h.createQuery("SELECT * FROM car_brands ORDER BY brand_id ASC").mapToBean(Brand.class).list());
    }

    // Lấy 1 hãng xe theo id
    public Brand getBrandById(int brandId) {
        return get().withHandle(h -> h.createQuery("SELECT * FROM car_brands WHERE brand_id = :brandId").bind("brandId", brandId).mapToBean(Brand.class).findFirst().orElse(null));
    }

    // Thêm hãng xe mới
    public void insertBrand(Brand brand) {
        get().useHandle(h -> h.createUpdate("INSERT INTO car_brands (brand_name, logo, country, description_brand, is_active) VALUES (:brandName, :logo, :country, :descriptionBrand, :isActive)").bindBean(brand).execute());
    }

    // Cập nhật hãng xe theo brand_id
    public void updateBrand(Brand brand) {
        get().useHandle(h ->
                h.createUpdate(
                        "UPDATE car_brands SET brand_name = :brandName, logo = :logo, country = :country, description_brand = :descriptionBrand, is_active = :isActive WHERE brand_id = :brandId").bindBean(brand).execute());
    }

    // Xóa hãng xe theo id
    public void deleteBrand(int brandId) {
        get().useHandle(h -> h.createUpdate("DELETE FROM car_brands WHERE brand_id = :brandId").bind("brandId", brandId).execute());
    }
}