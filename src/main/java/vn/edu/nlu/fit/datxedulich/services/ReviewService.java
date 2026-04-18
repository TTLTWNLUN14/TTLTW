package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.dao.ReviewDAO;
import vn.edu.nlu.fit.datxedulich.model.Review;
import java.util.List;

public class ReviewService {
    private final ReviewDAO reviewDAO = new ReviewDAO();

    public List<Review> getReviews(int accountId) {
        return reviewDAO.getReviewsByAccountId(accountId);
    }

    public Review getReviewById(int reviewId) {
        return reviewDAO.getReviewById(reviewId);
    }
}