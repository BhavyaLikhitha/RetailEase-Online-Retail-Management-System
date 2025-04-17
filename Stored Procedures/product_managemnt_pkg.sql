CREATE OR REPLACE PACKAGE product_mgmt_pkg AS
  PROCEDURE add_product (
    p_product_name        IN VARCHAR2,
    p_product_description IN VARCHAR2,
    p_stock_quantity      IN NUMBER,
    p_actual_price        IN NUMBER,
    p_category_id         IN NUMBER
  );

  PROCEDURE update_stock (
    p_product_id    IN NUMBER,
    p_new_stock_qty IN NUMBER
  );
END product_mgmt_pkg;
/


CREATE OR REPLACE PACKAGE BODY product_mgmt_pkg AS

  PROCEDURE add_product (
    p_product_name        IN VARCHAR2,
    p_product_description IN VARCHAR2,
    p_stock_quantity      IN NUMBER,
    p_actual_price        IN NUMBER,
    p_category_id         IN NUMBER
  ) IS
    v_cat_count INTEGER;
  BEGIN
    -- Validate price
    IF p_actual_price < 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Actual price must be non-negative.');
    END IF;

    -- Validate stock
    IF p_stock_quantity < 0 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Stock quantity must be non-negative.');
    END IF;

    -- Validate category exists
    SELECT COUNT(*) INTO v_cat_count
    FROM Categories
    WHERE Category_ID = p_category_id;

    IF v_cat_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20003, 'Invalid category ID.');
    END IF;

    -- Insert product
    INSERT INTO Products (
      Product_Name, Product_Description, Stock_Quantity, Actual_Price, Category_ID
    ) VALUES (
      p_product_name, p_product_description, p_stock_quantity, p_actual_price, p_category_id
    );
  END add_product;

  ------------------------------------------------------------------

  PROCEDURE update_stock (
    p_product_id    IN NUMBER,
    p_new_stock_qty IN NUMBER
  ) IS
    v_exists INTEGER;
  BEGIN
    -- Check if product exists
    SELECT COUNT(*) INTO v_exists
    FROM Products
    WHERE Product_ID = p_product_id;

    IF v_exists = 0 THEN
      RAISE_APPLICATION_ERROR(-20004, 'Product does not exist.');
    END IF;

    -- Update stock
    UPDATE Products
    SET Stock_Quantity = p_new_stock_qty
    WHERE Product_ID = p_product_id;
  END update_stock;

END product_mgmt_pkg;
/


--Test Case 1: Insert product with negative price

BEGIN
  product_mgmt_pkg.add_product(
    p_product_name => 'Invalid Price Product',
    p_product_description => 'This should fail',
    p_stock_quantity => 10,
    p_actual_price => -99,   -- Negative price
    p_category_id => 1
  );
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TC1 - Expected Error: ' || SQLERRM);
END;
/

--OUTPUT: TC1 - Expected Error: ORA-20001: Actual price must be non-negative.

--Test Case 2: Add product with invalid category ID

BEGIN
  product_mgmt_pkg.add_product(
    p_product_name => 'Invalid Category Product',
    p_product_description => 'Invalid Category',
    p_stock_quantity => 10,
    p_actual_price => 100,
    p_category_id => 9999  -- Category ID not present
  );
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TC2 - Expected Error: ' || SQLERRM);
END;
/

--OUTPUT: TC2 - Expected Error: ORA-20003: Invalid category ID.

--Test Case 3: Update stock of non-existent product

BEGIN
  product_mgmt_pkg.update_stock(
    p_product_id => 9999,         -- Does not exist
    p_new_stock_qty => 20
  );
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TC3 - Expected Error: ' || SQLERRM);
END;
/

-- OUTPUT: TC3 - Expected Error: ORA-20004: Product does not exist.


-- Positive Test Case (for validation)
BEGIN
  product_mgmt_pkg.add_product(
    p_product_name => 'Valid Product',
    p_product_description => 'This should work!',
    p_stock_quantity => 50,
    p_actual_price => 250,
    p_category_id => 1
  );
  DBMS_OUTPUT.PUT_LINE('Product added successfully.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

--OUTPUT: Product added successfully.