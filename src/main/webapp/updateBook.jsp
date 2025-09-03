<%@ page import="model.Book,model.User" %>
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
  Book b=(Book)request.getAttribute("book");
  if(b==null){ response.sendRedirect("AdminServlet?q=books"); return; }
%>
<html>
<head>
<title>Update Book</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="topbar">
  <div>Editing Book #<%=b.getId()%></div>
  <div>
    <a href="AdminServlet?q=books">Back</a>
    <a class="danger" href="LogoutServlet">Logout</a>
  </div>
</div>

<form action="AdminServlet" method="post" class="wide">
  <input type="hidden" name="action" value="update">
  <input type="hidden" name="id" value="<%=b.getId()%>">
  Title: <input type="text" name="title" value="<%=b.getTitle()%>" required><br>
  Author:<input type="text" name="author" value="<%=b.getAuthor()%>" required><br>
  Available:
  <select name="available">
    <option value="true" <%= b.isAvailable() ? "selected":"" %>>true</option>
    <option value="false" <%= !b.isAvailable() ? "selected":"" %>>false</option>
  </select><br>
  <button type="submit">Update</button>
</form>
</body>
</html>
