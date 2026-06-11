package vn.edu.nlu.fit.datxedulich.dao;

import org.jdbi.v3.core.statement.PreparedBatch;
import vn.edu.nlu.fit.datxedulich.model.CarType;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CarTypeDao extends BaseDao {
    static Map<Integer, CarType> productMap = new HashMap<Integer, CarType>();

    public List<CarType> getListCarType() {
        return get().withHandle(h -> h.createQuery("SELECT * FROM car_types WHERE is_active = 1").mapToBean(CarType.class).list());
    }

    public CarType getCarTypeById(int id) {
        return get().withHandle(h -> h.createQuery("select * from car_types where type_id = :id")
                .bind("id", id).mapToBean(CarType.class).first());
    }

    public void insertProduct(List<CarType> products) {
        get().useHandle(handle -> {
            PreparedBatch batch = handle.prepareBatch(
                    "INSERT INTO car_types (brand_id, type_name, category, seating_plan, fuel, price_km, price_day, img, description_type, count) " +
                            "VALUES (:brandId, :typeName, :category, :seatingPlan, :fuel, :priceKm, :priceDay, :img, :descriptionType, :count)"
            );
            products.forEach(product -> batch.bindBean(product).add());
            batch.execute();
        });
    }

    public List<CarType> getCarTypesByBrandId(int brandId) {
        return get().withHandle(h -> h.createQuery("SELECT * FROM car_types WHERE brand_id = :brandId AND is_active = 1 ORDER BY type_id")
                .bind("brandId", brandId).mapToBean(CarType.class).list());
    }

    public void insertCarType(CarType ct) {
        get().useHandle(h -> h.createUpdate(
                        "INSERT INTO car_types (brand_id, type_name, category, seating_plan, fuel, price_km, price_day, img, description_type, count) " +
                                "VALUES (:brandId, :typeName, :category, :seatingPlan, :fuel, :priceKm, :priceDay, :img, :descriptionType, :count)")
                .bindBean(ct).execute());
    }

    public void updateCarType(CarType ct) {
        get().useHandle(h -> h.createUpdate(
                        "UPDATE car_types SET brand_id = :brandId, type_name = :typeName, category = :category, " +
                                "seating_plan = :seatingPlan, fuel = :fuel, price_km = :priceKm, " +
                                "price_day = :priceDay, img = :img, description_type = :descriptionType, count = :count " +
                                "WHERE type_id = :typeId")
                .bindBean(ct).execute());
    }

    public boolean deleteCarType(int typeId) {
        try {
            get().useHandle(h -> h.createUpdate(
                            "DELETE FROM car_types WHERE type_id = :typeId")
                    .bind("typeId", typeId).execute());
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    // Thêm: lọc nhiều tiêu chí
    public List<CarType> filterCarTypes(Integer brandId, String category, Integer seatingPlan,
                                        String fuel, Integer maxPriceKm) {
        StringBuilder sql = new StringBuilder("SELECT * FROM car_types WHERE is_active = 1");
        if (brandId != null && brandId > 0)       sql.append(" AND brand_id = :brandId");
        if (category != null && !category.isEmpty()) sql.append(" AND category = :category");
        if (seatingPlan != null && seatingPlan > 0)  sql.append(" AND seating_plan = :seatingPlan");
        if (fuel != null && !fuel.isEmpty())         sql.append(" AND fuel = :fuel");
        if (maxPriceKm != null && maxPriceKm > 0)   sql.append(" AND price_km <= :maxPriceKm");
        sql.append(" ORDER BY type_id");

        return get().withHandle(h -> {
            var query = h.createQuery(sql.toString());
            if (brandId != null && brandId > 0)         query.bind("brandId", brandId);
            if (category != null && !category.isEmpty()) query.bind("category", category);
            if (seatingPlan != null && seatingPlan > 0)  query.bind("seatingPlan", seatingPlan);
            if (fuel != null && !fuel.isEmpty())         query.bind("fuel", fuel);
            if (maxPriceKm != null && maxPriceKm > 0)   query.bind("maxPriceKm", maxPriceKm);
            return query.mapToBean(CarType.class).list();
        });
    }

    // Phân trang
    public List<CarType> getCarTypesPaged(int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        return get().withHandle(h -> h.createQuery(
                        "SELECT * FROM car_types WHERE is_active = 1 ORDER BY type_id LIMIT :limit OFFSET :offset")
                .bind("limit", pageSize)
                .bind("offset", offset)
                .mapToBean(CarType.class).list());
    }

    public int countCarTypes() {
        return get().withHandle(h -> h.createQuery("SELECT COUNT(*) FROM car_types WHERE is_active = 1")
                .mapTo(Integer.class).one());
    }

    public int countCarTypesByBrand(int brandId) {
        return get().withHandle(h -> h.createQuery(
                        "SELECT COUNT(*) FROM car_types WHERE brand_id = :brandId AND is_active = 1")
                .bind("brandId", brandId)
                .mapTo(Integer.class).one());
    }
}