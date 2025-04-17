# 🛒 RetailEase - Online Retail Management System (Oracle DB Implementation)

## 🧾 Project Deliverables

- ✅ Final **ER Diagram** (with normalization proof)
- ✅ Documented **Business Rules** & Validations
- ✅ **Data Flow Diagrams** for each major module:
  - Customer Onboarding
  - Order Management
  - Inventory Management
  - Reordering Inventory
- ✅ **Views**:
  - `Current_inventory_status`
  - `Product_wise_price_changes`
  - `Total_Sales_region_wise`
  - `Week_wise_sales` 
  - etc
- ✅ Fully functional **SQL scripts**:
  - DDL: Table creation with constraints
  - DML: Sample data insertion
  - Views: Pre-defined queries for reporting
  - Users & Grants: Oracle user creation with roles and permissions

---

## 🛠️ How to Run the Scripts

> **Important:** All scripts are Oracle-compliant. Ensure you're connected to your Oracle DB instance before running.

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/BhavyaLikhitha/RetailEase-Online-Retail-Management-System.git
cd RetailEase-Online-Retail-Management-System
```
### 2️⃣ Run Scripts in Order
Open Oracle SQL Developer, and execute the scripts in the following order:

- **Step 1: Create Users and Assign Roles**
- **Step 2: Create Database Schema (DDL)**
- **Step 3: Insert Sample Data (DML)**
- **Step 4: Create Views**

## 🔁 Script Reusability 

All scripts are built with **re-runnability** in mind:

- ✅ `DROP IF EXISTS` logic is included to prevent **ORA errors**
- ✅ All constraints and sequences are dropped and recreated cleanly
- ✅ Views and users are **conditionally handled**
- ✅ Scripts can be **re-executed multiple times** without failure


## Implementations

🧠 PL/SQL Functions
The following functions were implemented to support validation, calculation, and data integrity across the system:

🔍 Validation Functions
fn_is_valid_email(p_email) – Validates proper email format using regex.

fn_is_valid_mobile(p_mobile) – Checks if the mobile number contains only digits.

📦 Business Logic Functions
fn_get_discounted_price(p_product_id) – Returns the final price after applying active promotions.

fn_order_total(p_order_id) – Calculates the total value of an order based on quantity and price.

fn_get_stock(p_product_id) – Retrieves the current stock level for a given product.

🔐 Existence Checks
fn_check_category_exists(p_category_id) – Returns TRUE if the category exists.

fn_category_exists(p_category_id) – Alias for checking category existence.

fn_user_exists(p_user_id) – Confirms if a user ID exists.

fn_order_exists(p_order_id) – Confirms if an order ID exists.

fn_product_exists(p_product_id) – Confirms if a product ID exists.

Each function is modular and used within procedures, triggers, and validations to ensure data accuracy and maintain referential integrity.

🛠 PL/SQL Stored Procedures
The following procedures were implemented to handle core system actions and validations:

🧑‍💼 User & Profile Management
sp_register_user – Registers a new user with basic validations.

sp_add_to_wishlist – Adds a wishlist record for a user if not already existing.

🛒 Order & Payment Processing
sp_place_order – Places an order, inserts order items, and updates product stock.

sp_make_payment – Processes payment for an order and records it in the Payments table.

⭐ Reviews & Feedback
sp_add_review – Allows a user to leave a product review, with checks for duplicates.

Each procedure includes appropriate exception handling, input validation using utility functions, and transaction-safe logic to maintain data integrity.

🔄 Database Triggers
To enforce business rules and automate system-level validations, the following triggers were implemented:

📦 Inventory & Order Logic
trg_reduce_stock – Automatically reduces product stock after an order item is inserted.

🛡 Data Integrity & Validation
trg_prevent_duplicate_review – Prevents a user from reviewing the same product more than once.

trg_unique_wishlist – Ensures only one wishlist entry exists per user.

trg_update_login – Logs activity when a user’s login timestamp is updated.

Each trigger supports automated enforcement of constraints and ensures referential integrity without manual intervention.