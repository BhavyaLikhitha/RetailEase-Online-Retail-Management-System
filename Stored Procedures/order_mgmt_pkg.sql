-- order_mgmt_pkg place order and cancel order
CREATE OR REPLACE PACKAGE order_mgmt_pkg AS
  PROCEDURE place_order (
    p_user_id         IN NUMBER,
    p_shipping_method IN VARCHAR2,
    p_products        IN SYS.ODCINUMBERLIST,   -- List of product IDs
    p_quantities      IN SYS.ODCINUMBERLIST    -- List of quantities
  );

  PROCEDURE cancel_order (
    p_order_id IN NUMBER
  );
END order_mgmt_pkg;
/


CREATE OR REPLACE PACKAGE BODY order_mgmt_pkg AS

  PROCEDURE place_order (
    p_user_id         IN NUMBER,
    p_shipping_method IN VARCHAR2,
    p_products        IN SYS.ODCINUMBERLIST,
    p_quantities      IN SYS.ODCINUMBERLIST
  ) IS
    v_order_id    NUMBER;
    v_available   NUMBER;
  BEGIN
    -- Check if product list is empty
    IF p_products.COUNT = 0 OR p_quantities.COUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Order must contain at least one product.');
    END IF;

    -- Shipping method validation (redundant with CHECK constraint but useful for catching before insert)
    IF UPPER(p_shipping_method) NOT IN ('STANDARD', 'EXPRESS', 'SAME-DAY') THEN
      RAISE_APPLICATION_ERROR(-20002, 'Invalid shipping method.');
    END IF;

    -- Check each product's stock
    FOR i IN 1 .. p_products.COUNT LOOP
      SELECT Stock_Quantity INTO v_available
      FROM Products
      WHERE Product_ID = p_products(i);

      IF v_available < p_quantities(i) THEN
        RAISE_APPLICATION_ERROR(-20003, 'Product ID ' || p_products(i) || ' is out of stock or insufficient.');
      END IF;
    END LOOP;

    -- Generate new Order ID manually
    SELECT NVL(MAX(Order_ID), 0) + 1 INTO v_order_id FROM Orders;

    -- Insert into Orders table
    INSERT INTO Orders (
      Order_ID, User_ID, Shipping_Method, Order_Date, Order_Status
    ) VALUES (
      v_order_id, p_user_id, p_shipping_method, SYSDATE, 'Order Placed'
    );

    -- Insert OrderItems and update stock
    FOR i IN 1 .. p_products.COUNT LOOP
      INSERT INTO OrderItems (
        Order_ID, Product_ID, Quantity
      ) VALUES (
        v_order_id, p_products(i), p_quantities(i)
      );

      UPDATE Products
      SET Stock_Quantity = Stock_Quantity - p_quantities(i)
      WHERE Product_ID = p_products(i);
    END LOOP;

  END place_order;

  ----------------------------------------------------------------------

  PROCEDURE cancel_order (
    p_order_id IN NUMBER
  ) IS
    v_status VARCHAR2(50);
  BEGIN
    SELECT Order_Status INTO v_status
    FROM Orders
    WHERE Order_ID = p_order_id;

    IF v_status = 'Cancelled' THEN
      RAISE_APPLICATION_ERROR(-20004, 'Order is already cancelled.');
    END IF;

    UPDATE Orders
    SET Order_Status = 'Cancelled'
    WHERE Order_ID = p_order_id;
  END cancel_order;

END order_mgmt_pkg;
/

-- Test Case – Place order without order items
BEGIN
  order_mgmt_pkg.place_order(
    p_user_id         => 101,
    p_shipping_method => 'Standard',
    p_products        => SYS.ODCINUMBERLIST(),       -- ❌ Empty list
    p_quantities      => SYS.ODCINUMBERLIST()
  );
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TC1 - Expected Error: ' || SQLERRM);
END;
/

--OUTPUT: TC1 - Expected Error: ORA-20001: Order must contain at least one product.


--Test Case 2: Add order with invalid shipping method
BEGIN
  order_mgmt_pkg.place_order(
    p_user_id         => 101,
    p_shipping_method => 'DroneDelivery',  -- ❌ Invalid method
    p_products        => SYS.ODCINUMBERLIST(201),
    p_quantities      => SYS.ODCINUMBERLIST(1)
  );
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TC2 - Expected Error: ' || SQLERRM);
END;
/
 
--OUTPUT: TC2 - Expected Error: ORA-20002: Invalid shipping method.

--Test Case 3: Place order with out-of-stock product
BEGIN
  order_mgmt_pkg.place_order(
    p_user_id         => 101,
    p_shipping_method => 'Express',
    p_products        => SYS.ODCINUMBERLIST(10),   -- Product id 10 has stock < 50
    p_quantities      => SYS.ODCINUMBERLIST(50)
  );
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TC3 - Expected Error: ' || SQLERRM);
END;
/

--OUTPUT: TC3 - Expected Error: ORA-01403: no data found
--TC3 - Expected Error: ORA-21003: Product ID 202 is out of stock or insufficient.

-- Test Case 4: Place order with multiple products (one out of stock)

SELECT * FROM PRODUCTS;
BEGIN
  order_mgmt_pkg.place_order(
    p_user_id         => 101,
    p_shipping_method => 'Same-Day',
    p_products        => SYS.ODCINUMBERLIST(1,2),   -- 2 is short on stock
    p_quantities      => SYS.ODCINUMBERLIST(5, 99)
  );
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TC4 - Expected Error: ' || SQLERRM);
END;
/

--OUTPUT: TC4 - Expected Error: ORA-20003: Product ID 2 is out of stock or insufficient.

-- Positive Test Case: Place order with valid user, products & stock
SELECT * FROM USERS;
BEGIN
  order_mgmt_pkg.place_order(
    p_user_id         => 11,
    p_shipping_method => 'Express',
    p_products        => SYS.ODCINUMBERLIST(3, 5),
    p_quantities      => SYS.ODCINUMBERLIST(2, 10)   -- Ensure both products have enough stock
  );
  DBMS_OUTPUT.PUT_LINE('TC5 - Order placed successfully.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TC5 - Unexpected Error: ' || SQLERRM);
END;
/
--
--OUTPUT: TC5 - Order placed successfully.

--Test Case for cancel_order
SELECT * FROM ORDERS;
BEGIN
  order_mgmt_pkg.cancel_order(p_order_id => 11);  -- real Order_ID
  DBMS_OUTPUT.PUT_LINE('TC6 - Order cancelled successfully.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TC6 - Error: ' || SQLERRM);
END;
/

--OUTPUT: TC6 - Order cancelled successfully.
