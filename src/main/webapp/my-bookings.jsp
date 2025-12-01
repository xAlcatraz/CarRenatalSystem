<%-- 
    Document   : my-bookings
    Created on : Dec 1, 2025, 4:43:06 AM
    Author     : danim
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.carrental.model.BookingInfo"%>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String userName  = (String) session.getAttribute("userName");
    String userRole  = (String) session.getAttribute("userRole");
    boolean loggedIn = (userEmail != null);
    boolean isAdmin  = "admin".equals(userRole);

    List<BookingInfo> bookings = (List<BookingInfo>) request.getAttribute("bookings");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>My Bookings - B&amp;D Car Rentals</title>
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

            /* NAVBAR (same style as other pages) */
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
            }

            .page-header {
                display: flex;
                justify-content: space-between;
                align-items: baseline;
                margin-bottom: 16px;
            }

            .page-header h1 {
                font-size: 24px;
                color: #2d3748;
            }

            .page-header span {
                font-size: 13px;
                color: #718096;
            }

            .user-info-bar {
                margin-bottom: 16px;
                padding: 8px 10px;
                border-radius: 8px;
                background-color: #ebf8ff;
                border: 1px solid #bee3f8;
                font-size: 13px;
                color: #2b6cb0;
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

            .bookings-card {
                background: #ffffff;
                border-radius: 12px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.08);
                padding: 18px 20px;
            }

            /* Booking cards */
            .bookings-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
                gap: 16px;
                margin-top: 10px;
            }

            .booking-item {
                background-color: #f9fafb;
                border-radius: 10px;
                border: 1px solid #e2e8f0;
                padding: 10px 12px;
                display: flex;
                flex-direction: column;
            }

            .booking-header {
                display: flex;
                justify-content: space-between;
                align-items: baseline;
                margin-bottom: 4px;
            }

            .booking-title {
                font-size: 15px;
                font-weight: 600;
                color: #2d3748;
            }

            .booking-ref {
                font-size: 11px;
                color: #718096;
            }

            .booking-status {
                font-size: 11px;
                font-weight: 600;
                padding: 3px 8px;
                border-radius: 999px;
            }

            .status-upcoming {
                background-color: #c6f6d5;
                color: #22543d;
            }

            .status-completed {
                background-color: #e2e8f0;
                color: #4a5568;
            }

            .booking-body {
                font-size: 13px;
                color: #4a5568;
                margin-top: 6px;
            }

            .booking-body p {
                margin: 2px 0;
            }

            .booking-footer {
                margin-top: 8px;
                display: flex;
                justify-content: space-between;
                align-items: baseline;
                font-size: 13px;
            }

            .price-label {
                font-weight: 600;
                color: #2f855a;
            }

            .empty-message {
                margin-top: 16px;
                color: #4a5568;
                font-size: 14px;
            }

            a.link {
                color: #3182ce;
                text-decoration: none;
                font-size: 13px;
            }
            a.link:hover {
                text-decoration: underline;
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
            <div class="page-header">
                <h1>My Bookings</h1>
                <% if (bookings != null) { %>
                    <span><%= bookings.size() %> booking(s)</span>
                <% } %>
            </div>

            <% if (loggedIn) { %>
                <div class="user-info-bar">
                    Viewing bookings for <strong><%= userEmail %></strong>
                    (Role: <%= isAdmin ? "admin" : "user" %>)
                </div>
            <% } %>

            <% if (errorMessage != null) { %>
                <div class="error">
                    <%= errorMessage %>
                </div>
            <% } %>

            <div class="bookings-card">
                <% if (bookings != null && !bookings.isEmpty()) { %>
                    <div class="bookings-grid">
                        <% for (BookingInfo b : bookings) { 
                               String ref = String.format("BK-%05d", b.getId());
                               boolean isCompleted = "Completed".equalsIgnoreCase(b.getStatus());
                        %>
                            <div class="booking-item">
                                <div class="booking-header">
                                    <div>
                                        <div class="booking-title">
                                            <%= b.getBrand() %> <%= b.getModel() %>
                                        </div>
                                        <div class="booking-ref">
                                            Ref: <%= ref %>
                                        </div>
                                    </div>
                                    <div class="booking-status <%= isCompleted ? "status-completed" : "status-upcoming" %>">
                                        <%= b.getStatus() %>
                                    </div>
                                </div>

                                <div class="booking-body">
                                    <p><strong>Type:</strong> <%= b.getCarType() %> · <%= b.getCapacity() %> seats · <%= b.getFuelType() %></p>
                                    <p><strong>Start:</strong> <%= b.getStartDate() %> at <%= b.getStartTime() %></p>
                                    <p><strong>End:</strong> <%= b.getEndDate() %> at <%= b.getEndTime() %></p>
                                </div>

                                <div class="booking-footer">
                                    <div>
                                        <div class="price-label">
                                            $<%= String.format("%.2f", b.getTotalPrice()) %>
                                        </div>
                                        <div style="font-size: 12px; color:#718096;">
                                            ($<%= String.format("%.2f", b.getPricePerDay()) %> / day)
                                        </div>
                                    </div>
                                    <a class="link" href="<%= request.getContextPath() %>/booking-confirmation?bookingId=<%= b.getId() %>">
                                        View details
                                    </a>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <p class="empty-message">
                        You don't have any bookings yet.
                        <a class="link" href="<%= request.getContextPath() %>/browse-cars">Browse cars</a>
                        to make your first booking.
                    </p>
                <% } %>
            </div>
        </div>

        <script>
            // Dropdown behavior (same as other pages)
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
