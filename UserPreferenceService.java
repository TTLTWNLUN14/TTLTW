package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.dao.UserPreferenceDAO;
import vn.edu.nlu.fit.datxedulich.model.UserPreference;

public class UserPreferenceService {
    private final UserPreferenceDAO preferenceDAO = new UserPreferenceDAO();

    public UserPreference getPreference(int accountId) {
        UserPreference preference = preferenceDAO.getPreferenceByAccountId(accountId);
        if (preference == null) {
            preferenceDAO.createPreference(accountId);
            preference = preferenceDAO.getPreferenceByAccountId(accountId);
        }
        return preference;
    }

    public boolean updatePreference(UserPreference preference) {
        return preferenceDAO.updatePreference(preference);
    }
}