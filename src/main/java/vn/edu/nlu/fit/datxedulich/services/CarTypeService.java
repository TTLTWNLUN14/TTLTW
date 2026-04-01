package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.dao.CarTypeDao;
import vn.edu.nlu.fit.datxedulich.model.CarType;
import java.util.List;

public class CarTypeService {
    private final CarTypeDao carTypeDao = new CarTypeDao();

    public List<CarType> getListCarType() {
        return carTypeDao.getListCarType();
    }

    public List<CarType> getCarTypesByBrandId(int brandId) {
        return carTypeDao.getCarTypesByBrandId(brandId);
    }

    public CarType getCarTypeById(int typeId) {
        return carTypeDao.getCarTypeById(typeId);
    }

    public void insertCarType(CarType ct) {
        carTypeDao.insertCarType(ct);
    }

    public void updateCarType(CarType ct) {
        carTypeDao.updateCarType(ct);
    }

    public void deleteCarType(int typeId) {
        carTypeDao.deleteCarType(typeId);
    }
}