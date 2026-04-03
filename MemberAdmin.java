package vn.edu.nlu.fit.datxedulich.model;

import java.io.Serializable;

public class MemberAdmin implements Serializable {
    private int customerId;
    private String fullName;
    private String phone;
    private String email;
    private String memberTier;
    private int points;
    private boolean isActive;
    private int totalTrips;
    private double totalSpent;

    public MemberAdmin() {}

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

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
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

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getTierColor() {
        if (memberTier == null) return "#6b7280";
        return switch (memberTier.toUpperCase()) {
            case "DIAMOND"  -> "#8b5cf6";
            case "PLATINUM" -> "#0ea5e9";
            case "GOLD"     -> "#f5b82e";
            case "SILVER"   -> "#9ca3af";
            default         -> "#6b7280";
        };
    }
    public String getDisplayId() {
        return String.format("#MB%04d", customerId);
    }
}
