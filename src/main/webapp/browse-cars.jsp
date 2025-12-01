<%-- 
    Document   : browse-cars
    Created on : Nov 13, 2025, 12:45:39 AM
    Author     : Benjamin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.carrental.model.Car"%>

<%
    // Session info
    String userEmail = (String) session.getAttribute("userEmail");
    String userName  = (String) session.getAttribute("userName");
    String userRole  = (String) session.getAttribute("userRole");
    boolean loggedIn = (userEmail != null);
    boolean isAdmin  = "admin".equals(userRole);

    // Data from servlet
    List<Car> carList      = (List<Car>) request.getAttribute("carList");
    String errorMessage    = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Browse Cars - B&amp;D Car Rentals</title>
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

            /* NAVBAR – same look as index.jsp */
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
                display: flex;
                padding: 24px 32px;
                gap: 24px;
            }

            .filters-card {
                width: 260px;
                background: #ffffff;
                border-radius: 12px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.08);
                padding: 18px 20px;
            }

            .filters-card h2 {
                font-size: 18px;
                margin-bottom: 12px;
                color: #2d3748;
            }

            .filter-group {
                margin-bottom: 16px;
            }

            .filter-group-title {
                font-weight: bold;
                font-size: 14px;
                margin-bottom: 6px;
                color: #4a5568;
            }

            .filter-option {
                display: flex;
                align-items: center;
                gap: 6px;
                font-size: 13px;
                color: #4a5568;
                margin-bottom: 4px;
            }

            .filter-buttons {
                margin-top: 12px;
                display: flex;
                flex-direction: column;
                gap: 8px;
            }

            /* REUSABLE BUTTON STYLE */
            .btn {
                display: inline-flex;
                justify-content: center;
                align-items: center;
                padding: 8px 14px;
                border-radius: 999px;
                font-size: 14px;
                border: 1px solid #4a5568;
                background-color: #2d3748;
                color: #e2e8f0;
                text-decoration: none;
                cursor: pointer;
                transition: background-color 0.15s ease,
                            color 0.15s ease,
                            transform 0.05s ease;
            }

            .btn:hover {
                background-color: #38a169;
                color: #fff;
                transform: translateY(-1px);
            }

            .btn-primary {
                background-color: #38a169;
                border-color: #38a169;
                color: #fff;
            }

            .btn-secondary {
                background-color: #edf2f7;
                border-color: #cbd5e0;
                color: #2d3748;
            }

            .btn-secondary:hover {
                background-color: #e2e8f0;
                color: #1a202c;
            }

            .cars-card {
                flex: 1;
                background: #ffffff;
                border-radius: 12px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.08);
                padding: 18px 20px;
                display: flex;
                flex-direction: column;
            }

            .cars-header {
                display: flex;
                justify-content: space-between;
                align-items: baseline;
                margin-bottom: 12px;
            }

            .cars-header h1 {
                font-size: 22px;
                color: #2d3748;
            }

            .cars-header span {
                font-size: 13px;
                color: #718096;
            }

            .error {
                margin-bottom: 10px;
                padding: 10px;
                border-radius: 8px;
                border: 1px solid #e53e3e;
                background-color: #fff5f5;
                color: #c53030;
                font-size: 14px;
            }

            .user-info-bar {
                margin-bottom: 10px;
                padding: 8px 10px;
                border-radius: 8px;
                background-color: #ebf8ff;
                border: 1px solid #bee3f8;
                font-size: 13px;
                color: #2b6cb0;
            }

            .empty-message {
                margin-top: 20px;
                font-size: 14px;
                color: #4a5568;
            }
            
            /* CAR CARDS */
            .cars-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
                gap: 16px;
                margin-top: 10px;
            }

            .car-card {
                background-color: #f9fafb;
                border-radius: 12px;
                box-shadow: 0 2px 6px rgba(0,0,0,0.08);
                overflow: hidden;
                display: flex;
                flex-direction: column;
                border: 1px solid #e2e8f0;
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }
            
            .car-image-wrap {
                position: relative;
                width: 100%;
                height: 150px;
                overflow: hidden;
            }

            .car-image-wrap img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .car-badge {
                position: absolute;
                top: 8px;
                left: 8px;
                padding: 4px 10px;
                border-radius: 999px;
                font-size: 11px;
                font-weight: 600;
                background-color: rgba(56, 161, 105, 0.9); 
                color: #fff;
            }

            .car-badge.unavailable {
                background-color: rgba(229, 62, 62, 0.9); 
            }

            .car-body {
                padding: 10px 12px 6px;
                flex: 1;
            }

            .car-title {
                font-size: 16px;
                font-weight: 600;
                color: #2d3748;
                margin-bottom: 4px;
            }

            .car-meta {
                font-size: 13px;
                color: #718096;
                margin-bottom: 6px;
            }

            .car-price {
                font-size: 15px;
                font-weight: 600;
                color: #2f855a;
            }

            .car-footer {
                padding: 8px 12px 12px;
                display: flex;
                justify-content: flex-end;
                align-items: center;
            }

            .car-footer .small-note {
                font-size: 12px;
                color: #a0aec0;
                margin-right: auto;
            }

            .car-footer .btn {
                padding: 6px 12px;
                font-size: 13px;
            }
            
            .car-card-link {
                display: block;
                text-decoration: none;
                color: inherit;
            }

            .car-card-link.disabled {
                pointer-events: none;
                cursor: not-allowed;
                opacity: 0.75;
            }
            
            .car-card-link:hover .car-card {
                transform: translateY(-6px) scale(1.02);
                box-shadow: 0 8px 20px rgba(0,0,0,0.15);
            }

            .car-card-link.disabled:hover .car-card {
                transform: none;
                box-shadow: 0 2px 6px rgba(0,0,0,0.08);
                cursor: not-allowed;
            }
            
            .car-card-link.disabled .car-card {
                opacity: 0.7;
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

        <!-- PAGE CONTENT -->
        <div class="page-container">

            <!-- FILTERS -->
            <div class="filters-card">
                <h2>Filters</h2>

                <!-- keep your existing filter inputs / names here -->
                <form method="get" action="<%= request.getContextPath() %>/browse-cars">

                    <div class="filter-group">
                        <div class="filter-group-title">Car Type:</div>
                        <label class="filter-option">
                            <input type="checkbox" name="type" value="Sedan"> Sedan
                        </label>
                        <label class="filter-option">
                            <input type="checkbox" name="type" value="SUV"> SUV
                        </label>
                        <label class="filter-option">
                            <input type="checkbox" name="type" value="Truck"> Truck
                        </label>
                    </div>

                    <div class="filter-group">
                        <div class="filter-group-title">Capacity:</div>
                        <label class="filter-option">
                            <input type="checkbox" name="capacity" value="5"> 5 passengers
                        </label>
                        <label class="filter-option">
                            <input type="checkbox" name="capacity" value="6"> 6 passengers
                        </label>
                    </div>

                    <div class="filter-group">
                        <div class="filter-group-title">Fuel Type:</div>
                        <label class="filter-option">
                            <input type="checkbox" name="fuel" value="Gas"> Gas
                        </label>
                        <label class="filter-option">
                            <input type="checkbox" name="fuel" value="Diesel"> Diesel
                        </label>
                        <label class="filter-option">
                            <input type="checkbox" name="fuel" value="Electric"> Electric
                        </label>
                        <label class="filter-option">
                            <input type="checkbox" name="fuel" value="Hybrid"> Hybrid
                        </label>
                    </div>

                    <div class="filter-buttons">
                        <button type="submit" class="btn btn-primary">Apply Filters</button>
                        <a href="<%= request.getContextPath() %>/browse-cars"
                           class="btn btn-secondary">Clear Filters</a>
                    </div>
                </form>
            </div>

            <!-- CARS TABLE -->
            <div class="cars-card">
                <div class="cars-header">
                    <h1>Browse Available Cars</h1>
                    <% if (carList != null) { %>
                        <span><%= carList.size() %> Available Cars</span>
                    <% } %>
                </div>

                <% if (loggedIn) { %>
                    <div class="user-info-bar">
                        Logged in as <strong><%= userEmail %></strong>
                        (Role: <%= isAdmin ? "admin" : "user" %>)
                    </div>
                <% } else { %>
                    <div class="user-info-bar">
                        Not logged in. <a href="<%= request.getContextPath() %>/login.jsp">Login</a>
                        or <a href="<%= request.getContextPath() %>/register.jsp">Register</a> to book cars.
                    </div>
                <% } %>

                <% if (errorMessage != null) { %>
                    <div class="error">
                        ERROR: <%= errorMessage %>
                    </div>
                <% } %>

                <% if (carList != null && !carList.isEmpty()) { %>
                    <div class="cars-grid">
                        <%
                            for (Car car : carList) {
                                String imgPath = (car.getImagePath() != null && !car.getImagePath().isEmpty())
                                                 ? car.getImagePath()
                                                 : "images/cars/default-car.jpg";

                                String cardHref;
                                boolean clickable = true;

                                if (loggedIn && car.isAvailable()) {
                                    cardHref = request.getContextPath() + "/book-car?carId=" + car.getId();
                                } else if (!loggedIn) {
                                    cardHref = request.getContextPath() + "/login.jsp";
                                } else {
                                    cardHref = "#";
                                    clickable = false;
                                }
                        %>
                            <a href="<%= cardHref %>"
                               class="car-card-link <%= clickable ? "" : "disabled" %>">
                                <div class="car-card <%= car.isAvailable() ? "" : "unavailable" %>">
                                    <div class="car-image-wrap">
                                        <img
                                            src="<%= request.getContextPath() + "/" + imgPath %>"
                                            alt="<%= car.getBrand() + " " + car.getModel() %>"
                                        />
                                        <span class="car-badge <%= car.isAvailable() ? "" : "unavailable" %>">
                                            <%= car.isAvailable() ? "Available" : "Unavailable" %>
                                        </span>
                                    </div>

                                    <div class="car-body">
                                        <div class="car-title">
                                            <%= car.getBrand() %> <%= car.getModel() %>
                                        </div>
                                        <div class="car-meta">
                                            <%= car.getCarType() %> ·
                                            <%= car.getCapacity() %> seats ·
                                            <%= car.getFuelType() %>
                                        </div>
                                        <div class="car-price">
                                            $<%= String.format("%.2f", car.getPricePerDay()) %> / day
                                        </div>
                                    </div>

                                    <div class="car-footer">
                                        <% if (!loggedIn) { %>
                                            <span class="small-note">Click card to login &amp; book</span>
                                        <% } else if (!car.isAvailable()) { %>
                                            <span class="small-note">Not available for booking</span>
                                        <% } else { %>
                                            <span class="small-note">Click card to book</span>
                                        <% } %>
                                    </div>
                                </div>
                            </a>
                        <% } %>
                    </div>
                <% } else { %>
                    <p class="empty-message">No cars match your filter criteria.</p>
                <% } %>
            </div>
        </div>

        <script>
            // Same dropdown behaviour as index.jsp
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
