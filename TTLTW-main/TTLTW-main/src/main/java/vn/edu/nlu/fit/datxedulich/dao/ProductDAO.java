package vn.edu.nlu.fit.datxedulich.dao;

import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.statement.PreparedBatch;
import vn.edu.nlu.fit.datxedulich.model.Product;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProductDAO extends BaseDao{
    static Map<Integer, Product> productMap = new HashMap<Integer, Product>();

    public List<Product> getListProduct() {
        return get().withHandle(h-> h.createQuery("select * from products").mapToBean(Product.class).list());
    }

    public Product getProduct(int id) {
        return get().withHandle(h -> h.createQuery("select * from products where id = :id").bind("id", id).mapToBean(Product.class).first()
        );
    }
    public void insertProduct(List<Product> products) {
        get().useHandle(handle -> {
            PreparedBatch batch = handle.prepareBatch("insert into products values(:id,:name,:priceKm,:priceDay,:image)");
            products.forEach(product ->{
                batch.bindBean(product).add();
            });
            batch.execute();
        });

    }
    public List<Product> getProductsByBrandId(int brandId) {
        return get().withHandle(h ->
                h.createQuery("SELECT * FROM products WHERE brand_id = :brandId")
                        .bind("brandId", brandId)
                        .mapToBean(Product.class)
                        .list()
        );
    }


}
