INSERT INTO Users (First_Name, Last_Name, Email, Username, Password, Mobile_Number, Registration_Date)
VALUES ('John', 'Smith', 'john.smith@example.com', 
        'user0', 'pass0', '1234567890', CURRENT_TIMESTAMP);


INSERT INTO Users (First_Name, Last_Name, Email, Username, Password, Mobile_Number, Registration_Date)
VALUES ('Jane', 'Johnson', 'jane.johnson@example.com', 
        'user1', 'pass1', '1234567891', CURRENT_TIMESTAMP);


INSERT INTO Users (First_Name, Last_Name, Email, Username, Password, Mobile_Number, Registration_Date)
VALUES ('Alice', 'Williams', 'alice.williams@example.com', 
        'user2', 'pass2', '1234567892', CURRENT_TIMESTAMP);


INSERT INTO Users (First_Name, Last_Name, Email, Username, Password, Mobile_Number, Registration_Date)
VALUES ('Bob', 'Brown', 'bob.brown@example.com', 
        'user3', 'pass3', '1234567893', CURRENT_TIMESTAMP);


INSERT INTO Users (First_Name, Last_Name, Email, Username, Password, Mobile_Number, Registration_Date)
VALUES ('Charlie', 'Jones', 'charlie.jones@example.com', 
        'user4', 'pass4', '1234567894', CURRENT_TIMESTAMP);


INSERT INTO Users (First_Name, Last_Name, Email, Username, Password, Mobile_Number, Registration_Date)
VALUES ('Diana', 'Garcia', 'diana.garcia@example.com', 
        'user5', 'pass5', '1234567895', CURRENT_TIMESTAMP);


INSERT INTO Users (First_Name, Last_Name, Email, Username, Password, Mobile_Number, Registration_Date)
VALUES ('Eva', 'Miller', 'eva.miller@example.com', 
        'user6', 'pass6', '1234567896', CURRENT_TIMESTAMP);


INSERT INTO Users (First_Name, Last_Name, Email, Username, Password, Mobile_Number, Registration_Date)
VALUES ('Frank', 'Davis', 'frank.davis@example.com', 
        'user7', 'pass7', '1234567897', CURRENT_TIMESTAMP);


INSERT INTO Users (First_Name, Last_Name, Email, Username, Password, Mobile_Number, Registration_Date)
VALUES ('Grace', 'Rodriguez', 'grace.rodriguez@example.com', 
        'user8', 'pass8', '1234567898', CURRENT_TIMESTAMP);


INSERT INTO Users (First_Name, Last_Name, Email, Username, Password, Mobile_Number, Registration_Date)
VALUES ('Henry', 'Martinez', 'henry.martinez@example.com', 
        'user9', 'pass9', '1234567899', CURRENT_TIMESTAMP);

INSERT INTO Categories (Category_Name) VALUES ('Electronics');
INSERT INTO Categories (Category_Name) VALUES ('Books');
INSERT INTO Categories (Category_Name) VALUES ('Clothing');
INSERT INTO Categories (Category_Name) VALUES ('Home');
INSERT INTO Categories (Category_Name) VALUES ('Toys');
INSERT INTO Categories (Category_Name) VALUES ('Sports');
INSERT INTO Categories (Category_Name) VALUES ('Beauty');
INSERT INTO Categories (Category_Name) VALUES ('Garden');
INSERT INTO Categories (Category_Name) VALUES ('Automotive');
INSERT INTO Categories (Category_Name) VALUES ('Food');

INSERT INTO Products (Product_Name, Product_Description, Stock_Quantity, Actual_Price, Category_ID)
VALUES ('Product_1', 'Description for Product_1', 10, 
        392, 10);


INSERT INTO Products (Product_Name, Product_Description, Stock_Quantity, Actual_Price, Category_ID)
VALUES ('Product_2', 'Description for Product_2', 89, 
        37, 2);


INSERT INTO Products (Product_Name, Product_Description, Stock_Quantity, Actual_Price, Category_ID)
VALUES ('Product_3', 'Description for Product_3', 72, 
        262, 1);


INSERT INTO Products (Product_Name, Product_Description, Stock_Quantity, Actual_Price, Category_ID)
VALUES ('Product_4', 'Description for Product_4', 83, 
        37, 9);


INSERT INTO Products (Product_Name, Product_Description, Stock_Quantity, Actual_Price, Category_ID)
VALUES ('Product_5', 'Description for Product_5', 36, 
        154, 9);


INSERT INTO Products (Product_Name, Product_Description, Stock_Quantity, Actual_Price, Category_ID)
VALUES ('Product_6', 'Description for Product_6', 72, 
        162, 8);


INSERT INTO Products (Product_Name, Product_Description, Stock_Quantity, Actual_Price, Category_ID)
VALUES ('Product_7', 'Description for Product_7', 88, 
        252, 1);


