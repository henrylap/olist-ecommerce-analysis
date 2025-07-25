-- ================================
-- SALES & REVENUE METRICS
-- ================================

-- Total Revenue
SELECT SUM(price + freight_value) AS total_revenue FROM olist;

-- Average Order Value (AOV)
SELECT AVG(price + freight_value) AS avg_order_value FROM olist;

-- Number of Orders
SELECT COUNT(DISTINCT order_id) AS total_orders FROM olist;

-- Total Quantity Sold
SELECT SUM(order_item_id) AS total_items_sold FROM olist;

-- Revenue by Product Category
SELECT product_category_name, SUM(price + freight_value) AS revenue
FROM olist
GROUP BY product_category_name
ORDER BY revenue DESC;

-- ================================
-- CUSTOMER & ORDER BEHAVIOR
-- ================================

-- Orders Per Customer
SELECT customer_unique_id, COUNT(DISTINCT order_id) AS orders
FROM olist
GROUP BY customer_unique_id
ORDER BY orders DESC;

-- Reorder Rate
SELECT ROUND(
    COUNT(DISTINCT customer_unique_id) FILTER (WHERE order_count > 1) * 100.0 /
    COUNT(DISTINCT customer_unique_id), 2
) AS reorder_rate
FROM (
    SELECT customer_unique_id, COUNT(DISTINCT order_id) AS order_count
    FROM olist
    GROUP BY customer_unique_id
) sub;

-- ================================
-- DELIVERY PERFORMANCE
-- ================================

-- Average Delivery Delay
SELECT AVG(DATE(order_delivered_customer_date) - DATE(order_estimated_delivery_date)) AS avg_delivery_delay
FROM olist
WHERE order_delivered_customer_date IS NOT NULL AND order_estimated_delivery_date IS NOT NULL;

-- On Time Delivery Rate
SELECT 
    ROUND(SUM(CASE WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 1 ELSE 0 END) * 100.0 / 
          COUNT(*), 2) AS on_time_delivery_rate
FROM olist
WHERE order_delivered_customer_date IS NOT NULL AND order_estimated_delivery_date IS NOT NULL;

-- ================================
-- PRODUCT PERFORMANCE
-- ================================

-- Top Selling Products 
SELECT product_id, COUNT(order_item_id) AS total_sold
FROM olist
GROUP BY product_id
ORDER BY total_sold DESC
LIMIT 10;

-- Top Revenue Generating Products
SELECT product_id, SUM(payment_value) AS revenue
FROM olist
GROUP BY product_id
ORDER BY revenue DESC
LIMIT 10;

-- ================================
-- CUSTOMER FEEDBACK
-- ================================

-- Average Review Score by Category
SELECT product_category_name_english, ROUND(AVG(review_score), 2) AS avg_review_score
FROM olist
WHERE review_score IS NOT NULL
GROUP BY product_category_name_english
ORDER BY avg_review_score DESC;

-- Review Score Distribution
SELECT review_score, COUNT(*) AS count
FROM olist
GROUP BY review_score
ORDER BY review_score;

-- ================================
-- LOGISTICS
-- ================================

-- Average Shipping Time
SELECT AVG(DATE(order_delivered_customer_date) - DATE(order_approved_at)) AS avg_shipping_days
FROM olist
WHERE order_delivered_customer_date IS NOT NULL AND order_approved_at IS NOT NULL;

-- ================================
-- GEOGRAPHIC INSIGHTS
-- ================================

-- Revenue by State
SELECT customer_state, SUM(payment_value) AS revenue
FROM olist
GROUP BY customer_state
ORDER BY revenue DESC;

-- Orders by City
SELECT customer_city, COUNT(DISTINCT order_id) AS total_orders
FROM olist
GROUP BY customer_city
ORDER BY total_orders DESC

-- ================================
-- TREND ANALYSIS
-- ================================

-- Monthly Revenue Trend
SELECT DATE_TRUNC('month', order_purchase_timestamp) AS month,  
       SUM(payment_value) AS revenue  
FROM olist  
GROUP BY month  
ORDER BY month;














