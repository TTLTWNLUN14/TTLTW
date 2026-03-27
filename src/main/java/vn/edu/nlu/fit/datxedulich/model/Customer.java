package vn.edu.nlu.fit.datxedulich.model;

public class Customer {
    private int customerId;
    private int accountId;
    private String member;
    private int points;

    public Customer(int  customerId, int accountId, String member, int points) {
        this.customerId = customerId;
        this.accountId = accountId;
        this.member = member;
        this.points = points;
    }

    public int getCustomerId() {
        return customerId;
    }
    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getAccountId() {
        return accountId;
    }
    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public String getMember() {
        return member;
    }
    public void setMember(String member) {
        this.member = member;
    }

    public int getPoints() {
        return points;
    }
    public void setPoints(int points) {
        this.points = points;
    }
}