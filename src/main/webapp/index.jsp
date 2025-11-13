<%-- 
    Document   : index
    Created on : Nov 10, 2025, 9:11:05 PM
    Author     : danim
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Car Rental System</title>
    </head>
    <body>
        <h1>Car Rental System</h1>
        <p><a href="<%= request.getContextPath() %>/login.jsp">Login</a></p>
        <p><a href="<%= request.getContextPath() %>/register.jsp">Register</a></p>
        <p><a href="<%= request.getContextPath() %>/dbtest">Test DB Connection</a></p>
    </body>
</html>
