<%-- 
    Document   : book-car
    Created on : Nov 13, 2025, 1:19:18 AM
    Author     : Benjamin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.carrental.model.Car"%>
<%@page import="java.time.LocalDate"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Car</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 20px;
            background-color: white;
        }
        h1 {
            color: #333;
        }
        .car-info {
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            padding: 15px;
            margin: 20px 0;
        }
        .car-info h2 {
            margin-top: 0;
        }
        form {
            max-width: 500px;
        }
        label {
            display: block;
            margin: 15px 0 5px 0;
            font-weight: bold;
        }
        input[type="date"] {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            font-size: 14px;
        }
        button {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover {
            background-color: #45a049;
        }
        .error {
            color: red;
            border: 1px solid red;
            padding: 10px;
            margin: 10px 0;
        }
        .note {
            background-color: #fffacd;
            border: 1px solid #e6e600;
            padding: 10px;
            margin: 15px 0;
        }
        a {
            color: blue;
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <%
        Car car = (Car) request.getAttribute("car");
        String error = (String) request.getAttribute("error");
        
        if (car == null) {
            response.sendRedirect(request.getContextPath() + "/browse-cars");
            return;
        }
        
        // Get today's date for min date validation
        LocalDate today = LocalDate.now();
        String minDate = today.toString();
    %>
    <h1>Book Your Car</h1>
    
    <!-- Car Information -->
    <div class="car-info">
        <h2><%= car.getBrand() %> <%= car.getModel() %></h2>
        <p><strong>Car ID:</strong> <%= car.getId() %></p>
        <p><strong>Price per Day:</strong> $<%= String.format("%.2f", car.getPricePerDay()) %></p>
        <p><strong>Status:</strong> Available</p>
    </div>
    
    <!-- Error Message -->
    <% if (error != null) { %>
        <div class="error">
            ERROR: <%= error %>
        </div>
    <% } %>
    
    <!-- Booking Form -->
    <h2>Select Rental Dates</h2>
    
    <div class="note">
        <strong>Note:</strong> The car will be marked as unavailable once you complete the booking.
    </div>
    
    <form method="POST" action="<%= request.getContextPath() %>/book-car">
        <input type="hidden" name="carId" value="<%= car.getId() %>">
        
        <label for="startDate">Start Date:</label>
        <input type="date" id="startDate" name="startDate" min="<%= minDate %>" required>
        
        <label for="endDate">End Date:</label>
        <input type="date" id="endDate" name="endDate" min="<%= minDate %>" required>
        
        <button type="submit">Confirm Booking</button>
    </form>
    
    <hr>
    <p><a href="<%= request.getContextPath() %>/browse-cars">Back to Browse Cars</a></p>
</body>
</html>
