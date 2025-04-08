


CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    InStock INT,
    CreatedAt DATETIME
);

SELECT * from Products;

-- Top 5 Most Expensive Products in Stock (query a)
SELECT TOP 5 ProductID, ProductName, Category, Price, InStock
FROM Products
WHERE InStock > 0
ORDER BY Price DESC;


-- Total Number of Products Added in the Last 30 Days (query b)
SELECT COUNT(*) AS TotalRecentProducts
FROM Products
WHERE CreatedAt >= DATEADD(DAY, -30, GETDATE());


-- Average Price per Category, Sorted Highest to Lowest (query c)
SELECT Category, AVG(Price) AS AvgPrice
FROM Products
GROUP BY Category
ORDER BY AvgPrice DESC;