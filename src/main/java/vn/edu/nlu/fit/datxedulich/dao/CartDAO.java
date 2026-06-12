package vn.edu.nlu.fit.datxedulich.dao;

import vn.edu.nlu.fit.datxedulich.model.cart.Cart;
import vn.edu.nlu.fit.datxedulich.model.cart.CartItem;
import vn.edu.nlu.fit.datxedulich.model.CarType;
import vn.edu.nlu.fit.datxedulich.services.ProductService;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class CartDAO extends BaseDao {

    private int getOrCreateCartId(int accountId) {
        Integer cartId = get().withHandle(h ->
                h.createQuery("SELECT cart_id FROM cart WHERE account_id = :accountId")
                        .bind("accountId", accountId)
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(null)
        );
        if (cartId != null) return cartId;

        return get().withHandle(h ->
                h.createUpdate("INSERT INTO cart (account_id) VALUES (:accountId)")
                        .bind("accountId", accountId)
                        .executeAndReturnGeneratedKeys("cart_id")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public void saveCart(int accountId, Cart cart) {
        int cartId = getOrCreateCartId(accountId);

        get().useHandle(h -> {
            h.createUpdate("DELETE FROM cart_items WHERE cart_id = :cartId")
                    .bind("cartId", cartId).execute();

            for (CartItem item : cart.getItems()) {
                h.createUpdate(
                                "INSERT INTO cart_items " +
                                        "(cart_id, type_id, quantity, from_province, to_province, " +
                                        " km, pickup_time, return_time, email, phone) " +
                                        "VALUES (:cartId, :typeId, :qty, :from, :to, " +
                                        "        :km, :pickup, :ret, :email, :phone)")
                        .bind("cartId", cartId)
                        .bind("typeId", item.getProduct().getTypeId())
                        .bind("qty", item.getQuantity())
                        .bind("from", item.getFromProvinceId() > 0 ? item.getFromProvinceId() : null)
                        .bind("to", item.getToProvinceId() > 0 ? item.getToProvinceId() : null)
                        .bind("km", item.getKm())
                        .bind("pickup", item.getPickupTime())
                        .bind("ret", item.getReturnTime())
                        .bind("email", item.getEmail())
                        .bind("phone", item.getPhone())
                        .execute();
            }
        });
    }

    public Cart loadCart(int accountId) {
        Integer cartId = get().withHandle(h ->
                h.createQuery("SELECT cart_id FROM cart WHERE account_id = :accountId")
                        .bind("accountId", accountId)
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(null)
        );
        if (cartId == null) return new Cart();

        List<Map<String, Object>> rows = get().withHandle(h ->
                h.createQuery(
                                "SELECT ci.*, ct.* FROM cart_items ci " +
                                        "JOIN car_types ct ON ci.type_id = ct.type_id " +
                                        "WHERE ci.cart_id = :cartId")
                        .bind("cartId", cartId)
                        .mapToMap()
                        .list()
        );

        Cart cart = new Cart();
        ProductService ps = new ProductService();

        for (Map<String, Object> row : rows) {
            int typeId = (int) row.get("type_id");
            CarType carType = ps.getCarTypeById(typeId);
            if (carType == null) continue;

            int qty = (int) row.get("quantity");

            CartItem item = new CartItem(qty, carType);
            item.setKm(row.get("km") != null ? (int) row.get("km") : 0);
            if (row.get("from_province") != null) item.setFromProvinceId((int) row.get("from_province"));
            if (row.get("to_province") != null) item.setToProvinceId((int) row.get("to_province"));
            if (row.get("pickup_time") != null) item.setPickupTime((String) row.get("pickup_time"));
            if (row.get("return_time") != null) item.setReturnTime((String) row.get("return_time"));
            if (row.get("email") != null) item.setEmail((String) row.get("email"));
            if (row.get("phone") != null) item.setPhone((String) row.get("phone"));

            cart.addItem(carType, qty);
            cart.getItems().stream()
                    .filter(i -> i.getProduct().getTypeId() == typeId)
                    .findFirst()
                    .ifPresent(i -> {
                        i.setKm(item.getKm());
                        i.setFromProvinceId(item.getFromProvinceId());
                        i.setToProvinceId(item.getToProvinceId());
                        i.setPickupTime(item.getPickupTime());
                        i.setReturnTime(item.getReturnTime());
                        i.setEmail(item.getEmail());
                        i.setPhone(item.getPhone());
                    });
        }
        return cart;
    }

    public void clearCart(int accountId) {
        get().useHandle(h -> {
            Integer cartId = h.createQuery("SELECT cart_id FROM cart WHERE account_id = :accountId")
                    .bind("accountId", accountId).mapTo(Integer.class).findFirst().orElse(null);
            if (cartId != null) {
                h.createUpdate("DELETE FROM cart_items WHERE cart_id = :cartId")
                        .bind("cartId", cartId).execute();
            }
        });
    }

    public void removeBookedItems(int accountId, List<Integer> typeIds) {
        if (typeIds == null || typeIds.isEmpty()) return;

        get().useHandle(h -> {
            Integer cartId = h.createQuery(
                            "SELECT cart_id FROM cart WHERE account_id = :accountId")
                    .bind("accountId", accountId)
                    .mapTo(Integer.class)
                    .findFirst()
                    .orElse(null);

            if (cartId == null) return;

            String placeholders = typeIds.stream()
                    .map(i -> "?")
                    .collect(Collectors.joining(", "));

            var update = h.createUpdate(
                    "DELETE FROM cart_items WHERE cart_id = ? AND type_id IN (" + placeholders + ")"
            ).bind(0, cartId);

            for (int i = 0; i < typeIds.size(); i++) {
                update = update.bind(i + 1, typeIds.get(i));
            }
            update.execute();
        });
    }
}
