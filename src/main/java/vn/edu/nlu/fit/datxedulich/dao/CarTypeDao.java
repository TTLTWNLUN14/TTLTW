package vn.edu.nlu.fit.datxedulich.dao;

import org.jdbi.v3.core.statement.PreparedBatch;
import vn.edu.nlu.fit.datxedulich.model.CarType;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CarTypeDao extends BaseDao {
    static Map<Integer, CarType> productMap = new HashMap<Integer, CarType>();

    public List<CarType> getListCarType() {
        return get().withHandle(h -> h.createQuery("select * from car_types").mapToBean(CarType.class).list());
    }

    public CarType getCarTypeById(int id) {
        return get().withHandle(h -> h.createQuery("select * from car_types where type_id = :id")
                .bind("id", id).mapToBean(CarType.class).first());
    }

    public void insertProduct(List<CarType> products) {
        get().useHandle(handle -> {
            PreparedBatch batch = handle.prepareBatch(
                    "INSERT INTO car_types (brand_id, type_name, category, seating_plan, fuel, price_dirver, price_km, price_day, img, description_type, count, is_active) " +
                            "VALUES (:brandId, :typeName, :category, :seatingPlan, :fuel, :priceDirver, :priceKm, :priceDay, :img, :descriptionType, :count, :isActive)"
            );
            products.forEach(product -> batch.bindBean(product).add());
            batch.execute();
        });
    }

    public List<CarType> getCarTypesByBrandId(int brandId) {
        return get().withHandle(h -> h.createQuery("SELECT * FROM car_types WHERE brand_id = :brandId ORDER BY type_id")
                .bind("brandId", brandId).mapToBean(CarType.class).list());
    }

    public void insertCarType(CarType ct) {
        get().useHandle(h -> h.createUpdate(
                        "INSERT INTO car_types (brand_id, type_name, category, seating_plan, fuel, price_km, price_day, img, description_type, count, is_active) " +
                                "VALUES (:brandId, :typeName, :category, :seatingPlan, :fuel, :priceKm, :priceDay, :img, :descriptionType, :count, :isActive)")
                .bindBean(ct).execute());
    }

    public void updateCarType(CarType ct) {
        get().useHandle(h -> h.createUpdate(
                        "UPDATE car_types SET brand_id = :brandId, type_name = :typeName, category = :category, " +
                                "seating_plan = :seatingPlan, fuel = :fuel, price_dirver = :priceDirver, price_km = :priceKm, " +
                                "price_day = :priceDay, img = :img, description_type = :descriptionType, count = :count, " +
                                "is_active = :isActive WHERE type_id = :typeId")
                .bindBean(ct).execute());
    }

    // FIX: Soft delete - đánh dấu is_active = false thay vì DELETE cứng
    // Tránh lỗi foreign key khi xe đã có booking/cart liên quan
    public boolean softDeleteCarType(int typeId) {
        int rows = get().withHandle(h -> h.createUpdate(
                        "UPDATE car_types SET is_active = false WHERE type_id = :typeId")
                .bind("typeId", typeId).execute());
        return rows > 0;
    }

    // FIX: Xóa cứng chỉ dùng khi xe CHƯA có booking nào
    public boolean deleteCarType(int typeId) {
        try {
            // Kiểm tra xem xe có liên quan đến booking chưa
            boolean hasBooking = get().withHandle(h ->
                    h.createQuery("SELECT COUNT(*) FROM bookings WHERE type_id = :typeId")
                            .bind("typeId", typeId)
                            .mapTo(Integer.class)
                            .one()
            ) > 0;

            if (hasBooking) {
                // Có booking → chỉ ẩn đi, không xóa
                return softDeleteCarType(typeId);
            }

            // Chưa có booking → xóa cứng được
            get().useHandle(h -> h.createUpdate(
                            "DELETE FROM car_types WHERE type_id = :typeId")
                    .bind("typeId", typeId).execute());
            return true;
        } catch (Exception e) {
            // Nếu vẫn lỗi FK (bảng khác) → fallback soft delete
            return softDeleteCarType(typeId);
        }
    }

    // Thêm: lọc nhiều tiêu chí (dùng cho commit 2)
    public List<CarType> filterCarTypes(Integer brandId, String category, Integer seatingPlan,
                                        String fuel, Integer maxPriceKm) {
        StringBuilder sql = new StringBuilder("SELECT * FROM car_types WHERE 1=1");
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

    // Phân trang (dùng cho commit 4)
    public List<CarType> getCarTypesPaged(int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        return get().withHandle(h -> h.createQuery(
                        "SELECT * FROM car_types ORDER BY type_id LIMIT :limit OFFSET :offset")
                .bind("limit", pageSize)
                .bind("offset", offset)
                .mapToBean(CarType.class).list());
    }

    public int countCarTypes() {
        return get().withHandle(h -> h.createQuery("SELECT COUNT(*) FROM car_types")
                .mapTo(Integer.class).one());
    }

    public int countCarTypesByBrand(int brandId) {
        return get().withHandle(h -> h.createQuery(
                        "SELECT COUNT(*) FROM car_types WHERE brand_id = :brandId")
                .bind("brandId", brandId)
                .mapTo(Integer.class).one());
    }
}