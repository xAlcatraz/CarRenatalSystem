package com.carrental.servlets;

import com.carrental.util.DBConnection;
import com.carrental.model.Car;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.Duration;

@WebServlet("/book-car")
public class BookCarServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            // Not logged in - redirect to login
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get car ID from URL parameter
        String carIdStr = request.getParameter("carId");
        
        if (carIdStr == null || carIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/browse-cars");
            return;
        }
        
        int carId = Integer.parseInt(carIdStr);
        
        // Get car details from database
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Car car = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT id, brand, model, car_type, capacity, fuel_type, price_per_day, available FROM cars WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, carId);
            rs = ps.executeQuery();

            if (rs.next()) {
                car = new Car();
                car.setId(rs.getInt("id"));
                car.setBrand(rs.getString("brand"));
                car.setModel(rs.getString("model"));
                car.setCarType(rs.getString("car_type"));
                car.setCapacity(rs.getInt("capacity"));
                car.setFuelType(rs.getString("fuel_type"));
                car.setPricePerDay(rs.getDouble("price_per_day"));
                car.setAvailable(rs.getBoolean("available"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        // Check if car exists and is available
        if (car == null) {
            response.sendRedirect(request.getContextPath() + "/browse-cars");
            return;
        }
        
        if (!car.isAvailable()) {
            request.setAttribute("error", "This car is no longer available.");
            response.sendRedirect(request.getContextPath() + "/browse-cars");
            return;
        }
        
        // Store car in request and forward to booking form
        request.setAttribute("car", car);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/book-car.jsp");
        dispatcher.forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        
        // Get form data
        String carIdStr = request.getParameter("carId");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String startTimeStr = request.getParameter("startTime");
        String endTimeStr = request.getParameter("endTime");

        // Validate inputs
        if (carIdStr == null || startDateStr == null || endDateStr == null ||
            startTimeStr == null || endTimeStr == null ||
            carIdStr.isEmpty() || startDateStr.isEmpty() || endDateStr.isEmpty() ||
            startTimeStr.isEmpty() || endTimeStr.isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            doGet(request, response);
            return;
        }
        
        int carId = Integer.parseInt(carIdStr);
        
        // Parse date + time together to create LocalDateTime
        LocalDateTime startDateTime = LocalDateTime.parse(startDateStr + "T" + startTimeStr);
        LocalDateTime endDateTime = LocalDateTime.parse(endDateStr + "T" + endTimeStr);
        
        // Also parse just the times for storage
        LocalTime startTime = LocalTime.parse(startTimeStr);
        LocalTime endTime = LocalTime.parse(endTimeStr);
        
        // Validate date/times
        LocalDateTime now = LocalDateTime.now();
        if (startDateTime.isBefore(now)) {
            request.setAttribute("error", "Start date/time cannot be in the past.");
            doGet(request, response);
            return;
        }
        
        if (endDateTime.isBefore(startDateTime) || endDateTime.isEqual(startDateTime)) {
            request.setAttribute("error", "End date/time must be after start date/time.");
            doGet(request, response);
            return;
        }
        
        // Calculate total hours between start and end
        Duration duration = Duration.between(startDateTime, endDateTime);
        double totalHours = duration.toHours() + (duration.toMinutesPart() / 60.0);
        
        // Minimum 1 hour rental
        if (totalHours < 1) {
            totalHours = 1;
        }
        
        Connection conn = null;
        PreparedStatement psGetCar = null;
        PreparedStatement psInsertBooking = null;
        PreparedStatement psUpdateCar = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // Get car price and check availability
            String sqlGetCar = "SELECT price_per_day, available FROM cars WHERE id = ? FOR UPDATE";
            psGetCar = conn.prepareStatement(sqlGetCar);
            psGetCar.setInt(1, carId);
            rs = psGetCar.executeQuery();
            
            if (!rs.next()) {
                throw new SQLException("Car not found");
            }
            
            boolean available = rs.getBoolean("available");
            if (!available) {
                request.setAttribute("error", "This car is no longer available.");
                conn.rollback();
                doGet(request, response);
                return;
            }
            
            // Calculate price using hourly rate
            double pricePerDay = rs.getDouble("price_per_day");
            double pricePerHour = pricePerDay / 24.0;
            double totalPrice = totalHours * pricePerHour;
            
            // Insert booking WITH times now
            String sqlInsertBooking = "INSERT INTO bookings (user_id, car_id, start_date, start_time, end_date, end_time, total_price) VALUES (?, ?, ?, ?, ?, ?, ?)";
            psInsertBooking = conn.prepareStatement(sqlInsertBooking, Statement.RETURN_GENERATED_KEYS);
            psInsertBooking.setInt(1, userId);
            psInsertBooking.setInt(2, carId);
            psInsertBooking.setDate(3, Date.valueOf(startDateTime.toLocalDate()));
            psInsertBooking.setTime(4, Time.valueOf(startTime));  // NEW: Store start time
            psInsertBooking.setDate(5, Date.valueOf(endDateTime.toLocalDate()));
            psInsertBooking.setTime(6, Time.valueOf(endTime));    // NEW: Store end time
            psInsertBooking.setDouble(7, totalPrice);
            
            int rowsInserted = psInsertBooking.executeUpdate();
            
            if (rowsInserted == 0) {
                throw new SQLException("Failed to create booking");
            }
            
            // Get generated booking ID
            ResultSet generatedKeys = psInsertBooking.getGeneratedKeys();
            int bookingId = 0;
            if (generatedKeys.next()) {
                bookingId = generatedKeys.getInt(1);
            }
            
            // Update car availability to FALSE
            String sqlUpdateCar = "UPDATE cars SET available = FALSE WHERE id = ?";
            psUpdateCar = conn.prepareStatement(sqlUpdateCar);
            psUpdateCar.setInt(1, carId);
            psUpdateCar.executeUpdate();
            
            // Commit transaction
            conn.commit();
            
            // Redirect to confirmation page
            response.sendRedirect(request.getContextPath() + "/booking-confirmation?bookingId=" + bookingId);
            
        } catch (SQLException e) {
            // Rollback on error
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            request.setAttribute("error", "Database error: " + e.getMessage());
            e.printStackTrace();
            doGet(request, response);
            
        } finally {
            try {
                if (rs != null) rs.close();
                if (psGetCar != null) psGetCar.close();
                if (psInsertBooking != null) psInsertBooking.close();
                if (psUpdateCar != null) psUpdateCar.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}