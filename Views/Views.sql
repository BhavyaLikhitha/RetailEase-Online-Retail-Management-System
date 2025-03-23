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
