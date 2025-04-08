# Junior-SQL-DBA-Assignment-

# 1-Optimization Check:

Suggested Indexes to Improve Performance
To speed up queries like:

1-Filtering on InStock.
2-Sorting on Price.
3-Aggregating/grouping by Category.
4-Filtering on CreatedAt.

Composite Index

-- For query a (Top 5 expensive in-stock products)
CREATE NONCLUSTERED INDEX idx_InStock_Price ON Products (InStock, Price DESC);

-- For query b (Recent products)
CREATE NONCLUSTERED INDEX idx_CreatedAt ON Products (CreatedAt);

-- For query c (Average price per category)
CREATE NONCLUSTERED INDEX idx_Category ON Products (Category);


2-View Execution Plan for First Query

To see the estimated execution plan without actually running the query, we can use:

SET SHOWPLAN_ALL ON;
GO

SELECT TOP 5 ProductID, ProductName, Category, Price, InStock
FROM Products
WHERE InStock > 0
ORDER BY Price DESC;
GO

-- Turn it off afterward
SET SHOWPLAN_ALL OFF;



# 2-Approach

Product Analysis & Export - Explained

:-What Our Product Table Looks Like
We have a table called Products that stores info like:

ProductID: Unique product number

ProductName: The name of the product

Category: Type of product (like Electronics, Apparel, etc.)

Price: How much it costs

InStock: How many items are available

CreatedAt: When the product was added

- What We Wanted to Find Out
1. Top 5 Most Expensive Products in Stock
We wanted to see which high-end products are currently available.
- So, we looked for items that are in stock, sorted them by price (highest first), and picked the top 5.

3. How Many Products Were Added in the Last 30 Days
To track how many new products got added recently,
- we checked the CreatedAt date and counted everything from the last 30 days.

4. What’s the Average Price in Each Category
This helps us understand pricing trends by product type.
- We grouped products by category and calculated the average price for each one, then sorted them from highest to lowest.

Making These Queries Faster
To help the database run these queries more efficiently, we added some indexes:

1-One to help filter and sort by stock and price.
2-One to help quickly find recently added products.
3-One to group and get average prices by category.


:-Exporting Product Data to a CSV File
We also needed to export our data so it can be used in Excel or shared.

Two ways to do that:
Option 1: Command Line (sqlcmd)
You can run a simple command like this:

bash
Copy
Edit
sqlcmd -S <server_name> -d <database_name> -E -Q "SELECT * FROM Products" -s "," -W -o "C:\Exports\products.csv"
This saves the data as a .csv file with commas between columns.

Option 2: PowerShell

powershell
Copy
Edit
Invoke-Sqlcmd -Query "SELECT * FROM Products" -ServerInstance "<server_name>" -Database "<database_name>" |
Export-Csv -Path "C:\Exports\products.csv" -NoTypeInformation
This does the same thing but uses PowerShell commands.

1.These queries and exports help with reporting, monitoring, and business decisions.
2.The logic is simple, but performance can be improved a lot with the right indexes.
3.Exporting is useful for backups, Excel reports, or sharing with non-technical folks.



# 3-Real-World Handling of a Slow Product Search

Real-World Handling of a Slow Product Search

1. Understand the Problem
Start by clarifying with the developer or product team:
- What exactly is slow — the product search API, a dashboard, a report?
- Is it slow all the time or only with certain filters (e.g., sorting by price, filtering by stock)?
- What's the query being run?


2. Analyze the Query
Once you have the SQL query:
- Run it in SQL Server Management Studio (SSMS).
- Use SET STATISTICS IO, TIME ON; or SET SHOWPLAN_ALL ON; to inspect performance.
- Check for things like:
  - Table scans (bad for performance)
  - Missing indexes
  - High read/write costs

Look at execution plans and cost distribution.


3. Check Table Structure & Indexes
- Review the schema — are there indexes on commonly filtered columns like InStock, Category, or CreatedAt?
- If not, create or suggest non-clustered indexes that match the query patterns (especially for WHERE, ORDER BY, and JOIN clauses).
  
 
 Use covering indexes when possible to avoid key lookups.

4.Optimize the Query
Refactor the query if needed:
- Reduce unnecessary columns in SELECT
- Use TOP with an ORDER BY to limit result sets
- Avoid functions in WHERE clause if possible (they break index usage)

Example: sql
Bad
WHERE DATEDIFF(DAY, CreatedAt, GETDATE()) < 30
Good
WHERE CreatedAt >= DATEADD(DAY, -30, GETDATE())

5.Export or Report the Data
If the team needs this data externally:
- Use a scheduled job (via SQL Agent or a script) to export it to CSV
- Use sqlcmd or PowerShell for automation
- Store files in shared folders or push to cloud buckets (e.g., S3, Azure Blob)

6.Monitor After the Fix
- Keep an eye on performance using database monitoring tools (like SQL Sentry, Redgate, or built-in DMVs).
- Ask the dev team if the changes helped — iterate if needed.



