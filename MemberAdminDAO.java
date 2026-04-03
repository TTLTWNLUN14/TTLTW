package vn.edu.nlu.fit.datxedulich.dao;

import vn.edu.nlu.fit.datxedulich.model.MemberAdmin;
import java.util.List;

public class MemberAdminDAO extends BaseDao {

    public List<MemberAdmin> getAllMembers() {
        return get().withHandle(h ->
            h.createQuery(
                "SELECT " +
                "  c.customer_id                                           AS customerId, " +
                "  a.full_name                                             AS fullName, " +
                "  a.phone                                                 AS phone, " +
                "  a.email                                                 AS email, " +
                "  COALESCE(c.member, 'Standard')                         AS memberTier, " +
                "  COALESCE(c.points, 0)                                  AS points, " +
                "  a.is_active                                             AS isActive, " +
                "  COALESCE((" +
                "      SELECT COUNT(*) FROM bookings b WHERE b.customer_id = c.customer_id" +
                "  ), 0)                                                   AS totalTrips, " +
                "  COALESCE((" +
                "      SELECT SUM(b.total_price) FROM bookings b WHERE b.customer_id = c.customer_id" +
                "  ), 0)                                                   AS totalSpent " +
                "FROM accounts a " +
                "LEFT JOIN customers c ON a.account_id = c.account_id " +
                "WHERE a.role_id = 2 " +
                "ORDER BY c.points DESC"
            )
            .mapToBean(MemberAdmin.class)
            .list()
        );
    }

    public MemberAdmin getMemberById(int customerId) {
        return get().withHandle(h ->
            h.createQuery(
                "SELECT " +
                "  c.customer_id AS customerId, a.full_name AS fullName, " +
                "  a.phone AS phone, a.email AS email, " +
                "  COALESCE(c.member, 'Standard') AS memberTier, " +
                "  COALESCE(c.points, 0) AS points, a.is_active AS isActive, " +
                "  COALESCE((SELECT COUNT(*) FROM bookings b WHERE b.customer_id = c.customer_id), 0) AS totalTrips, " +
                "  COALESCE((SELECT SUM(b.total_price) FROM bookings b WHERE b.customer_id = c.customer_id), 0) AS totalSpent " +
                "FROM accounts a " +
                "LEFT JOIN customers c ON a.account_id = c.account_id " +
                "WHERE c.customer_id = :customerId"
            )
            .bind("customerId", customerId)
            .mapToBean(MemberAdmin.class)
            .findFirst()
            .orElse(null)
        );
    }

    public boolean updateMemberTier(int customerId, String memberTier, int points) {
        try {
            get().useHandle(h ->
                h.createUpdate(
                    "UPDATE customers SET member = :memberTier, points = :points " +
                    "WHERE customer_id = :customerId"
                )
                .bind("memberTier", memberTier)
                .bind("points", points)
                .bind("customerId", customerId)
                .execute()
            );
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean toggleAccountStatus(int customerId, boolean isActive) {
        try {
            get().useHandle(h ->
                h.createUpdate(
                    "UPDATE accounts a " +
                    "INNER JOIN customers c ON a.account_id = c.account_id " +
                    "SET a.is_active = :isActive " +
                    "WHERE c.customer_id = :customerId"
                )
                .bind("isActive", isActive)
                .bind("customerId", customerId)
                .execute()
            );
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countAllMembers() {
        return get().withHandle(h ->
            h.createQuery(
                "SELECT COUNT(*) FROM accounts WHERE role_id = 2"
            )
            .mapTo(Integer.class)
            .one()
        );
    }
}
