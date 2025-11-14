<%-- 
    Document   : index
    Created on : Nov 10, 2025, 9:11:05 PM
    Author     : danim
--%>

<%-- 
    Document   : index
    Created on : Nov 10, 2025, 9:11:05 PM
    Author     : danim
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Car Rental System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            background: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 400px;
            width: 100%;
        }
        
        h1 {
            font-size: 28px;
            color: #333;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .nav-links {
            list-style: none;
        }
        
        .nav-links li {
            margin-bottom: 12px;
        }
        
        .nav-links a {
            display: block;
            padding: 12px 16px;
            background-color: #f9f9f9;
            color: #333;
            text-decoration: none;
            border: 1px solid #ddd;
            border-radius: 4px;
            transition: all 0.2s ease;
        }
        
        .nav-links a:hover {
            background-color: #4CAF50;
            color: white;
            border-color: #4CAF50;
        }
        
        .primary-link {
            background-color: #4CAF50;
            color: white;
            border-color: #4CAF50;
        }
        
        .primary-link:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Car Rental System</h1>
        <ul class="nav-links">
            <%
            String email = (String) session.getAttribute("userEmail");
            boolean loggedIn = (email != null);
            %>
            <% if (loggedIn) { %>
            <li><a href="<%= request.getContextPath() %>/browse-cars" class="primary-link">Browse Available Cars</a></li>
            <li><a href="<%= request.getContextPath() %>/logout">Logout</a></li>
            <% } else { %>
                <li><a href="<%= request.getContextPath() %>/browse-cars" class="primary-link">Browse Available Cars</a></li>
                <li><a href="<%= request.getContextPath() %>/login.jsp">Login</a></li>
                <li><a href="<%= request.getContextPath() %>/register.jsp">Register</a></li>
            <% } %>
        </ul>
    </div>
</body>
</html>
