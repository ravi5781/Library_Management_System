<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    // If already logged in, redirect based on role
    User current = (User) session.getAttribute("user");
    if (current != null) {
        if ("ADMIN".equals(current.getRole())) {
            response.sendRedirect("adminHome.jsp");
        } else {
            response.sendRedirect("memberHome.jsp");
        }
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Library Management System</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(to right, #283e51, #485563);
            color: #fff;
            text-align: center;
        }
        header {
            background: #1b2838;
            padding: 20px;
            font-size: 24px;
            font-weight: bold;
            letter-spacing: 1px;
        }
        .container {
            margin-top: 100px;
        }
        .btn {
            display: inline-block;
            padding: 12px 24px;
            margin: 15px;
            background: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
            transition: background 0.3s;
        }
        .btn:hover {
            background: #0056b3;
        }
        footer {
            margin-top: 150px;
            background: #1b2838;
            padding: 15px;
            font-size: 14px;
            color: #ccc;
        }
    </style>
</head>
<body>
    <header>
        📚 Welcome to Library Management System
    </header>

    <div class="container">
        <h1>Manage Books, Members & Borrowing Easily</h1>
        <p>Login or Register to continue</p>
        <a href="login.jsp" class="btn">Login</a>
        <a href="register.jsp" class="btn">Register</a>
    </div>

    <footer>
        &copy; <%= java.time.Year.now() %> Library Management System. All Rights Reserved.
    </footer>
</body>
</html>
