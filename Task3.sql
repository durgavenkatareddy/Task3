create database hello;
use hello;
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Country VARCHAR(50)
);

INSERT INTO Customers (CustomerID, CustomerName, Country) VALUES
(1, 'Alice Johnson', 'USA'),
(2, 'Bob Smith', 'Canada'),
(3, 'Charlie Brown', 'UK'),
(4, 'Diana Prince', 'USA'),
(5, 'Ethan Hunt', 'Australia');
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    CustomerID INT,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Orders (OrderID, OrderDate, CustomerID, TotalAmount) VALUES
(101, '2024-01-15', 1, 250.00),
(102, '2024-02-10', 1, 500.00),
(103, '2024-02-25', 2, 300.00),
(104, '2024-03-05', 3, 150.00),
(105, '2024-04-01', 5, 800.00),
(106, '2024-04-15', 2, 200.00),
(107, '2024-05-01', 4, 450.00);

SELECT Customers.CustomerName, COUNT(Orders.OrderID) AS TotalOrders
FROM Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE Orders.OrderDate >= '2024-01-01'
GROUP BY Customers.CustomerName
ORDER BY TotalOrders DESC;

-- Show customers who have placed at least one order
SELECT 
    Customers.CustomerName, 
    Orders.OrderID, 
    Orders.TotalAmount
FROM 
    Customers
INNER JOIN 
    Orders ON Customers.CustomerID = Orders.CustomerID;

-- Show all customers, even if they have no orders
SELECT 
    Customers.CustomerName, 
    Orders.OrderID
FROM 
    Customers
LEFT JOIN 
    Orders ON Customers.CustomerID = Orders.CustomerID;

-- Show all orders, even if there is no matching customer
SELECT 
    Customers.CustomerName, 
    Orders.OrderID
FROM 
    Customers
RIGHT JOIN 
    Orders ON Customers.CustomerID = Orders.CustomerID;

-- Customers whose average order amount is higher than the overall average
SELECT 
    CustomerName
FROM 
    Customers
WHERE 
    CustomerID IN (
        SELECT 
            CustomerID
        FROM 
            Orders
        GROUP BY 
            CustomerID
        HAVING 
            AVG(TotalAmount) > (SELECT AVG(TotalAmount) FROM Orders)
    );
-- Show total and average order amounts by each customer
SELECT 
    Customers.CustomerName,
    SUM(Orders.TotalAmount) AS TotalSales,
    AVG(Orders.TotalAmount) AS AvgOrderValue
FROM 
    Customers
INNER JOIN 
    Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY 
    Customers.CustomerName;




-- Now recreate the view
CREATE VIEW MonthlySalesView AS
SELECT 
    YEAR(OrderDate) AS SalesYear,
    MONTH(OrderDate) AS SalesMonth,
    SUM(TotalAmount) AS MonthlySales
FROM 
    Orders
GROUP BY 
    YEAR(OrderDate), MONTH(OrderDate);
    
    
-- Drop the existing view
DROP VIEW MonthlySalesView;

CREATE VIEW MonthlySalesView AS
SELECT 
    YEAR(OrderDate) AS SalesYear,
    MONTH(OrderDate) AS SalesMonth,
    SUM(TotalAmount) AS MonthlySales
FROM 
    Orders
GROUP BY 
    YEAR(OrderDate), MONTH(OrderDate);

DROP VIEW IF EXISTS MonthlySalesView;

CREATE VIEW MonthlySalesView AS
SELECT 
    YEAR(OrderDate) AS SalesYear,
    MONTH(OrderDate) AS SalesMonth,
    SUM(TotalAmount) AS MonthlySales
FROM 
    Orders
GROUP BY 
    YEAR(OrderDate), MONTH(OrderDate);

SELECT * FROM MonthlySalesView WHERE MonthlySales > 500;

-- Create an index on CustomerID to speed up JOINs
CREATE INDEX idx_orders_customerid ON Orders(CustomerID);

-- Create another index on OrderDate + TotalAmount (optional for analysis queries)
CREATE INDEX idx_orders_orderdate_totalamount ON Orders(OrderDate, TotalAmount);

-- View all indexes created
SHOW INDEX FROM Orders;



