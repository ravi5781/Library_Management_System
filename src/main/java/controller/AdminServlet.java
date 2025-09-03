package controller;

import dao.BookDAO;
import dao.UserDAO;
import model.Book;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AdminServlet extends HttpServlet {

    private boolean ensureAdmin(HttpServletRequest req, HttpServletResponse res) throws IOException{
        HttpSession s=req.getSession(false);
        if(s==null || s.getAttribute("user")==null){ res.sendRedirect("login.jsp?msg=Login first"); return false; }
        User u=(User)s.getAttribute("user");
        if(!"ADMIN".equals(u.getRole())){ res.sendRedirect("memberHome.jsp"); return false; }
        return true;
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        if(!ensureAdmin(req,res)) return;
        String q=req.getParameter("q");
        if("members".equals(q)){
            req.setAttribute("members", UserDAO.getAllMembers());
            req.getRequestDispatcher("adminHome.jsp").forward(req,res);
        } else if("books".equals(q)){
            req.setAttribute("books", BookDAO.getAll());
            req.getRequestDispatcher("adminHome.jsp").forward(req,res);
        } else if("edit".equals(q)){
            int id=Integer.parseInt(req.getParameter("id"));
            req.setAttribute("book", BookDAO.getById(id));
            req.getRequestDispatcher("updateBook.jsp").forward(req,res);
        } else {
            res.sendRedirect("adminHome.jsp");
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        if(!ensureAdmin(req,res)) return;
        String action=req.getParameter("action");
        switch(action){
            case "add":{
                Book b=new Book();
                b.setTitle(req.getParameter("title"));
                b.setAuthor(req.getParameter("author"));
                b.setAvailable(true);
                boolean ok=BookDAO.addBook(b);
                res.sendRedirect("adminHome.jsp?msg="+(ok?"Book added":"Add failed"));
                break;
            }
            case "update":{
                Book b=new Book();
                b.setId(Integer.parseInt(req.getParameter("id")));
                b.setTitle(req.getParameter("title"));
                b.setAuthor(req.getParameter("author"));
                b.setAvailable("true".equals(req.getParameter("available")));
                boolean ok=BookDAO.updateBook(b);
                res.sendRedirect("adminHome.jsp?msg="+(ok?"Updated":"Update failed"));
                break;
            }
            case "delete":{
                int id=Integer.parseInt(req.getParameter("id"));
                boolean ok=BookDAO.deleteBook(id);
                res.sendRedirect("adminHome.jsp?msg="+(ok?"Deleted":"Delete failed"));
                break;
            }
        }
    }
}
