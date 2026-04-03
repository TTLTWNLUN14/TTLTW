package vn.edu.nlu.fit.datxedulich.dao;

import vn.edu.nlu.fit.datxedulich.model.Province;

import java.util.List;

public class ProvinceDao extends BaseDao {

    public List<Province> getAllProvinces() {
        return get().withHandle(h ->
            h.createQuery("SELECT * FROM provinces ORDER BY province_name ASC")
             .mapToBean(Province.class)
             .list()
        );
    }

    public int getDistance(int fromProvinceId, int toProvinceId) {
        Integer dist = get().withHandle(h ->
            h.createQuery(
                "SELECT distance_km FROM province_distances " +
                "WHERE (from_province_id = :from AND to_province_id = :to) " +
                "   OR (from_province_id = :to AND to_province_id = :from) " +
                "LIMIT 1"
            )
            .bind("from", fromProvinceId)
            .bind("to", toProvinceId)
            .mapTo(Integer.class)
            .findFirst()
            .orElse(0)
        );
        return dist == null ? 0 : dist;
    }
}
