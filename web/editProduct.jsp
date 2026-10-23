<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Product - SmartPOS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .card-custom { border: none; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card card-custom p-4">
                    <h3 class="fw-bold mb-3 text-primary"><i class="fa-solid fa-pen-to-square me-2"></i>Edit Product</h3>
                    
                    <%
                        String idStr = request.getParameter("id");
                        String name = "", category = "";
                        double price = 0.0;
                        int stock = 0;
                        
                        try {
                            int id = Integer.parseInt(idStr);
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/smartpos_db", "root", "Baba@2218#");
                            
                            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM products WHERE id = ?");
                            pstmt.setInt(1, id);
                            ResultSet rs = pstmt.executeQuery();
                            
                            if(rs.next()) {
                                name = rs.getString("product_name");
                                category = rs.getString("category");
                                price = rs.getDouble("price");
                                stock = rs.getInt("stock_quantity");
                            }
                            conn.close();
                        } catch(Exception e) {
                            out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                        }
                    %>

                    <form action="${pageContext.request.contextPath}/UpdateServlet" method="POST">
                        <input type="hidden" name="id" value="<%= idStr %>">
                        
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Product Name</label>
                            <input type="text" name="product_name" class="form-control" value="<%= name %>" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Category</label>
                            <input type="text" name="category" class="form-control" value="<%= category %>" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Price (₹)</label>
                            <input type="number" step="0.01" name="price" class="form-control" value="<%= price %>" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Stock Quantity</label>
                            <input type="number" name="stock_quantity" class="form-control" value="<%= stock %>" required>
                        </div>
                        
                        <div class="d-flex justify-content-between">
                            <a href="index.jsp" class="btn btn-secondary"><i class="fa-solid fa-arrow-left me-1"></i> Cancel</a>
                            <button type="submit" class="btn btn-primary fw-bold"><i class="fa-solid fa-floppy-disk me-1"></i> Update Product</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>