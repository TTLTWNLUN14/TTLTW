package vn.edu.nlu.fit.datxedulich.dao;

import org.jdbi.v3.core.statement.PreparedBatch;
import vn.edu.nlu.fit.datxedulich.model.Brand;
import vn.edu.nlu.fit.datxedulich.model.Product;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BrandDao extends  BaseDao{
    static Map<Integer, Brand> productMap = new HashMap<Integer, Brand>();

    public List<Brand> getListBrand() {
        return get().withHandle(h-> h.createQuery("select * from car_brands").mapToBean(Brand.class).list());
    }

    public Brand getBrand(int brandId) {
        return get().withHandle(h -> h.createQuery("select * from car_brands where brand_id = :brandId").bind("brandId", brandId).mapToBean(Brand.class).first()
        );
    }

    // insertBrand null
    public void insertBrand(List<Product> products) {
        get().useHandle(handle -> {
            PreparedBatch batch = handle.prepareBatch("//none");
            products.forEach(product ->{
                batch.bindBean(product).add();
            });
            batch.execute();
        });

    }
}
