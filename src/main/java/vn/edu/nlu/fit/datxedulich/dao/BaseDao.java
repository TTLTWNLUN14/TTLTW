package vn.edu.nlu.fit.datxedulich.dao;

import com.mysql.cj.jdbc.MysqlDataSource;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.mapper.reflect.ReflectionMappers;

import java.sql.SQLException;

public abstract class BaseDao {
    Jdbi jdbi;
    protected Jdbi get() {
        if (jdbi == null) {
            connect();

        }
        return jdbi;
    }
    private void connect() {
        MysqlDataSource dataSource = new MysqlDataSource();
        System.out.println("jdbc:mysql://"+DBProperties.host+":"+DBProperties.port+"/"+DBProperties.dbname+ "?tinyInt1isBit=false");
        dataSource.setUrl("jdbc:mysql://" + DBProperties.host + ":" + DBProperties.port + "/" + DBProperties.dbname + "?tinyInt1isBit=false");
        dataSource.setUser(DBProperties.username);
        dataSource.setPassword(DBProperties.password);
        try{
            dataSource.setUseCompression(true);
            dataSource.setAutoReconnect(true);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        jdbi = Jdbi.create(dataSource);

    }

}
