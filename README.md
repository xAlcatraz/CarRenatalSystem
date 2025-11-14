# Car Rental System: Backend & Database Milestone
CSE 3021: Internet and Web Programming
Team: Daniel E. Melendrez & Benjamin Muniz
Date: Nov 13, 2025

## Overview 
This milestone implements the backend and database components for our Car Rental System.
We are using:
- Java Servlets (Jakarta EE)
- JSP Pages
- MySQL Databases
- JDBC 
- Apache Tomcat 11
- NetBeans IDE

We included user authentication, car browsing, booking functionality, and connected the backend to our current frontend.

## How To Run
### The following must be Installed:
- MySQL Community Server + Workbench
- Apache Tomcat 11
- NetBeans 23+
- Java 17

### Database Set Up
- Open MySQL Workbech
- Run the SQL Script provided in project
- Confirm tables and sample data are created
- Create DB credentials by going to Files -> CarRentalSystem-1.0/src/main/resources/
- Copy the db.properties.sample and create a new db.properties file and pase
- Replace user with MySQL credentials, for example user=root password=MySQL password 

## TODO
- Password Hashing
- Duplicate Email Checking
- Roles (User and Admin currently all are User)
- Profile Page
- Admin Functionalities
- Booking History

## Database Schema
### Database name: 'car_rental'
Project consists of three tables 
- Users: id, name, email, password, role
- Cars: id, brand, model, price_per_day, available
- Bookings: id, user_id, car_id, start_date, end_date, total_price
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

All of our servlets do/use the following:
- JDBC
- Handle Exceptions
- Close Connections
- Pass data to JSP Pages
- Use HttpSession for login tracking

## Minimal Frontend/JSP Implementation
### User Pages:
- login.jsp
- register.jsp
- browse-cars.jsp
- book-car.jsp
- index.jsp

### Session Behavior:
- Main Menu with Browse Cars, Login, and Register Options
- Logged in user can browse cars and book cars
