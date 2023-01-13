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

SELECT *
FROM Production.Product;

--2. How many product do we have by category? by sub-category?
-- By Subcategory
SELECT ps.[Name] AS Subcategory ,COUNT(*) AS TotalNumberProduct 
FROM Production.Product p
FULL JOIN Production.ProductSubcategory ps 
ON ps.ProductSubcategoryID = p.ProductSubcategoryID
GROUP BY ps.[Name];

-- By Category
--WITH cte_subcategory (ProductSubcategoryID, [Name], TotalNumberProduct) AS (
--		SELECT ps.ProductSubcategoryID, ps.[Name] AS Subcategory ,COUNT(*) AS TotalNumberProduct 
--		FROM Production.Product p
--		FULL JOIN Production.ProductSubcategory ps 
--		ON ps.ProductSubcategoryID = p.ProductSubcategoryID
--		GROUP BY ps.ProductSubcategoryID, ps.[Name]
--)

--SELECT pc.[Name], COUNT(*) AS TotalNumberProduct 
--FROM Production.ProductSubcategory ps
--JOIN cte_subcategory cs 
--ON ps.ProductSubcategoryID = cs.ProductSubcategoryID
--JOIN Production.ProductCategory pc
--ON pc.ProductCategoryID = pc.ProductCategoryID
--GROUP BY pc.[Name];

--SELECT pc.ProductCategoryID, COUNT(*) 
--FROM Production.ProductSubcategory ps
--JOIN Production.ProductCategory pc
--ON ps.ProductCategoryID = pc.ProductCategoryID
--GROUP BY pc.ProductCategoryID;

--3. How many product do we have by productline? by style? by class?


--4. What are the product that aren't sell by the company anymore?


--5. How many product model do we have?


--6. What is the average cost of product? by category? by sub-category? by productline? by style? by class?


--7. What is the average listing price of product? by category? by sub-category? by productline? by style? by class?


--8. How many product did we sell through our channels (physical stores, marketing, online stores, refferals)?


--9. How many purchase do we have by product during the year?


--10. How many purchase do we have by product during the year?


--11. Which products are the most purchase by customers? (Same question for category, sub-category, productline, style and class)


--12. What is the total revenue by each? by category? by sub-category? by productline? by style? by class?