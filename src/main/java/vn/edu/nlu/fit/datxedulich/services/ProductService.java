package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.dao.ProductDAO;
import vn.edu.nlu.fit.datxedulich.model.CarType;
import java.util.List;

public class ProductService {
    ProductDAO pdao = new ProductDAO();
    public List<CarType> getListProduct() {
        return pdao.getListProduct();
    }

    public CarType getProduct(int id) {
        return pdao.getProduct(id);
    }

    public List<CarType> getProductsByBrandId(int brandId) {
        return pdao.getProductsByBrandId(brandId);
    }
}