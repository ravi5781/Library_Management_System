<%@ page import="model.User, java.util.List, model.Book, dao.BookDAO, dao.UserDAO" %>
<%
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader("Expires", 0);

    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>


<%
  User u = (User) session.getAttribute("user");
  if (u == null) { response.sendRedirect("login.jsp?msg=Login first"); return; }
  if (!"ADMIN".equals(u.getRole())) { response.sendRedirect("memberHome.jsp"); return; }
  List<Book> books = BookDAO.getAll();
  List<User> members = UserDAO.getAllMembers();
%>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Admin Dashboard</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <div class="navbar">
    <a href="adminHome.jsp">Home</a>
    <a href="addBook.jsp">Add Book</a>
    <a href="LogoutServlet" class="btn-small">Logout</a>



  </div>

  <div class="container">
    <h2>Welcome, <%= u.getName() %> (Admin)</h2>

    <% if(request.getParameter("msg") != null){ %>
      <div class="<%= request.getParameter("msg").toLowerCase().contains("failed") ? "error" : "success" %>">
        <%= request.getParameter("msg") %>
      </div>
    <% } %>

    <div style="display:flex; gap:20px; justify-content:center; flex-wrap:wrap;">
      <div class="card">
        <h3>Total Books</h3>
        <p style="font-size:24px;"><%= books.size() %></p>
        <a class="btn-small" href="AdminServlet?q=books">Manage</a>
      </div>

      <div class="card">
        <h3>Registered Users</h3>
        <p style="font-size:24px;"><%= members.size() %></p>
        <a class="btn-small" href="AdminServlet?q=members">View</a>
      </div>
    </div>

    <h3 style="margin-top:30px;">Books List</h3>
    <table>
      <thead>
        <tr><th>ID</th><th>Title</th><th>Author</th><th>Available</th><th>Actions</th></tr>
      </thead>
      <tbody>
      <% for (Book b : books) { %>
        <tr>
          <td><%= b.getId() %></td>
          <td><%= b.getTitle() %></td>
          <td><%= b.getAuthor() %></td>
          <td><%= b.isAvailable() %></td>
          <td>
            <a class="btn-small" href="AdminServlet?q=edit&id=<%= b.getId() %>">Edit</a>
            <form action="AdminServlet" method="post" style="display:inline;">
              <input type="hidden" name="action" value="delete">
              <input type="hidden" name="id" value="<%= b.getId() %>">
              <button class="btn-small" type="submit">Delete</button>
            </form>
          </td>
        </tr>
      <% } %>
      </tbody>
    </table>

    <h3 style="margin-top:30px;">Users</h3>
    <table>
      <thead><tr><th>ID</th><th>Name</th><th>Email</th><th>Mobile</th><th>Role</th></tr></thead>
      <tbody>
      <% for (User mu : members) { %>
        <tr>
          <td><%= mu.getId() %></td>
          <td><%= mu.getName() %></td>
          <td><%= mu.getEmail() %></td>
          <td><%= mu.getMobile() %></td>
          <td><%= mu.getRole() %></td>
        </tr>
      <% } %>
      </tbody>
    </table>

  </div>
</body>
</html>
