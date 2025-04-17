CREATE OR REPLACE PACKAGE review_mgmt_pkg AS
  PROCEDURE add_review (
    p_user_id    IN NUMBER,
    p_product_id IN NUMBER,
    p_rating     IN NUMBER,
    p_comments   IN VARCHAR2
  );
END review_mgmt_pkg;
/

CREATE OR REPLACE PACKAGE BODY review_mgmt_pkg AS

  PROCEDURE add_review (
    p_user_id    IN NUMBER,
    p_product_id IN NUMBER,
    p_rating     IN NUMBER,
    p_comments   IN VARCHAR2
  ) IS
    v_count INTEGER;
  BEGIN
    -- Rating validation
    IF p_rating NOT BETWEEN 1 AND 5 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Rating must be between 1 and 5.');
    END IF;

    -- Comment length check
    IF LENGTH(p_comments) > 1000 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Comment exceeds 1000 characters.');
    END IF;

    -- Check for duplicate review
    SELECT COUNT(*) INTO v_count
    FROM Reviews
    WHERE User_ID = p_user_id AND Product_ID = p_product_id;

    IF v_count > 0 THEN
      RAISE_APPLICATION_ERROR(-20003, 'Review already exists for this user and product.');
    END IF;

    -- Insert review
    INSERT INTO Reviews (
      User_ID, Product_ID, Rating, Comments
    ) VALUES (
      p_user_id, p_product_id, p_rating, p_comments
    );
  END add_review;

END review_mgmt_pkg;
/

--Test Case 1: Add review with rating = 6 (Invalid)
BEGIN
  review_mgmt_pkg.add_review(
    p_user_id    => 3,
    p_product_id => 2,
    p_rating     => 6,  -- Invalid rating
    p_comments   => 'Rating too high test'
  );
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TC1 - Expected Error: ' || SQLERRM);
END;
/

-- OUTPUT: TC1 - Expected Error: ORA-20001: Rating must be between 1 and 5.

--Test Case 2: Add duplicate review by same user/product

BEGIN
  review_mgmt_pkg.add_review(
    p_user_id    => 3,  -- Already reviewed product 2
    p_product_id => 2,
    p_rating     => 4,
    p_comments   => 'Duplicate review test'
  );
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TC2 - Expected Error: ' || SQLERRM);
END;
/

-- OUTPUT: TC2 - Expected Error: ORA-20003: Review already exists for this user and product.

-- POSITIVE TEST CASE
SELECT * FROM USERS;
BEGIN
  review_mgmt_pkg.add_review(
    p_user_id    => 1,  -- User exists
    p_product_id => 5,  -- Product exists
    p_rating     => 4,  -- Valid rating (1–5)
    p_comments   => 'Great product! Would buy again.'  -- ✅ Comment < 1000 chars
  );
  DBMS_OUTPUT.PUT_LINE('TC3 - Review added successfully.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TC3 - Unexpected Error: ' || SQLERRM);
END;
/

-- OUTPUT: TC3 - Review added successfully.