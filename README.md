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
