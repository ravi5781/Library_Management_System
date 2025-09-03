<%@page import="dao.BookDAO"%>
<%@ page import="java.util.*,model.Book,model.User" %>
<%
    // prevent cache (back button after logout)
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader("Expires", 0);

    // check login
    User u = (User) session.getAttribute("user");
    if (u == null || !"MEMBER".equals(u.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Borrowed Books</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f7fa;
            margin: 0;
            padding: 0;
        }
        .topbar {
            background: #003366;
            color: white;
            padding: 12px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .topbar a {
            color: white;
            text-decoration: none;
            margin-left: 15px;
            font-weight: bold;
        }
        .topbar a.danger {
            background: #d9534f;
            padding: 5px 10px;
            border-radius: 4px;
        }
        .topbar a.danger:hover {
            background: #b52b27;
        }
        h2 {
            text-align: center;
            margin-top: 20px;
        }
        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            background: white;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }
        th {
            background: #003366;
            color: white;
        }
        .btn-return {
            background: #28a745;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-return:hover {
            background: #1e7d34;
        }
        .msg {
            width: 80%;
            margin: 10px auto;
            text-align: center;
            padding: 10px;
            border-radius: 5px;
            background: #e7f7ec;
            color: #1a7b34;
        }
    </style>
</head>
<body>
    <div class="topbar">
        <div>Borrowed by <b><%= u.getName() %></b></div>
        <div>
            <a href="memberHome.jsp">Home</a>
            <a class="danger" href="LogoutServlet">Logout</a>
        </div>
    </div>

    <h2>My Borrowed Books</h2>

    <% if (request.getParameter("msg") != null) { %>
        <div class="msg"><%= request.getParameter("msg") %></div>
    <% } %>

    <table>
        <tr>
            <th>ID</th>
            <th>Title</th>
            <th>Author</th>
            <th>Action</th>
        </tr>
        <%
            List<Book> books = BookDAO.getBorrowedByUser(u.getId());
            if (books == null || books.isEmpty()) {
        %>
            <tr>
                <td colspan="4">No borrowed books yet.</td>
            </tr>
        <%
            } else {
                for (Book b : books) {
        %>
            <tr>
                <td><%= b.getId() %></td>
                <td><%= b.getTitle() %></td>
                <td><%= b.getAuthor() %></td>
                <td>
                    <form action="MemberServlet" method="post">
  <input type="hidden" name="action" value="return" />
  <input type="hidden" name="bookId" value="<%= b.getId() %>" />
  <button type="submit" class="btn-return">Return</button>
</form>
                    
                </td>
            </tr>
        <%
                }
            }
        %>
    </table>
</body>
</html>