INSERT INTO Products (Product_Name, Product_Description, Stock_Quantity, Actual_Price, Category_ID)
VALUES ('Product_8', 'Description for Product_8', 96, 
        146, 5);


INSERT INTO Products (Product_Name, Product_Description, Stock_Quantity, Actual_Price, Category_ID)
VALUES ('Product_9', 'Description for Product_9', 69, 
        388, 7);


INSERT INTO Products (Product_Name, Product_Description, Stock_Quantity, Actual_Price, Category_ID)
VALUES ('Product_10', 'Description for Product_10', 31, 
        184, 5);


INSERT INTO Orders (User_ID, Total_Price, Order_Status, Shipping_Method, Order_Date)
VALUES (2, 794, 'Order Placed', 'Standard', CURRENT_TIMESTAMP);


INSERT INTO Orders (User_ID, Total_Price, Order_Status, Shipping_Method, Order_Date)
VALUES (2, 389, 'Order Placed', 'Standard', CURRENT_TIMESTAMP);


INSERT INTO Orders (User_ID, Total_Price, Order_Status, Shipping_Method, Order_Date)
VALUES (4, 964, 'Order Placed', 'Standard', CURRENT_TIMESTAMP);


INSERT INTO Orders (User_ID, Total_Price, Order_Status, Shipping_Method, Order_Date)
VALUES (9, 952, 'Order Placed', 'Standard', CURRENT_TIMESTAMP);


INSERT INTO Orders (User_ID, Total_Price, Order_Status, Shipping_Method, Order_Date)
VALUES (3, 290, 'Order Placed', 'Standard', CURRENT_TIMESTAMP);


INSERT INTO Orders (User_ID, Total_Price, Order_Status, Shipping_Method, Order_Date)
VALUES (6, 818, 'Order Placed', 'Standard', CURRENT_TIMESTAMP);


INSERT INTO Orders (User_ID, Total_Price, Order_Status, Shipping_Method, Order_Date)
VALUES (7, 674, 'Order Placed', 'Standard', CURRENT_TIMESTAMP);


INSERT INTO Orders (User_ID, Total_Price, Order_Status, Shipping_Method, Order_Date)
VALUES (3, 749, 'Order Placed', 'Standard', CURRENT_TIMESTAMP);


INSERT INTO Orders (User_ID, Total_Price, Order_Status, Shipping_Method, Order_Date)
VALUES (5, 330, 'Order Placed', 'Standard', CURRENT_TIMESTAMP);


INSERT INTO Orders (User_ID, Total_Price, Order_Status, Shipping_Method, Order_Date)
VALUES (10, 452, 'Order Placed', 'Standard', CURRENT_TIMESTAMP);


INSERT INTO OrderItems (Order_ID, Product_ID, Quantity)
VALUES (8, 7, 5);


INSERT INTO OrderItems (Order_ID, Product_ID, Quantity)
VALUES (6, 5, 5);


INSERT INTO OrderItems (Order_ID, Product_ID, Quantity)
VALUES (3, 2, 2);


INSERT INTO OrderItems (Order_ID, Product_ID, Quantity)
VALUES (8, 6, 5);


INSERT INTO OrderItems (Order_ID, Product_ID, Quantity)
VALUES (6, 3, 5);


INSERT INTO OrderItems (Order_ID, Product_ID, Quantity)
VALUES (3, 8, 2);


INSERT INTO OrderItems (Order_ID, Product_ID, Quantity)
VALUES (10, 1, 2);


INSERT INTO OrderItems (Order_ID, Product_ID, Quantity)
VALUES (10, 6, 5);


INSERT INTO OrderItems (Order_ID, Product_ID, Quantity)
VALUES (8, 6, 2);


INSERT INTO OrderItems (Order_ID, Product_ID, Quantity)
VALUES (3, 7, 3);


INSERT INTO Reviews (User_ID, Product_ID, Rating, Comments)
VALUES (9, 2, 5, 'Review comment 0');


INSERT INTO Reviews (User_ID, Product_ID, Rating, Comments)
VALUES (3, 4, 5, 'Review comment 1');


INSERT INTO Reviews (User_ID, Product_ID, Rating, Comments)
VALUES (3, 1, 3, 'Review comment 2');


INSERT INTO Reviews (User_ID, Product_ID, Rating, Comments)
VALUES (6, 8, 5, 'Review comment 3');


INSERT INTO Reviews (User_ID, Product_ID, Rating, Comments)
VALUES (10, 6, 3, 'Review comment 4');


INSERT INTO Reviews (User_ID, Product_ID, Rating, Comments)
VALUES (6, 1, 4, 'Review comment 5');


INSERT INTO Reviews (User_ID, Product_ID, Rating, Comments)
VALUES (3, 4, 1, 'Review comment 6');


