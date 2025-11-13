/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.carrental.servlets;

import com.carrental.util.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

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
        out.println("        body { font-family: Arial, sans-serif; margin: 20px; }");
        out.println("        .success { background-color: #d4edda; border: 1px solid #c3e6cb; padding: 20px; margin: 20px 0; }");
        out.println("        .details { background-color: #f9f9f9; border: 1px solid #ddd; padding: 15px; margin: 20px 0; }");
        out.println("        a { color: blue; text-decoration: underline; }");
        out.println("    </style>");
        out.println("</head>");
        out.println("<body>");
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT b.id, b.start_date, b.end_date, b.total_price, " +
                        "c.brand, c.model, c.price_per_day " +
                        "FROM bookings b " +
                        "JOIN cars c ON b.car_id = c.id " +
                        "WHERE b.id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, bookingId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                out.println("<h1>Booking Confirmed!</h1>");
                out.println("<div class='success'>");
                out.println("    <h2>✓ Your booking has been successfully created!</h2>");
                out.println("</div>");
                
                out.println("<div class='details'>");
                out.println("    <h3>Booking Details:</h3>");
                out.println("    <p><strong>Booking ID:</strong> " + rs.getInt("id") + "</p>");
                out.println("    <p><strong>Car:</strong> " + rs.getString("brand") + " " + rs.getString("model") + "</p>");
                out.println("    <p><strong>Start Date:</strong> " + rs.getDate("start_date") + "</p>");
                out.println("    <p><strong>End Date:</strong> " + rs.getDate("end_date") + "</p>");
                out.println("    <p><strong>Price per Day:</strong> $" + String.format("%.2f", rs.getDouble("price_per_day")) + "</p>");
                out.println("    <p><strong>Total Price:</strong> $" + String.format("%.2f", rs.getDouble("total_price")) + "</p>");
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
