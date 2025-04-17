-- FUNCTIONS


-- 1. fn_is_valid_email
CREATE OR REPLACE FUNCTION fn_is_valid_email (
  p_email IN VARCHAR2
) RETURN BOOLEAN IS
BEGIN
  RETURN REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
END;
/

BEGIN
  IF fn_is_valid_email('test@example.com') THEN
    DBMS_OUTPUT.PUT_LINE('fn_is_valid_email valid');
  ELSE
    DBMS_OUTPUT.PUT_LINE('fn_is_valid_email invalid');
  END IF;
END;
/

-- 2. fn_is_valid_mobile
CREATE OR REPLACE FUNCTION fn_is_valid_mobile (
  p_mobile IN VARCHAR2
) RETURN BOOLEAN IS
BEGIN
  RETURN REGEXP_LIKE(p_mobile, '^\d+$');
END;
/

BEGIN
  IF fn_is_valid_mobile('as9876543210') THEN
    DBMS_OUTPUT.PUT_LINE('fn_is_valid_mobile valid');
  ELSE
    DBMS_OUTPUT.PUT_LINE('fn_is_valid_mobile invalid');
  END IF;
END;
/

-- 3. fn_get_discounted_price
CREATE OR REPLACE FUNCTION fn_get_discounted_price (
  p_id IN NUMBER
) RETURN NUMBER IS
  v_price Products.Actual_Price%TYPE;
  v_discount Product_Promotions.Discount_Percentage%TYPE := 0;
  v_final_price NUMBER;
BEGIN
  SELECT Actual_Price INTO v_price
  FROM Products
  WHERE Product_ID = p_id;

  SELECT MAX(Discount_Percentage) INTO v_discount
  FROM Product_Promotions
  WHERE Product_ID = p_id
    AND SYSDATE BETWEEN Start_Date AND End_Date;

  v_final_price := v_price * (1 - (v_discount / 100));
  RETURN v_final_price;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END;
/

BEGIN
  DBMS_OUTPUT.PUT_LINE('Discounted Price: ' || fn_get_discounted_price(2));
END;
/

-- 4. fn_order_total
CREATE OR REPLACE FUNCTION fn_order_total (
  p_order_id IN NUMBER
) RETURN NUMBER IS
  v_total NUMBER := 0;
BEGIN
  SELECT SUM(oi.Quantity * p.Actual_Price)
  INTO v_total
  FROM OrderItems oi
  JOIN Products p ON oi.Product_ID = p.Product_ID
  WHERE oi.Order_ID = p_order_id;

  RETURN v_total;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0;
END;
/

BEGIN
  DBMS_OUTPUT.PUT_LINE('Order Total: ' || fn_order_total(3));
END;
/

-- 5. fn_get_stock
CREATE OR REPLACE FUNCTION fn_get_stock (
  p_product_id IN NUMBER
) RETURN NUMBER IS
  v_stock NUMBER;
BEGIN
  SELECT Stock_Quantity INTO v_stock
  FROM Products
  WHERE Product_ID = p_product_id;

  RETURN v_stock;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END;
/

BEGIN
  DBMS_OUTPUT.PUT_LINE('Stock Quantity: ' || fn_get_stock(2));
END;
/

-- 6. fn_check_category_exists
CREATE OR REPLACE FUNCTION fn_check_category_exists (
  p_category_id IN NUMBER
) RETURN NUMBER IS
  v_exists NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO v_exists
  FROM Categories
  WHERE Category_ID = p_category_id;

  RETURN CASE WHEN v_exists > 0 THEN 1 ELSE 0 END;
END;
/

BEGIN
  DBMS_OUTPUT.PUT_LINE('Category Exists: ' || fn_check_category_exists(1));
END;
/

-- 7. fn_category_exists
CREATE OR REPLACE FUNCTION fn_category_exists (
  p_category_id IN NUMBER
) RETURN BOOLEAN IS
BEGIN
  RETURN fn_check_category_exists(p_category_id) = 1;
END;
/

BEGIN
  IF fn_category_exists(1) THEN
    DBMS_OUTPUT.PUT_LINE('fn_category_exists true');
  ELSE
    DBMS_OUTPUT.PUT_LINE('fn_category_exists false');
  END IF;
END;
/

-- 8. fn_user_exists
CREATE OR REPLACE FUNCTION fn_user_exists (
  p_user_id IN NUMBER
) RETURN BOOLEAN IS
  v_exists NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO v_exists
  FROM Users
  WHERE User_ID = p_user_id;

  RETURN v_exists > 0;
END;
/

BEGIN
  IF fn_user_exists(3) THEN
    DBMS_OUTPUT.PUT_LINE('fn_user_exists found');
  ELSE
    DBMS_OUTPUT.PUT_LINE('fn_user_exists not found');
  END IF;
END;
/

-- 9. fn_order_exists
CREATE OR REPLACE FUNCTION fn_order_exists (
  p_order_id IN NUMBER
) RETURN BOOLEAN IS
  v_exists NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO v_exists
  FROM Orders
  WHERE Order_ID = p_order_id;

  RETURN v_exists > 0;
END;
/

BEGIN
  IF fn_order_exists(3) THEN
    DBMS_OUTPUT.PUT_LINE('fn_order_exists found');
  ELSE
    DBMS_OUTPUT.PUT_LINE('fn_order_exists not found');
  END IF;
END;
/

-- 10. fn_product_exists
CREATE OR REPLACE FUNCTION fn_product_exists (
  p_product_id IN NUMBER
) RETURN BOOLEAN IS
  v_exists NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO v_exists
  FROM Products
  WHERE Product_ID = p_product_id;

  RETURN v_exists > 0;
END;
/

BEGIN
  IF fn_product_exists(2) THEN
    DBMS_OUTPUT.PUT_LINE('fn_product_exists found');
  ELSE
    DBMS_OUTPUT.PUT_LINE('fn_product_exists not found');
  END IF;
END;
/

