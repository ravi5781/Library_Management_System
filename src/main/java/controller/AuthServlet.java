// src/controller/AuthServlet.java
package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;

public class AuthServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String action = req.getParameter("action");

        if("register".equals(action)) {
            User u = new User();
            u.setName(req.getParameter("name"));
            u.setEmail(req.getParameter("email"));
            u.setPassword(req.getParameter("password"));
            u.setMobile(req.getParameter("mobile"));

            if(UserDAO.registerUser(u)) {
                res.sendRedirect("login.jsp?msg=Registered Successfully!");
            } else {
                res.sendRedirect("register.jsp?msg=Error in Registration");
            }
        } 
        else if("login".equals(action)) {
            String email=req.getParameter("email");
            String pass=req.getParameter("password");

            User u=UserDAO.login(email,pass);
            if(u!=null) {
                HttpSession session=req.getSession();
                session.setMaxInactiveInterval(30 * 60);
                session.setAttribute("user", u);
                if("ADMIN".equals(u.getRole()))
                    res.sendRedirect("adminHome.jsp");
                else
                    res.sendRedirect("memberHome.jsp");
            } else {
                res.sendRedirect("login.jsp?msg=Invalid Credentials");
            }
        }
    }
}
