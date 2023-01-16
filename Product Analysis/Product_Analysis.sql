---------------------------------------
-- ADVENTURE WORKS CYCLE : HR ANALYSIS --
---------------------------------------

--Author: Coumba Coulibaly
--Date: 09/01/2023 
--Tool used: MS SQL Server

USE AdventureWorks2019;


------------------------
--CASE STUDY QUESTIONS--
------------------------

--1. How many product do we manufacture?
SELECT COUNT(*) AS TotalNumberProduct
FROM Production.Product;

--2. How many product do we have by category? by sub-category?
-- By Subcategory
SELECT ps.[Name] AS Subcategory, COUNT(*) AS TotalNumberProduct 
FROM Production.Product p
FULL JOIN Production.ProductSubcategory ps 
ON ps.ProductSubcategoryID = p.ProductSubcategoryID
GROUP BY ps.[Name];

-- By Category
SELECT pc.[Name] AS Category, ps.[Name] AS Subcategory, COUNT(p.ProductID) AS TotalNumberProduct 
FROM Production.ProductSubcategory ps
FULL JOIN  Production.Product p
ON ps.ProductSubcategoryID = p.ProductSubcategoryID
FULL JOIN Production.ProductCategory pc
ON pc.ProductCategoryID = ps.ProductCategoryID
GROUP BY pc.[Name], ps.[Name]
ORDER BY pc.[Name];

--3. How many product do we have by productline? by style? by class?
--by productline R = Road, M = Mountain, T = Touring, S = Standard
SELECT ProductLine, COUNT(*) AS TotalNumberProduct 
FROM Production.Product
GROUP BY ProductLine;

--by style W = Womens, M = Mens, U = Universal
SELECT Style, COUNT(*) AS TotalNumberProduct 
FROM Production.Product
GROUP BY Style;

--by class H = High, M = Medium, L = Low
SELECT Class, COUNT(*) AS TotalNumberProduct 
FROM Production.Product
GROUP BY Class;

--4. What are the product that aren't sell by the company anymore?
SELECT *
FROM Production.Product 
WHERE SellEndDate IS NOT NULL;

--5. How many product model do we have?
SELECT COUNT(*) AS TotalNumberModel 
FROM Production.ProductModel;

--6. What is the average cost of product? by category? by sub-category? by productline? by style? by class?
SELECT AVG(StandardCost) AS AverageProductCost
FROM Production.Product
WHERE StandardCost <> 0;

-- By Subcategory
SELECT ps.[Name] AS Subcategory , AVG(p.StandardCost) AS AverageProductCost
FROM Production.Product p
FULL JOIN Production.ProductSubcategory ps 
ON p.ProductSubcategoryID = ps.ProductSubcategoryID
AND StandardCost <> 0
GROUP BY ps.[Name];

-- By Category
SELECT pc.[Name] AS Category, ps.[Name] AS Subcategory, AVG(p.StandardCost) AS AverageProductCost 
FROM Production.ProductSubcategory ps
FULL JOIN  Production.Product p
ON ps.ProductSubcategoryID = p.ProductSubcategoryID AND StandardCost <> 0
FULL JOIN Production.ProductCategory pc
ON pc.ProductCategoryID = ps.ProductCategoryID
GROUP BY pc.[Name], ps.[Name]
ORDER BY pc.[Name];

-- By Productline
SELECT ProductLine, AVG(StandardCost) AS AverageProductCost
FROM Production.Product
WHERE StandardCost <> 0
GROUP BY ProductLine;

-- By Style
SELECT Style, AVG(StandardCost) AS AverageProductCost
FROM Production.Product
WHERE StandardCost <> 0
GROUP BY Style;

-- By Class
SELECT Class, AVG(StandardCost) AS AverageProductCost
FROM Production.Product
WHERE StandardCost <> 0
GROUP BY Class;

--7. What is the average listing price of product? by category? by sub-category? by productline? by style? by class?
SELECT AVG(ListPrice) AS AverageProductListingPrice
FROM Production.Product
WHERE ListPrice <> 0;

-- By Subcategory
SELECT ps.[Name] AS Subcategory , AVG(p.ListPrice) AS AverageProductListingPrice
FROM Production.Product p
FULL JOIN Production.ProductSubcategory ps 
ON p.ProductSubcategoryID = ps.ProductSubcategoryID
AND p.ListPrice <> 0
GROUP BY ps.[Name];

-- By Category
SELECT pc.[Name] AS Category, ps.[Name] AS Subcategory, AVG(p.ListPrice) AS AverageProductListingPrice 
FROM Production.ProductSubcategory ps
FULL JOIN  Production.Product p
ON ps.ProductSubcategoryID = p.ProductSubcategoryID AND p.ListPrice <> 0
FULL JOIN Production.ProductCategory pc
ON pc.ProductCategoryID = ps.ProductCategoryID
GROUP BY pc.[Name], ps.[Name]
ORDER BY pc.[Name];

-- By Productline
SELECT ProductLine, AVG(ListPrice) AS AverageProductListingPrice
FROM Production.Product
WHERE ListPrice <> 0
GROUP BY ProductLine;

-- By Style
SELECT Style, AVG(ListPrice) AS AverageProductListingPrice
FROM Production.Product
WHERE ListPrice <> 0
GROUP BY Style;

-- By Class
SELECT Class, AVG(ListPrice) AS AverageProductListingPrice
FROM Production.Product
WHERE ListPrice <> 0
GROUP BY Class;

--8. How many product did we sell through our channels (physical stores, marketing, online stores, refferals) this year?
SELECT *
FROM Sales.SalesOrderHeader

SELECT *
FROM Sales.Store


--Sales through marketing and referrals
SELECT sr.[Name] AS Channels, COUNT(so.SalesOrderID) AS TotalNumberOrder
FROM Sales.SalesOrderHeaderSalesReason so
JOIN Sales.SalesReason sr 
ON so.SalesReasonID = sr.SalesReasonID AND YEAR(so.ModifiedDate) = '2014' 
AND (SR.ReasonType = 'Marketing' OR SR.ReasonType = 'Promotion' OR SR.[Name] = 'Review')
GROUP BY sr.[Name];

--9. How many purchase do we have by product during the year?
SELECT od.ProductID, p.[Name] AS Product, COUNT(*) AS TotalNumberOrder
FROM Sales.SalesOrderDetail od
JOIN Sales.SalesOrderHeader oh
ON od.SalesOrderID = oh.SalesOrderID 
JOIN Production.Product p
ON p.ProductID = od.ProductID
WHERE YEAR(oh.OrderDate) = '2014'
GROUP BY od.ProductID, p.[Name]
ORDER BY TotalNumberOrder DESC;

--10. How many purchase do we have by product during the year?


--11. Which products are the most purchase by customers? (Same question for category, sub-category, productline, style and class)


--12. What is the total revenue by each? by category? by sub-category? by productline? by style? by class?