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
                font-size: 24px;
                color: #333;
                margin-bottom: 24px;
                text-align: center;
            }
        
            .form-group {
                margin-bottom: 16px;
            }
        
            label {
                display: block;
                margin-bottom: 6px;
                font-weight: bold;
                color: #333;
            }
        
            input[type="text"],
            input[type="email"],
            input[type="password"] {
                width: 100%;
                padding: 10px;
                border-radius: 4px;
                border: 1px solid #ddd;
                font-size: 14px;
            }
        
            .btn {
                display: inline-block;
                padding: 10px 16px;
                border-radius: 4px;
                border: none;
                cursor: pointer;
                text-align: center;
                font-size: 14px;
                text-decoration: none;
            }
        
            .btn-primary {
                width: 100%;
                background-color: #4CAF50;
                color: white;
                border: 1px solid #4CAF50;
                margin-top: 8px;
            }
        
            .btn-primary:hover {
                background-color: #45a049;
            }
        
            .links {
                margin-top: 16px;
                font-size: 14px;
                text-align: center;
            }
        
            .links a {
                color: #0066cc;
                text-decoration: underline;
            }
        
            .error {
                margin-bottom: 16px;
                padding: 10px;
                border-radius: 4px;
                border: 1px solid #e53935;
                background-color: #ffebee;
                color: #b71c1c;
                font-size: 14px;
            }
        </style>
    </head>
    <body>
        <%
            String error = (String) request.getAttribute("error");
            String message = (String) request.getAttribute("message");
        %>
        
        <div class="container">
            <h1>Create Account</h1>
            
            <% if (error != null) { %>
                <div class="error">
                    <%= error %>
                </div>
            <% } %>
            
            <% if (message != null) { %>
                <div class="error" style="border-color:#4CAF50;background-color:#e8f5e9;color:#2e7d32;">
                <%= message %>
                </div>
            <% } %>
            
            <form method="post" action="<%= request.getContextPath() %>/register">
                <div class="form-group">
                    <label for="name">Full Name</label>
                    <input id="name" name="name" type="text" required>
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input id="email" name="email" type="email" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input id="password" name="password" type="password" required>
                </div>
                <button type="submit" class="btn btn-primary">Register</button>
            </form>
                
            <div class="links">
                <p>
                    <a href="<%= request.getContextPath() %>/login.jsp">Back to Login</a>
                </p>
                <p>
                    <a href="<%= request.getContextPath() %>/index.jsp">Back to Main Menu</a>
                </p>
            </div>
        </div>
    </body>
</html>
