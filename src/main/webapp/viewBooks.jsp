<%@page import="dao.BookDAO"%>
<%
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader("Expires", 0);

    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>


<%@ page import="java.util.*,model.Book,model.User" %>
<%
  User u=(User)session.getAttribute("user");
  if(u==null){ response.sendRedirect("login.jsp?msg=Login first"); return; }
%>
<html>
<head>
<title>Books</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="topbar">
  <div>Viewing Books</div>
  <div>
    <a href="<%= "ADMIN".equals(u.getRole())? "adminHome.jsp" : "memberHome.jsp" %>">Back</a>
    <a class="danger" href="LogoutServlet">Logout</a>
  </div>
</div>

<h2>Books</h2>
<table>
  <tr><th>ID</th><th>Title</th><th>Author</th><th>Status</th>
  <% if("MEMBER".equals(u.getRole())){ %><th>Action</th><% } %></tr>
  <%
    List<Book> books=BookDAO.getAll();
    if(books==null) books=new ArrayList<>();
    for(Book b:books){
  %>
  <tr>
    <td><%=b.getId()%></td>
    <td><%=b.getTitle()%></td>
    <td><%=b.getAuthor()%></td>
    <td><%= b.isAvailable() ? "Available" : "Borrowed" %></td>
    <% if("MEMBER".equals(u.getRole())){ %>
      <td>
        <% if(b.isAvailable()){ %>
        <form action="MemberServlet" method="post" style="display:inline;">
          <input type="hidden" name="action" value="borrow">
          <input type="hidden" name="bookId" value="<%=b.getId()%>">
          <button type="submit">Borrow</button>
        </form>
        <% } %>
      </td>
    <% } %>
  </tr>
  <% } %>
</table>
</body>
</html>
