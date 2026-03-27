package vn.edu.nlu.fit.datxedulich.model;


public class Google {
    private String id;
    private String email;
    private String name;
    private String picture;

    public GooglePojo() {}

    public String getId() {
        return id;
    }
    public void setId(String v) {
        this.id = v;
    }

    public String getEmail()  {
        return email;
    }
    public void setEmail(String v)     {
        this.email = v;
    }

    public String getName() {
        return name;
    }
    public void setName(String v)      {
        this.name = v;
    }

    public String getPicture() {
        return picture;
    }
    public void setPicture(String v)   {
        this.picture = v;
    }

    @Override
    public String toString() {
        return "Google{id='" + id + "', email='" + email + "', name='" + name + "'}";
    }
}