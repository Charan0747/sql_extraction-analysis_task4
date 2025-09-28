--Total Sales By Country
SELECT 
	country,
	SUM(quantity*unit_price) AS total_sales
FROM Orders AS o
INNER JOIN Customers c 
ON o.customer_id = c.customer_id
INNER JOIN OrderItems oi
ON o.order_id = oi.order_id
INNER JOIN Products p
ON oi.product_id = p.product_id
GROUP BY c.country
ORDER BY total_sales DESC;

--Monthly Sales Trend
SELECT 
    YEAR(o.order_date) AS order_year,
    MONTH(o.order_date) AS order_month,
    SUM(oi.quantity * p.unit_price) AS total_sales
FROM Orders o
INNER JOIN OrderItems oi 
ON o.order_id = oi.order_id
INNER JOIN Products p 
ON oi.product_id = p.product_id
GROUP BY YEAR(o.order_date), MONTH(o.order_date)
ORDER BY order_year, order_month;

--Average Order Value
SELECT 
    AVG(order_total) AS avg_order_value
FROM (
    SELECT 
        o.order_id,
        SUM(oi.quantity * p.unit_price) AS order_total
    FROM Orders o
    INNER JOIN OrderItems oi 
    ON o.order_id = oi.order_id
    INNER JOIN Products p 
    ON oi.product_id = p.product_id
    GROUP BY o.order_id
) AS order_totals;

--Order Status Count
SELECT 
    o.order_status,
    COUNT(*) AS order_count
FROM Orders o
GROUP BY o.order_status
ORDER BY order_count DESC;

--Average Rating Per Order
SELECT 
    p.product_name,
    AVG(r.rating) AS avg_rating,
    COUNT(r.review_id) AS total_reviews
FROM Products p
INNER JOIN OrderItems oi ON p.product_id = oi.product_id
INNER JOIN Orders o ON oi.order_id = o.order_id
LEFT JOIN Reviews r ON o.order_id = r.order_id
GROUP BY p.product_name
ORDER BY avg_rating DESC;


