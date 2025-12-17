
-- Stored Procedures & Functions
------------------------------------------ 
 


-- Search for a product by name, returning results sorted by most recent purchase date**.

CREATE PROCEDURE sp_SearchProductByName
    @ProductName NVARCHAR(100)
AS
BEGIN
    SELECT
        p.ProductID,
        p.ProductName,
        p.Category,
        p.Price,
        MAX(o.OrderDate) AS LastPurchaseDate
    FROM Products p
    LEFT JOIN OrderDetails od
        ON p.ProductID = od.ProductID
    LEFT JOIN Orders o
        ON od.OrderID = o.OrderID
    WHERE p.ProductName LIKE '%' + @ProductName + '%'
    GROUP BY
        p.ProductID,
        p.ProductName,
        p.Category,
        p.Price
    ORDER BY LastPurchaseDate DESC;
END;



-- Retrieve a customer’s full order and payment history, if they have an order today.

-- this First checks if the customer placed an order today
--If yes → returns all historical orders
-- If no → returns nothing


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




-- Update an Employee’s Details: Job role and department

CREATE PROCEDURE sp_UpdateEmployeeDetails
    @EmployeeID INT,
    @NewPosition NVARCHAR(50),
    @NewDepartmentID INT
AS
BEGIN
    UPDATE Employees
    SET
        Position = @NewPosition,
        DepartmentID = @NewDepartmentID
    WHERE EmployeeID = @EmployeeID;
END;


-- Delete completed orders after a certain peroid
CREATE PROCEDURE sp_DeleteOldCompletedOrders
    @DaysOld INT
AS
BEGIN
    DELETE FROM Orders
    WHERE PaymentStatus = 'Completed'
      AND OrderDate < DATEADD(DAY, -@DaysOld, GETDATE());
END;
-- this could actually also be archived

