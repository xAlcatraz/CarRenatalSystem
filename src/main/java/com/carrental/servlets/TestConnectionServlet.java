package com.carrental.servlets;

import com.carrental.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

@WebServlet("/dbtest")
public class TestConnectionServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    resp.setContentType("text/html;charset=UTF-8");
    try (PrintWriter out = resp.getWriter()) {
      out.println("<h2>Reached /dbtest ✅</h2>");
      out.flush();

      try (Connection con = DBConnection.getConnection();
           Statement st = con.createStatement();
           ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM cars")) {

        rs.next();
        out.println("<p>Connected to DB…</p>");
        out.println("<p>cars rows: " + rs.getInt(1) + "</p>");

      } catch (Exception e) {
        e.printStackTrace(); // shows in Tomcat output
        resp.setStatus(500);
        out.println("<p style='color:red'>DB error: "
            + e.getClass().getSimpleName() + ": " + e.getMessage() + "</p>");
      }
    }
  }
}
