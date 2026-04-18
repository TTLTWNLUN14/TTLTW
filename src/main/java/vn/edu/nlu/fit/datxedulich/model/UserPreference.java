package vn.edu.nlu.fit.datxedulich.model;

import java.io.Serializable;

public class UserPreference implements Serializable {
    private int preferenceId;
    private int accountId;
    private boolean notificationBooking;
    private boolean notificationPromotion;
    private boolean emailWeekly;
    private boolean preferenceLanguage;

    public UserPreference() {}

    public UserPreference(int accountId, boolean notificationBooking, boolean notificationPromotion,
                          boolean emailWeekly, boolean preferenceLanguage) {
        this.accountId = accountId;
        this.notificationBooking = notificationBooking;
        this.notificationPromotion = notificationPromotion;
        this.emailWeekly = emailWeekly;
        this.preferenceLanguage = preferenceLanguage;
    }

    public boolean isPreferenceLanguage() {
        return preferenceLanguage;
    }

    public void setPreferenceLanguage(boolean preferenceLanguage) {
        this.preferenceLanguage = preferenceLanguage;
    }

    public int getPreferenceId() {
        return preferenceId;
    }

    public void setPreferenceId(int preferenceId) {
        this.preferenceId = preferenceId;
    }

    public boolean isNotificationPromotion() {
        return notificationPromotion;
    }

    public void setNotificationPromotion(boolean notificationPromotion) {
        this.notificationPromotion = notificationPromotion;
    }

    public boolean isNotificationBooking() {
        return notificationBooking;
    }

    public void setNotificationBooking(boolean notificationBooking) {
        this.notificationBooking = notificationBooking;
    }

    public boolean isEmailWeekly() {
        return emailWeekly;
    }

    public void setEmailWeekly(boolean emailWeekly) {
        this.emailWeekly = emailWeekly;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }
}