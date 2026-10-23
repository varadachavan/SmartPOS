<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartPOS - Billing Counter</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .navbar-custom { background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); }
        .card-custom { border: none; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        @media print {
            body * { visibility: hidden; }
            #printableArea, #printableArea * { visibility: visible; }
            #printableArea { position: absolute; left: 0; top: 0; width: 100%; box-shadow: none !important; }
            .no-print { display: none; }
        }
    </style>
</head>
<body>

    <!-- Top Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom mb-4 shadow-sm no-print">
        <div class="container-fluid px-4">
            <a class="navbar-brand fw-bold fs-4" href="index.jsp">
                <i class="fa-solid fa-store me-2"></i>SmartPOS Billing Counter
            </a>
            <a href="index.jsp" class="btn btn-light fw-bold text-primary">
                <i class="fa-solid fa-arrow-left me-1"></i> Back to Dashboard
            </a>
        </div>
    </nav>

    <div class="container-fluid px-4">
        <div class="row">
            <!-- Left Side: Product Selection & Billing Form -->
            <div class="col-md-7 no-print">
                <div class="card card-custom p-4">
                    <h4 class="fw-bold text-dark mb-3"><i class="fa-solid fa-cash-register me-2 text-primary"></i>New Bill Invoice</h4>
                    
                    <form action="${pageContext.request.contextPath}/POSServlet" method="POST">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Select Product</label>
                            <select name="product_id" class="form-select" required>
                                <option value="" disabled selected>-- Choose Product from Inventory --</option>
                                <%
                                    try {
                                        Class.forName("com.mysql.cj.jdbc.Driver");
                                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/smartpos_db", "root", "Baba@2218#");
                                        Statement stmt = conn.createStatement();
                                        ResultSet rs = stmt.executeQuery("SELECT * FROM products WHERE stock_quantity > 0");
                                        while(rs.next()) {
                                %>
                                        <option value="<%= rs.getInt("id") %>">
                                            <%= rs.getString("product_name") %> - ₹<%= rs.getDouble("price") %> (Stock: <%= rs.getInt("stock_quantity") %>)
                                        </option>
                                <%
                                        }
                                        conn.close();
                                    } catch(Exception e) {
                                        out.println("<option disabled>Error: " + e.getMessage() + "</option>");
                                    }
                                %>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Quantity</label>
                            <input type="number" name="quantity" class="form-control" value="1" min="1" required>
                        </div>

                        <button type="submit" class="btn btn-success w-100 fw-bold py-2">
                            <i class="fa-solid fa-print me-1"></i> Generate & Print Bill
                        </button>
                    </form>
                </div>
            </div>

            <!-- Right Side: Printable Invoice Preview Area -->
            <div class="col-md-5">
                <div class="card card-custom p-4 bg-white" id="printableArea">
                    <div class="text-center border-bottom pb-3 mb-3">
                        <h3 class="fw-bold text-primary mb-0"><i class="fa-solid fa-store me-2"></i>SmartPOS Store</h3>
                        <p class="text-muted small mb-0">Official Tax Invoice / Receipt</p>
                    </div>
                    
                    <div class="mb-3 d-flex justify-content-between">
                        <div>
                            <p class="small text-muted mb-1"><strong>Date:</strong> <%= new java.util.Date() %></p>
                        </div>
                        <div>
                            <p class="small text-muted mb-0"><strong>Status:</strong> <span class="badge bg-success">Paid</span></p>
                        </div>
                    </div>

                    <hr>

                    <%
                        Boolean isGenerated = (Boolean) request.getAttribute("invoiceGenerated");
                        if(isGenerated != null && isGenerated) {
                            String pName = (String) request.getAttribute("productName");
                            Double pPrice = (Double) request.getAttribute("price");
                            Integer pQty = (Integer) request.getAttribute("quantity");
                            Double pTotal = (Double) request.getAttribute("totalAmount");
                    %>
                            <div class="table-responsive mb-4">
                                <table class="table table-bordered">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Item</th>
                                            <th>Qty</th>
                                            <th>Price</th>
                                            <th>Total</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td><%= pName %></td>
                                            <td><%= pQty %></td>
                                            <td>₹<%= pPrice %></td>
                                            <td class="fw-bold">₹<%= pTotal %></td>
                                        </tr>
                                    </tbody>
                                </table>
                                <div class="text-end mt-3">
                                    <h4 class="fw-bold text-success">Grand Total: ₹<%= pTotal %></h4>
                                </div>
                            </div>
                    <%
                        } else {
                    %>
                            <div class="text-center py-4 no-print">
                                <i class="fa-solid fa-receipt fa-3x text-secondary mb-2"></i>
                                <p class="text-muted">Select a product and quantity to generate the checkout receipt.</p>
                            </div>
                    <%
                        }
                    %>

                    <div class="d-grid gap-2 mt-3 no-print">
                        <button onclick="window.print()" class="btn btn-outline-primary fw-bold">
                            <i class="fa-solid fa-print me-1"></i> Print Receipt
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>