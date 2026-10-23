-- 1. Database Create Karein
CREATE DATABASE smartpos_db;

-- 2. Database Select Karein
USE smartpos_db;

-- 3. Products Table Banaein
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL
);

-- 4. Sample Data Insert Karein
INSERT INTO products (product_name, category, price, stock_quantity) 
VALUES ('Amul Butter 100g', 'Dairy', 58.00, 20),
       ('Tata Salt 1kg', 'Grocery', 28.00, 50);
       
      
