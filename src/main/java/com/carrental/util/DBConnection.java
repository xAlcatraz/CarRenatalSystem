package com.carrental.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {

    private static final String DEFAULT_URL =
        "jdbc:mysql://localhost:3306/car_rental?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

    private static String URL  = DEFAULT_URL;
    private static String USER = "__MISSING__"; 
    private static String PASS = "__MISSING__";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("[DB DEBUG] MySQL driver loaded.");
        } catch (ClassNotFoundException e) {
            System.out.println("[DB DEBUG] Driver NOT found: " + e.getMessage());
        }

        boolean loaded = false;
        try (InputStream in = DBConnection.class
                .getClassLoader()
                .getResourceAsStream("db.properties")) {

            if (in != null) {
                Properties p = new Properties();
                p.load(in);
                URL  = p.getProperty("db.url", DEFAULT_URL);
                USER = p.getProperty("db.user", USER);
                PASS = p.getProperty("db.pass", PASS);
                loaded = true;
            }
        } catch (Exception e) {
            System.out.println("[DB DEBUG] Error loading db.properties: " + e.getMessage());
        }

        System.out.println("[DB DEBUG] propsLoaded=" + loaded +
                           " URL=" + URL +
                           " USER=" + USER +
                           " PASS_EMPTY=" + (PASS == null || PASS.isEmpty()));

        if ("__MISSING__".equals(USER) || "__MISSING__".equals(PASS)) {
            throw new RuntimeException("db.properties not loaded or missing db.user/db.pass");
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
