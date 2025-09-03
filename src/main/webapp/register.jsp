

<html>
<head>
<title>Register</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
<h2>Register</h2>
<form action="AuthServlet" method="post">
    <input type="hidden" name="action" value="register">
    Name: <input type="text" name="name" required><br>
    Email: <input type="email" name="email" required><br>
    Password: <input type="password" name="password" required><br>
    Mobile: <input type="text" name="mobile" required><br>
    <button type="submit">Register</button>
</form>
</body>
</html>
