package vn.edu.nlu.fit.datxedulich.model;

import java.io.Serializable;
import java.util.Date;

public class User implements Serializable {
    private int accountId;
    private String username;
    private String passWordHash;
    private String email;
    private String fullName;
    private int phone;
    private int CCCD;
    private Date birthday;
    private int roleID;
    private String gender;
    private Date lastLogin;
    private Date firstLogin;
    private  String isActive;


    public User() {
    }

    public int getRoleID() {
        return roleID;
    }

    public void setRoleID(int roleID) {
        this.roleID = roleID;
    }

    public int getPhone() {
        return phone;
    }

    public void setPhone(int phone) {
        this.phone = phone;
    }

    public String getPassWordHash() {
        return passWordHash;
    }

    public void setPassWordHash(String passWordHash) {
        this.passWordHash = passWordHash;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
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

    public int getAccountId() {
        return accountId;
    }

    public String getIsActive() {
        return isActive;
    }

    public void setIsActive(String isActive) {
        this.isActive = isActive;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public Date getFirstLogin() {
        return firstLogin;
    }

    public void setFirstLogin(Date firstLogin) {
        this.firstLogin = firstLogin;
    }

    public Date getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(Date lastLogin) {
        this.lastLogin = lastLogin;
    }

    @Override
    public String toString() {
        return "User{" +
                "accountId=" + accountId +
                ", username='" + username + '\'' +
                ", passWordHash='" + passWordHash + '\'' +
                ", email='" + email + '\'' +
                ", fullName='" + fullName + '\'' +
                ", phone=" + phone +
                ", CCCD=" + CCCD +
                ", birthday=" + birthday +
                ", roleID=" + roleID +
                ", gender='" + gender + '\'' +
                ", lastLogin=" + lastLogin +
                ", firstLogin=" + firstLogin +
                ", isActive='" + isActive + '\'' +
                '}';
    }
}