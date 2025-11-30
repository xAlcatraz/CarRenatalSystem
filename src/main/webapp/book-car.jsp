<%-- 
    Document   : book-car
    Created on : Nov 13, 2025, 1:19:18 AM
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
            color: #333;
        }
        .car-details {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
            margin-top: 15px;
        }
        .car-details p {
            margin: 5px 0;
        }
        form {
            max-width: 800px;
        }
        .booking-container {
            display: flex;
            gap: 30px;
        }
        .dates-times-section {
            flex: 1;
        }
        .price-summary {
            width: 250px;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            padding: 15px;
            height: fit-content;
            position: sticky;
            top: 20px;
        }
        .price-summary h3 {
            margin-top: 0;
            color: #333;
            font-size: 1.2em;
        }
        .price-line {
            display: flex;
            justify-content: space-between;
            margin: 10px 0;
            padding: 5px 0;
        }
        .price-line.total {
            border-top: 2px solid #333;
            padding-top: 10px;
            margin-top: 15px;
            font-weight: bold;
            font-size: 1.1em;
        }
        .duration-display {
            color: #666;
            font-size: 0.9em;
            margin: 5px 0;
        }
        .date-time-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        .date-time-group {
            flex: 1;
        }
        label {
            display: block;
            margin: 15px 0 5px 0;
            font-weight: bold;
        }
        input[type="date"],
        input[type="time"] {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            font-size: 14px;
            box-sizing: border-box;
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
        double pricePerDay = car.getPricePerDay();
    %>
    <h1>Book Your Car</h1>
    
    <!-- Car Information with All Details -->
    <div class="car-info">
        <h2><%= car.getBrand() %> <%= car.getModel() %></h2>
        <div class="car-details">
            <p><strong>Car ID:</strong> <%= car.getId() %></p>
            <p><strong>Type:</strong> <%= car.getCarType() %></p>
            <p><strong>Capacity:</strong> <%= car.getCapacity() %> passengers</p>
            <p><strong>Fuel Type:</strong> <%= car.getFuelType() %></p>
            <p><strong>Price per Day:</strong> $<%= String.format("%.2f", car.getPricePerDay()) %></p>
            <p><strong>Status:</strong> Available</p>
        </div>
    </div>
    
    <!-- Error Message -->
    <% if (error != null) { %>
        <div class="error">
            ERROR: <%= error %>
        </div>
    <% } %>
    
    <!-- Booking Form -->
    <h2>Select Rental Dates and Times</h2>
    
    <div class="note">
        <strong>Note:</strong> The car will be marked as unavailable once you complete the booking. Price is calculated at $<%= String.format("%.2f", pricePerDay / 24) %> per hour.
    </div>
    
    <form method="POST" action="<%= request.getContextPath() %>/book-car">
        <input type="hidden" name="carId" value="<%= car.getId() %>">
        
        <div class="booking-container">
            <!-- Dates and Times Section -->
            <div class="dates-times-section">
                <!-- Start Date and Time -->
                <div class="date-time-row">
                    <div class="date-time-group">
                        <label for="startDate">Start Date:</label>
                        <input type="date" id="startDate" name="startDate" min="<%= minDate %>" required>
                    </div>
                    <div class="date-time-group">
                        <label for="startTime">Start Time:</label>
                        <input type="time" id="startTime" name="startTime" value="09:00" required>
                    </div>
                </div>
                
                <!-- End Date and Time -->
                <div class="date-time-row">
                    <div class="date-time-group">
                        <label for="endDate">End Date:</label>
                        <input type="date" id="endDate" name="endDate" min="<%= minDate %>" required>
                    </div>
                    <div class="date-time-group">
                        <label for="endTime">End Time:</label>
                        <input type="time" id="endTime" name="endTime" value="09:00" required>
                    </div>
                </div>
                
                <button type="submit">Confirm Booking</button>
            </div>
            
            <!-- Price Summary Section -->
            <div class="price-summary">
                <h3>Price Summary</h3>
                <div class="duration-display">
                    <strong>Duration:</strong>
                    <div id="durationText">Select dates to calculate</div>
                </div>
                <div class="price-line">
                    <span>Price per Day:</span>
                    <span>$<%= String.format("%.2f", pricePerDay) %></span>
                </div>
                <div class="price-line">
                    <span>Total Hours:</span>
                    <span id="totalHours">0</span>
                </div>
                <div class="price-line total">
                    <span>Estimated Total:</span>
                    <span id="totalPrice">$0.00</span>
                </div>
            </div>
        </div>
    </form>
    
    <hr>
    <p><a href="<%= request.getContextPath() %>/browse-cars">Back to Browse Cars</a></p>
    
    <script>
        // Store the price per day from server
        const pricePerDay = <%= pricePerDay %>;
        const pricePerHour = pricePerDay / 24;
        
        // Get all date/time input elements
        const startDateInput = document.getElementById('startDate');
        const startTimeInput = document.getElementById('startTime');
        const endDateInput = document.getElementById('endDate');
        const endTimeInput = document.getElementById('endTime');
        
        // Get display elements
        const durationText = document.getElementById('durationText');
        const totalHoursDisplay = document.getElementById('totalHours');
        const totalPriceDisplay = document.getElementById('totalPrice');
        
        // Function to calculate price
        function calculatePrice() {
            // Get values
            const startDate = startDateInput.value;
            const startTime = startTimeInput.value;
            const endDate = endDateInput.value;
            const endTime = endTimeInput.value;
            
            // Check if all fields are filled
            if (!startDate || !startTime || !endDate || !endTime) {
                durationText.textContent = 'Select dates to calculate';
                totalHoursDisplay.textContent = '0';
                totalPriceDisplay.textContent = '$0.00';
                return;
            }
            
            // Create datetime objects
            const startDateTime = new Date(startDate + 'T' + startTime);
            const endDateTime = new Date(endDate + 'T' + endTime);
            
            // Calculate difference in milliseconds
            const diffMs = endDateTime - startDateTime;
            
            // Check if end is before start
            if (diffMs <= 0) {
                durationText.textContent = 'End must be after start';
                totalHoursDisplay.textContent = '0';
                totalPriceDisplay.textContent = '$0.00';
                return;
            }
            
            // Convert to hours
            const totalHours = diffMs / (1000 * 60 * 60);
            
            // Calculate days and remaining hours
            const days = Math.floor(totalHours / 24);
            const hours = Math.floor(totalHours % 24);
            const minutes = Math.floor((totalHours % 1) * 60);
            
            // Build duration text
            let duration = '';
            if (days > 0) duration += days + ' day' + (days > 1 ? 's' : '');
            if (hours > 0) duration += (duration ? ', ' : '') + hours + ' hour' + (hours > 1 ? 's' : '');
            if (minutes > 0 && days === 0) duration += (duration ? ', ' : '') + minutes + ' min';
            
            // Calculate total price (hourly rate)
            const totalPrice = totalHours * pricePerHour;
            
            // Update display
            durationText.textContent = duration || 'Less than 1 hour';
            totalHoursDisplay.textContent = totalHours.toFixed(1);
            totalPriceDisplay.textContent = '$' + totalPrice.toFixed(2);
        }
        
        // Add event listeners to all inputs
        startDateInput.addEventListener('change', calculatePrice);
        startTimeInput.addEventListener('change', calculatePrice);
        endDateInput.addEventListener('change', calculatePrice);
        endTimeInput.addEventListener('change', calculatePrice);
        
        // Also trigger on input for real-time updates
        startDateInput.addEventListener('input', calculatePrice);
        startTimeInput.addEventListener('input', calculatePrice);
        endDateInput.addEventListener('input', calculatePrice);
        endTimeInput.addEventListener('input', calculatePrice);
    </script>
</body>
</html>
