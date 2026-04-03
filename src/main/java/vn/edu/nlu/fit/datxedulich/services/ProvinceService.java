package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.dao.ProvinceDao;
import vn.edu.nlu.fit.datxedulich.model.Province;

import java.util.List;

public class ProvinceService {
    private final ProvinceDao provinceDao = new ProvinceDao();

    public List<Province> getAllProvinces() {
        return provinceDao.getAllProvinces();
    }

    public int getDistance(int fromProvinceId, int toProvinceId) {
        return provinceDao.getDistance(fromProvinceId, toProvinceId);
    }
}
