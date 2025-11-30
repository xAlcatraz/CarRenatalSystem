package com.carrental.servlets;

import com.carrental.util.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/booking-confirmation")
public class BookingConfirmationServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get user info from session
        String userEmail = (String) session.getAttribute("userEmail");
        
        String bookingIdStr = request.getParameter("bookingId");
        
        if (bookingIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/browse-cars");
            return;
        }
        
        int bookingId = Integer.parseInt(bookingIdStr);
        
        // Get booking details
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("    <title>Booking Confirmation</title>");
        out.println("    <style>");
        out.println("        body { font-family: Arial, sans-serif; margin: 20px; background-color: white; }");
        out.println("        h1 { color: #333; }");
        out.println("        .success { background-color: #d4edda; border: 1px solid #c3e6cb; padding: 20px; margin: 20px 0; }");
        out.println("        .success h2 { margin: 0; color: #155724; }");
        out.println("        .details { background-color: #f9f9f9; border: 1px solid #ddd; padding: 15px; margin: 20px 0; }");
        out.println("        .details h3 { margin-top: 0; color: #333; }");
        out.println("        .info-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; margin-top: 15px; }");
        out.println("        .info-item { margin: 5px 0; }");
        out.println("        .info-item strong { color: #555; }");
        out.println("        .booking-ref { font-size: 1.2em; color: #007bff; font-weight: bold; }");
        out.println("        .price-breakdown { background-color: #fff; border: 1px solid #ddd; padding: 15px; margin: 20px 0; }");
        out.println("        .price-line { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #eee; }");
        out.println("        .price-line.total { border-top: 2px solid #333; border-bottom: none; font-weight: bold; font-size: 1.1em; margin-top: 10px; padding-top: 10px; }");
        out.println("        a { color: blue; text-decoration: underline; }");
        out.println("        .user-info { background-color: #e7f3ff; border: 1px solid #b3d9ff; padding: 10px; margin: 20px 0; }");
        out.println("    </style>");
        out.println("</head>");
        out.println("<body>");
        
        try {
            conn = DBConnection.getConnection();
            // NOW includes start_time and end_time
            String sql = "SELECT b.id, b.start_date, b.start_time, b.end_date, b.end_time, b.total_price, " +
                        "c.brand, c.model, c.car_type, c.capacity, c.fuel_type, c.price_per_day " +
                        "FROM bookings b " +
                        "JOIN cars c ON b.car_id = c.id " +
                        "WHERE b.id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, bookingId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                // Get data
                int id = rs.getInt("id");
                String brand = rs.getString("brand");
                String model = rs.getString("model");
                String carType = rs.getString("car_type");
                int capacity = rs.getInt("capacity");
                String fuelType = rs.getString("fuel_type");
                Date startDate = rs.getDate("start_date");
                Time startTimeSQL = rs.getTime("start_time");  // NEW
                Date endDate = rs.getDate("end_date");
                Time endTimeSQL = rs.getTime("end_time");      // NEW
                double pricePerDay = rs.getDouble("price_per_day");
                double totalPrice = rs.getDouble("total_price");
                
                // Convert SQL Time to LocalTime for formatting
                LocalTime startTime = startTimeSQL.toLocalTime();
                LocalTime endTime = endTimeSQL.toLocalTime();
                DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("hh:mm a");
                
                // Calculate hours from total price and daily rate
                double pricePerHour = pricePerDay / 24.0;
                double totalHours = totalPrice / pricePerHour;
                
                // Calculate days and hours
                int days = (int) (totalHours / 24);
                int hours = (int) (totalHours % 24);
                
                // Format booking reference
                String bookingReference = String.format("BK-%05d", id);
                
                out.println("<h1>Booking Confirmed!</h1>");
                
                // User info
                if (userEmail != null) {
                    out.println("<div class='user-info'>");
                    out.println("    <p><strong>Confirmation sent to:</strong> " + userEmail + "</p>");
                    out.println("</div>");
                }
                
                // Success message
                out.println("<div class='success'>");
                out.println("    <h2>✓ Your booking has been successfully created!</h2>");
                out.println("</div>");
                
                // Booking details
                out.println("<div class='details'>");
                out.println("    <h3>Booking Details</h3>");
                out.println("    <div class='info-grid'>");
                out.println("        <div class='info-item'><strong>Booking Reference:</strong> <span class='booking-ref'>" + bookingReference + "</span></div>");
                out.println("        <div class='info-item'><strong>Car:</strong> " + brand + " " + model + "</div>");
                out.println("        <div class='info-item'><strong>Type:</strong> " + carType + "</div>");
                out.println("        <div class='info-item'><strong>Capacity:</strong> " + capacity + " passengers</div>");
                out.println("        <div class='info-item'><strong>Fuel Type:</strong> " + fuelType + "</div>");
                out.println("        <div class='info-item'><strong>Start:</strong> " + startDate + " at " + startTime.format(timeFormatter) + "</div>");
                out.println("        <div class='info-item'><strong>End:</strong> " + endDate + " at " + endTime.format(timeFormatter) + "</div>");
                
                // Show duration
                String duration = "";
                if (days > 0) duration += days + " day" + (days > 1 ? "s" : "");
                if (hours > 0) duration += (duration.isEmpty() ? "" : ", ") + hours + " hour" + (hours > 1 ? "s" : "");
                out.println("        <div class='info-item'><strong>Duration:</strong> " + duration + "</div>");
                out.println("        <div class='info-item'><strong>Total Hours:</strong> " + String.format("%.1f", totalHours) + " hours</div>");
                out.println("    </div>");
                out.println("</div>");
                
                // Price breakdown
                out.println("<div class='price-breakdown'>");
                out.println("    <h3>Price Breakdown</h3>");
                out.println("    <div class='price-line'>");
                out.println("        <span>Price per Day:</span>");
                out.println("        <span>$" + String.format("%.2f", pricePerDay) + "</span>");
                out.println("    </div>");
                out.println("    <div class='price-line'>");
                out.println("        <span>Price per Hour:</span>");
                out.println("        <span>$" + String.format("%.2f", pricePerHour) + "</span>");
                out.println("    </div>");
                out.println("    <div class='price-line'>");
                out.println("        <span>Total Hours:</span>");
                out.println("        <span>" + String.format("%.1f", totalHours) + " hours</span>");
                out.println("    </div>");
                out.println("    <div class='price-line total'>");
                out.println("        <span>Total Price:</span>");
                out.println("        <span>$" + String.format("%.2f", totalPrice) + "</span>");
                out.println("    </div>");
                out.println("</div>");
                
            } else {
                out.println("<h1>Error</h1>");
                out.println("<p>Booking not found.</p>");
            }
            
        } catch (SQLException e) {
            out.println("<h1>Error</h1>");
            out.println("<p>Unable to retrieve booking details.</p>");
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
        
        out.println("<hr>");
        out.println("<p><a href='" + request.getContextPath() + "/browse-cars'>Browse More Cars</a></p>");
        out.println("<p><a href='" + request.getContextPath() + "/index.jsp'>Back to Home</a></p>");
        out.println("</body>");
        out.println("</html>");
    }
}