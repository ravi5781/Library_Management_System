package dao;

import model.Book;
import java.sql.*;
import java.util.*;

public class BookDAO {

    public static boolean addBook(Book b){
        String sql="INSERT INTO books(title,author,available) VALUES(?,?,?)";
        try(Connection con=DBConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(sql)){
            ps.setString(1,b.getTitle());
            ps.setString(2,b.getAuthor());
            ps.setBoolean(3,b.isAvailable());
            return ps.executeUpdate()>0;
        }catch(Exception e){ e.printStackTrace(); }
        return false;
    }

    public static boolean updateBook(Book b){
        String sql="UPDATE books SET title=?, author=?, available=? WHERE id=?";
        try(Connection con=DBConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(sql)){
            ps.setString(1,b.getTitle());
            ps.setString(2,b.getAuthor());
            ps.setBoolean(3,b.isAvailable());
            ps.setInt(4,b.getId());
            return ps.executeUpdate()>0;
        }catch(Exception e){ e.printStackTrace(); }
        return false;
    }

    public static boolean deleteBook(int id){
        String sql="DELETE FROM books WHERE id=?";
        try(Connection con=DBConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(sql)){
            ps.setInt(1,id);
            return ps.executeUpdate()>0;
        }catch(Exception e){ e.printStackTrace(); }
        return false;
    }

    public static Book getById(int id){
        String sql="SELECT * FROM books WHERE id=?";
        try(Connection con=DBConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(sql)){
            ps.setInt(1,id);
            ResultSet rs=ps.executeQuery();
            if(rs.next()){
                Book b=new Book();
                b.setId(rs.getInt("id"));
                b.setTitle(rs.getString("title"));
                b.setAuthor(rs.getString("author"));
                b.setAvailable(rs.getBoolean("available"));
                return b;
            }
        }catch(Exception e){ e.printStackTrace(); }
        return null;
    }

    public static List<Book> getAll(){
        List<Book> list=new ArrayList<>();
        String sql="SELECT * FROM books ORDER BY id DESC";
        try(Connection con=DBConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(sql);
            ResultSet rs=ps.executeQuery()){
            while(rs.next()){
                Book b=new Book();
                b.setId(rs.getInt("id"));
                b.setTitle(rs.getString("title"));
                b.setAuthor(rs.getString("author"));
                b.setAvailable(rs.getBoolean("available"));
                list.add(b);
            }
        }catch(Exception e){ e.printStackTrace(); }
        return list;
    }

    public static List<Book> search(String title, String author, String idStr){
        StringBuilder sb=new StringBuilder("SELECT * FROM books WHERE 1=1");
        List<Object> params=new ArrayList<>();
        if(title!=null && !title.trim().isEmpty()){
            sb.append(" AND title LIKE ?");
            params.add("%"+title.trim()+"%");
        }
        if(author!=null && !author.trim().isEmpty()){
            sb.append(" AND author LIKE ?");
            params.add("%"+author.trim()+"%");
        }
        if(idStr!=null && !idStr.trim().isEmpty()){
            sb.append(" AND id=?");
            params.add(Integer.parseInt(idStr.trim()));
        }
        sb.append(" ORDER BY id DESC");

        List<Book> list=new ArrayList<>();
        try(Connection con=DBConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(sb.toString())){
            for(int i=0;i<params.size();i++) ps.setObject(i+1, params.get(i));
            ResultSet rs=ps.executeQuery();
            while(rs.next()){
                Book b=new Book();
                b.setId(rs.getInt("id"));
                b.setTitle(rs.getString("title"));
                b.setAuthor(rs.getString("author"));
                b.setAvailable(rs.getBoolean("available"));
                list.add(b);
            }
        }catch(Exception e){ e.printStackTrace(); }
        return list;
    }

    // --- Borrow / Return ---
    public static boolean borrowBook(int userId, int bookId){
        String check="SELECT available FROM books WHERE id=?";
        String insert="INSERT INTO borrowed_books(user_id,book_id) VALUES(?,?)";
        String update="UPDATE books SET available=false WHERE id=?";

        try(Connection con=DBConnection.getConnection()){
            con.setAutoCommit(false);

            try(PreparedStatement c=con.prepareStatement(check)){
                c.setInt(1,bookId);
                ResultSet rs=c.executeQuery();
                if(!rs.next() || !rs.getBoolean(1)){
                    con.rollback(); return false; // not available
                }
            }

            try(PreparedStatement ins=con.prepareStatement(insert);
                PreparedStatement up=con.prepareStatement(update)){

                ins.setInt(1,userId); ins.setInt(2,bookId); ins.executeUpdate();
                up.setInt(1,bookId);  up.executeUpdate();
            }
            con.commit(); return true;
        }catch(Exception e){ e.printStackTrace(); }
        return false;
    }
    public static boolean returnBook(int userId, int bookId) {
        String deleteBorrowed = "DELETE FROM borrowed_books WHERE user_id=? AND book_id=? LIMIT 1";
        String updateBook = "UPDATE books SET available = TRUE WHERE id = ?";

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false); // transaction

            try (PreparedStatement pstDelete = con.prepareStatement(deleteBorrowed)) {
                pstDelete.setInt(1, userId);
                pstDelete.setInt(2, bookId);
                int deleted = pstDelete.executeUpdate();
                if (deleted == 0) {
                    con.rollback();
                    return false; // nothing deleted -> user didn't have this book borrowed
                }
            }

            try (PreparedStatement pstUpdate = con.prepareStatement(updateBook)) {
                pstUpdate.setInt(1, bookId);
                pstUpdate.executeUpdate();
            }

            con.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            // fallback: nothing committed
        }
        return false;
    }

    
    

    public static List<Book> getBorrowedByUser(int userId){
        String sql="SELECT b.* FROM books b JOIN borrowed_books bb ON b.id=bb.book_id WHERE bb.user_id=?";
        List<Book> list=new ArrayList<>();
        try(Connection con=DBConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(sql)){
            ps.setInt(1,userId);
            ResultSet rs=ps.executeQuery();
            while(rs.next()){
                Book b=new Book();
                b.setId(rs.getInt("id"));
                b.setTitle(rs.getString("title"));
                b.setAuthor(rs.getString("author"));
                b.setAvailable(false);
                list.add(b);
            }
        }catch(Exception e){ e.printStackTrace(); }
        return list;
    }
}
