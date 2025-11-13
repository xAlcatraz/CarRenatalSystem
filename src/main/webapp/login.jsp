<%-- 
    Document   : login
    Created on : Nov 12, 2025, 8:07:32 PM
    Author     : danim
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
    </head>
    <body>
        <h2>Login</h2>
        <%
            String error = request.getParameter("error");
            if ("1".equals(error)) {
        %>
            <p style="color:red;">Invalid email or password.</p>
        <%
            }
        %>
        
        <form method="post" action="<%= request.getContextPath() %>/login">
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
            <button type="submit">Login</button>
        </form>
        <p><a href="<%= request.getContextPath() %>/register.jsp">Don't have an Account> Register</a></p>
    </body>
</html>
