<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartPOS - Inventory Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .navbar-custom { background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); }
        .card-custom { border: none; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
    </style>
</head>
<body>

    <!-- Top Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom mb-4 shadow-sm">
        <div class="container-fluid px-4">
            <a class="navbar-brand fw-bold fs-4" href="index.jsp">
                <i class="fa-solid fa-store me-2"></i>SmartPOS Dashboard
            </a>
            <div>
                <a href="pos.jsp" class="btn btn-light fw-bold text-primary me-2">
                    <i class="fa-solid fa-cash-register me-1"></i> Open POS Counter
                </a>
            </div>
        </div>
    </nav>

    <div class="container-fluid px-4">
        <div class="row">
            <!-- Left Side: Add Product Form with Dynamic Category Dropdown -->
            <div class="col-md-4">
                <div class="card card-custom p-4 mb-4">
                    <h4 class="fw-bold text-dark mb-3"><i class="fa-solid fa-plus-circle me-2 text-primary"></i>Add New Product</h4>
                    
                    <form action="AddProductServlet" method="POST">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Product Name</label>
                            <input type="text" name="product_name" class="form-control" placeholder="Enter product name" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Category</label>
                            <select name="category" class="form-select" required>
                                <option value="" disabled selected>-- Select Product Category --</option>
                                <%
                                    try {
                                        Class.forName("com.mysql.cj.jdbc.Driver");
                                        Connection catConn = DriverManager.getConnection("jdbc:mysql://localhost:3306/smartpos_db", "root", "");
                                        Statement catStmt = catConn.createStatement();
                                        ResultSet catRs = catStmt.executeQuery("SELECT DISTINCT category FROM products WHERE category IS NOT NULL AND category != ''");
                                        while(catRs.next()) {
                                            String catName = catRs.getString("category");
                                %>
                                            <option value="<%= catName %>"><%= catName %></option>
                                <%
                                        }
                                        catRs.close();
                                        catStmt.close();
                                        catConn.close();
                                    } catch(Exception e) {
                                        // Fallback if needed
                                    }
                                %>
                                <option value="Groceries">Groceries</option>
                                <option value="Snacks & Sweets">Snacks & Sweets</option>
                                <option value="Beverages">Beverages</option>
                                <option value="Dairy & Bakery">Dairy & Bakery</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Price (₹)</label>
                            <input type="number" step="0.01" name="price" class="form-control" placeholder="0.00" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Stock Quantity</label>
                            <input type="number" name="stock_quantity" class="form-control" placeholder="0" required>
                        </div>
                        
                        <button type="submit" class="btn btn-primary w-100 fw-bold py-2">
                            <i class="fa-solid fa-save me-1"></i> Save Product
                        </button>
                    </form>
                </div>
            </div>

            <!-- Right Side: Product Inventory Table -->
            <div class="col-md-8">
                <div class="card card-custom p-4">
                    <h4 class="fw-bold text-dark mb-3"><i class="fa-solid fa-boxes-stacked me-2 text-primary"></i>Inventory Stock List</h4>
                    
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Product Name</th>
                                    <th>Category</th>
                                    <th>Price</th>
                                    <th>Stock</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                        Class.forName("com.mysql.cj.jdbc.Driver");
                                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/smartpos_db", "root", "Baba@2218#");
                                        Statement stmt = conn.createStatement();
                                        ResultSet rs = stmt.executeQuery("SELECT * FROM products");
                                        
                                        while(rs.next()) {
                                %>
                                <tr>
                                    <td><%= rs.getInt("id") %></td>
                                    <td class="fw-semibold"><%= rs.getString("product_name") %></td>
                                    <td><span class="badge bg-secondary"><%= rs.getString("category") %></span></td>
                                    <td>₹<%= rs.getDouble("price") %></td>
                                    <td>
                                        <% 
                                            int stock = rs.getInt("stock_quantity");
                                            if(stock < 5) {
                                        %>
                                            <span class="badge bg-danger"><%= stock %> (Low)</span>
                                        <% } else { %>
                                            <span class="badge bg-success"><%= stock %></span>
                                        <% } %>
                                    </td>
                                    <td class="text-center">
                                        <!-- Edit Button -->
                                        <a href="editProduct.jsp?id=<%= rs.getInt("id") %>" class="btn btn-sm btn-warning text-white me-1">
                                            <i class="fa-solid fa-pen"></i>
                                        </a>
                                        <!-- Delete Form -->
                                        <form action="DeleteProductServlet" method="POST" style="display:inline;">
                                            <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                                            <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this product?');">
                                                <i class="fa-solid fa-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                <%
                                        }
                                        conn.close();
                                    } catch(Exception e) {
                                        out.println("<tr><td colspan='6' class='text-danger text-center'>Error loading inventory: " + e.getMessage() + "</td></tr>");
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>