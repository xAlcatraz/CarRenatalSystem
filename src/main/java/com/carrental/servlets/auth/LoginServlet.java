/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.carrental.servlets.auth;

import com.carrental.util.DBConnection;
import com.carrental.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author danim
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        if (email != null)
            email = email.trim();
            
        if (email == null || email.isEmpty() || password == null || password.isEmpty()){
            request.setAttribute("error", "Email and Password Required.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        String storedHash = null;
        String name       = null;
        String role       = null;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement sm = conn.prepareStatement(
                "SELECT id, name, email, password_hash, role FROM users WHERE email = ?")){
            sm.setString(1, email);
            try(ResultSet rs = sm.executeQuery()){
                if (rs.next()){
                    storedHash = rs.getString("password_hash");
                    name       = rs.getString("name");
                    role       = rs.getString("role");
                }
            }
        } catch (SQLException e){
            e.printStackTrace();
            request.setAttribute("error", "Database Error: Login: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        boolean ok = PasswordUtil.checkPassword(password, storedHash);
        if (!ok){
            request.setAttribute("error", "Invalid Email or Password.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        HttpSession session = request.getSession(true);
        session.setAttribute("userEmail", email);
        session.setAttribute("userName",  name);
        session.setAttribute("userRole",  role != null ? role : "user");
        
        response.sendRedirect(request.getContextPath() + "/browse-cars");
    }
}
