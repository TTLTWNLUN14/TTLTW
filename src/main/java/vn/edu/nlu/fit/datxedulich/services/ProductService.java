package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.dao.CarTypeDao;
import vn.edu.nlu.fit.datxedulich.model.CarType;
import java.util.List;

public class ProductService {
    CarTypeDao pdao = new CarTypeDao();
    public List<CarType> getListCarType() {
        return pdao.getListCarType();
    }

    public CarType getCarTypeById(int id) {
        return pdao.getCarTypeById(id);
    }

    public List<CarType> getProductsByBrandId(int brandId) {
        return pdao.getCarTypesByBrandId(brandId);
    }
}