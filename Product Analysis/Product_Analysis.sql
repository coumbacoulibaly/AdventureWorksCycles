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
WHERE StandardCost <> 0; --Use to filter BOM elements which cost are equal to 0.

-- By Subcategory
SELECT ps.[Name] AS Subcategory , AVG(p.StandardCost) AS AverageProductCost
FROM Production.Product p
FULL JOIN Production.ProductSubcategory ps 
ON p.ProductSubcategoryID = ps.ProductSubcategoryID
AND StandardCost <> 0 --Use to filter BOM elements which cost are equal to 0.
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
WHERE StandardCost <> 0 --Use to filter BOM elements which cost are equal to 0.
GROUP BY ProductLine;

-- By Style
SELECT Style, AVG(StandardCost) AS AverageProductCost
FROM Production.Product
WHERE StandardCost <> 0 --Use to filter BOM elements which cost are equal to 0.
GROUP BY Style;

-- By Class
SELECT Class, AVG(StandardCost) AS AverageProductCost
FROM Production.Product
WHERE StandardCost <> 0 --Use to filter BOM elements which cost are equal to 0.
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
-- Online Store Orders 
SELECT COUNT(*) AS TotalNumberOrder
FROM Sales.SalesOrderHeader
WHERE OnlineOrderFlag = '1' AND YEAR(OrderDate) = '2014';

-- Physical Stores Orders 
SELECT COUNT(*) AS TotalNumberOrder
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL AND YEAR(OrderDate) = '2014';

--Orders from marketing and referrals
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

--10. Which product is the most purchase by customers during the past years?
WITH cte_product_ordered ([YEAR], ProductID, ProductName, OrderNumber) AS (
	SELECT YEAR(oh.OrderDate) as [YEAR], od.ProductID, p.[Name] AS ProductName, 
			COUNT(*) as OrderNumber
	FROM Sales.SalesOrderDetail od
	JOIN Sales.SalesOrderHeader oh
	ON od.SalesOrderID = oh.SalesOrderID 
	JOIN Production.Product p
	ON p.ProductID = od.ProductID
	GROUP BY YEAR(oh.OrderDate), od.ProductID, p.[Name]
)

SELECT po.[YEAR], po.ProductID, po.ProductName, po.OrderNumber
FROM cte_product_ordered po
INNER JOIN 
(SELECT [YEAR], MAX(OrderNumber) as MaxOrderNumber
FROM cte_product_ordered 
GROUP BY [YEAR]) pom
ON po.[YEAR] = pom.[YEAR] AND po.OrderNumber = pom.MaxOrderNumber;

--11. Which products are the most purchase by category? by sub-category?
-- By Subcategory
WITH cte_subcategory(ProductSubcategoryID, SubcategoryName, ProductID, ProductName) AS (
	SELECT ps.ProductSubcategoryID, ps.[Name] AS SubcategoryName, p.ProductID, p.[Name] AS ProductName
	FROM Production.Product p
	FULL JOIN Production.ProductSubcategory ps 
	ON p.ProductSubcategoryID = ps.ProductSubcategoryID
),
cte_product_ordered (ProductSubcategoryID, SubcategoryName, ProductID, ProductName, OrderNumber) AS (
	SELECT  s.ProductSubcategoryID,
			s.SubcategoryName,
			od.ProductID, 
			s.ProductName, 
			COUNT(*) as OrderNumber
	FROM Sales.SalesOrderDetail od
	JOIN Sales.SalesOrderHeader oh
	ON od.SalesOrderID = oh.SalesOrderID 
	FULL JOIN cte_subcategory s
	ON s.ProductID = od.ProductID
	WHERE YEAR(oh.OrderDate) = '2014'
	GROUP BY s.ProductSubcategoryID, s.SubcategoryName, od.ProductID, s.ProductName
)
SELECT  po.ProductSubcategoryID, po.SubcategoryName, po.ProductID, po.ProductName, po.OrderNumber
FROM cte_product_ordered po
INNER JOIN 
(SELECT ProductSubcategoryID, MAX(OrderNumber) as MaxOrderNumber
FROM cte_product_ordered 
GROUP BY ProductSubcategoryID) pom
ON po.ProductSubcategoryID = pom.ProductSubcategoryID AND po.OrderNumber = pom.MaxOrderNumber
ORDER BY po.OrderNumber DESC;

-- By Category
WITH cte_Category(Category, SubcategoryName, ProductID, ProductName) AS (
	SELECT pc.[Name] AS Category, ps.[Name] AS SubcategoryName, p.ProductID, p.[Name] AS ProductName
	FROM Production.ProductSubcategory ps
	FULL JOIN  Production.Product p
	ON p.ProductSubcategoryID = ps.ProductSubcategoryID
	FULL JOIN Production.ProductCategory pc
	ON pc.ProductCategoryID = ps.ProductCategoryID
	GROUP BY pc.[Name], ps.[Name], p.ProductID, p.[Name]
),
cte_product_ordered (Category, SubcategoryName, ProductID, ProductName, OrderNumber) AS (
	SELECT  s.Category,
			s.SubcategoryName,
			od.ProductID, 
			s.ProductName, 
			COUNT(*) as OrderNumber
	FROM Sales.SalesOrderDetail od
	JOIN Sales.SalesOrderHeader oh
	ON od.SalesOrderID = oh.SalesOrderID 
	FULL JOIN cte_subcategory s
	ON s.ProductID = od.ProductID
	WHERE YEAR(oh.OrderDate) = '2014'
	GROUP BY s.Category, s.SubcategoryName, od.ProductID, s.ProductName
)
SELECT  po.Category, po.SubcategoryName, po.ProductID, po.ProductName, po.OrderNumber
FROM cte_product_ordered po
INNER JOIN 
(SELECT Category, MAX(OrderNumber) as MaxOrderNumber
FROM cte_product_ordered 
GROUP BY Category) pom
ON po.Category = pom.Category AND po.OrderNumber = pom.MaxOrderNumber
ORDER BY po.OrderNumber DESC;

