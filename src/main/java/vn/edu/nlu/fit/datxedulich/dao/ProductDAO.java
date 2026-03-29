package vn.edu.nlu.fit.datxedulich.dao;

import org.jdbi.v3.core.statement.PreparedBatch;
import vn.edu.nlu.fit.datxedulich.model.CarType;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProductDAO extends BaseDao{
    static Map<Integer, CarType> productMap = new HashMap<Integer, CarType>();

    public List<CarType> getListProduct() {
        return get().withHandle(h-> h.createQuery("select * from car_types").mapToBean(CarType.class).list());
    }

    public CarType getProduct(int id) {
        return get().withHandle(h -> h.createQuery("select * from car_types where type_id = :id").bind("id", id).mapToBean(CarType.class).first()
        );
    }

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
    public List<CarType> getProductsByBrandId(int brandId) {
        return get().withHandle(h ->
                h.createQuery("SELECT * FROM car_types WHERE brand_id = :brandId")
                        .bind("brandId", brandId)
                        .mapToBean(CarType.class)
                        .list()
        );
    }


}