-- Views

-- 1. Customer Spendings
CREATE OR REPLACE VIEW vw_EnhancedCustomerOrderSummary AS
SELECT 
    u.User_ID,
    u.First_Name || ' ' || u.Last_Name AS Full_Name,
    COUNT(o.Order_ID) AS Number_Of_Orders,
    SUM(CASE WHEN o.Order_Status != 'In Cart' THEN o.Total_Price ELSE 0 END) AS Total_Spent,
    AVG(CASE WHEN o.Order_Status != 'In Cart' THEN o.Total_Price ELSE NULL END) AS Average_Order_Value,
    MAX(CASE WHEN o.Order_Status != 'In Cart' THEN o.Order_Date ELSE NULL END) AS Last_Order_Date,
    (
        SELECT o2.Order_Status 
        FROM Orders o2 
        WHERE o2.User_ID = u.User_ID AND o2.Order_Status != 'In Cart' 
        ORDER BY o2.Order_Date DESC 
        FETCH FIRST 1 ROWS ONLY
    ) AS Last_Order_Status,
    CASE 
        WHEN (SUM(CASE WHEN o.Order_Status != 'In Cart' THEN o.Total_Price ELSE 0 END) / NULLIF(MONTHS_BETWEEN(SYSDATE, MIN(o.Order_Date)), 0)) >= 2500 THEN 'Gold'
        WHEN (SUM(CASE WHEN o.Order_Status != 'In Cart' THEN o.Total_Price ELSE 0 END) / NULLIF(MONTHS_BETWEEN(SYSDATE, MIN(o.Order_Date)), 0)) >= 1500 THEN 'Silver'
        WHEN (SUM(CASE WHEN o.Order_Status != 'In Cart' THEN o.Total_Price ELSE 0 END) / NULLIF(MONTHS_BETWEEN(SYSDATE, MIN(o.Order_Date)), 0)) >= 750 THEN 'Bronze'
        ELSE 'New'
    END AS Customer_Segment
FROM 
    Users u
JOIN 
    Orders o ON u.User_ID = o.User_ID
GROUP BY 
    u.User_ID, u.First_Name, u.Last_Name;

select * from vw_EnhancedCustomerOrderSummary;

-- 2. RATING'S Overview
CREATE OR REPLACE VIEW vw_CategoryRatingSummary AS
SELECT 
    c.Category_Name,
    ROUND(AVG(r.Rating),2) AS Average_Rating,
    AVG(CASE WHEN r.Rating = 5 THEN 1 ELSE 0 END) AS Avg_No_Of_5_Star_Ratings
FROM Reviews r
JOIN Products p ON r.Product_ID = p.Product_ID
JOIN Categories c ON p.Category_ID = c.Category_ID
GROUP BY c.Category_Name
ORDER BY Average_Rating DESC;

SELECT * FROM vw_CategoryRatingSummary;

-- 3.View's for Order Summary

CREATE OR REPLACE VIEW vw_OrderSummary AS
SELECT 
    o.Order_Date,
    o.Order_ID,
    COUNT(oi.Product_ID) AS Number_Of_Products,
    o.Total_Price AS Grand_Total,
    p.Payment_Method
FROM Orders o
JOIN OrderItems oi ON o.Order_ID = oi.Order_ID
JOIN Payments p ON o.Order_ID = p.Order_ID
GROUP BY o.Order_ID, o.Order_Date, o.Total_Price, p.Payment_Method
ORDER BY o.Order_Date DESC;

SELECT * FROM vw_OrderSummary;

-- 4.Inventory Quantity report
CREATE OR REPLACE VIEW vw_ProductInventoryStatus AS
SELECT 
    p.Product_Name,
    SUM(p.Stock_Quantity) AS TotalStockQuantity,
    CASE 
        WHEN SUM(p.Stock_Quantity) <= 0 THEN 'Out of Stock'
        WHEN SUM(p.Stock_Quantity) BETWEEN 1 AND 50 THEN 'Low Stock'
        ELSE 'In Stock'
    END AS InventoryStatus
FROM 
    Products p
GROUP BY 
    p.Product_Name;
    
