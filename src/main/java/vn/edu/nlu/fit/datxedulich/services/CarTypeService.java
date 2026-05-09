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

    public boolean deleteCarType(int typeId) {
        return carTypeDao.deleteCarType(typeId);
    }

    public List<CarType> filterCarTypes(Integer brandId, String category,
                                        Integer seatingPlan, String fuel, Integer maxPriceKm) {
        return carTypeDao.filterCarTypes(brandId, category, seatingPlan, fuel, maxPriceKm);
    }

    public List<CarType> getCarTypesPaged(int page, int pageSize) {
        return carTypeDao.getCarTypesPaged(page, pageSize);
    }

    public int countCarTypes() {
        return carTypeDao.countCarTypes();
    }

    public int countCarTypesByBrand(int brandId) {
        return carTypeDao.countCarTypesByBrand(brandId);
    }
}