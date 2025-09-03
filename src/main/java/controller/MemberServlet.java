package controller;

import dao.BookDAO;
import dao.UserDAO;
import model.Book;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class MemberServlet extends HttpServlet {

    private boolean ensureMember(HttpServletRequest req, HttpServletResponse res) throws IOException{
        HttpSession s=req.getSession(false);
        if(s==null || s.getAttribute("user")==null){ res.sendRedirect("login.jsp?msg=Login first"); return false; }
        User u=(User)s.getAttribute("user");
        if(!"MEMBER".equals(u.getRole())){ res.sendRedirect("adminHome.jsp"); return false; }
        return true;
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        String action=req.getParameter("action");
        if(!ensureMember(req,res)) return;

        HttpSession session=req.getSession(false);
        User user=(User)session.getAttribute("user");

        switch(action){
            case "updateProfile":{
                User u=new User();
                u.setId(user.getId());
                u.setName(req.getParameter("name"));
                u.setEmail(req.getParameter("email"));
                u.setMobile(req.getParameter("mobile"));
                boolean ok=UserDAO.updateProfile(u);
                if(ok){
                    // refresh session copy
                    user.setName(u.getName()); user.setEmail(u.getEmail()); user.setMobile(u.getMobile());
                    session.setAttribute("user", user);
                    res.sendRedirect("memberHome.jsp?msg=Profile updated");
                } else res.sendRedirect("editProfile.jsp?msg=Update failed");
                break;
            }
            case "search":{
                String title=req.getParameter("title");
                String author=req.getParameter("author");
                String idStr=req.getParameter("bookId");
                List<Book> list=BookDAO.search(title,author,idStr);
                req.setAttribute("books", list);
                req.getRequestDispatcher("viewBooks.jsp").forward(req,res);
                break;
            }
            case "borrow": {
                int bookId = Integer.parseInt(req.getParameter("bookId"));
                if (BookDAO.borrowBook(user.getId(), bookId)) {
                    res.sendRedirect("MemberServlet?q=borrowed&msg=Borrowed successfully");
                } else {
                    res.sendRedirect("MemberServlet?q=all&msg=Borrow failed");
                }
                break;
            }

            case "return": {
                // ensures only the logged-in user can return their own borrowed book
                try {
                    int bookId = Integer.parseInt(req.getParameter("bookId"));
                    boolean ok = BookDAO.returnBook(user.getId(), bookId);
                    String msg = ok ? "Book returned successfully" : "Return failed (not borrowed)";
                    // redirect back to borrowed list so user sees updated list
                    res.sendRedirect("MemberServlet?q=borrowed&msg=" + java.net.URLEncoder.encode(msg, "UTF-8"));
                } catch (NumberFormatException nfe) {
                    res.sendRedirect("MemberServlet?q=borrowed&msg=" + java.net.URLEncoder.encode("Invalid Book ID", "UTF-8"));
                }
                break;
            }

        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        if(!ensureMember(req,res)) return;
        String q=req.getParameter("q");
        if("all".equals(q)){
            req.setAttribute("books", BookDAO.getAll());
            req.getRequestDispatcher("viewBooks.jsp").forward(req,res);
        } else if("borrowed".equals(q)){
            HttpSession s=req.getSession(false);
            User u=(User)s.getAttribute("user");
            req.setAttribute("books", BookDAO.getBorrowedByUser(u.getId()));
            req.getRequestDispatcher("borrowedBooks.jsp").forward(req,res);
        }
        else if("borrowed".equals(q)){
            HttpSession s=req.getSession(false);
            User u=(User)s.getAttribute("user");
            List<Book> borrowed = BookDAO.getBorrowedByUser(u.getId());
            System.out.println("DEBUG: Borrowed books for user " + u.getId() + " = " + borrowed.size());
            req.setAttribute("books", borrowed);
            req.getRequestDispatcher("borrowedBooks.jsp").forward(req,res);
        } else {
            res.sendRedirect("memberHome.jsp");
        }
    }
}
