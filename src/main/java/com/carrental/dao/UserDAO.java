/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.carrental.dao;

import com.carrental.model.User;
import com.carrental.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author danim
 */
public class UserDAO {
    private static final String INSERT_SQL = "INSERT INTO users (name, email, password_hash, role) VALUES (?, ?, ?, ?)";
    private static final String SELECT_BY_EMAIL_SQL = "SELECT id, name, email, password_hash, role FROM users WHERE email = ?";
    
    public int register(User user) throws SQLException {
        try (Connection connection = DBConnection.getConnection(); 
            PreparedStatement ps = connection.prepareStatement(INSERT_SQL)){
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getRole());
            
            return ps.executeUpdate();
        }
    }
    
    public User findByEmail(String email) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
            PreparedStatement ps = connection.prepareStatement(SELECT_BY_EMAIL_SQL)){
            ps.setString(1, email);
            
            try (ResultSet rs = ps.executeQuery()){
                if (rs.next()){
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setPasswordHash(rs.getString("password_hash"));
                    user.setRole(rs.getString("role"));
                    return user;
                } else {
                    return null;
                }
            }
        }
    }
}
