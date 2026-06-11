package vn.edu.nlu.fit.datxedulich.dao;

import vn.edu.nlu.fit.datxedulich.model.Voucher;

import java.util.List;

public class VoucherDAO extends BaseDao {
    public List<Voucher> getAllVouchers() {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM voucher ORDER BY voucher_id DESC")
                        .mapToBean(Voucher.class)
                        .list()
        );
    }

    public List<Voucher> getActiveVouchers(double orderPrice) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM voucher WHERE is_active = TRUE AND uses_left > 0 " +
                                "AND expires_at >= NOW() AND min_order <= :orderPrice " +
                                "ORDER BY expires_at ASC")
                        .bind("orderPrice", orderPrice)
                        .mapToBean(Voucher.class)
                        .list()
        );
    }

    public List<Voucher> searchVouchers(String keyword) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM voucher WHERE code LIKE :keyword OR name_voucher LIKE :keyword " +
                                "ORDER BY voucher_id DESC")
                        .bind("keyword", "%" + keyword + "%")
                        .mapToBean(Voucher.class)
                        .list()
        );
    }

    public List<Voucher> getVouchersByStatus(boolean isActive) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM voucher WHERE is_active = :isActive ORDER BY voucher_id DESC")
                        .bind("isActive", isActive)
                        .mapToBean(Voucher.class)
                        .list()
        );
    }

    public List<Voucher> getVouchersByTier(String tier) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM voucher WHERE min_tier = :minTier AND is_active = TRUE " +
                                "ORDER BY voucher_id DESC")
                        .bind("Tier", tier)
                        .mapToBean(Voucher.class)
                        .list()
        );
    }

    public Voucher getVoucherByCode(String code) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM voucher WHERE code = :code")
                        .bind("code", code)
                        .mapToBean(Voucher.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public boolean validateVoucher(int voucherId, double orderPrice) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM voucher WHERE voucher_id = :voucherId " +
                                "AND is_active = TRUE AND uses_left > 0 AND expires_at >= NOW() AND min_order <= :orderPrice")
                        .bind("voucherId", voucherId)
                        .bind("orderPrice", orderPrice)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    public boolean validateVoucherByCode(String code, double orderPrice) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM voucher WHERE code = :code " +
                                "AND is_active = TRUE AND uses_left > 0 AND expires_at >= NOW() AND min_order <= :orderPrice")
                        .bind("code", code)
                        .bind("orderPrice", orderPrice)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    public boolean reduceVoucherUsage(int voucherId) {
        return get().withHandle(handle ->
                handle.createUpdate("UPDATE voucher SET uses_left = uses_left - 1 WHERE voucher_id = :voucherId " +
                                "AND uses_left > 0")
                        .bind("voucherId", voucherId)
                        .execute() > 0
        );
    }


    public boolean addVoucher(Voucher voucher) {
        return get().withHandle(handle ->
                handle.createUpdate(
                                "INSERT INTO voucher (code, name_voucher, discount, price_max_discount, min_order, min_tier, uses_left, expires_at, is_active) " +
                                        "VALUES (:code, :nameVoucher, :discount, :priceMaxDiscount, :minOrder, :minTier, :usesLeft, :expiresAt, :isActive)")
                        .bindBean(voucher)
                        .execute() > 0
        );
    }

    public boolean updateVoucher(Voucher voucher) {
        return get().withHandle(handle ->
                handle.createUpdate(
                                "UPDATE voucher SET code = :code, name_voucher = :nameVoucher, discount = :discount, " +
                                        "price_max_discount = :priceMaxDiscount, min_order = :minOrder, min_tier = :minTier, " +
                                        "uses_left = :usesLeft, expires_at = :expiresAt, is_active = :isActive " +
                                        "WHERE voucher_id = :voucherId")
                        .bindBean(voucher)
                        .execute() > 0
        );
    }

    public boolean deleteVoucher(int voucherId) {
        return get().withHandle(handle ->
                handle.createUpdate("DELETE FROM voucher WHERE voucher_id = :voucherId")
                        .bind("voucherId", voucherId)
                        .execute() > 0
        );
    }

    public Voucher getVoucherById(int voucherId) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM voucher WHERE voucher_id = :voucherId")
                        .bind("voucherId", voucherId)
                        .mapToBean(Voucher.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public boolean isCodeExists(String code) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM voucher WHERE code = :code")
                        .bind("code", code)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    public boolean isCodeExistsExcept(String code, int voucherId) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM voucher WHERE code = :code AND voucher_id != :voucherId")
                        .bind("code", code)
                        .bind("voucherId", voucherId)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }
}
