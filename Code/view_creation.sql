--==========================================
--View Creation for Reporting and Analysis
--==========================================

IF OBJECT_ID('vw_Sales_view','V') IS NOT NULL
    DROP VIEW vw_Sales_view;
GO
CREATE VIEW vw_Sales_view AS
SELECT 
    o.order_id,
    c.customer_id,
    c.first_name,
    c.last_name,
    c.gender,
    c.age_group,
    c.country,
    o.order_date,
    o.order_status,
    o.payment_method,
    p.product_id,
    p.product_name,
    p.category,
    oi.quantity,
    p.unit_price,
    (oi.quantity * p.unit_price) AS total_price,
    r.review_id,
    r.rating,
    r.review_text,
    r.review_date
FROM Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id
INNER JOIN OrderItems oi ON o.order_id = oi.order_id
INNER JOIN Products p ON oi.product_id = p.product_id
LEFT JOIN Reviews r ON o.order_id = r.order_id;
