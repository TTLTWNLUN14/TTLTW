package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.dao.BrandDao;
import vn.edu.nlu.fit.datxedulich.model.Brand;
import java.util.List;

public class BrandService {
    private final BrandDao brandDao = new BrandDao();

    public List<Brand> getListBrand() {
        return brandDao.getListBrand();
    }

    public Brand getBrandById(int id) {
        return brandDao.getBrandById(id);
    }

    public void insertBrand(Brand brand) {
        brandDao.insertBrand(brand);
    }

    public void updateBrand(Brand brand) {
        brandDao.updateBrand(brand);
    }

    public void deleteBrand(int id) {
        brandDao.deleteBrand(id);
    }
}