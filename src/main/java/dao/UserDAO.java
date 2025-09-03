// src/dao/UserDAO.java
package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.User;

public class UserDAO {

    public static boolean registerUser(User u) {
        try(Connection con=DBConnection.getConnection()) {
            // Check if first user -> make ADMIN
            String role = "MEMBER";
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM users");
            if(rs.next() && rs.getInt(1)==0) {
                role="ADMIN";
            }

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO users(name,email,password,mobile,role) VALUES(?,?,?,?,?)"
            );
            ps.setString(1, u.getName());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getMobile());
            ps.setString(5, role);
            return ps.executeUpdate()>0;
        } catch(Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static User login(String email, String pass) {
        try(Connection con=DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM users WHERE email=? AND password=?"
            );
            ps.setString(1,email);
            ps.setString(2,pass);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setMobile(rs.getString("mobile"));
                return u;
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public static boolean updateProfile(User u){
        String sql="UPDATE users SET name=?, mobile=?, email=? WHERE id=?";
        try(Connection con=DBConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(sql)){
            ps.setString(1,u.getName());
            ps.setString(2,u.getMobile());
            ps.setString(3,u.getEmail());
            ps.setInt(4,u.getId());
            return ps.executeUpdate()>0;
        }catch(Exception e){ e.printStackTrace(); 
       }
        return false;
    }

    public static List<User> getAllMembers(){
        List<User> list=new ArrayList<>();
        String sql="SELECT id,name,email,mobile,role FROM users ORDER BY id DESC";
        try(Connection con=DBConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(sql);
            ResultSet rs=ps.executeQuery()){
            while(rs.next()){
                User u=new User();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setMobile(rs.getString("mobile"));
                u.setRole(rs.getString("role"));
                list.add(u);
            }
        }catch(Exception e){ e.printStackTrace(); }
        return list;
    }
}
