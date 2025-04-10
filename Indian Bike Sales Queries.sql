# First Create Database
CREATE DATABASE IF NOT EXISTS bike_sales;
USE bike_sales;
SELECT * FROM bike_sales_data;
SELECT COUNT(*) AS total_rows FROM bike_sales_data;
# SELECT COUNT(*) FROM bike_sales_data;
DESCRIBE bike_sales_data; # Basic structure of dataset

SELECT * FROM bike_sales_data LIMIT 10;

# Data Analysis Using SQL
# 1. Total Number of Bikes
SELECT COUNT(*) AS total_bikes
FROM bike_sales_data;

# 2. Total Number of Brands
SELECT COUNT(DISTINCT brand) AS total_brands
FROM bike_sales_data;

# 3.Top 5 Brands by Number of Bikes
SELECT brand, COUNT(*) AS bike_count
FROM bike_sales_data
GROUP BY brand
ORDER BY bike_count DESC
LIMIT 5;

# 4.  Average Resale Price by Brand
SELECT brand, ROUND(AVG(`Resale Price (INR)`),0) AS avg_resale_price
FROM bike_sales_data
GROUP BY brand
ORDER BY avg_resale_price DESC;
# Other method for this
SELECT brand, ROUND(AVG(`Resale Price (INR)`), 0) AS avg_resale_price
FROM bike_sales_data
WHERE `Resale Price (INR)` IS NOT NULL AND `Resale Price (INR)` > 0
GROUP BY brand
ORDER BY avg_resale_price DESC;

# 5.  Average Mileage by Fuel Type
SELECT `fuel type`, ROUND(AVG(`Mileage (km/l)`), 2) AS avg_mileage
FROM bike_sales_data
GROUP BY `fuel type`;

# 6. Total Bikes by State
SELECT State, COUNT(*) AS total_bikes
FROM bike_sales_data
GROUP BY State
ORDER BY total_bikes DESC;

# 7. Most Common Manufacture Year
SELECT `Year of Manufacture`, COUNT(*) AS count
FROM bike_sales_data
GROUP BY `Year of Manufacture`
ORDER BY count DESC
LIMIT 1;

# 8. Average Price vs Resale Price
SELECT 
    ROUND(AVG(`Price (INR)`), 0) AS avg_price,
    ROUND(AVG(`Resale Price (INR)`), 0) AS avg_resale_price
FROM bike_sales_data;

# 9.Top 5 States with Most Bikes
SELECT State, COUNT(*) AS bike_count
FROM bike_sales_data
GROUP BY State
ORDER BY bike_count DESC
LIMIT 5;

# 10. Insurance Status Breakdown
SELECT `Insurance Status`, COUNT(*) AS count
FROM bike_sales_data
GROUP BY `Insurance Status`
ORDER BY count DESC;

# 11. Resale Value Loss (Original – Resale Price)
SELECT Brand,
ROUND(AVG(`Price (INR)` - `Resale Price (INR)`), 0) AS avg_loss
FROM bike_sales_data
WHERE `Price (INR)` > 0 AND `Resale Price (INR)` > 0
GROUP BY Brand
ORDER BY avg_loss DESC;

# Step-by-Step JOIN Practice for Task 3

# Create a brand_info table (to join with brand)
CREATE TABLE brand_info (
  brand VARCHAR(50) PRIMARY KEY,
  country_of_origin VARCHAR(50)
);

INSERT INTO brand_info (brand, country_of_origin) VALUES
('Hero', 'India'),
('Honda', 'Japan'),
('TVS', 'India'),
('Yamaha', 'Japan'),
('Bajaj', 'India'),
('KTM', 'Austria');

# INNER JOIN – Only matching rows in both tables
SELECT b.brand, b.model, i.country_of_origin
FROM bike_sales_data b
INNER JOIN brand_info i ON b.brand = i.brand;

# LEFT JOIN – All bikes, even if brand info is missing
SELECT b.brand, b.model, i.country_of_origin
FROM bike_sales_data b
LEFT JOIN brand_info i ON b.brand = i.brand;

# RIGHT JOIN – All brand info, even if no bike is listed
SELECT b.brand, b.model, i.country_of_origin
FROM bike_sales_data b
RIGHT JOIN brand_info i ON b.brand = i.brand;

# Subqueries (For Task 3)
#A subquery is a query inside another query. You can use it in: SELECT, WHERE, FROM

# 1. Subquery in WHERE clause
# Find bikes that cost more than the average bike price
SELECT brand, model, `Price (INR)`
FROM bike_sales_data
WHERE `Price (INR)` > (
    SELECT AVG(`Price (INR)`)
    FROM bike_sales_data);
    
# 2. Subquery in FROM clause
# Get top 3 brands by average resale value
SELECT *
FROM (SELECT brand, ROUND(AVG(`Resale Price (INR)`), 0) AS avg_resale
    FROM bike_sales_data
    WHERE `Resale Price (INR)` > 0
    GROUP BY brand
    ORDER BY avg_resale DESC
    LIMIT 3) AS top_brands;   

#What is a View in SQL?
#A View is like a saved virtual table created from a query.
#You can:Query it like a table (SELECT * FROM view_name) , Use it to simplify complex queries

# View 1: Top 5 Brands by Bike Count

CREATE VIEW top_5_brands AS
SELECT brand, COUNT(*) AS total_bikes
FROM bike_sales_data
GROUP BY brand
ORDER BY total_bikes DESC
LIMIT 5;
SELECT * FROM top_5_brands;

# View 2: Fuel Type Distribution
CREATE VIEW `Fuel Type` AS
SELECT `Fuel Type`, COUNT(*) AS total_bikes
FROM bike_sales_data
GROUP BY `Fuel Type`;
SELECT * FROM `Fuel Type`;

# What Is an Index in SQL?
# An index helps MySQL find rows faster — like a table of contents in a book.

# 1. Index on brand
CREATE INDEX idx_brand ON bike_sales_data(Brand(50));
SHOW INDEXES FROM bike_sales_data;