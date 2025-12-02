# Car Rental System: Backend & Database Milestone
CSE 3021: Internet and Web Programming
Team: Daniel E. Melendrez & Benjamin Muniz
Date: Nov 13, 2025

## Overview 
This milestone implements the backend and database components for our Car Rental System.
The System Supports:
- User Authentication (registering, logging in, and logging out)
- Password Hashing using BCrypt
- Duplicate Email Validation
- Car Browsing
- Car Booking
- Session Handling
- JSP Servlet Database integration
Technologies Used:
- Java Servlets (Jakarta EE)
- JSP Pages
- MySQL Databases
- JDBC 
- Apache Tomcat 11
- NetBeans IDE
- BCrypt (password hashing)

## How To Run
### The following must be Installed:
- MySQL Community Server + Workbench
- Apache Tomcat 11
- NetBeans 23+
- Java 17

### Database Set Up
- Open MySQL Workbech
- Run the SQL Script found in the Files tab (Files -> SQL -> car_rental_schema.sql)
    - This script will automatically create the database, generate required tables, and insert samples cars.
- Configuring Databse Credentials 
    - In NetBeans open src/main/resources/dg.properties and if missing copy the sample and create db.properties
    - Update with your MySQL credentials (user and password)
- Running the Project
    - Clean Build and Run and application should start at the CarRentalSystem/ Home page

## TODO
- Role Based Access Control
    - Admin vs User Behaviors
    - Admin dashboard
    - Admin ability to add, remove, and edit cars
    - Admin View of all Bookings
- Profile Page
    - View and Edit User info
    - Reset Password
- Validation Improvements
    - Currently only a 5 character minimum is enforced 
    - Better Error Messages
- Additional Features
    - Cancel Bookings
    - Search Bar for Cars
    - Profile Picture

## Database Schema
### Database name: 'car_rental'
Project consists of three tables 
- Users:
    - id INT(PK)
    - name VARCHAR
    - email VARCHAR(unique)
    - password_hash VARCHAR
    - role ENUM('user','admin')
- Cars: 
    - id INT(PK)
    - brand VARCHAR
    - model VARCHAR
    - price_per_day DECIMAL
    - available BOOLEAN
    - image_path VARCHAR
- Bookings: 
    - id INT(PK)
    - user_id INT(FK -> users.id)
    - car_id INT(FK -> cars.id)
    - start_date DATE
    - end_date DATE
    - total_price DECIMAL

### Relationships
- user -> bookings
- car -> bookings
### SQL Script
Our SQL script can be found by going in Files under the SQL directory. SQL/car_rental_schema.sql
Running this script will generate our tables and include some sample user and cars.

## Backend Servlets
### Authentication Servlets
- RegisterServlet.java at /register allows for the creation of user accounts.
- LoginServlet.java at /login authenticates users 
- LougoutServlet.java at /logout ends user session

### Application Servlets
- BrowseCarsServlet at /browse-cars displays available cars
- BookCarServlet at /book-car books selected car and saves it into the booking table
- MyBookingsServlet at /my-bookings displays booking for that user

All of our servlets do/use the following:
- JDBC
- Handle Exceptions
- Close Connections
- Pass data to JSP Pages
- Use HttpSession for login tracking

## FrontEnd
### User Pages:
- index.jsp
- login.jsp
- register.jsp
- browse-cars.jsp
- book-car.jsp
- my-bookings.jsp


### User Session Behavior:
- Unathenticated Users must sign in in order to book a car.
- Logged in users see personalized options
- Logout clears session
- Duplicate Email shows error
- Registration redirects to login
- Login redirects to browse cars
- Booking a car redirects to confimation booking
- Confirmation redirects to receipt

## BackEnd
### Servlets Implemented
- Authentication Servlets
    - RegisterServlet: Creates a new user account, validates email, and hashes password
    - LoginServlet: Authenticates user using BCrypt and loads user session
    - LogoutServlet: invalidates current session and redirects to login
- Applications Servlets
    - BrowseCarsServlet: Displays List of available cars
    - BookCarServlet: Book a selected car, inserts into database, and marks unavailable
    - MyBookingsServlet: Displays Booking history for the current logged in user

### BackEnd Behavior:
- Password Hashing
- Duplicate Email Detection
- DAO class seperates Car rental and databse logic
- Database Handling:
    - Uses PreparedStatement preventing SQL injections
    - Connections closed using finally blocks
- Session Tracking:
    - Logged in user can book cars
- Redirect Flow:
    - Registration -> Login
    - Login -> Browse Cars
    - Browse Cars -> Booking
    - Booking -> Confirmation Page
    - Logout -> Clear Session and return to Login
