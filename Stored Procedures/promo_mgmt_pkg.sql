CREATE OR REPLACE PACKAGE promo_mgmt_pkg AS
  PROCEDURE add_promotion (
    p_product_id         IN NUMBER,
    p_discount_percentage IN NUMBER,
    p_start_date         IN DATE,
    p_end_date           IN DATE
  );
END promo_mgmt_pkg;
/

CREATE OR REPLACE PACKAGE BODY promo_mgmt_pkg AS

  PROCEDURE add_promotion (
    p_product_id         IN NUMBER,
    p_discount_percentage IN NUMBER,
    p_start_date         IN DATE,
    p_end_date           IN DATE
  ) IS
    v_actual_price Products.Actual_Price%TYPE;
    v_discounted_price NUMBER(10, 2);
  BEGIN
    -- Discount validation
    IF p_discount_percentage < 0 OR p_discount_percentage > 100 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Discount must be between 0 and 100.');
    END IF;

    -- Date range validation
    IF p_end_date < p_start_date THEN
      RAISE_APPLICATION_ERROR(-20002, 'End date must be greater than or equal to start date.');
    END IF;

    -- Get actual price
    SELECT Actual_Price INTO v_actual_price
    FROM Products
    WHERE Product_ID = p_product_id;

    -- Calculate discounted price
    v_discounted_price := v_actual_price * (1 - p_discount_percentage / 100);

    -- Final price must be ≤ actual price (should always be unless discount is negative)
    IF v_discounted_price > v_actual_price THEN
      RAISE_APPLICATION_ERROR(-20003, 'Discounted price cannot be higher than actual price.');
    END IF;

    -- Insert into promotions
    INSERT INTO Product_Promotions (
      Product_ID, Discount_Percentage, Start_Date, End_Date
    ) VALUES (
      p_product_id, p_discount_percentage, p_start_date, p_end_date
    );
  END add_promotion;

END promo_mgmt_pkg;
/


--TC1: Add promotion with end date < start date
BEGIN
  promo_mgmt_pkg.add_promotion(
    p_product_id => 2,
    p_discount_percentage => 20,
    p_start_date => TO_DATE('2025-05-10', 'YYYY-MM-DD'),
    p_end_date => TO_DATE('2025-05-01', 'YYYY-MM-DD')  -- End date < Start
  );
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TC1 - Expected Error: ' || SQLERRM);
END;
/

--OUTPUT: TC1 - Expected Error: ORA-20002: End date must be greater than or equal to start date.

--TC2: Add promo with discount > 100%
BEGIN
  promo_mgmt_pkg.add_promotion(
    p_product_id => 2,
    p_discount_percentage => 150,  --  Invalid
    p_start_date => TO_DATE('2025-05-01', 'YYYY-MM-DD'),
    p_end_date => TO_DATE('2025-06-01', 'YYYY-MM-DD')
  );
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TC2 - Expected Error: ' || SQLERRM);
END;
/

--OUTPUT: TC2 - Expected Error: ORA-20001: Discount must be between 0 and 100.

--TC3: Add promo with invalid date range (again, same as TC1 for clarity)
BEGIN
  promo_mgmt_pkg.add_promotion(
    p_product_id => 3,
    p_discount_percentage => 30,
    p_start_date => TO_DATE('2025-07-01', 'YYYY-MM-DD'),
    p_end_date => TO_DATE('2025-06-30', 'YYYY-MM-DD')  -- Invalid range
  );
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TC3 - Expected Error: ' || SQLERRM);
END;
/

--OUTPUT: TC3 - Expected Error: ORA-20002: End date must be greater than or equal to start date.

-- TC4: Attempt to apply promo where discounted price > actual price
BEGIN
  promo_mgmt_pkg.add_promotion(
    p_product_id => 2,
    p_discount_percentage => -50,  --  Negative discount raises price
    p_start_date => TO_DATE('2025-05-01', 'YYYY-MM-DD'),
    p_end_date => TO_DATE('2025-06-01', 'YYYY-MM-DD')
  );
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TC4 - Expected Error: ' || SQLERRM);
END;
/


--OUTPUT: TC4 - Expected Error: ORA-20001: Discount must be between 0 and 100.


--Add promotion with overlapping dates for the same product
BEGIN
  promo_mgmt_pkg.add_promotion(
    p_product_id => 2,  -- Existing product
    p_discount_percentage => 15,
    p_start_date => TO_DATE('2023-06-01', 'YYYY-MM-DD'),
    p_end_date => TO_DATE('2023-12-31', 'YYYY-MM-DD')  -- May overlap with existing one
  );
  DBMS_OUTPUT.PUT_LINE('️ TC4 - Promo added, but may overlap.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TC4 - Error: ' || SQLERRM);
END;
/
-- OUTPUT: TC4 - Promo added, but may overlap.

--Add promotion for a non-existent Product ID

BEGIN
  promo_mgmt_pkg.add_promotion(
    p_product_id => 9999,  -- Product doesn’t exist
    p_discount_percentage => 25,
    p_start_date => TO_DATE('2025-06-01', 'YYYY-MM-DD'),
    p_end_date => TO_DATE('2025-06-30', 'YYYY-MM-DD')
  );
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TC6 - Expected Error: ' || SQLERRM);
END;
/

-- OUTPUT: TC6 - Expected Error: ORA-01403: no data found