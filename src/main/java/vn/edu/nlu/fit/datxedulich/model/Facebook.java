package vn.edu.nlu.fit.datxedulich.model;

public class Facebook {
    private String id;
    private String name;
    private String email;

    public Facebook(String  id, String name, String email) {
        this.id = id;
        this.name = name;
        this.email = email;
    }

    public String getId(){
        return id;
    }
    public void setId(String v){
        this.id = v;
    }

    public String getName(){
        return name;
    }
    public void setName(String v){
        this.name = v;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String v){
        this.email = v;
    }

    @Override
    public String toString() {
        return "Facebook{id='" + id + "', email='" + email + "', name='" + name + "'}";
    }
}