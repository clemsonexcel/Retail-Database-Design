# Retail Database Design (SQL Server)

## Project Overview

I designed a **relational database** for a fictional retail company to manage **customers, inventory tracking, orders, and suppliers**. The focus of the project was on **database modeling, table relationships, and data integrity**, with sample SQL queries demonstrating database functionality.

## Business Context

The company previously managed data using spreadsheets and disconnected applications, resulting in **data inconsistencies, delayed order fulfillment, and challenges in reporting**. This database centralizes and structures data, providing a foundation for efficient retail operations.

## Key Features & Implementation

* **Database Tables**: Customers, Products, Orders, Inventory, Suppliers, Employees, Departments
* **Relationships**: Primary and foreign keys to ensure data integrity
* **Normalization**: Schema designed to **3rd Normal Form (3NF)**
* **Sample SQL Queries**: Demonstrated retrieving data such as:

  * Customers over a certain age with high-value orders
  * Orders linked to suppliers and employees
* **Views and Stored Procedures**: Created for common operations like searching products and retrieving customer order histories

## Tools & Concepts

* Microsoft SQL Server (T-SQL)
* Relational database design
* ER diagram creation
* Database normalization
* Data integrity constraints
* Views and stored procedures

## Entity Relationship Diagram

The final **Entity-Relationship Diagram (ERD)** showing all tables and their relationships, highlighting primary keys, foreign keys, and how entities connect.

![Dashboard-Image](ERD.png)


## SQL Snippets

### Creating Tables
Tables where created implementing data intergrity constraints such as `StockQuantity` column never being in the negative and `OrderDate` never being in the past.


```sql
-- creating Product Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100) NOT NULL,
    Category NVARCHAR(50) NOT NULL,
    Description NVARCHAR(MAX),
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    CostPrice DECIMAL(10,2) NOT NULL CHECK (CostPrice >= 0),
    SupplierID INT NOT NULL FOREIGN KEY REFERENCES Suppliers(SupplierID),
    StockQuantity INT NOT NULL CHECK (StockQuantity >= 0),
    ReorderLevel INT DEFAULT 10,
    LastRestockDate DATE
);
```

### Creating Views

Multiple SQL views were created to support operational reporting, inventory monitoring, sales analysis, customer history tracking, employee performance evaluation, and comprehensive order reporting.

```sql
-- View for inventory monitoring to check low stock product
CREATE VIEW vw_LowStockProducts AS
SELECT
    p.ProductID,
    p.ProductName,
    p.Category,
    p.StockQuantity,
    p.ReorderLevel,
    s.SupplierName
FROM Products p
JOIN Suppliers s
    ON p.SupplierID = s.SupplierID
WHERE p.StockQuantity <= p.ReorderLevel;
```

### Stored Procedures

Stored procedures were implemented to support product search functionality, conditional customer order history retrieval, employee data management, and automated cleanup of completed orders.

```sql
-- Retrieving a customer’s full order and payment history, if they have an order today.

CREATE PROCEDURE sp_GetCustomerOrderHistoryIfOrderedToday
    @CustomerID INT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Orders
        WHERE CustomerID = @CustomerID
          AND CAST(OrderDate AS DATE) = CAST(GETDATE() AS DATE)
    )
    BEGIN
        SELECT
            o.OrderID,
            o.OrderDate,
            o.TotalAmount,
            o.PaymentStatus,
            o.PaymentMethod
        FROM Orders o
        WHERE o.CustomerID = @CustomerID
        ORDER BY o.OrderDate DESC;
    END
END;

```


### Data Retrieval

Sample SQL queries were written to answer key business questions related to customer spending behavior, order fulfillment, supplier relationships, and sales performance.

```sql
-- Query to retrieve customers older than 40 with total orders exceeding $5000

SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
WHERE DATEDIFF(YEAR, c.DateOfBirth, GETDATE()) > 40
GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName
HAVING SUM(o.TotalAmount) > 5000;
```

*"This project focuses on database design and querying and does not include a frontend or application layer."*






