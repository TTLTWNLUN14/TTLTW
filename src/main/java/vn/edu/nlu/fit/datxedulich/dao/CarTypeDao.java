package vn.edu.nlu.fit.datxedulich.dao;

import org.jdbi.v3.core.statement.PreparedBatch;
import vn.edu.nlu.fit.datxedulich.model.CarType;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CarTypeDao extends BaseDao{
    static Map<Integer, CarType> productMap = new HashMap<Integer, CarType>();

    public List<CarType> getListCarType() {
        return get().withHandle(h-> h.createQuery("select * from car_types").mapToBean(CarType.class).list());
    }

    public CarType getCarTypeById(int id) {
        return get().withHandle(h -> h.createQuery("select * from car_types where type_id = :id").bind("id", id).mapToBean(CarType.class).first()
        );
    }

    // insert

    public void insertProduct(List<CarType> products) {
        get().useHandle(handle -> {
            PreparedBatch batch = handle.prepareBatch(
                    "INSERT INTO car_types (brand_id, type_name, category, seating_plan, fuel, price_dirver, price_km, price_day, img, description_type, count, is_active) " +
                            "VALUES (:brandId, :typeName, :category, :seatingPlan, :fuel, :priceDirver, :priceKm, :priceDay, :img, :descriptionType, :count, :active)"
            );
            products.forEach(product -> {
                batch.bindBean(product).add();
            });
            batch.execute();
        });
    }
    public List<CarType> getCarTypesByBrandId(int brandId) {
        return get().withHandle(h ->h.createQuery("SELECT * FROM car_types WHERE brand_id = :brandId ORDER BY type_id").bind("brandId", brandId).mapToBean(CarType.class).list());
    }
    // Thêm loại xe mới
    public void insertCarType(CarType ct) {
        get().useHandle(h ->h.createUpdate("INSERT INTO car_types (brand_id, type_name, category, seating_plan, fuel,  price_dirver, price_km, price_day, img, description_type, count, is_active) VALUES  (:brandId, :typeName, :category, :seatingPlan, :fuel,  :priceDirver, :priceKm, :priceDay, :img, :descriptionType, :count, :active)").bindBean(ct).execute());
    }

    // Cập nhật loại xe
    public void updateCarType(CarType ct) {
        get().useHandle(h ->h.createUpdate("UPDATE car_types SET brand_id = :brandId, type_name = :typeName, category = :category, seating_plan = :seatingPlan, fuel = :fuel, price_dirver = :priceDirver, price_km = :priceKm, price_day = :priceDay, img = :img, description_type = :descriptionType, count = :count, is_active = :active WHERE type_id = :typeId").bindBean(ct).execute());
    }

    // Xóa loại xe
    public void deleteCarType(int typeId) {
        get().useHandle(h ->
                h.createUpdate("DELETE FROM car_types WHERE type_id = :typeId").bind("typeId", typeId).execute());
    }

}