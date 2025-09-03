<html>
<head>
<title>Login</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
<h2>Login</h2>

<%-- Optional: show message if redirected with ?msg=Invalid --%>
<% if (request.getParameter("msg") != null) { %>
  <p style="color:red;"><%= request.getParameter("msg") %></p>
<% } %>

<form action="AuthServlet" method="post">
    <input type="hidden" name="action" value="login">
    Email: <input type="email" name="email" required><br>
    Password: <input type="password" name="password" required><br>
    <button type="submit">Login</button>
</form>

<p>Don't have an account? <a href="register.jsp">Register here</a></p>
</body>
</html>
