CREATE OR REPLACE PACKAGE wishlist_mgmt_pkg AS
  PROCEDURE add_user_to_wishlist (
    p_user_id IN NUMBER
  );

  PROCEDURE remove_user_from_wishlist (
    p_user_id IN NUMBER
  );
END wishlist_mgmt_pkg;
/

CREATE OR REPLACE PACKAGE BODY wishlist_mgmt_pkg AS

  PROCEDURE add_user_to_wishlist (
    p_user_id IN NUMBER
  ) IS
    v_count INTEGER;
  BEGIN
    -- Check if user already has a wishlist entry
    SELECT COUNT(*) INTO v_count
    FROM Wishlist
    WHERE User_ID = p_user_id;

    IF v_count > 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'User already has a wishlist entry.');
    END IF;

    INSERT INTO Wishlist (User_ID)
    VALUES (p_user_id);
  END add_user_to_wishlist;

  -------------------------------------------------------------------

  PROCEDURE remove_user_from_wishlist (
    p_user_id IN NUMBER
  ) IS
    v_count INTEGER;
  BEGIN
    -- Check if entry exists
    SELECT COUNT(*) INTO v_count
    FROM Wishlist
    WHERE User_ID = p_user_id;

    IF v_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Wishlist entry for user not found.');
    END IF;

    DELETE FROM Wishlist
    WHERE User_ID = p_user_id;
  END remove_user_from_wishlist;

END wishlist_mgmt_pkg;
/


--TC1: Add wishlist entry for user who already has one
BEGIN
  wishlist_mgmt_pkg.add_user_to_wishlist(p_user_id => 3);  -- Already exists
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TC1 - Expected Error: ' || SQLERRM);
END;
/

--OUTPUT: TC1 - Expected Error: ORA-20001: User already has a wishlist entry.

--TC2: Add wishlist entry for a valid user who doesn’t have one
BEGIN
  wishlist_mgmt_pkg.add_user_to_wishlist(p_user_id => 5);  -- Assuming not present
  DBMS_OUTPUT.PUT_LINE('TC2 - Wishlist added successfully.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TC2 - Unexpected Error: ' || SQLERRM);
END;
/

--OUTPUT: TC2 - Wishlist added successfully.

--TC3: Remove wishlist entry for a user not in the table
BEGIN
  wishlist_mgmt_pkg.remove_user_from_wishlist(p_user_id => 999);  -- Invalid
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TC3 - Expected Error: ' || SQLERRM);
END;
/

-- OUTPUT: Expected Error: ORA-20002: Wishlist entry for user not found.

--TC4: Remove a valid wishlist entry
BEGIN
  wishlist_mgmt_pkg.remove_user_from_wishlist(p_user_id => 5);  -- Just added in TC2
  DBMS_OUTPUT.PUT_LINE('TC4 - Wishlist entry removed.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TC4 - Unexpected Error: ' || SQLERRM);
END;
/

--OUTPUT: TC4 - Wishlist entry removed.
