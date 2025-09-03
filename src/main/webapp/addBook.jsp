<%@ page import="model.User" %>
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
  User u=(User)session.getAttribute("user");
  if(u==null || !"ADMIN".equals(u.getRole())){ response.sendRedirect("login.jsp"); return; }
%>
<html>
<head>
<title>Add Book</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="topbar">
  <div>Add a new Book</div>
  <div>
    <a href="AdminServlet?q=books">Back to Books</a>
    <a class="danger" href="LogoutServlet">Logout</a>
  </div>
</div>

<form action="AdminServlet" method="post" class="wide">
  <input type="hidden" name="action" value="add">
  Title: <input type="text" name="title" required><br>
  Author: <input type="text" name="author" required><br>
  <button type="submit">Add Book</button>
</form>
</body>
</html>
