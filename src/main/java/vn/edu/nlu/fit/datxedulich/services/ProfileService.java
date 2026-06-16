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

    /**
     * Update user profile information
     */
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
                    null);
        }

        return updated;
    }

    public boolean updateSettings(int accountId, UserPreference preferenceData) throws Exception {
        preferenceData.setAccountId(accountId);
        return preferenceService.updatePreference(preferenceData);
    }

    public boolean changePassword(int accountId, String oldPassword, String newPassword) throws Exception {
        if (oldPassword == null || oldPassword.trim().isEmpty()) {
            throw new Exception("Vui lòng nhập mật khẩu hiện tại!");
        }
        if (newPassword == null || newPassword.length() < 6) {
            throw new Exception("Mật khẩu mới phải có ít nhất 6 ký tự!");
        }

        User currentUser = userDAO.findById(accountId);
        if (currentUser == null) {
            throw new Exception("Không tìm thấy tài khoản!");
        }

        String hashedOldPassword = hashPassword(oldPassword);
        if (!hashedOldPassword.equals(currentUser.getPassword_hash())) {
            throw new Exception("Mật khẩu hiện tại không đúng!");
        }

        String hashedNewPassword = hashPassword(newPassword);
        boolean success = userDAO.updatePassword(accountId, hashedNewPassword);

        if (success) {
            notificationService.sendNotification(accountId, Notification.Type.PROFILE_UPDATE,
                    "Đổi mật khẩu thành công",
                    "Mật khẩu của bạn đã được thay đổi",
                    null);
        }

        return success;
    }

    public Member getMemberProfile(int accountId) throws Exception {
        Member member = memberService.getMemberInfo(accountId);
        if (member == null) {
            throw new Exception("Không tìm thấy thông tin thành viên!");
        }
        return member;
    }

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : messageDigest) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}