package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.dao.ProductDAO;
import vn.edu.nlu.fit.datxedulich.model.Product;
import java.util.List;

public class ProductService {
    ProductDAO pdao = new ProductDAO();
    public List<Product> getListProduct() {
        return pdao.getListProduct();
    }

    public Product getProduct(int id) {
        return pdao.getProduct(id);
    }

    public List<Product> getProductsByBrandId(int brandId) {
        return pdao.getProductsByBrandId(brandId);
    }
}
