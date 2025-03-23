-- USERS TABLE
CREATE TABLE Users (
    User_ID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    First_Name VARCHAR2(50) NOT NULL,
    Last_Name VARCHAR2(50) NOT NULL,
    Email VARCHAR2(256) NOT NULL UNIQUE,
    Username VARCHAR2(50) NOT NULL UNIQUE,
    Password VARCHAR2(256) NOT NULL,
    Mobile_Number VARCHAR2(15),
    Registration_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Last_Login_Date TIMESTAMP,
    CONSTRAINT chk_mobile_number_format CHECK (REGEXP_LIKE(Mobile_Number, '^[0-9]+$')),
    CONSTRAINT chk_email_format CHECK (Email LIKE '%@%.%')
);

-- CATEGORIES TABLE
CREATE TABLE Categories (
    Category_ID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Category_Name VARCHAR2(255) NOT NULL
);

-- PRODUCTS TABLE
CREATE TABLE Products (
    Product_ID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Product_Name VARCHAR2(100) NOT NULL,
    Product_Description VARCHAR2(1000),
    Stock_Quantity NUMBER CHECK (Stock_Quantity >= 0),
    Actual_Price NUMBER(10, 2) CHECK (Actual_Price >= 0),
    Category_ID NUMBER REFERENCES Categories(Category_ID) ON DELETE CASCADE
);

-- ORDERS TABLE
CREATE TABLE Orders (
    Order_ID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    User_ID NUMBER REFERENCES Users(User_ID) ON DELETE CASCADE,
    Total_Price NUMBER(10, 2),
    Order_Status VARCHAR2(50) CHECK (Order_Status IN ('Order Placed', 'In Cart', 'Cancelled')),
    Shipping_Method VARCHAR2(50) CHECK (Shipping_Method IN ('Standard', 'Express', 'Same-Day')),
    Order_Date TIMESTAMP NOT NULL
);

-- ORDER ITEMS TABLE
CREATE TABLE OrderItems (
    OrderItem_ID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Order_ID NUMBER NOT NULL REFERENCES Orders(Order_ID) ON DELETE CASCADE,
    Product_ID NUMBER NOT NULL REFERENCES Products(Product_ID) ON DELETE CASCADE,
    Quantity NUMBER NOT NULL CHECK (Quantity > 0)
);

-- REVIEWS TABLE
CREATE TABLE Reviews (
    Review_ID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    User_ID NUMBER NOT NULL REFERENCES Users(User_ID) ON DELETE CASCADE,
    Product_ID NUMBER NOT NULL REFERENCES Products(Product_ID) ON DELETE CASCADE,
    Rating NUMBER NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comments VARCHAR2(1000),
    Review_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PAYMENTS TABLE
CREATE TABLE Payments (
    Payment_ID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Payment_Method VARCHAR2(50) NOT NULL,
    Payment_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Order_ID NUMBER REFERENCES Orders(Order_ID) ON DELETE SET NULL
);

-- PRODUCT PROMOTIONS TABLE
CREATE TABLE Product_Promotions (
    Promotion_Product_ID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Product_ID NUMBER NOT NULL REFERENCES Products(Product_ID) ON DELETE CASCADE,
    Discount_Percentage NUMBER CHECK (Discount_Percentage BETWEEN 0 AND 100),
    Start_Date TIMESTAMP,
    End_Date TIMESTAMP,
    CONSTRAINT chk_promotion_dates CHECK (End_Date >= Start_Date)
);

-- WISHLIST TABLE
CREATE TABLE Wishlist (
    Wishlist_ID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    User_ID NUMBER NOT NULL REFERENCES Users(User_ID) ON DELETE CASCADE
);