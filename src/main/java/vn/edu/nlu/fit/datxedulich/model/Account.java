package vn.edu.nlu.fit.datxedulich.model;

public class Account {
    private int accountId;
    private String email;
    private String userName;
    int phone;
    int CCCD;
    String passwordHash;
    String address;
    String gender;
    Date birthday;
    Date lastLogin;
    Date firstLogin;
    private int roleId;
    private boolean isActive;

    public Account(int accountId, String email, String userName, int phone, int CCCD, String passwordHash, String address, int roleId, boolean isActive) {
        this.accountId = accountId;
        this.email = email;
        this.userName = userName;
        this.phone = phone;
        this.CCCD = CCCD;
        this.passwordHash = passwordHash;
        this.address = address;
        this.roleId = roleId;
        this.isActive = isActive;
    }

    public int getAccountId() {
        return accountId;
    }
    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public int getRoleId() {
        return roleId;
    }
    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public boolean isActive() {
        return isActive;
    }
    public void setActive(boolean active) {
        isActive = active;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public int getPhone() {
        return phone;
    }

    public void setPhone(int phone) {
        this.phone = phone;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public Date getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(Date lastLogin) {
        this.lastLogin = lastLogin;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Date getFirstLogin() {
        return firstLogin;
    }

    public void setFirstLogin(Date firstLogin) {
        this.firstLogin = firstLogin;
    }

    public int getCCCD() {
        return CCCD;
    }

    public void setCCCD(int CCCD) {
        this.CCCD = CCCD;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
}