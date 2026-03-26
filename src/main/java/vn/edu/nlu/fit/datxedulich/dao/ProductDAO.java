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

    static {
        productMap.put(1, new Product(1, "Ford Ranger", 4100, 1100000, "https://fordcapital.vn/wp-content/uploads/2021/11/ford-ranger-2022-2023-1.jpg"));
                productMap.put(2, new Product(2, "Ford Ranger 2", 4200, 1200000, ""));
                productMap.put(3, new Product(3, "Ford Ranger 3", 4300, 1300000, ""));
                productMap.put(4, new Product(4, "Ford Ranger 4", 4400, 1400000, ""));
    }

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

    public static void main(String[] args) {
        ProductDAO dao = new ProductDAO();
        List<Product> products = dao.getListProduct();

        dao.getProduct(1);
    }
}
