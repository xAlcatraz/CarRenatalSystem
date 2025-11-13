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
        
        // Get session info (if user is logged in)
        HttpSession session = request.getSession(false);
        
        // List to store cars
        List<Car> carList = new ArrayList<>();
        String errorMessage = null;
        
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            // Connect to database
            conn = DBConnection.getConnection();
            
            // Query for available cars
            stmt = conn.createStatement();
            String sql = "SELECT id, brand, model, price_per_day, available FROM cars WHERE available = TRUE ORDER BY id ASC";
            rs = stmt.executeQuery(sql);
            
            // Loop through results and create Car objects
            while (rs.next()) {
                Car car = new Car();
                car.setId(rs.getInt("id"));
                car.setBrand(rs.getString("brand"));
                car.setModel(rs.getString("model"));
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
                if (stmt != null) stmt.close();
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
