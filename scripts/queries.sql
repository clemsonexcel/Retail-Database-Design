---------------------------------------

-- Customers older than 40 with total orders exceeding $5000


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


-- Orders linked to suppliers and employees

SELECT
    o.OrderID,
    o.OrderDate,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    s.SupplierName,
    o.PaymentStatus
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
    ON p.SupplierID = s.SupplierID;

-- Top 5 best-selling products by total revenue

SELECT TOP 5
    p.ProductName,
    SUM(od.Quantity) AS UnitsSold,
    SUM(od.LineTotal) AS TotalRevenue
FROM OrderDetails od
JOIN Products p
    ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalRevenue DESC;


-- Customers who have never placed an order

SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Email
FROM Customers c
LEFT JOIN Orders o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;
