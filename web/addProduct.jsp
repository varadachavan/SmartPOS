<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Add Product - SmartPOS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5" style="max-width: 600px;">
        <div class="card shadow border-0 p-4">
            <h2 class="text-primary mb-4 fw-bold text-center">Add New Product</h2>
            <form action="AddProductServlet" method="POST">
                <div class="mb-3">
                    <label class="form-label fw-semibold">Product Name</label>
                    <input type="text" name="product_name" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Category</label>
                    <input type="text" name="category" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Price (₹)</label>
                    <input type="number" step="0.01" name="price" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Stock Quantity</label>
                    <input type="number" name="stock_quantity" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-success w-100 fw-bold py-2">Save Product</button>
                <a href="index.jsp" class="btn btn-secondary w-100 mt-2">Back to Dashboard</a>
            </form>
        </div>
    </div>
</body>
</html>