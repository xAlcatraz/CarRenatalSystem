<%-- 
    Document   : browse-cars
    Created on : Nov 13, 2025, 12:45:39 AM
    Author     : Benjamin
--%>

<%-- 
    Document   : browse-cars
    Created on : Nov 13, 2025, 12:45:39 AM
    Author     : Benjamin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.carrental.model.Car"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Browse Cars</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 20px;
            background-color: white;
        }
        h1 {
            color: #333;
        }
        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin: 20px 0;
        }
        th, td { 
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        th { 
            background-color: #f0f0f0;
        }
        a {
            color: blue;
            text-decoration: underline;
        }
        .error {
            color: red;
            border: 1px solid red;
            padding: 10px;
            margin: 10px 0;
        }
        .user-info {
            margin-bottom: 20px;
            padding: 10px;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
        }
    </style>
</head>
<body>
    <%
        // Get data from servlet
        List<Car> carList = (List<Car>) request.getAttribute("carList");
        String errorMessage = (String) request.getAttribute("errorMessage");
        
        // Get session info
        String userEmail = null;
        String userRole = null;
        if (session != null) {
            userEmail = (String) session.getAttribute("userEmail");
            userRole = (String) session.getAttribute("userRole");
        }
        
        boolean isLoggedIn = (userEmail != null);
    %>
    
    <h1>Browse Available Cars</h1>
    
    <!-- User info -->
    <% if (isLoggedIn) { %>
        <div class="user-info">
            Logged in as: <strong><%= userEmail %></strong> (Role: <%= userRole %>)
            &nbsp; | &nbsp;
            <a href="<%= request.getContextPath() %>/logout">Logout</a>
        </div>
    <% } else { %>
        <div class="user-info">
            Not logged in. <a href="<%= request.getContextPath() %>/login.jsp">Login</a> or 
            <a href="<%= request.getContextPath() %>/register.jsp">Register</a> to book cars.
        </div>
    <% } %>
    
    <!-- Show error if any -->
    <% if (errorMessage != null) { %>
        <div class="error">
            ERROR: <%= errorMessage %>
        </div>
    <% } %>
    
    <!-- Cars table -->
    <% if (carList != null && !carList.isEmpty()) { %>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Brand</th>
                    <th>Model</th>
                    <th>Price per Day</th>
                    <th>Available</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% for (Car car : carList) { %>
                    <tr>
                        <td><%= car.getId() %></td>
                        <td><%= car.getBrand() %></td>
                        <td><%= car.getModel() %></td>
                        <td>$<%= String.format("%.2f", car.getPricePerDay()) %></td>
                        <td><%= car.isAvailable() ? "Yes" : "No" %></td>
                        <td>
                            <% if (isLoggedIn) { %>
                                <a href="<%= request.getContextPath() %>/book-car?carId=<%= car.getId() %>">Book</a>
                            <% } else { %>
                                <a href="<%= request.getContextPath() %>/login.jsp">Login to Book</a>
                            <% } %>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
        
        <p>Total cars available: <%= carList.size() %></p>
    <% } else { %>
        <p>No cars available.</p>
    <% } %>
    
    <hr>
    <p><a href="<%= request.getContextPath() %>/index.jsp">Back to Home</a></p>
</body>
</html>

