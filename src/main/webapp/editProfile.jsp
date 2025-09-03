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
  if(u==null){ response.sendRedirect("login.jsp?msg=Login first"); return; }
%>
<html>
<head>
<title>Edit Profile</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="topbar">
  <div>Editing: <b><%=u.getName()%></b></div>
  <div>
    <a href="<%= "ADMIN".equals(u.getRole())? "adminHome.jsp" : "memberHome.jsp" %>">Home</a>
    <a class="danger" href="LogoutServlet">Logout</a>
  </div>
</div>

<h2>Update Profile</h2>
<form action="<%= "ADMIN".equals(u.getRole())? "AdminServlet" : "MemberServlet" %>" method="post" class="wide">
  <input type="hidden" name="action" value="updateProfile"><!-- AdminServlet ignores -->
  Name:  <input type="text" name="name" value="<%=u.getName()%>" required><br>
  Email: <input type="email" name="email" value="<%=u.getEmail()%>" required><br>
  Mobile:<input type="text" name="mobile" value="<%=u.getMobile()%>" required><br>
  <button type="submit" formaction="MemberServlet">Save Changes</button>
</form>

<% if(request.getParameter("msg")!=null){ %>
  <div class="msg"><%=request.getParameter("msg")%></div>
<% } %>
</body>
</html>