--12. What is the total revenue by each product this year?
WITH cte_numberproduct (ProductID, Product, TotalNumberOrder) AS (
	SELECT od.ProductID, p.[Name] AS Product, COUNT(*) AS TotalNumberOrder--, (  COUNT(*) * p.ListPrice ) AS TotalRevenue
	FROM Sales.SalesOrderDetail od
	JOIN Sales.SalesOrderHeader oh
	ON od.SalesOrderID = oh.SalesOrderID 
	JOIN Production.Product p
	ON p.ProductID = od.ProductID
	WHERE YEAR(oh.OrderDate) = '2014'
	GROUP BY od.ProductID, p.[Name]
)
SELECT p.ProductID, np.Product, np.TotalNumberOrder ,(np.TotalNumberOrder * p.ListPrice) AS TotalRevenue
FROM Production.Product p
JOIN cte_numberproduct np
ON p.ProductID = np.ProductID
ORDER BY TotalRevenue DESC;

--13. Which product makes the highest revenue this year by category? by sub-category?
-- By Subcategory
WITH cte_subcategory(ProductSubcategoryID, SubcategoryName, ProductID, ProductName) AS (
	SELECT ps.ProductSubcategoryID, ps.[Name] AS SubcategoryName, p.ProductID, p.[Name] AS ProductName
	FROM Production.Product p
	FULL JOIN Production.ProductSubcategory ps 
	ON p.ProductSubcategoryID = ps.ProductSubcategoryID
),
cte_numberproduct (ProductSubcategoryID, SubcategoryName, ProductID, ProductName, TotalNumberOrder) AS (
	SELECT s.ProductSubcategoryID, s.SubcategoryName, od.ProductID, s.ProductName, COUNT(*) AS TotalNumberOrder
	FROM Sales.SalesOrderDetail od
	JOIN Sales.SalesOrderHeader oh
	ON od.SalesOrderID = oh.SalesOrderID 
	JOIN cte_subcategory s
	ON s.ProductID = od.ProductID
	WHERE YEAR(oh.OrderDate) = '2014'
	GROUP BY s.ProductSubcategoryID, s.SubcategoryName, od.ProductID, s.ProductName
),
cte_revenue (ProductSubcategoryID, SubcategoryName, ProductID, ProductName, TotalNumberOrder, TotalRevenue) AS (
	SELECT np.ProductSubcategoryID, np.SubcategoryName, np.ProductID, np.ProductName, 
			TotalNumberOrder, 
			(np.TotalNumberOrder * p.ListPrice) AS TotalRevenue
	FROM Production.Product p
	JOIN cte_numberproduct np	
	ON p.ProductID = np.ProductID
)
SELECT  r.ProductSubcategoryID, r.SubcategoryName, r.ProductID, r.ProductName, r.TotalNumberOrder, r.TotalRevenue
FROM cte_revenue r
INNER JOIN (
SELECT ProductSubcategoryID, MAX(TotalRevenue) AS MaxTotalRevenue
FROM cte_revenue 
GROUP BY ProductSubcategoryID) rm
ON r.ProductSubcategoryID = rm.ProductSubcategoryID AND r.TotalRevenue = rm.MaxTotalRevenue
ORDER BY r.TotalRevenue DESC;

-- By Category
WITH cte_category(Category, SubcategoryName, ProductID, ProductName) AS (
	SELECT pc.[Name] AS Category, ps.[Name] AS SubcategoryName, p.ProductID, p.[Name] AS ProductName
	FROM Production.ProductSubcategory ps
	FULL JOIN  Production.Product p
	ON p.ProductSubcategoryID = ps.ProductSubcategoryID
	FULL JOIN Production.ProductCategory pc
	ON pc.ProductCategoryID = ps.ProductCategoryID
	GROUP BY pc.[Name], ps.[Name], p.ProductID, p.[Name]
),
cte_product_ordered (Category, SubcategoryName, ProductID, ProductName, TotalNumberOrder) AS (
	SELECT  c.Category,
			c.SubcategoryName,
			od.ProductID, 
			c.ProductName, 
			COUNT(*) as TotalNumberOrder
	FROM Sales.SalesOrderDetail od
	JOIN Sales.SalesOrderHeader oh
	ON od.SalesOrderID = oh.SalesOrderID 
	FULL JOIN cte_category c
	ON c.ProductID = od.ProductID
	WHERE YEAR(oh.OrderDate) = '2014'
	GROUP BY c.Category, c.SubcategoryName, od.ProductID, c.ProductName
),
cte_revenue (Category, SubcategoryName, ProductID, ProductName, TotalNumberOrder, TotalRevenue) AS (
	SELECT np.Category, np.SubcategoryName, np.ProductID, np.ProductName, 
			np.TotalNumberOrder, 
			(np.TotalNumberOrder * p.ListPrice) AS TotalRevenue
	FROM Production.Product p
	JOIN cte_product_ordered np	
	ON p.ProductID = np.ProductID
)
SELECT  r.Category, r.SubcategoryName, r.ProductID, r.ProductName, r.TotalNumberOrder, r.TotalRevenue
FROM cte_revenue r
INNER JOIN (
SELECT Category, MAX(TotalRevenue) AS MaxTotalRevenue
FROM cte_revenue 
GROUP BY Category) rm
ON r.Category = rm.Category AND r.TotalRevenue = rm.MaxTotalRevenue
ORDER BY r.TotalRevenue DESC;