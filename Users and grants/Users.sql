-- Create Admin User
-- 1. Admin User: retail_admin
-- Has full control over tables, views, sequences, and user access (ideal for developers or DBAs).
CREATE USER retail_admin IDENTIFIED BY RetailAdmin123#;

-- Grant full privileges (including DDL/DML)
GRANT CONNECT, RESOURCE TO retail_admin;
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE TRIGGER TO retail_admin;

-- 2. End User (Customer): retail_customer
-- Access Only:
-- View products, categories, and promotions
-- Place orders, add reviews, make payments, manage wishlist
-- View only their own orders/reviews (recommend views for this)

-- Create End User
CREATE USER retail_customer IDENTIFIED BY customer123;
GRANT CREATE SESSION TO retail_customer;

-- Grant read-only access to product info
GRANT SELECT ON Products TO retail_customer;
GRANT SELECT ON Categories TO retail_customer;
GRANT SELECT ON Product_Promotions TO retail_customer;

-- Grant DML access for customer actions
GRANT INSERT ON Orders TO retail_customer;
GRANT INSERT ON OrderItems TO retail_customer;
GRANT INSERT ON Reviews TO retail_customer;
GRANT INSERT ON Payments TO retail_customer;
GRANT INSERT ON Wishlist TO retail_customer;

-- Also allow customer to view their submitted data
GRANT SELECT ON Orders TO retail_customer;
GRANT SELECT ON OrderItems TO retail_customer;
GRANT SELECT ON Reviews TO retail_customer;
GRANT SELECT ON Payments TO retail_customer;
GRANT SELECT ON Wishlist TO retail_customer;


-- 3. Analyst User: retail_analyst
-- Access Only:
-- Read-only access to all tables for analysis
-- Primarily for querying and dashboards

-- Create Analyst User
CREATE USER retail_analyst IDENTIFIED BY analyst123;
GRANT CREATE SESSION TO retail_analyst;

-- Read-only access to all necessary tables
GRANT SELECT ON Users TO retail_analyst;
GRANT SELECT ON Products TO retail_analyst;
GRANT SELECT ON Categories TO retail_analyst;
GRANT SELECT ON Orders TO retail_analyst;
GRANT SELECT ON OrderItems TO retail_analyst;
GRANT SELECT ON Reviews TO retail_analyst;
GRANT SELECT ON Payments TO retail_analyst;
GRANT SELECT ON Product_Promotions TO retail_analyst;
GRANT SELECT ON Wishlist TO retail_analyst;

-- permission on views as well
GRANT SELECT ON vw_SalesReport TO retail_analyst;
GRANT SELECT ON vw_DailyOrderTrend TO retail_analyst;


