package vn.edu.nlu.fit.datxedulich.model;

import java.io.Serializable;

import java.time.LocalDate;

public class User implements Serializable {
    private int account_id;
    private int role_id;
    private String email;
    private String username;
    private String password_hash;
    private String full_name;
    private String phone;
    private String cccd;
    private LocalDate birthday;
    private String gender;
    private String address;
    private boolean is_active;
    private LocalDate last_login;
    private LocalDate first_login;


    public User() {
    }

    public User(String username, String password_hash) {
        this.username = username;
        this.password_hash = password_hash;
    }

    public User(String email, String password_hash, int role_id, String full_name, String username, String phone) {
        this.email = email;
        this.password_hash = password_hash;
        this.role_id = role_id;
        this.full_name = full_name;
        this.username = username;
        this.phone = phone;
        this.is_active = true;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public int getRole_id() {
        return role_id;
    }

    public void setRole_id(int role_id) {
        this.role_id = role_id;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword_hash() {
        return password_hash;
    }

    public void setPassword_hash(String password_hash) {
        this.password_hash = password_hash;
    }

    public boolean isIs_active() {
        return is_active;
    }

    public void setIs_active(boolean is_active) {
        this.is_active = is_active;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getFull_name() {
        return full_name;
    }

    public void setFull_name(String full_name) {
        this.full_name = full_name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCccd() {
        return cccd;
    }

    public void setCccd(String cccd) {
        this.cccd = cccd;
    }

    public String getAddress() {
        return address;
    }

    public LocalDate getLast_login() {
        return last_login;
    }

    public void setLast_login(LocalDate last_login) {
        this.last_login = last_login;
    }

    public LocalDate getFirst_login() {
        return first_login;
    }

    public void setFirst_login(LocalDate first_login) {
        this.first_login = first_login;
    }

    public LocalDate getBirthday() {
        return birthday;
    }

    public void setBirthday(LocalDate birthday) {
        this.birthday = birthday;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getAccount_id() {
        return account_id;
    }

    public void setAccount_id(int account_id) {
        this.account_id = account_id;
    }
}