package vn.edu.nlu.fit.datxedulich.dao;

import vn.edu.nlu.fit.datxedulich.model.Review;
import java.util.List;

public class ReviewDAO extends BaseDao {

    public List<Review> getReviewsByAccountId(int accountId) {
        return get().withHandle(h -> h.createQuery("SELECT r.review_id as reviewId, r.booking_id as bookingId, " + "CONCAT('AC-', LPAD(b.booking_id, 5, '0')) as bookingCode, " + "r.rating, r.comment, DATE(r.created_at) as createdAt, " + "ct.type_name as carName, r.is_visible as isVisible " + "FROM reviews r " + "INNER JOIN bookings b ON r.booking_id = b.booking_id " + "INNER JOIN customers c ON b.customer_id = c.customer_id " + "INNER JOIN car_types ct ON b.type_id = ct.type_id " + "WHERE c.account_id = :accountId AND r.is_visible = 1 " + "ORDER BY r.created_at DESC")
                        .bind("accountId", accountId)
                        .mapToBean(Review.class)
                        .list()
        );
    }

    public Review getReviewById(int reviewId) {
        return get().withHandle(h -> h.createQuery("SELECT review_id as reviewId, booking_id as bookingId, " + "rating, comment, DATE(created_at) as createdAt, is_visible as isVisible " + "FROM reviews WHERE review_id = :reviewId")
                        .bind("reviewId", reviewId)
                        .mapToBean(Review.class)
                        .findFirst()
                        .orElse(null)
        );
    }
}