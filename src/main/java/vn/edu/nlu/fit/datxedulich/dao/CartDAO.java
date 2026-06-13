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

        // FIX: dùng alias tường minh, không SELECT *
        List<Map<String, Object>> rows = get().withHandle(h ->
                h.createQuery(
                                "SELECT " +
                                        "  ci.type_id    AS ci_type_id, " +
                                        "  ci.quantity   AS ci_quantity, " +
                                        "  ci.from_province, " +
                                        "  ci.to_province, " +
                                        "  ci.km, " +
                                        "  ci.pickup_time, " +
                                        "  ci.return_time, " +
                                        "  ci.email, " +
                                        "  ci.phone " +
                                        "FROM cart_items ci " +
                                        "WHERE ci.cart_id = :cartId")
                        .bind("cartId", cartId)
                        .mapToMap()
                        .list()
        );

        Cart cart = new Cart();
        ProductService ps = new ProductService();

        for (Map<String, Object> row : rows) {
            Object typeIdObj = row.get("ci_type_id");
            if (typeIdObj == null) continue;
            int typeId = ((Number) typeIdObj).intValue();

            CarType carType = ps.getCarTypeById(typeId);
            if (carType == null) continue;

            Object qtyObj = row.get("ci_quantity");
            int qty = qtyObj != null ? ((Number) qtyObj).intValue() : 1;

            // addItem thêm item vào cart map
            cart.addItem(carType, qty);

            // gán lại route / time data (tìm item vừa add)
            CartItem item = cart.get(typeId);
            if (item == null) continue;

            if (row.get("km") != null)
                item.setKm(((Number) row.get("km")).intValue());
            if (row.get("from_province") != null)
                item.setFromProvinceId(((Number) row.get("from_province")).intValue());
            if (row.get("to_province") != null)
                item.setToProvinceId(((Number) row.get("to_province")).intValue());
            if (row.get("pickup_time") != null)
                item.setPickupTime(row.get("pickup_time").toString());
            if (row.get("return_time") != null)
                item.setReturnTime(row.get("return_time").toString());
            if (row.get("email") != null)
                item.setEmail(row.get("email").toString());
            if (row.get("phone") != null)
                item.setPhone(row.get("phone").toString());
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