INSERT INTO Reviews (User_ID, Product_ID, Rating, Comments)
VALUES (4, 3, 3, 'Review comment 7');


INSERT INTO Reviews (User_ID, Product_ID, Rating, Comments)
VALUES (1, 1, 1, 'Review comment 8');


INSERT INTO Reviews (User_ID, Product_ID, Rating, Comments)
VALUES (7, 8, 1, 'Review comment 9');


INSERT INTO Payments (Payment_Method, Order_ID)
VALUES ('Credit Card', 9);


INSERT INTO Payments (Payment_Method, Order_ID)
VALUES ('Credit Card', 8);


INSERT INTO Payments (Payment_Method, Order_ID)
VALUES ('Credit Card', 9);


INSERT INTO Payments (Payment_Method, Order_ID)
VALUES ('Credit Card', 10);


INSERT INTO Payments (Payment_Method, Order_ID)
VALUES ('Credit Card', 9);


INSERT INTO Payments (Payment_Method, Order_ID)
VALUES ('Credit Card', 6);


INSERT INTO Payments (Payment_Method, Order_ID)
VALUES ('Credit Card', 2);


INSERT INTO Payments (Payment_Method, Order_ID)
VALUES ('Credit Card', 5);


INSERT INTO Payments (Payment_Method, Order_ID)
VALUES ('Credit Card', 2);


INSERT INTO Payments (Payment_Method, Order_ID)
VALUES ('Credit Card', 5);


INSERT INTO Product_Promotions (Product_ID, Discount_Percentage, Start_Date, End_Date)
VALUES (2, 39, TO_DATE('2023-02-27', 'YYYY-MM-DD'), TO_DATE('2023-07-19', 'YYYY-MM-DD'));


INSERT INTO Product_Promotions (Product_ID, Discount_Percentage, Start_Date, End_Date)
VALUES (6, 16, TO_DATE('2023-03-28', 'YYYY-MM-DD'), TO_DATE('2023-09-03', 'YYYY-MM-DD'));


INSERT INTO Product_Promotions (Product_ID, Discount_Percentage, Start_Date, End_Date)
VALUES (4, 37, TO_DATE('2023-02-21', 'YYYY-MM-DD'), TO_DATE('2023-08-18', 'YYYY-MM-DD'));


INSERT INTO Product_Promotions (Product_ID, Discount_Percentage, Start_Date, End_Date)
VALUES (6, 39, TO_DATE('2023-04-07', 'YYYY-MM-DD'), TO_DATE('2023-12-08', 'YYYY-MM-DD'));


INSERT INTO Product_Promotions (Product_ID, Discount_Percentage, Start_Date, End_Date)
VALUES (7, 43, TO_DATE('2023-03-05', 'YYYY-MM-DD'), TO_DATE('2023-06-20', 'YYYY-MM-DD'));


INSERT INTO Product_Promotions (Product_ID, Discount_Percentage, Start_Date, End_Date)
VALUES (5, 32, TO_DATE('2023-01-31', 'YYYY-MM-DD'), TO_DATE('2023-10-02', 'YYYY-MM-DD'));


INSERT INTO Product_Promotions (Product_ID, Discount_Percentage, Start_Date, End_Date)
VALUES (3, 38, TO_DATE('2023-05-30', 'YYYY-MM-DD'), TO_DATE('2023-11-13', 'YYYY-MM-DD'));


INSERT INTO Product_Promotions (Product_ID, Discount_Percentage, Start_Date, End_Date)
VALUES (1, 39, TO_DATE('2023-03-06', 'YYYY-MM-DD'), TO_DATE('2023-08-14', 'YYYY-MM-DD'));


INSERT INTO Product_Promotions (Product_ID, Discount_Percentage, Start_Date, End_Date)
VALUES (10, 40, TO_DATE('2023-05-06', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));


INSERT INTO Product_Promotions (Product_ID, Discount_Percentage, Start_Date, End_Date)
VALUES (7, 50, TO_DATE('2023-02-17', 'YYYY-MM-DD'), TO_DATE('2023-12-24', 'YYYY-MM-DD'));

INSERT INTO Wishlist (User_ID) VALUES (3);
INSERT INTO Wishlist (User_ID) VALUES (7);
INSERT INTO Wishlist (User_ID) VALUES (6);
INSERT INTO Wishlist (User_ID) VALUES (1);
INSERT INTO Wishlist (User_ID) VALUES (3);
INSERT INTO Wishlist (User_ID) VALUES (3);
INSERT INTO Wishlist (User_ID) VALUES (1);
INSERT INTO Wishlist (User_ID) VALUES (4);
INSERT INTO Wishlist (User_ID) VALUES (8);
INSERT INTO Wishlist (User_ID) VALUES (8);