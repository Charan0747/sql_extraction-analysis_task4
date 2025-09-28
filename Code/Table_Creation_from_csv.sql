--==================================
--Creating & Using the Database.
--==================================
CREATE DATABASE Ecommerce;
use Ecommerce;
GO

--==================================
-- Drop existing table if it exists
--==================================
IF OBJECT_ID('dbo.Sales_data', 'U') IS NOT NULL
    DROP TABLE dbo.Sales_data;
GO

--==================================
-- Create the Sales_data table
--==================================
CREATE TABLE dbo.Sales_data (
    customer_id      NVARCHAR(20),
    first_name       NVARCHAR(50),
    last_name        NVARCHAR(50),
    gender           NVARCHAR(20),
    age_group        NVARCHAR(20),
    signup_date      DATE,
    country          NVARCHAR(50),
    product_id       NVARCHAR(20),
    product_name     NVARCHAR(100),
    category         NVARCHAR(50),
    quantity         INT,
    unit_price       DECIMAL(10,2),
    order_id         NVARCHAR(20) ,
    order_date       DATE,
    order_status     NVARCHAR(20),
    payment_method   NVARCHAR(30),
    rating           INT,
    review_text      NVARCHAR(MAX),
    review_id        NVARCHAR(20),
    review_date      DATE
);
GO

--==================================
-- Truncate for full reload
--==================================
TRUNCATE TABLE dbo.Sales_data;
GO

--==================================
-- Bulk insert data from CSV
--==================================
BULK INSERT dbo.Sales_data
FROM 'C:\Users\cherr\Downloads\archive\ecommerce_dataset_10000.csv'
WITH (
    FIRSTROW = 2,                -- Skip header row
    FIELDTERMINATOR = ',',       -- CSV delimiter
    ROWTERMINATOR = '0x0d0a',    -- Windows line breaks (CRLF); use 0x0a if Linux LF
    TABLOCK,
    CODEPAGE = '65001'           -- Handles UTF-8 CSV properly
);
GO
