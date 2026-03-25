package vn.edu.nlu.fit.datxedulich.dao;

import vn.edu.nlu.fit.datxedulich.model.Product;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProductDAO {
    static Map<Integer, Product> productMap = new HashMap<Integer, Product>();

    static {
        productMap.put(1, new Product(1, "Ford Ranger", 4100, 1100000, "https://fordcapital.vn/wp-content/uploads/2021/11/ford-ranger-2022-2023-1.jpg"));
                productMap.put(2, new Product(2, "Ford Ranger 2", 4200, 1200000, "https://www.google.com/imgres?q=Ford%20Ranger&imgurl=https%3A%2F%2Fautobikes.vn%2Fstores%2Fnews_dataimages%2Fnguyenthuy%2F052023%2F19%2F16%2F2332_Ford_Ranger_Raptor_2024_1.jpg%3Frt%3D20230519162340&imgrefurl=https%3A%2F%2Fautobikes.vn%2Fcan-canh-ford-ranger-raptor-2024-vua-ra-mat-tai-my-gia-quy-doi-tu-2-ty-dong-17171.html&docid=XflSSDZLDvA2CM&tbnid=nME8qCEYc4rz-M&vet=12ahUKEwj5w5m2mLuTAxXPhK8BHRvLFQQQnPAOegQIIRAB..i&w=645&h=365&hcb=2&ved=2ahUKEwj5w5m2mLuTAxXPhK8BHRvLFQQQnPAOegQIIRAB"));
                productMap.put(3, new Product(3, "Ford Ranger 3", 4300, 1300000, "https://www.google.com/imgres?q=Ford%20Ranger&imgurl=https%3A%2F%2Fthanhxuanford.vn%2Fpublic%2Fupload%2Fimages%2Fhinhsanpham%2Fford-ranger-xl-the-he-moi-51491660644183.jpg&imgrefurl=https%3A%2F%2Fthanhxuanford.vn%2Fsan-pham%2F160%2Fford-ranger-xl-the-he-moi&docid=1tDBEM2Jf1mkEM&tbnid=T_xs8Y4omV01eM&vet=12ahUKEwj5w5m2mLuTAxXPhK8BHRvLFQQQnPAOegQIHhAB..i&w=980&h=580&hcb=2&ved=2ahUKEwj5w5m2mLuTAxXPhK8BHRvLFQQQnPAOegQIHhAB"));
                productMap.put(4, new Product(4, "Ford Ranger 4", 4400, 1400000, "https://www.google.com/imgres?q=Ford%20Ranger&imgurl=https%3A%2F%2Fotofordmienbac.com%2Fwp-content%2Fuploads%2F11-59.jpg&imgrefurl=https%3A%2F%2Fotofordmienbac.com%2Fsan-pham%2Fford-ranger-raptor-2-0l-2%2F&docid=NNJxXT0st4nOKM&tbnid=gJgh7M1nOyZWNM&vet=12ahUKEwj5w5m2mLuTAxXPhK8BHRvLFQQQnPAOegQIIxAB..i&w=723&h=407&hcb=2&ved=2ahUKEwj5w5m2mLuTAxXPhK8BHRvLFQQQnPAOegQIIxAB"));
    }

    public List<Product> getListProduct() {
        return new ArrayList<Product>(productMap.values());
    }

    public Product getProduct(int id) {
        return productMap.get(id);
    }
}
