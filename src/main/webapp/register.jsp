<%-- 
    Document   : register
    Created on : Nov 12, 2025, 8:20:14 PM
    Author     : danim
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register</title>
    </head>
    <body>
        <h2>Register</h2>
        <form method="post" action="<%= request.getContextPath() %>/register">
            <label>
                Name:
                <input type="text" name="name" required>
            </label>
            <br>
            <label>
                Email:
                <input type="email" name="email" required>
            </label>
            <br>
            <label>
                Password:
                <input type="password" name="password" required>
            </label>
            <br>
            <button type="submit">Create Account</button>
        </form>
        <p><a href="<%= request.getContextPath() %>/login.jsp">Back to Login</a></p>
    </body>
</html>
