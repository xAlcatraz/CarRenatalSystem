/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.carrental.servlets;

import com.carrental.model.BookingInfo;
import com.carrental.util.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author danim
 */
@WebServlet("/my-bookings")
public class MyBookingsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");

        List<BookingInfo> bookings = new ArrayList<>();
        String errorMessage = null;

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            String sql =
                "SELECT b.id, b.start_date, b.start_time, b.end_date, b.end_time, b.total_price, " +
                "       c.brand, c.model, c.car_type, c.capacity, c.fuel_type, c.price_per_day " +
                "FROM bookings b " +
                "JOIN cars c ON b.car_id = c.id " +
                "WHERE b.user_id = ? " +
                "ORDER BY b.start_date DESC, b.start_time DESC";

            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            LocalDateTime now = LocalDateTime.now();

            while (rs.next()) {
                BookingInfo info = new BookingInfo();
                info.setId(rs.getInt("id"));
                info.setBrand(rs.getString("brand"));
                info.setModel(rs.getString("model"));
                info.setCarType(rs.getString("car_type"));
                info.setCapacity(rs.getInt("capacity"));
                info.setFuelType(rs.getString("fuel_type"));
                info.setStartDate(rs.getDate("start_date"));
                info.setStartTime(rs.getTime("start_time"));
                info.setEndDate(rs.getDate("end_date"));
                info.setEndTime(rs.getTime("end_time"));
                info.setPricePerDay(rs.getDouble("price_per_day"));
                info.setTotalPrice(rs.getDouble("total_price"));

                LocalDateTime endDateTime = LocalDateTime.of(
                        info.getEndDate().toLocalDate(),
                        info.getEndTime().toLocalTime()
                );
                String status = endDateTime.isBefore(now) ? "Completed" : "Upcoming";
                info.setStatus(status);

                bookings.add(info);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            errorMessage = "Database error while loading your bookings.";
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("bookings", bookings);
        request.setAttribute("errorMessage", errorMessage);

        RequestDispatcher rd = request.getRequestDispatcher("/my-bookings.jsp");
        rd.forward(request, response);
    }
}
