package vn.edu.nlu.fit.datxedulich.model;

import java.io.Serializable;
import java.time.LocalDate;
import java.util.Date;

public class Member implements Serializable {
    private int memberId;
    private String fullName;
    private String email;
    private String phone;
    private Date dob;
    private String gender;
    private String cccd;
    private String address;
    private String memberTier;
    private int totalTrips;
    private int points;
    private double totalSpent;
    private LocalDate joinDate;

    public Member() {}

    public Member(int memberId, String fullName, String email, String phone,
                  Date dob, String gender, String cccd, String address,
                  String memberTier, int totalTrips, int points,
                  double totalSpent, LocalDate joinDate) {
        this.memberId = memberId;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.dob = dob;
        this.gender = gender;
        this.cccd = cccd;
        this.address = address;
        this.memberTier = memberTier;
        this.totalTrips = totalTrips;
        this.points = points;
        this.totalSpent = totalSpent;
        this.joinDate = joinDate;
    }

    public int getTotalTrips() {
        return totalTrips;
    }

    public void setTotalTrips(int totalTrips) {
        this.totalTrips = totalTrips;
    }

    public double getTotalSpent() {
        return totalSpent;
    }

    public void setTotalSpent(double totalSpent) {
        this.totalSpent = totalSpent;
    }

    public int getPoints() {
        return points;
    }

    public void setPoints(int points) {
        this.points = points;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getMemberTier() {
        return memberTier;
    }

    public void setMemberTier(String memberTier) {
        this.memberTier = memberTier;
    }

    public int getMemberId() {
        return memberId;
    }

    public void setMemberId(int memberId) {
        this.memberId = memberId;
    }

    public LocalDate getJoinDate() {
        return joinDate;
    }

    public void setJoinDate(LocalDate joinDate) {
        this.joinDate = joinDate;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
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

    public void setAddress(String address) {
        this.address = address;
    }
}