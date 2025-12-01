<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String userName  = (String) session.getAttribute("userName");
    String userRole  = (String) session.getAttribute("userRole");
    boolean loggedIn = (userEmail != null);
    boolean isAdmin  = "admin".equals(userRole);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Car Rental System - Home</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: Arial, sans-serif;
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

            .user-button span.caret {
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
                justify-content: center;
                align-items: center;          
                padding: 48px 24px 24px;
            }

            /* HERO CARD*/
            .hero-card {
                background: #2d3748;
                padding: 40px 50px;
                border-radius: 14px;
                max-width: 600px;
                width: 100%;
                text-align: center;
                box-shadow: 0 10px 25px rgba(0,0,0,0.25);
                border-top: 4px solid #2f855a;
            }

            .hero-title {
                font-size: 28px;
                margin-bottom: 12px;
                color: #e2e8f0;         
            }

            .hero-subtitle {
                font-size: 15px;
                color: #cbd5e0;
                margin-bottom: 28px;
                line-height: 1.5;
            }

            .hero-buttons {
                display: flex;
                flex-direction: column;
                gap: 12px;
                margin: 25px 0;
            }
            
            .hero-buttons .side-by-side {
                display: flex;
                gap: 12px;           
            }
            
            /* NOTE TEXT */
            .hero-note {
                color: #cbd5e0;
                font-size: 13px;
                margin-top: 6px;
            }
            .hero-note strong {
                color: #fff;
            }
            
            /* BUTTONS */
            .btn {
                display: inline-flex;
                justify-content: center;
                align-items: center;
                padding: 10px 18px;
                border-radius: 999px;          
                background-color: #2d3748;
                border: 1px solid #4a5568;
                color: #e2e8f0;
                font-size: 14px;
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
                color: #fff;
                border-color: #38a169;
            }

            .btn-primary:hover {
                background-color: #2f855a;
            }

            .btn-secondary {
                background-color: #2d3748;
                border-color: #4a5568;
                color: #e2e8f0;
            }
            
            .btn-full {
                width: 100%;
                justify-content: center;
            }
            
            .btn-half {
                flex: 1;            
                justify-content: center;
            }
        </style>
    </head>
    <script>
        // Toggle user dropdown on click
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

          // Close when clicking anywhere else
          document.addEventListener('click', function () {
            userMenu.classList.remove('open');
          });

          // Don't close when clicking inside the dropdown
          dropdown.addEventListener('click', function (e) {
            e.stopPropagation();
          });
        });
    </script>
    <body>
        <!-- NAVBAR -->
        <div class="navbar">
            <div class="nav-left">
                <a href="<%= request.getContextPath() %>/index.jsp"
                   class="nav-pill nav-brand">
                    B&D Car Rentals
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
            <div class="hero-card">
                <h1 class="hero-title">Welcome to B&D Car Rentals</h1>
                <p class="hero-subtitle">
                    Browse available cars, book rentals in minutes, and keep track of your booking history.
                </p>

                <div class="hero-buttons">
                    <a href="<%= request.getContextPath() %>/browse-cars" class="btn btn-primary btn-full">
                        Browse Available Cars
                    </a>

                    <% if (!loggedIn) { %>
                        <div class="side-by-side">
                            <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-secondary btn-half">
                                Login
                            </a>
                            <a href="<%= request.getContextPath() %>/register.jsp" class="btn btn-secondary btn-half">
                                Create Account
                            </a>
                        </div>
                    <% } else { %>
                        <a href="<%= request.getContextPath() %>/my-bookings" class="btn btn-secondary btn-full">
                            View My Bookings
                        </a>
                    <% } %>
                </div>

                <p class="hero-note">
                    <strong>NOTE:</strong> You can browse cars without logging in.<br> An account is required to complete a booking.
                </p>
            </div>
        </div>
    </body>
</html>