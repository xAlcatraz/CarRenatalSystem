/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.carrental.servlets.auth;

import com.carrental.dao.UserDAO;
import com.carrental.model.User;
import com.carrental.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.regex.Pattern;

/**
 *
 * @author danim
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    private static final int MIN_PASS_LEN = 5;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirm  = request.getParameter("confirmPassword");
        
        if (name != null)
            name = name.trim();
        if (email != null)
            email = email.trim();
        
        String error = null;
        if (name == null || name.isEmpty()){
            error = "Name Required";
        } else if (email == null || email.isEmpty()){
            error = "Email Required";
        } else if (!EMAIL_PATTERN.matcher(email).matches()) {
            error = "Enter Valid Email Address";
        } else if (password == null || password.length() < MIN_PASS_LEN){
            error = "Password must be at least " +MIN_PASS_LEN+ " characters.";
        } else if (confirm == null || !password.equals(confirm)){
            error = "Password and ReTyped Password do NOT match.";
        }
        
        if (error != null){
            request.setAttribute("error", error);
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        UserDAO userDAO = new UserDAO();
        
        try {
            User existing = userDAO.findByEmail(email);
            if (existing != null) {
                request.setAttribute("error", "Email Already Used. Try Logging In.");
                request.setAttribute("name", name);
                request.setAttribute("email", email);
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            String hashed = PasswordUtil.hashPassword(password);

            User user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setPasswordHash(hashed);
            user.setRole("user");

            int rows = userDAO.register(user);
            if (rows != 1) {
                request.setAttribute("error", "Failed to create account. Please try again.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database Registration Error: " + e.getMessage());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        request.getSession().setAttribute("registerSuccess", "Account Created Successfully. Log In.");
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
