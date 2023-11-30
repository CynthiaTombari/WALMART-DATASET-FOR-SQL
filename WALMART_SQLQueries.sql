CREATE DATABASE Walmart;
USE Walmart;

SELECT TOP 1*
FROM [dbo].[Products];

SELECT TOP 1*
FROM [dbo].[Sales];

SELECT TOP 1*
FROM [dbo].[Store];


/* DETERMINE THE TOTAL SALES PROFIT FOR EACH PRODUCT*/

SELECT P.ProductName, ROUND(SUM(UnitPrice * Quantity),2) AS Total_sales_profit
FROM Products P
INNER JOIN Sales S
  ON P.ProductId = S.ProductId
GROUP BY P.ProductName
ORDER BY P.ProductName ASC;


/* WHAT IS THE TOTAL PRODUCTION COST FOR EACH PRODUCT*/

SELECT P.ProductName, ROUND(SUM(ProductCost * Quantity),2) AS Total_product_cost
FROM Products P
INNER JOIN Sales S
  ON P.ProductId = S.ProductId
GROUP BY P.ProductName
ORDER BY P.ProductName ASC;


/*SHOW ALL AVAILABLE PRODUCTS AND THEIR TOTAL SALES PROFIT*/

SELECT ST.ProductId, P.ProductName, SUM(QuantityAvailable) AS Quantity_Available, ROUND(SUM(QuantityAvailable * UnitPrice),2) AS Total_available_sales
FROM Products P
INNER JOIN Sales S
  ON P.ProductId = S.ProductId
INNER JOIN Store ST
  ON S.ProductId = ST.ProductId
GROUP BY P.ProductName,ST.ProductId
ORDER BY P.ProductName ASC;


/*SHOW ALL STORE ID, STORE NAME AND THEIR TOTAL SALES*/

SELECT S.StoreId, ST.StoreName, ROUND(SUM(UnitPrice * Quantity),2) AS Total_store_profit
FROM Sales S
LEFT JOIN Store ST
  ON S.ProductId = ST.ProductId
GROUP BY S.StoreId, ST.StoreName
ORDER BY Total_store_profit DESC;


/*DETERMINE THE QUANTITY SOLD BY STORE AND ADDRESS*/

SELECT ST.StoreName,ST.Address, ROUND(SUM(UnitPrice * Quantity),2) AS Total_store_profit, SUM(Quantity) AS Quantity_sold
FROM Sales S
INNER JOIN Store ST
  ON S.ProductId = ST.ProductId
GROUP BY ST.Address, ST.StoreName
ORDER BY Total_store_profit DESC;


/*WHAT NEIGHBORHOOD HAS THE LEAST SALES*/

SELECT TOP 5 ST.neighborhood, ROUND(SUM(UnitPrice * Quantity),2) AS Least_sales
FROM Store ST
INNER JOIN Sales S
  ON ST.ProductId = S.ProductId
GROUP BY ST.neighborhood
ORDER BY Least_sales ASC;


/*COMPARE THE TOTAL PRICE OF QUANTITY SOLD TO THE TOTAL PRICE OF AVAILABLE GOODS FOR EACH SUPPLIER*/

SELECT P.Supplier, ROUND(SUM(UnitPrice * Quantity),2) AS Goods_sold, ROUND(SUM(QuantityAvailable * UnitPrice),2) AS Goods_available
FROM Products P
INNER JOIN Sales S
  ON P.ProductId = S.ProductId
INNER JOIN Store ST
  ON S.ProductId = ST.ProductId
GROUP BY P.Supplier;


/*WHAT 3 PRODUCTS ARE MOST SUPPLIED*/

SELECT TOP 3 ProductName, COUNT(Supplier) AS Supplies,ROUND(SUM(UnitPrice * Quantity),2) AS Supply_profit
FROM Products P
INNER JOIN sales s
  ON P.ProductId = S.ProductId
GROUP BY P.ProductName
ORDER BY Supplies DESC;


/*SHOW THE AVERAGE PRODUCT COST FOR EACH PRODUCT*/

SELECT ProductName, ROUND(AVG(ProductCost), 2) AS Avg_cost
FROM Products P
GROUP BY P.ProductName;



/*ARE THERE ANY DIFFERENCE IN AVG UNIT PRICE OF PRODUCTS FOR EACH YEAR*/

SELECT DISTINCT YEAR(Date) AS Distinct_year, P.ProductName, ROUND(AVG(UnitPrice),2)AS Avg_unitprice
FROM Products P
INNER JOIN Sales S
  ON P.ProductId = S.ProductId
GROUP BY S.Date, P.ProductName
ORDER BY P.ProductName;



/*WHAT ARE THE MOST EXPENSIVE PRODUCTS TO PRODUCE*/

SELECT TOP 5 MAX(ProductCost)AS Most_expensive, P.ProductName
FROM Products P
GROUP BY ProductName
ORDER BY Most_expensive DESC;


/*WHAT SUPPLIERS SUPPLY THE LEAST AMOUNT OF PRODUCTS*/

SELECT TOP 5 Supplier, COUNT(ProductId) AS Quantity
FROM Products P
GROUP BY P.Supplier
ORDER BY Quantity ASC;


/*INCREASE THE UNIT PRICE OF PRODUCTS THAT BEGIN WITH 'A' */

SELECT P.ProductName, S.ProductId, S.UnitPrice,
CASE 
     WHEN S.UnitPrice < 5 THEN S.UnitPrice * 5
     WHEN S.UnitPrice >= 10 THEN S.UnitPrice *2
     ELSE S.UnitPrice *3
END AS Increased_price
FROM Products P
INNER JOIN Sales S
     ON P.ProductId = S.ProductId
WHERE P.ProductName LIKE 'A%'
GROUP BY P.ProductName,S.ProductId, S.UnitPrice
ORDER BY S.ProductId;