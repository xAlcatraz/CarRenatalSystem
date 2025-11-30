/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.carrental.servlets;
import com.carrental.util.DBConnection;
import com.carrental.model.Car;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.*;
@WebServlet("/browse-cars")
public class BrowseCarsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get filter parameters from the request
        String[] carTypes = request.getParameterValues("carType");
        String[] capacities = request.getParameterValues("capacity");
        String[] fuelTypes = request.getParameterValues("fuelType");
        
        // Get session info (if user is logged in)
        HttpSession session = request.getSession(false);
        
        // List to store cars
        List<Car> carList = new ArrayList<>();
        String errorMessage = null;
        
        Connection conn = null;
        Statement resetStmt = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            // Connect to database
            conn = DBConnection.getConnection();
            
            // Reset all cars to available when page loads
//            resetStmt = conn.createStatement();
//            resetStmt.executeUpdate("UPDATE cars SET available = TRUE");
//            resetStmt.close();
            
            // Build dynamic SQL query based on filters
            StringBuilder sql = new StringBuilder(
                "SELECT id, brand, model, car_type, capacity, fuel_type, price_per_day, available " +
                "FROM cars WHERE available = TRUE"
            );
            
            List<String> conditions = new ArrayList<>();
            List<Object> parameters = new ArrayList<>();
            
            // Add car type filter
            if (carTypes != null && carTypes.length > 0) {
                String placeholders = String.join(",", Collections.nCopies(carTypes.length, "?"));
                conditions.add("car_type IN (" + placeholders + ")");
                for (String type : carTypes) {
                    parameters.add(type);
                }
            }
            
            // Add capacity filter
            if (capacities != null && capacities.length > 0) {
                String placeholders = String.join(",", Collections.nCopies(capacities.length, "?"));
                conditions.add("capacity IN (" + placeholders + ")");
                for (String cap : capacities) {
                    parameters.add(Integer.parseInt(cap));
                }
            }
            
            // Add fuel type filter
            if (fuelTypes != null && fuelTypes.length > 0) {
                String placeholders = String.join(",", Collections.nCopies(fuelTypes.length, "?"));
                conditions.add("fuel_type IN (" + placeholders + ")");
                for (String fuel : fuelTypes) {
                    parameters.add(fuel);
                }
            }
            
            // Combine all conditions with AND
            if (!conditions.isEmpty()) {
                sql.append(" AND ").append(String.join(" AND ", conditions));
            }
            
            sql.append(" ORDER BY id ASC");
            
            // Prepare and execute statement
            pstmt = conn.prepareStatement(sql.toString());
            
            // Set parameters in the prepared statement
            int paramIndex = 1;
            for (Object param : parameters) {
                if (param instanceof String) {
                    pstmt.setString(paramIndex++, (String) param);
                } else if (param instanceof Integer) {
                    pstmt.setInt(paramIndex++, (Integer) param);
                }
            }
            
            // Execute query
            rs = pstmt.executeQuery();
            
            // Loop through results and create Car objects
            while (rs.next()) {
                Car car = new Car();
                car.setId(rs.getInt("id"));
                car.setBrand(rs.getString("brand"));
                car.setModel(rs.getString("model"));
                car.setCarType(rs.getString("car_type"));
                car.setCapacity(rs.getInt("capacity"));
                car.setFuelType(rs.getString("fuel_type"));
                car.setPricePerDay(rs.getDouble("price_per_day"));
                car.setAvailable(rs.getBoolean("available"));
                carList.add(car);
            }
            
        } catch (SQLException e) {
            errorMessage = "Database error: " + e.getMessage();
            e.printStackTrace();
            
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (resetStmt != null) resetStmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        // Store data in request scope so JSP can access it
        request.setAttribute("carList", carList);
        request.setAttribute("errorMessage", errorMessage);
        
        // Forward to JSP for display
        RequestDispatcher dispatcher = request.getRequestDispatcher("/browse-cars.jsp");
        dispatcher.forward(request, response);
    }
}
