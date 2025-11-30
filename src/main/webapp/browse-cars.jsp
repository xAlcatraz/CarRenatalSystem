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
        .container {
            display: flex;
            gap: 20px;
        }
        .filter-section {
            width: 250px;
            padding: 15px;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            height: fit-content;
        }
        .filter-section h2 {
            color: #333;
            margin-top: 0;
            font-size: 1.3em;
        }
        .filter-group {
            margin-bottom: 20px;
        }
        .filter-group strong {
            display: block;
            margin-bottom: 8px;
            color: #333;
        }
        .filter-group label {
            display: block;
            margin-bottom: 5px;
            cursor: pointer;
        }
        .filter-group input[type="checkbox"] {
            margin-right: 8px;
        }
        .filter-buttons {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .filter-buttons button {
            padding: 8px 15px;
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }
        .filter-buttons button:hover {
            background-color: #45a049;
        }
        .filter-buttons a {
            padding: 8px 15px;
            background-color: #f0f0f0;
            color: #333;
            border: 1px solid #ddd;
            text-align: center;
            text-decoration: none;
            display: block;
        }
        .filter-buttons a:hover {
            background-color: #e0e0e0;
        }
        .main-content {
            flex: 1;
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
    
    <%
    // Get the selected filter values to keep checkboxes checked
    String[] selectedCarTypes = request.getParameterValues("carType");
    String[] selectedCapacities = request.getParameterValues("capacity");
    String[] selectedFuelTypes = request.getParameterValues("fuelType");
    %>

    <%!
    // Helper method to check if a value is in the array (JSP Declaration)
    private boolean isChecked(String[] array, String value) {
        if (array == null) return false;
        for (String item : array) {
            if (item.equals(value)) return true;
        }
        return false;
    }
    %>

    <div class="container">
    
        <!-- Filter Section -->
        <div class="filter-section">
            <h2>Filters</h2>
            <form method="get" action="<%= request.getContextPath() %>/browse-cars">

                <!-- Car Type Filter -->
                <div class="filter-group">
                    <strong>Car Type:</strong>
                    <label><input type="checkbox" name="carType" value="Sedan" <%= isChecked(selectedCarTypes, "Sedan") ? "checked" : "" %>> Sedan</label>
                    <label><input type="checkbox" name="carType" value="SUV" <%= isChecked(selectedCarTypes, "SUV") ? "checked" : "" %>> SUV</label>
                    <label><input type="checkbox" name="carType" value="Truck" <%= isChecked(selectedCarTypes, "Truck") ? "checked" : "" %>> Truck</label>
                </div>

                <!-- Capacity Filter -->
                <div class="filter-group">
                    <strong>Capacity:</strong>
                    <label><input type="checkbox" name="capacity" value="5" <%= isChecked(selectedCapacities, "5") ? "checked" : "" %>> 5 passengers</label>
                    <label><input type="checkbox" name="capacity" value="6" <%= isChecked(selectedCapacities, "6") ? "checked" : "" %>> 6 passengers</label>
                </div>

                <!-- Fuel Type Filter -->
                <div class="filter-group">
                    <strong>Fuel Type:</strong>
                    <label><input type="checkbox" name="fuelType" value="Gas" <%= isChecked(selectedFuelTypes, "Gas") ? "checked" : "" %>> Gas</label>
                    <label><input type="checkbox" name="fuelType" value="Diesel" <%= isChecked(selectedFuelTypes, "Diesel") ? "checked" : "" %>> Diesel</label>
                    <label><input type="checkbox" name="fuelType" value="Electric" <%= isChecked(selectedFuelTypes, "Electric") ? "checked" : "" %>> Electric</label>
                    <label><input type="checkbox" name="fuelType" value="Hybrid" <%= isChecked(selectedFuelTypes, "Hybrid") ? "checked" : "" %>> Hybrid</label>
                </div>

                <div class="filter-buttons">
                    <button type="submit">Apply Filters</button>
                    <a href="<%= request.getContextPath() %>/browse-cars">Clear Filters</a>
                </div>
            </form>
        </div>
        
        <!-- Main Content Section -->
        <div class="main-content">
            <!-- Cars table -->
            <% if (carList != null && !carList.isEmpty()) { %>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Brand</th>
                            <th>Model</th>
                            <th>Type</th>       
                            <th>Capacity</th>  
                            <th>Fuel Type</th> 
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
                                <td><%= car.getCarType() %></td>
                                <td><%= car.getCapacity() %></td>
                                <td><%= car.getFuelType() %></td>
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
                <p>No cars match your filter criteria.</p>
            <% } %>
            
            <hr>
            <p><a href="<%= request.getContextPath() %>/index.jsp">Back to Home</a></p>
        </div>
    </div>
</body>
</html>

