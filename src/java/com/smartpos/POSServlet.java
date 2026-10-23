package com.smartpos;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/POSServlet")
public class POSServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String productIdStr = request.getParameter("product_id");
        String qtyStr = request.getParameter("quantity");
        
        if(productIdStr != null && qtyStr != null && !productIdStr.isEmpty()) {
            try {
                int productId = Integer.parseInt(productIdStr);
                int qty = Integer.parseInt(qtyStr);
                
                Class.forName("com.mysql.cj.jdbc.Driver");
                // Yahan apna database password check kar lena (agar nahi hai toh "" rehne dein)
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/smartpos_db", "root", "Baba@2218#");
                
                // 1. Fetch current product details from database
                PreparedStatement psCheck = conn.prepareStatement("SELECT * FROM products WHERE id = ?");
                psCheck.setInt(1, productId);
                ResultSet rs = psCheck.executeQuery();
                
                if(rs.next()) {
                    String productName = rs.getString("product_name");
                    double price = rs.getDouble("price");
                    int currentStock = rs.getInt("stock_quantity");
                    
                    // Check if stock is sufficient
                    if(currentStock >= qty) {
                        int newStock = currentStock - qty; // Stock minus logic
                        
                        // 2. Update reduced stock in database
                        PreparedStatement psUpdate = conn.prepareStatement("UPDATE products SET stock_quantity = ? WHERE id = ?");
                        psUpdate.setInt(1, newStock);
                        psUpdate.setInt(2, productId);
                        psUpdate.executeUpdate();
                        psUpdate.close();
                        
                        // Pass details to JSP for live bill/invoice rendering
                        request.setAttribute("productName", productName);
                        request.setAttribute("price", price);
                        request.setAttribute("quantity", qty);
                        request.setAttribute("totalAmount", price * qty);
                        request.setAttribute("invoiceGenerated", true);
                    }
                }
                rs.close();
                psCheck.close();
                conn.close();
                
            } catch(Exception e) {
                e.printStackTrace();
            }
        }
        
        // Forward back to pos.jsp to show invoice preview
        request.getRequestDispatcher("pos.jsp").forward(request, response);
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("pos.jsp");
    }
}