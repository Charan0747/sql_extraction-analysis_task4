--=========================================
--Creating the Normalized Tables for each.
--=========================================

--=========================================
--Creating dbo.Customers Table
--=========================================

IF OBJECT_ID('dbo.Customers' ,'U') IS NOT NULL
    DROP TABLE dbo.Customers;
GO
CREATE TABLE dbo.Customers (
    customer_id   VARCHAR(20) PRIMARY KEY,
    first_name    NVARCHAR(50),
    last_name     NVARCHAR(50),
    gender        VARCHAR(10) CHECK (gender IN ('Male','Female','Other')),
    age_group     VARCHAR(20) CHECK (age_group IN ('Teenager','Adult','Senior')),
    signup_date   DATE,
    country       VARCHAR(50)
);

--=========================================
--Creating dbo.Products Table
--=========================================
IF OBJECT_ID('dbo.Products' ,'U') IS NOT NULL
    DROP TABLE dbo.Products;
GO
CREATE TABLE dbo.Products (
    product_id    VARCHAR(20) PRIMARY KEY,
    product_name  NVARCHAR(100),
    category      VARCHAR(50),
    unit_price    DECIMAL(10,2) CHECK (unit_price >= 0)
);

--=========================================
--Creating dbo.Orders Table
--=========================================
IF OBJECT_ID('dbo.Orders' ,'U') IS NOT NULL
    DROP TABLE dbo.Orders;
GO
CREATE TABLE dbo.Orders (
    order_id       VARCHAR(20) PRIMARY KEY,
    customer_id    VARCHAR(20) FOREIGN KEY REFERENCES Customers(customer_id),
    order_date     DATE,
    order_status   VARCHAR(20) CHECK (order_status IN ('Pending','Completed','Returned','Cancelled')),
    payment_method VARCHAR(30) CHECK (payment_method IN ('Credit Card','PayPal','Cash On Delivery'))
);

--=====================================================================
--Creating dbo.OrderItems Table(Handles multiple products per order)
--=====================================================================
IF OBJECT_ID('dbo.OrderItems' ,'U') IS NOT NULL
    DROP TABLE dbo.OrderItems;
GO
CREATE TABLE dbo.OrderItems (
    order_item_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id      VARCHAR(20) FOREIGN KEY REFERENCES Orders(order_id),
    product_id    VARCHAR(20) FOREIGN KEY REFERENCES Products(product_id),
    quantity      INT CHECK (quantity > 0)
);

--=========================================
--Creating dbo.Reviews Table
--=========================================
IF OBJECT_ID('dbo.Reviews' ,'U') IS NOT NULL
    DROP TABLE dbo.Reviews;
GO
CREATE TABLE Reviews (
    review_id     VARCHAR(20) PRIMARY KEY,
    order_id      VARCHAR(20) FOREIGN KEY REFERENCES Orders(order_id),
    rating        INT CHECK (rating BETWEEN 1 AND 5),
    review_text   NVARCHAR(255),
    review_date   DATE
);


--====================================================
--Insering the data into the normalized tables.
--====================================================
BEGIN TRANSACTION;
BEGIN TRY
    --Customers
    INSERT INTO Customers (customer_id, first_name, last_name, gender, age_group, signup_date, country)
    SELECT DISTINCT
        customer_id,
        first_name,
        last_name,
        CASE 
            WHEN LOWER(gender) IN ('m','male') THEN 'Male'
            WHEN LOWER(gender) IN ('f','female') THEN 'Female'
            ELSE 'Other'
        END AS gender,
        CASE 
            WHEN age_group LIKE 'Teen%' THEN 'Teenager'
            WHEN age_group LIKE 'Adult%' THEN 'Adult'
            WHEN age_group LIKE 'Senior%' THEN 'Senior'
            ELSE 'Unknown'
        END AS age_group,
        signup_date,
        country
    FROM Sales_data;

    --products
    INSERT INTO Products (product_id, product_name, category, unit_price)
    SELECT DISTINCT
        product_id,
        product_name,
        category,
        unit_price
    FROM Sales_data;

    --orders
    INSERT INTO Orders (order_id, customer_id, order_date, order_status, payment_method)
    SELECT DISTINCT
        order_id,
        customer_id,
        CAST(order_date AS DATE),
        CASE 
            WHEN LOWER(order_status) IN ('delivered','shipped') THEN 'Completed'
            WHEN LOWER(order_status) = 'pending' THEN 'Pending'
            WHEN LOWER(order_status) = 'returned' THEN 'Returned'
            WHEN LOWER(order_status) = 'cancelled' THEN 'Cancelled'
            ELSE 'Pending'
        END AS order_status,
        CASE 
            WHEN payment_method LIKE 'credit%' THEN 'Credit Card'
            WHEN payment_method LIKE 'paypal%' THEN 'PayPal'
            WHEN payment_method LIKE 'cash%' THEN 'Cash On Delivery'
            ELSE payment_method
        END AS payment_method
    FROM Sales_data;

    --orderitems
    INSERT INTO OrderItems (order_id, product_id, quantity)
    SELECT
        order_id,
        product_id,
        quantity
    FROM Sales_data;

    --reviews
    INSERT INTO Reviews (review_id, order_id, rating, review_text, review_date)
    SELECT DISTINCT
        review_id,
        order_id,
        CASE 
            WHEN rating < 1 THEN 1
            WHEN rating > 5 THEN 5
            ELSE rating
        END AS rating,
        review_text,
        review_date
    FROM Sales_data
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT('ERROR OCCURED DURING INSERTING:'+ ERROR_MESSAGE());
END CATCH

