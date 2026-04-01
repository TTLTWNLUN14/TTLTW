package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.dao.MemberDAO;
import vn.edu.nlu.fit.datxedulich.model.Member;
import vn.edu.nlu.fit.datxedulich.model.Product;

import java.util.List;

public class MemberService {
    private final MemberDAO memberDAO = new MemberDAO();

    public Member getMemberInfo(int memberId) {
        return memberDAO.getMemberById(memberId);
    }

    public boolean updateMemberInfo(Member member) {
        return memberDAO.updateMember(member);
    }

    public List<Product> getBookingHistory(int memberId) {
        return memberDAO.getMemberBookingHistory(memberId);
    }

    public void deleteBooking(int bookingId) {
        memberDAO.deleteBooking(bookingId);
    }

    public void deleteAllBookings(int memberId) {
        memberDAO.deleteAllBookings(memberId);
    }
}