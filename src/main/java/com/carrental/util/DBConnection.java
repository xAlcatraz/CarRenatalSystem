/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.carrental.util;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 *
 * @author danim
 */
public class DBConnection {
    private static final String DEFAULT_URL =
        "jdbc:mysql://localhost:3306/car_rental?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static String URL = DEFAULT_URL;
    private static String USER = "root";   // safe defaults
    private static String PASS = "";       // safe defaults

    static {
        try (InputStream in = DBConnection.class
                .getClassLoader()
                .getResourceAsStream("db.properties")) {

            if (in != null) {
                Properties p = new Properties();
                p.load(in);
                URL  = p.getProperty("db.url", DEFAULT_URL);
                USER = p.getProperty("db.user", USER);
                PASS = p.getProperty("db.pass", PASS);
            }
            // if db.properties is missing, we keep the defaults above
        } catch (Exception ignored) {
            // fail-safe: use defaults
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
