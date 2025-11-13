/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.carrental.servlets.auth;

import com.carrental.dao.UserDAO;
import com.carrental.model.User;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author danim
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        if (name == null || email == null || password == null || name.isBlank() || email.isBlank() || password.isBlank()){
            response.sendRedirect(request.getContextPath() + "/register.jsp");
            return;
        }
        
        User user = new User(name, email, password, "user");
        try {
            int rows = userDAO.register(user);
            if (rows == 1){
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/register.jsp");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database Error");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/register.jsp");
    }
}
