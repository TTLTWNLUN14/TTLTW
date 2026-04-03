package vn.edu.nlu.fit.datxedulich.model;

import java.io.Serializable;

public class Province implements Serializable {
    private int provinceId;
    private String provinceName;

    public Province() {}

    public int getProvinceId() {
        return provinceId;
    }
    public void setProvinceId(int provinceId) {
        this.provinceId = provinceId;
    }

    public String getProvinceName() {
        return provinceName;
    }
    public void setProvinceName(String provinceName) {
        this.provinceName = provinceName;
    }
}
