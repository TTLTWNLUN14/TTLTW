package vn.edu.nlu.fit.datxedulich.dao;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;

public class DBProperties {
    private static Properties props = new Properties();
    static{
        try{
            File f = new File("/db.properties");
            if(f.exists()){
                props.load(new FileInputStream(f));
            } else {
                props.load(DBProperties.class.getClassLoader().getResourceAsStream("db.properties"));
            }
        } catch (FileNotFoundException e) {
            throw new RuntimeException(e);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
    public static String host = props.getProperty("db.host");
    public static String port = props.getProperty("db.port");
    public static String username = props.getProperty("db.username");
    public static String password = props.getProperty("db.pass");
    public static String dbname = props.getProperty("db.name");

    public static void main(String[] args) {
        System.out.println(host);
        System.out.println(port);
        System.out.println(username);
        System.out.println(password);
        System.out.println(dbname);

    }
}
