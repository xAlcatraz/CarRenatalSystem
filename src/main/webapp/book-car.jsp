<%-- 
    Document   : book-car
    Created on : Nov 13, 2025, 1:19:18 AM
    Author     : Benjamin
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.carrental.model.Car"%>
<%@page import="java.time.LocalDate"%>

<%
    Car car   = (Car) request.getAttribute("car");
    String error = (String) request.getAttribute("error");

    if (car == null) {
        response.sendRedirect(request.getContextPath() + "/browse-cars");
        return;
    }

    // Session info for navbar
    String userEmail = (String) session.getAttribute("userEmail");
    String userName  = (String) session.getAttribute("userName");
    String userRole  = (String) session.getAttribute("userRole");
    boolean loggedIn = (userEmail != null);
    boolean isAdmin  = "admin".equals(userRole);

    // Get today's date for min date validation
    LocalDate today = LocalDate.now();
    String minDate = today.toString();
    double pricePerDay = car.getPricePerDay();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Book Car - B&amp;D Car Rentals</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: Arial, sans-serif;
                background-color: #f5f5f5;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            /* NAVBAR */
            .navbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 12px 32px;
                background-color: #1f2933;
                color: #fff;
                min-height: 64px;
            }

            .nav-left,
            .nav-right {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .nav-pill {
                display: inline-flex;
                align-items: center;
                padding: 8px 16px;
                border-radius: 999px;
                background-color: #2d3748;
                color: #e2e8f0;
                text-decoration: none;
                font-size: 14px;
                border: 1px solid #4a5568;
                transition: background-color 0.15s ease, color 0.15s ease,
                            transform 0.05s ease;
            }

            .nav-pill:hover {
                background-color: #38a169;
                color: #fff;
                transform: translateY(-1px);
            }

            .nav-brand {
                font-weight: bold;
                font-size: 16px;
                background-color: #2f855a;
            }

            .user-menu {
                position: relative;
                display: inline-block;
            }

            .user-button {
                display: inline-flex;
                align-items: center;
                padding: 8px 16px;
                border-radius: 999px;
                background-color: #2d3748;
                color: #e2e8f0;
                border: 1px solid #4a5568;
                cursor: pointer;
                font-size: 14px;
            }

            .user-button:hover {
                background-color: #38a169;
                color: #fff;
            }

            .user-button .caret {
                margin-left: 6px;
                font-size: 10px;
            }

            .user-dropdown {
                display: none;
                position: absolute;
                right: 0;
                margin-top: 6px;
                background: #fff;
                color: #333;
                min-width: 170px;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.25);
                z-index: 10;
                overflow: hidden;
            }

            .dropdown-item {
                display: block;
                padding: 8px 12px;
                color: #333;
                text-decoration: none;
                font-size: 14px;
            }

            .dropdown-item:hover {
                background-color: #f0f0f0;
            }

            .user-menu.open .user-dropdown {
                display: block;
            }

            /* PAGE LAYOUT */
            .page-container {
                flex: 1;
                padding: 24px 32px;
                display: flex;
                justify-content: center;
                align-items: flex-start;
            }

            .book-card {
                background: #ffffff;
                border-radius: 14px;
                box-shadow: 0 8px 20px rgba(0,0,0,0.12);
                padding: 22px 26px;
                max-width: 980px;
                width: 100%;
                border-top: 4px solid #2f855a;
            }

            .book-header {
                display: flex;
                justify-content: space-between;
                align-items: baseline;
                margin-bottom: 16px;
            }

            .book-title {
                font-size: 22px;
                color: #2d3748;
            }

            .book-subtitle {
                font-size: 14px;
                color: #718096;
            }

            .car-info {
                margin-top: 12px;
                margin-bottom: 18px;
                padding: 14px 16px;
                border-radius: 10px;
                background-color: #f7fafc;
                border: 1px solid #e2e8f0;
            }

            .car-name {
                font-size: 18px;
                font-weight: 600;
                color: #2d3748;
                margin-bottom: 8px;
            }

            .car-details {
                display: grid;
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 4px 16px;
                font-size: 14px;
                color: #4a5568;
            }

            .car-details p {
                margin: 2px 0;
            }

            .badge-available {
                display: inline-flex;
                align-items: center;
                padding: 3px 10px;
                border-radius: 999px;
                background-color: #c6f6d5;
                color: #22543d;
                font-size: 11px;
                font-weight: 600;
                margin-left: 8px;
            }

            .booking-layout {
                display: flex;
                gap: 28px;
                margin-top: 10px;
            }

            .dates-times-section {
                flex: 1;
            }

            .section-title {
                font-size: 16px;
                font-weight: 600;
                color: #2d3748;
                margin-bottom: 8px;
            }

            .note {
                background-color: #fefcbf;
                border: 1px solid #faf089;
                color: #744210;
                padding: 10px 12px;
                border-radius: 8px;
                font-size: 13px;
                margin-bottom: 16px;
            }

            .date-time-row {
                display: flex;
                gap: 16px;
                margin-bottom: 18px;
            }

            .date-time-group {
                flex: 1;
            }

            label {
                display: block;
                margin-bottom: 6px;
                font-weight: 600;
                font-size: 13px;
                color: #4a5568;
            }

            input[type="date"],
            input[type="time"] {
                width: 100%;
                padding: 8px 10px;
                border-radius: 8px;
                border: 1px solid #cbd5e0;
                font-size: 14px;
                box-sizing: border-box;
            }

            .btn {
                display: inline-flex;
                justify-content: center;
                align-items: center;
                padding: 10px 18px;
                border-radius: 999px;
                border: 1px solid #38a169;
                background-color: #38a169;
                color: #fff;
                font-size: 15px;
                cursor: pointer;
                text-decoration: none;
                transition: background-color 0.15s ease,
                            transform 0.05s ease;
            }

            .btn:hover {
                background-color: #2f855a;
                transform: translateY(-1px);
            }

            .btn-secondary-link {
                margin-top: 14px;
                font-size: 13px;
            }

            .btn-secondary-link a {
                color: #3182ce;
                text-decoration: underline;
            }

            .price-summary {
                width: 260px;
                background-color: #f7fafc;
                border: 1px solid #e2e8f0;
                border-radius: 10px;
                padding: 14px 16px;
                height: fit-content;
                position: sticky;
                top: 20px;
                font-size: 14px;
            }

            .price-summary h3 {
                margin-top: 0;
                margin-bottom: 8px;
                color: #2d3748;
                font-size: 16px;
            }

            .duration-display {
                margin-bottom: 10px;
                font-size: 13px;
                color: #4a5568;
            }

            .price-line {
                display: flex;
                justify-content: space-between;
                margin: 6px 0;
                padding: 4px 0;
                color: #4a5568;
            }

            .price-line.total {
                border-top: 2px solid #2d3748;
                padding-top: 10px;
                margin-top: 10px;
                font-weight: 600;
                font-size: 15px;
                color: #2d3748;
            }

            .error {
                margin-top: 10px;
                margin-bottom: 10px;
                padding: 10px;
                border-radius: 8px;
                border: 1px solid #e53e3e;
                background-color: #fff5f5;
                color: #c53030;
                font-size: 14px;
            }
        </style>
    </head>
    <body>
        <!-- NAVBAR -->
        <div class="navbar">
            <div class="nav-left">
                <a href="<%= request.getContextPath() %>/index.jsp"
                   class="nav-pill nav-brand">
                    B&amp;D Car Rentals
                </a>
                <a href="<%= request.getContextPath() %>/index.jsp"
                   class="nav-pill">
                    Home
                </a>
                <a href="<%= request.getContextPath() %>/browse-cars"
                   class="nav-pill">
                    Browse Cars
                </a>
            </div>

            <div class="nav-right">
                <% if (!loggedIn) { %>
                    <a href="<%= request.getContextPath() %>/login.jsp"
                       class="nav-pill">
                        Login
                    </a>
                    <a href="<%= request.getContextPath() %>/register.jsp"
                       class="nav-pill">
                        Register
                    </a>
                <% } else { %>
                    <div class="user-menu">
                        <button class="user-button">
                            <span>
                                <%= (userName != null && !userName.isEmpty())
                                     ? userName : userEmail %>
                                <% if (isAdmin) { %> (admin) <% } %>
                            </span>
                            <span class="caret">▼</span>
                        </button>
                        <div class="user-dropdown">
                            <a href="<%= request.getContextPath() %>/my-bookings"
                               class="dropdown-item">
                                My Bookings
                            </a>
                            <% if (isAdmin) { %>
                                <a href="<%= request.getContextPath() %>/admin/cars"
                                   class="dropdown-item">
                                    Admin Dashboard
                                </a>
                            <% } %>
                            <a href="<%= request.getContextPath() %>/logout"
                               class="dropdown-item">
                                Logout
                            </a>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- MAIN CONTENT -->
        <div class="page-container">
            <div class="book-card">
                <div class="book-header">
                    <div>
                        <div class="book-title">Book Your Car</div>
                        <div class="book-subtitle">
                            Complete your rental details for this vehicle.
                        </div>
                    </div>
                </div>

                <div class="car-info">
                    <div class="car-name">
                        <%= car.getBrand() %> <%= car.getModel() %>
                        <span class="badge-available">Available</span>
                    </div>
                    <div class="car-details">
                        <p><strong>Type:</strong> <%= car.getCarType() %></p>
                        <p><strong>Capacity:</strong> <%= car.getCapacity() %> passengers</p>
                        <p><strong>Fuel Type:</strong> <%= car.getFuelType() %></p>
                        <p><strong>Price per Day:</strong> $<%= String.format("%.2f", car.getPricePerDay()) %></p>
                    </div>
                </div>

                <% if (error != null) { %>
                    <div class="error">
                        ERROR: <%= error %>
                    </div>
                <% } %>

                <form method="POST" action="<%= request.getContextPath() %>/book-car">
                    <input type="hidden" name="carId" value="<%= car.getId() %>">

                    <div class="booking-layout">
                        <!-- Dates / Times -->
                        <div class="dates-times-section">
                            <div class="section-title">Select Rental Dates and Times</div>

                            <div class="note">
                                <strong>Note:</strong>
                                Price is calculated at 
                                $<%= String.format("%.2f", pricePerDay / 24) %> per hour.
                            </div>

                            <div class="date-time-row">
                                <div class="date-time-group">
                                    <label for="startDate">Start Date</label>
                                    <input type="date" id="startDate" name="startDate"
                                           min="<%= minDate %>" required>
                                </div>
                                <div class="date-time-group">
                                    <label for="startTime">Start Time</label>
                                    <input type="time" id="startTime" name="startTime"
                                           value="09:00" required>
                                </div>
                            </div>

                            <div class="date-time-row">
                                <div class="date-time-group">
                                    <label for="endDate">End Date</label>
                                    <input type="date" id="endDate" name="endDate"
                                           min="<%= minDate %>" required>
                                </div>
                                <div class="date-time-group">
                                    <label for="endTime">End Time</label>
                                    <input type="time" id="endTime" name="endTime"
                                           value="09:00" required>
                                </div>
                            </div>

                            <button type="submit" class="btn">Confirm Booking</button>

                            <div class="btn-secondary-link">
                                <a href="<%= request.getContextPath() %>/browse-cars">
                                    &larr; Back to Browse Cars
                                </a>
                            </div>
                        </div>

                        <!-- Price Summary -->
                        <div class="price-summary">
                            <h3>Price Summary</h3>
                            <div class="duration-display">
                                <strong>Duration:</strong><br>
                                <span id="durationText">Select dates to calculate</span>
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
            </div>
        </div>

        <script>
            const pricePerDay = <%= pricePerDay %>;
            const pricePerHour = pricePerDay / 24;

            const startDateInput = document.getElementById('startDate');
            const startTimeInput = document.getElementById('startTime');
            const endDateInput   = document.getElementById('endDate');
            const endTimeInput   = document.getElementById('endTime');

            const durationText      = document.getElementById('durationText');
            const totalHoursDisplay = document.getElementById('totalHours');
            const totalPriceDisplay = document.getElementById('totalPrice');

            function calculatePrice() {
                const startDate = startDateInput.value;
                const startTime = startTimeInput.value;
                const endDate   = endDateInput.value;
                const endTime   = endTimeInput.value;

                if (!startDate || !startTime || !endDate || !endTime) {
                    durationText.textContent = 'Select dates to calculate';
                    totalHoursDisplay.textContent = '0';
                    totalPriceDisplay.textContent = '$0.00';
                    return;
                }

                const startDateTime = new Date(startDate + 'T' + startTime);
                const endDateTime   = new Date(endDate + 'T' + endTime);
                const diffMs = endDateTime - startDateTime;

                if (diffMs <= 0) {
                    durationText.textContent = 'End must be after start';
                    totalHoursDisplay.textContent = '0';
                    totalPriceDisplay.textContent = '$0.00';
                    return;
                }

                const totalHours = diffMs / (1000 * 60 * 60);
                const days   = Math.floor(totalHours / 24);
                const hours  = Math.floor(totalHours % 24);
                const minutes = Math.floor((totalHours % 1) * 60);

                let duration = '';
                if (days > 0) duration += days + ' day' + (days > 1 ? 's' : '');
                if (hours > 0) duration += (duration ? ', ' : '') + hours + ' hour' + (hours > 1 ? 's' : '');
                if (minutes > 0 && days === 0) duration += (duration ? ', ' : '') + minutes + ' min';

                const totalPrice = totalHours * pricePerHour;

                durationText.textContent = duration || 'Less than 1 hour';
                totalHoursDisplay.textContent = totalHours.toFixed(1);
                totalPriceDisplay.textContent = '$' + totalPrice.toFixed(2);
            }

            ['change', 'input'].forEach(eventType => {
                startDateInput.addEventListener(eventType, calculatePrice);
                startTimeInput.addEventListener(eventType, calculatePrice);
                endDateInput.addEventListener(eventType, calculatePrice);
                endTimeInput.addEventListener(eventType, calculatePrice);
            });

            document.addEventListener('DOMContentLoaded', function () {
                var userMenu = document.querySelector('.user-menu');
                if (!userMenu) return;

                var button = userMenu.querySelector('.user-button');
                var dropdown = userMenu.querySelector('.user-dropdown');

                if (!button || !dropdown) return;

                button.addEventListener('click', function (e) {
                    e.preventDefault();
                    e.stopPropagation();
                    userMenu.classList.toggle('open');
                });

                document.addEventListener('click', function () {
                    userMenu.classList.remove('open');
                });

                dropdown.addEventListener('click', function (e) {
                    e.stopPropagation();
                });
            });
        </script>
    </body>
</html>