SELECT * FROM vw_ProductInventoryStatus;

-- 5.Shows users and the products they have in their wishlist.
CREATE OR REPLACE VIEW vw_UserWishlistProducts AS
SELECT 
    u.User_ID,
    u.First_Name || ' ' || u.Last_Name AS FullName,
    w.Wishlist_ID,
    p.Product_ID,
    p.Product_Name,
    p.Actual_Price
FROM 
    Wishlist w
JOIN Users u ON w.User_ID = u.User_ID
JOIN Products p ON p.Product_ID IN (
    SELECT Product_ID FROM OrderItems WHERE Order_ID IN (
        SELECT Order_ID FROM Orders WHERE User_ID = u.User_ID
    )
);

SELECT * FROM vw_UserWishlistProducts;

-- 6. Lists products with average ratings and number of reviews.
CREATE OR REPLACE VIEW vw_TopRatedProducts AS
SELECT 
    p.Product_ID,
    p.Product_Name,
    ROUND(AVG(r.Rating), 2) AS AvgRating,
    COUNT(r.Review_ID) AS TotalReviews
FROM 
    Products p
JOIN Reviews r ON p.Product_ID = r.Product_ID
GROUP BY p.Product_ID, p.Product_Name
HAVING COUNT(r.Review_ID) >= 3
ORDER BY AvgRating DESC;

SELECT * FROM vw_TopRatedProducts;

-- 7. Shows total amount each customer has paid across orders.
CREATE OR REPLACE VIEW vw_CustomerPaymentSummary AS
SELECT 
    u.User_ID,
    u.First_Name || ' ' || u.Last_Name AS FullName,
    COUNT(DISTINCT pay.Payment_ID) AS TotalPayments,
    SUM(o.Total_Price) AS TotalPaid,
    MAX(pay.Payment_Date) AS LastPaymentDate
FROM 
    Users u
JOIN Orders o ON u.User_ID = o.User_ID
JOIN Payments pay ON o.Order_ID = pay.Order_ID
GROUP BY u.User_ID, u.First_Name, u.Last_Name;

SELECT * FROM vw_CustomerPaymentSummary;

--8. Shows total stock and number of products per category.

CREATE OR REPLACE VIEW vw_CategoryWiseInventorySummary AS
SELECT 
    c.Category_Name,
    COUNT(p.Product_ID) AS TotalProducts,
    SUM(p.Stock_Quantity) AS TotalStock,
    ROUND(AVG(p.Stock_Quantity), 2) AS AvgStockPerProduct
FROM 
    Categories c
JOIN Products p ON c.Category_ID = p.Category_ID
GROUP BY c.Category_Name;

SELECT * FROM vw_CategoryWiseInventorySummary;

--9. Summarizes number of orders and revenue per day.
CREATE OR REPLACE VIEW vw_DailyOrderTrend AS
SELECT 
    TRUNC(o.Order_Date) AS OrderDay,
    COUNT(o.Order_ID) AS TotalOrders,
    SUM(o.Total_Price) AS TotalRevenue
FROM 
    Orders o
WHERE 
    o.Order_Status = 'Order Placed'
GROUP BY TRUNC(o.Order_Date)
ORDER BY OrderDay DESC;

SELECT * FROM vw_DailyOrderTrend;

--10 .Shows all products that were ordered by users but haven't been reviewed yet.
CREATE OR REPLACE VIEW vw_OrdersWithoutReviews AS
SELECT 
    u.User_ID,
    u.First_Name || ' ' || u.Last_Name AS CustomerName,
    o.Order_ID,
    o.Order_Date,
    p.Product_ID,
    p.Product_Name,
    oi.Quantity
FROM 
    Orders o
JOIN Users u ON o.User_ID = u.User_ID
JOIN OrderItems oi ON o.Order_ID = oi.Order_ID
JOIN Products p ON oi.Product_ID = p.Product_ID
LEFT JOIN Reviews r ON r.User_ID = u.User_ID AND r.Product_ID = p.Product_ID
WHERE 
    o.Order_Status = 'Order Placed'
    AND r.Review_ID IS NULL;

SELECT * FROM vw_OrdersWithoutReviews;