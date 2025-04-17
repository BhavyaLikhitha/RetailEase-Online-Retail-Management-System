--For retail_admin (Full Control)
GRANT EXECUTE ON user_mgmt_pkg TO retail_admin;
GRANT EXECUTE ON order_mgmt_pkg TO retail_admin;
GRANT EXECUTE ON product_mgmt_pkg TO retail_admin;
GRANT EXECUTE ON review_mgmt_pkg TO retail_admin;
GRANT EXECUTE ON promo_mgmt_pkg TO retail_admin;
GRANT EXECUTE ON wishlist_mgmt_pkg TO retail_admin;

--For retail_customer (Only relevant business actions)
GRANT EXECUTE ON order_mgmt_pkg TO retail_customer;       -- place_order, cancel_order
GRANT EXECUTE ON review_mgmt_pkg TO retail_customer;      -- add_review
GRANT EXECUTE ON wishlist_mgmt_pkg TO retail_customer;    -- add/remove wishlist


--Retail_analyst (Read-only → No EXECUTE needed)
--Already granted SELECT on:
--All core tables
