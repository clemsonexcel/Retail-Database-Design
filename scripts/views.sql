-----------------------------------------
-- view displaying all previous and current orders, showing
-- Order date, product details, customer name, payment status, supplier name, and employee handling the order
-- Include any customer reviews
-----------------------------------------



-- Order Summary Views
CREATE VIEW vw_OrderSummary AS
SELECT
    o.OrderID,
    o.OrderDate,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    o.TotalAmount,
    o.PaymentStatus
FROM Orders o
JOIN Customers c
    ON o.CustomerID = c.CustomerID;


-- Low stock products - Inventory monitoring
--Stock is low when StockQuantity <= ReorderLevel

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


-- Sales by Product - Revenue analysis
-- help understand top-selling product and revenue contribution per product

CREATE VIEW vw_SalesByProduct AS
SELECT
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity) AS TotalUnitsSold,
    SUM(od.LineTotal) AS TotalRevenue
FROM OrderDetails od
JOIN Products p
    ON od.ProductID = p.ProductID
GROUP BY
    p.ProductID,
    p.ProductName;


-- Customer Order History 

CREATE VIEW vw_CustomerOrderHistory AS
SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    o.OrderID,
    o.OrderDate,
    o.TotalAmount,
    o.PaymentStatus
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID;


-- Employee Order Performance
-- to understand employee workload and performance

CREATE VIEW vw_EmployeeOrderPerformance AS
SELECT
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName,
    COUNT(o.OrderID) AS OrdersHandled,
    SUM(o.TotalAmount) AS TotalSalesValue
FROM Employees e
JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
LEFT JOIN Orders o
    ON e.EmployeeID = o.EmployeeID
GROUP BY
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    d.DepartmentName;
-- LEFT JOIN ensures employees with zero orders still appear


-- Full Order Details
CREATE VIEW vw_FullOrderDetails AS
SELECT
    o.OrderID,
    o.OrderDate,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    p.ProductName,
    p.Category,
    od.Quantity,
    od.UnitPrice,
    od.LineTotal,
    o.PaymentStatus,
    s.SupplierName,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    r.Rating,
    r.Comment AS ReviewComment
FROM Orders o
JOIN Customers c
    ON o.CustomerID = c.CustomerID
JOIN Employees e
    ON o.EmployeeID = e.EmployeeID
JOIN OrderDetails od
    ON o.OrderID = od.OrderID
JOIN Products p
    ON od.ProductID = p.ProductID
JOIN Suppliers s
    ON p.SupplierID = s.SupplierID
LEFT JOIN Reviews r
    ON r.ProductID = p.ProductID
   AND r.CustomerID = c.CustomerID;
