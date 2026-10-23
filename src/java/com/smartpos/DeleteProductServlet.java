package com.smartpos;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DeleteProductServlet")
public class DeleteProductServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.trim().isEmpty()) {
            out.println("<h3>Error: Product ID is missing!</h3>");
            return;
        }
        
        try {
            int productId = Integer.parseInt(idStr);
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/smartpos_db", "root", "Baba@2218#");
            
            PreparedStatement pstmt = conn.prepareStatement("DELETE FROM products WHERE id = ?");
            pstmt.setInt(1, productId);
            int rows = pstmt.executeUpdate();
            
            pstmt.close();
            conn.close();
            
            if (rows > 0) {
                // Agar delete ho gaya toh wapas index par bhej do
                response.sendRedirect("index.jsp");
            } else {
                out.println("<h3 style='color:red;'>Error: Product with ID " + productId + " was not found in the database!</h3>");
            }
            
        } catch (Exception e) {
            // Agar koi SQL ya Driver error aayi toh screen par dikh jayegi
            out.println("<h3 style='color:red;'>Database Exception: " + e.getMessage() + "</h3>");
            e.printStackTrace(out);
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}