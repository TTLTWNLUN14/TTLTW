package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.model.Member;
import vn.edu.nlu.fit.datxedulich.model.User;
import vn.edu.nlu.fit.datxedulich.model.UserPreference;
import vn.edu.nlu.fit.datxedulich.model.Notification;
import vn.edu.nlu.fit.datxedulich.dao.UserDAO;
import vn.edu.nlu.fit.datxedulich.dao.MemberDAO;
import java.security.MessageDigest;

public class ProfileService {
    private final MemberService memberService = new MemberService();
    private final UserPreferenceService preferenceService = new UserPreferenceService();
    private final UserDAO userDAO = new UserDAO();
    private final NotificationService notificationService = new NotificationService();

    public boolean updateProfile(int accountId, Member memberData) throws Exception {
        Member member = memberService.getMemberInfo(accountId);
        if (member == null) {
            return false;
        }

        member.setFullName(memberData.getFullName());
        member.setPhone(memberData.getPhone());
        member.setEmail(memberData.getEmail());
        member.setAddress(memberData.getAddress());
        member.setCccd(memberData.getCccd());
        member.setGender(memberData.getGender());

        boolean updated = memberService.updateMemberInfo(member);

        if (updated) {
            notificationService.sendNotification(accountId, Notification.Type.PROFILE_UPDATE,
                    "Cập nhật thông tin thành công",
                    "Thông tin hồ sơ của bạn đã được cập nhật",
                    null, "fas fa-user-check", "/profile");
        }

        return updated;
    }
}