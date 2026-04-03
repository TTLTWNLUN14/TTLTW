package vn.edu.nlu.fit.datxedulich.model;

import java.io.Serializable;

public class ProvinceDistance implements Serializable {
    private int distanceId;
    private int fromProvinceId;
    private int toProvinceId;
    private int distanceKm;

    public ProvinceDistance() {}

    public int getDistanceId() {
        return distanceId;
    }
    public void setDistanceId(int distanceId) {
        this.distanceId = distanceId;
    }

    public int getFromProvinceId() {
        return fromProvinceId;
    }
    public void setFromProvinceId(int fromProvinceId) {
        this.fromProvinceId = fromProvinceId;
    }

    public int getToProvinceId() {
        return toProvinceId;
    }
    public void setToProvinceId(int toProvinceId) {
        this.toProvinceId = toProvinceId;
    }

    public int getDistanceKm() {
        return distanceKm;
    }
    public void setDistanceKm(int distanceKm) {
        this.distanceKm = distanceKm;
    }
}
