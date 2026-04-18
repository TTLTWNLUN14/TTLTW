package vn.edu.nlu.fit.datxedulich.dao;

import vn.edu.nlu.fit.datxedulich.model.UserPreference;

public class UserPreferenceDAO extends BaseDao {

    public UserPreference getPreferenceByAccountId(int accountId) {
        return get().withHandle(h -> h.createQuery("SELECT preference_id as preferenceId, account_id as accountId, " + "notification_booking as notificationBooking, " + "notification_promotion as notificationPromotion, " + "email_weekly as emailWeekly, " + "preference_language as preferenceLanguage " + "FROM user_preferences WHERE account_id = :accountId").bind("accountId", accountId).mapToBean(UserPreference.class).findFirst().orElse(null)
        );
    }

    public boolean updatePreference(UserPreference preference) {
        try {
            get().useHandle(h -> h.createUpdate("UPDATE user_preferences SET " + "notification_booking = :notificationBooking, " + "notification_promotion = :notificationPromotion, " + "email_weekly = :emailWeekly, " + "preference_language = :preferenceLanguage " + "WHERE account_id = :accountId")
                            .bind("notificationBooking", preference.isNotificationBooking())
                            .bind("notificationPromotion", preference.isNotificationPromotion())
                            .bind("emailWeekly", preference.isEmailWeekly())
                            .bind("preferenceLanguage", preference.isPreferenceLanguage())
                            .bind("accountId", preference.getAccountId())
                            .execute()
            );
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean createPreference(int accountId) {
        try {
            get().useHandle(h -> h.createUpdate("INSERT INTO user_preferences (account_id, notification_booking, " + "notification_promotion, email_weekly, preference_language) " + "VALUES (:accountId, 1, 1, 0, 0)")
                            .bind("accountId", accountId)
                            .execute()
            );
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}