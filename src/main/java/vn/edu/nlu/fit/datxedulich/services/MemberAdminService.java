package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.dao.MemberAdminDAO;
import vn.edu.nlu.fit.datxedulich.model.MemberAdmin;
import java.util.List;

public class MemberAdminService {

    private final MemberAdminDAO dao = new MemberAdminDAO();

    public List<MemberAdmin> getAllMembers() {
        return dao.getAllMembers();
    }

    public MemberAdmin getMemberById(int customerId) {
        return dao.getMemberById(customerId);
    }

    /**
     * Cập nhật hạng thành viên; tự động sync hạng theo điểm nếu points thay đổi.
     */
    public boolean updateMember(int customerId, String memberTier, int points) {
        // Nếu admin nhập điểm thủ công → tự động tính lại hạng cho nhất quán
        String resolvedTier = resolveTier(points);
        // Nhưng nếu admin chọn hạng rõ ràng (không để trống) thì ưu tiên hạng admin chọn
        if (memberTier != null && !memberTier.isBlank()) {
            resolvedTier = memberTier;
        }
        return dao.updateMemberTier(customerId, resolvedTier, points);
    }

    /**
     * Toggle trạng thái khóa / mở khóa tài khoản.
     */
    public boolean toggleStatus(int customerId, boolean lockAccount) {
        // lockAccount = true → set is_active = false (khóa)
        return dao.toggleAccountStatus(customerId, !lockAccount);
    }

    public int countAllMembers() {
        return dao.countAllMembers();
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    private String resolveTier(int points) {
        if (points >= 10000) return "Diamond";
        if (points >= 5000)  return "Platinum";
        if (points >= 2000)  return "Gold";
        if (points >= 500)   return "Silver";
        return "Standard";
    }
}
