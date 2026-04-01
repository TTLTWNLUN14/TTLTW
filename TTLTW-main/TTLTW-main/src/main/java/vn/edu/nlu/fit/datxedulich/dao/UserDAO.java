package vn.edu.nlu.fit.datxedulich.dao;

import vn.edu.nlu.fit.datxedulich.model.User;

import java.util.ArrayList;
import java.util.List;

public class UserDAO extends BaseDao{
   public User findByUserName(String userName){
       try {
           return get().withHandle(h -> h.createQuery("SELECT * FROM account WHERE username = :username")
                   .bind("username",userName)
                   .mapToBean(User.class)
                   .first());

       } catch (Exception e) {
           System.out.println("không kiếm thấy người dùng"+e.getMessage());
           return null;
       }
   }
  public User findById(int id){
       try {
           return get().withHandle(h -> h.createQuery("SELECT * FROM account WHERE id = :id")
                   .bind("id", id)
                   .mapToBean(User.class)
                   .first());
       }  catch (Exception e) {
           System.out.println("không kiem thay id"+e.getMessage());
           return null;
       }
  }
    public List<User> findAll() {
       try {
           return (List<User>) get().withHandle(h -> h.createQuery("SELECT * FROM account ORDER BY id DESC")
                   .mapToBean(User.class)
                   .first());
       } catch (Exception e){
           System.out.println("Lỗi khi lấy danh sách người dùng"+e.getMessage());
           return List.of();
       }
    }
    public boolean create(User user){
       try {
           int row = get().withHandle(h -> h.createUpdate("INSERT INTO account(username,password_hash,email,full_ name,phone,CCCD,gender,address,birthday,last_login,first_login)"+"VALUES()")
                   .bindBean(user)
                   .execute());
           return row > 0;
       } catch (Exception e) {
           System.out.println("Lỗi tạo user"+e.getMessage());
           return false;
       }
    }
    public boolean update(User user) {
       try {
           int row = get().withHandle(h -> h.createUpdate("UPDATE account SET password_hash=:password_hash,email =:email,full_name=:full_name WHERE account_id = :account_id")
                   .bindBean(user)
                   .execute());
           return row > 0;
       } catch (Exception e) {
           System.out.println("Lỗi khi cập nhật"+e.getMessage());
           return false;
       }
    }
    public boolean delete(int account_id) {
       try {
           int row = get().withHandle(h -> h.createUpdate("DELETE FROM account WHERE account_id=:account_id")
                   .bind("account_id",account_id)
                   .execute());
           return row > 0;
       } catch (Exception e){
           System.out.println("Lỗi khi xóa"+e.getMessage());
           return false;
       }
    }
   public boolean isUsernameExists(String username) {
       try {
           return findByUserName(username) !=null;
       }catch (Exception e){
           System.out.println("Lỗi khi kiểm tra tên đăng nhập"+e.getMessage());
           return false;
       }

    }
    public boolean isEmailExists(String email) {
       try {
            int row= get().withHandle(h -> h.createQuery("SECLECT COUNT (*) FROM account WHERE email=:email ")
                    .bind("email",email)
                    .mapTo(Integer.class)
                    .first());
            return row > 0;

       }catch (Exception e){
           System.out.println("Lỗi khi check email"+e.getMessage());
           return false;
       }
    }
}