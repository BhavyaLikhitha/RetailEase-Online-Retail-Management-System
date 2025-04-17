
-- 1. trg_set_reg_timestamp (Before insert on USERS)
CREATE OR REPLACE TRIGGER trg_set_reg_timestamp
BEFORE INSERT ON Users
FOR EACH ROW
BEGIN
  :NEW.Registration_Date := SYSDATE;
END;
/

-- 2. trg_set_order_date (Before insert on ORDERS)
CREATE OR REPLACE TRIGGER trg_set_order_date
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
  :NEW.Order_Date := SYSDATE;
END;
/

--TESTING
BEGIN
  INSERT INTO OrderItems (Order_ID, Product_ID, Quantity)
  VALUES (3, 2, 0);  -- ❌ Invalid
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Expected Trigger Error: ' || SQLERRM);
END;
/


-- 3. trg_review_auto_timestamp (Before insert on REVIEWS)
CREATE OR REPLACE TRIGGER trg_review_auto_timestamp
BEFORE INSERT ON Reviews
FOR EACH ROW
BEGIN
  :NEW.Review_Date := SYSDATE;
END;
/

-- 4. trg_check_promotion_price (Before insert or update on Product_Promotions)
CREATE OR REPLACE TRIGGER trg_check_promotion_price
BEFORE INSERT OR UPDATE ON Product_Promotions
FOR EACH ROW
DECLARE
  v_price NUMBER;
  v_final NUMBER;
BEGIN
  SELECT Actual_Price INTO v_price FROM Products WHERE Product_ID = :NEW.Product_ID;
  v_final := v_price * (1 - :NEW.Discount_Percentage / 100);

  IF v_final > v_price THEN
    RAISE_APPLICATION_ERROR(-20001, 'Final price after discount cannot exceed actual price.');
  END IF;
END;
/

-- 5. trg_set_user_reg_timestamp (Alias of trg_set_reg_timestamp)
-- Already covered by trg_set_reg_timestamp

-- 6. trg_update_login_timestamp (After UPDATE on Users)
CREATE OR REPLACE TRIGGER trg_update_login_timestamp
AFTER UPDATE ON Users
FOR EACH ROW
WHEN (OLD.Last_Login_Date IS NULL AND NEW.Last_Login_Date IS NOT NULL)
BEGIN
  DBMS_OUTPUT.PUT_LINE('User login timestamp updated to: ' || :NEW.Last_Login_Date);
END;
/

-- 7. trg_order_default_date (Alias of trg_set_order_date)
-- Already covered by trg_set_order_date

-- 8. trg_check_order_items_quantity (Before insert on OrderItems)
CREATE OR REPLACE TRIGGER trg_check_order_items_quantity
BEFORE INSERT ON OrderItems
FOR EACH ROW
BEGIN
  IF :NEW.Quantity <= 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'Order item quantity must be greater than 0.');
  END IF;
END;
/

-- 9. trg_validate_review_rating_comment (Before insert on Reviews)
CREATE OR REPLACE TRIGGER trg_validate_review_rating_comment
BEFORE INSERT ON Reviews
FOR EACH ROW
BEGIN
  IF :NEW.Rating < 1 OR :NEW.Rating > 5 THEN
    RAISE_APPLICATION_ERROR(-20003, 'Rating must be between 1 and 5.');
  END IF;

  IF LENGTH(:NEW.Comments) > 1000 THEN
    RAISE_APPLICATION_ERROR(-20004, 'Review comment exceeds 1000 characters.');
  END IF;
END;
/

-- 10. trg_validate_order_status (Before insert or update on Orders)
CREATE OR REPLACE TRIGGER trg_validate_order_status
BEFORE INSERT OR UPDATE ON Orders
FOR EACH ROW
BEGIN
  IF :NEW.Order_Status NOT IN ('Order Placed', 'In Cart', 'Cancelled') THEN
    RAISE_APPLICATION_ERROR(-20005, 'Invalid order status.');
  END IF;
END;
/

-- 11. trg_set_payment_null_on_order_delete (After delete on Orders)
CREATE OR REPLACE TRIGGER trg_set_payment_null_on_order_delete
AFTER DELETE ON Orders
FOR EACH ROW
BEGIN
  UPDATE Payments
  SET Order_ID = NULL
  WHERE Order_ID = :OLD.Order_ID;
END;
/
