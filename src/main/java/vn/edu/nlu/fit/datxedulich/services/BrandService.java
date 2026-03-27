package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.dao.BrandDao;
import vn.edu.nlu.fit.datxedulich.model.Brand;

import java.util.List;

public class BrandService {
    BrandDao bdao = new BrandDao();
    public List<Brand> getListBrand() {
        return bdao.getListBrand();
    }
    public Brand getBrand(int id) {
        return bdao.getBrand(id);
    }
}
