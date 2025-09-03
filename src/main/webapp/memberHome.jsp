<%@ page import="model.User, java.util.List, model.Book, dao.BookDAO" %>
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
  if (!"MEMBER".equals(u.getRole())) { response.sendRedirect("adminHome.jsp"); return; }
  List<Book> latest = BookDAO.getAll();
%>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Member Dashboard</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <div class="navbar">
    <a href="memberHome.jsp">Home</a>
    <a href="viewBooks.jsp">View All Books</a>
    <a href="borrowedBooks.jsp">My Borrowed</a>
    <a href="editProfile.jsp">Edit Profile</a>
    <a href="LogoutServlet" class="btn-small">Logout</a>
    

  </div>

  <div class="container">
    <h2>Welcome, <%= u.getName() %> (Member)</h2>

    <% if(request.getParameter("msg") != null){ %>
      <div class="<%= request.getParameter("msg").toLowerCase().contains("error") ? "error" : "success" %>">
        <%= request.getParameter("msg") %>
      </div>
    <% } %>

    <div style="max-width:900px; margin:auto;">
      <h3>Search Books</h3>
      <form action="MemberServlet" method="post" style="display:flex; gap:8px; flex-wrap:wrap; justify-content:center;">
        <input type="hidden" name="action" value="search">
        <input type="text" name="title" placeholder="Title" style="width:30%;">
        <input type="text" name="author" placeholder="Author" style="width:30%;">
        <input type="text" name="bookId" placeholder="Book ID" style="width:15%;">
        <button type="submit" style="width:15%;">Search</button>
      </form>

      <h3>Latest Books</h3>
      <table>
        <thead>
          <tr><th>ID</th><th>Title</th><th>Author</th><th>Status</th><th>Action</th></tr>
        </thead>
        <tbody>
        <% for (Book b : latest) { %>
          <tr>
            <td><%= b.getId() %></td>
            <td><%= b.getTitle() %></td>
            <td><%= b.getAuthor() %></td>
            <td><%= b.isAvailable() ? "Available" : "Borrowed" %></td>
            <td>
              <% if (b.isAvailable()) { %>
                <form action="MemberServlet" method="post" style="margin:0;">
                  <input type="hidden" name="action" value="borrow">
                  <input type="hidden" name="bookId" value="<%= b.getId() %>">
                  <button class="btn-small" type="submit">Borrow</button>
                </form>
              <% } else { %>
                —
              <% } %>
            </td>
          </tr>
        <% } %>
        </tbody>
      </table>
    </div>
  </div>
</body>
</html>
