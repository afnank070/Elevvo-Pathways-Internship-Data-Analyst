-- Task 5: SQL-Based Product Sales Analysis (Chinook DB)

-- 1. Top-Selling Tracks (Products)
SELECT 
  Track.Name AS ProductName,
  SUM(InvoiceLine.Quantity) AS UnitsSold
FROM InvoiceLine
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
GROUP BY ProductName
ORDER BY UnitsSold DESC
LIMIT 10;

-- 2. Revenue by Country
SELECT 
  Customer.Country,
  ROUND(SUM(Invoice.Total), 2) AS TotalRevenue
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
GROUP BY Customer.Country
ORDER BY TotalRevenue DESC;

-- 3. Monthly Sales Trend
SELECT 
  SUBSTR(InvoiceDate, 1, 7) AS Month,  -- yyyy-MM format
  ROUND(SUM(Total), 2) AS MonthlyRevenue
FROM Invoice
GROUP BY Month
ORDER BY Month;

-- 4. Top Artists by Units Sold
SELECT 
  Artist.Name AS ArtistName,
  SUM(InvoiceLine.Quantity) AS UnitsSold
FROM InvoiceLine
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
JOIN Album ON Track.AlbumId = Album.AlbumId
JOIN Artist ON Album.ArtistId = Artist.ArtistId
GROUP BY ArtistName
ORDER BY UnitsSold DESC
LIMIT 10;

-- 5. Best Customers by Spend
SELECT 
  Customer.FirstName || ' ' || Customer.LastName AS CustomerName,
  ROUND(SUM(Invoice.Total), 2) AS TotalSpent
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
GROUP BY Customer.CustomerId
ORDER BY TotalSpent DESC
LIMIT 10;

-- 6. Bonus: Top 5 Customers per Country using ROW_NUMBER()
SELECT *
FROM (
    SELECT 
      Customer.Country,
      Customer.FirstName || ' ' || Customer.LastName AS CustomerName,
      ROUND(SUM(Invoice.Total), 2) AS TotalSpent,
      ROW_NUMBER() OVER (PARTITION BY Customer.Country ORDER BY SUM(Invoice.Total) DESC) AS RankInCountry
    FROM Invoice
    JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
    GROUP BY Customer.CustomerId
)
WHERE RankInCountry <= 5;
