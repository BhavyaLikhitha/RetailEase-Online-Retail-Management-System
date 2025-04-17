-- USER MANAGEMENT (ADD USER AND UPDATE LOGIN DATE)
CREATE OR REPLACE PACKAGE user_mgmt_pkg AS
  PROCEDURE add_user (
    p_first_name      IN USERS.first_name%TYPE,
    p_last_name       IN USERS.last_name%TYPE,
    p_email           IN USERS.email%TYPE,
    p_username        IN USERS.username%TYPE,
    p_password        IN USERS.password%TYPE,
    p_mobile_number   IN USERS.mobile_number%TYPE
  );

  PROCEDURE update_login_date (
    p_username IN USERS.username%TYPE
  );
END user_mgmt_pkg;
/

CREATE OR REPLACE PACKAGE BODY user_mgmt_pkg AS

  PROCEDURE add_user (
    p_first_name      IN USERS.first_name%TYPE,
    p_last_name       IN USERS.last_name%TYPE,
    p_email           IN USERS.email%TYPE,
    p_username        IN USERS.username%TYPE,
    p_password        IN USERS.password%TYPE,
    p_mobile_number   IN USERS.mobile_number%TYPE
  ) IS
    v_count INTEGER;
  BEGIN
    -- Email format check
    IF NOT REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
      RAISE_APPLICATION_ERROR(-20001, 'Email format is invalid (must be like example@domain.com).');
    END IF;

    -- Mobile format check (digits only)
    IF NOT REGEXP_LIKE(p_mobile_number, '^\d+$') THEN
      RAISE_APPLICATION_ERROR(-20002, 'Mobile number must contain digits only.');
    END IF;

    -- Unique email check
    SELECT COUNT(*) INTO v_count
    FROM USERS
    WHERE LOWER(email) = LOWER(p_email);
    IF v_count > 0 THEN
      RAISE_APPLICATION_ERROR(-20003, 'Email already exists.');
    END IF;

    -- Unique username check
    SELECT COUNT(*) INTO v_count
    FROM USERS
    WHERE LOWER(username) = LOWER(p_username);
    IF v_count > 0 THEN
      RAISE_APPLICATION_ERROR(-20004, 'Username already exists.');
    END IF;

    -- Insert new user
    INSERT INTO USERS (
      first_name, last_name, email, username, password, mobile_number, registration_date
    ) VALUES (
      p_first_name, p_last_name, p_email, p_username, p_password, p_mobile_number, SYSDATE
    );
  END add_user;

  -- Update login timestamp
  PROCEDURE update_login_date (
    p_username IN USERS.username%TYPE
  ) IS
  BEGIN
    UPDATE USERS
    SET last_login_date = SYSDATE
    WHERE LOWER(username) = LOWER(p_username);

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20005, 'Username not found.');
    END IF;
  END update_login_date;

END user_mgmt_pkg;
/


--Test Case 1: Add user with invalid email (e.g., missing "@")
set serveroutput on
BEGIN
  user_mgmt_pkg.add_user(
    p_first_name    => 'Ava',
    p_last_name     => 'Lee',
    p_email         => 'aval33gmail.com',  -- Invalid email format (missing @)
    p_username      => 'ava_lee01',
    p_password      => 'Test1234',
    p_mobile_number => '9876543210'
  );
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Test Case 1 - Invalid Email: ' || SQLERRM);
END;
/

-- Output: Test Case 1 - Invalid Email: ORA-20001: Email format is invalid (must be like example@domain.com).
--Explanation:
--The email aval33gmail.com fails the regex validation because it lacks the @ symbol.
--The add_user procedure throws a custom ORA-20001 error as designed.


-- Test Case 2: Add user with duplicate username

BEGIN
  user_mgmt_pkg.add_user(
    p_first_name    => 'Liam',
    p_last_name     => 'Smith',
    p_email         => 'liam.unique@example.com',  -- Unique email
    p_username      => 'ava_lee01',                -- Duplicate username
    p_password      => 'Liam123',
    p_mobile_number => '9123456789'
  );
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Test Case 2 - Duplicate Username: ' || SQLERRM);
END;
/

-- Output : Test Case 2 - Duplicate Username: ORA-20004: Username already exists.
--Explanation: The username ava_lee01 was added in a previous (successful or attempted) insert.
--This triggers the uniqueness check and raises a custom ORA-20004 error.
