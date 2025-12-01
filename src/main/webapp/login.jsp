<%-- 
    Document   : login
    Created on : Nov 12, 2025, 8:07:32 PM
    Author     : danim
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String error   = request.getParameter("error");
    String message = request.getParameter("message");

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
        <title>Login - B&amp;D Car Rentals</title>
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

            /* NAVBAR (same vibe as index.jsp) */
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
                justify-content: center;
                align-items: center;
                padding: 32px 16px;
            }

            .auth-card {
                background: #2d3748;
                padding: 32px 36px;
                border-radius: 14px;
                max-width: 420px;
                width: 100%;
                box-shadow: 0 10px 25px rgba(0,0,0,0.25);
                border-top: 4px solid #2f855a;
                color: #e2e8f0;
            }

            .auth-title {
                font-size: 24px;
                margin-bottom: 6px;
                text-align: center;
            }

            .auth-subtitle {
                font-size: 14px;
                color: #cbd5e0;
                margin-bottom: 18px;
                text-align: center;
            }

            .form-group {
                margin-bottom: 16px;
            }

            label {
                display: block;
                margin-bottom: 6px;
                font-weight: 600;
                color: #e2e8f0;
                font-size: 14px;
            }

            input[type="email"],
            input[type="password"] {
                width: 100%;
                padding: 10px;
                border-radius: 8px;
                border: 1px solid #4a5568;
                font-size: 14px;
                background-color: #1a202c;
                color: #e2e8f0;
            }

            input[type="email"]::placeholder,
            input[type="password"]::placeholder {
                color: #a0aec0;
            }

            .btn {
                display: inline-flex;
                justify-content: center;
                align-items: center;
                padding: 10px 18px;
                border-radius: 999px;
                border: 1px solid #4a5568;
                background-color: #2d3748;
                color: #e2e8f0;
                font-size: 14px;
                text-decoration: none;
                cursor: pointer;
                width: 100%;
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
            }

            .links {
                margin-top: 18px;
                font-size: 13px;
                text-align: center;
                color: #cbd5e0;
            }

            .links a {
                color: #63b3ed;
                text-decoration: underline;
            }

            .error {
                margin-bottom: 16px;
                padding: 10px;
                border-radius: 8px;
                border: 1px solid #e53e3e;
                background-color: #fff5f5;
                color: #c53030;
                font-size: 14px;
            }

            .success {
                margin-bottom: 16px;
                padding: 10px;
                border-radius: 8px;
                border: 1px solid #38a169;
                background-color: #e6fffa;
                color: #276749;
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
            <div class="auth-card">
                <h1 class="auth-title">Login</h1>
                <p class="auth-subtitle">
                    Sign in to manage your bookings with B&amp;D Car Rentals.
                </p>

                <% if (error != null) { %>
                    <div class="error">
                        Invalid email or password. Please try again.
                    </div>
                <% } %>

                <% if (message != null) { %>
                    <div class="success">
                        <%= message %>
                    </div>
                <% } %>

                <form method="post" action="<%= request.getContextPath() %>/login">
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input id="email" name="email" type="email" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input id="password" name="password" type="password" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Login</button>
                </form>

                <div class="links">
                    <p>
                        Don’t have an account?
                        <a href="<%= request.getContextPath() %>/register.jsp">Create one</a>
                    </p>
                    <p>
                        <a href="<%= request.getContextPath() %>/index.jsp">Back to Home</a>
                    </p>
                </div>
            </div>
        </div>

        <script>
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

