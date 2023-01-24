----------------------------------------------------
-- ADVENTURE WORKS CYCLE : INVENTORY ANALYSIS --
----------------------------------------------------

--Author: Coumba Coulibaly
--Date: 09/01/2023 
--Tool used: MS SQL Server


USE AdventureWorks2019;


------------------------
--CASE STUDY QUESTIONS--
------------------------
--1. What is the average safety stock level?
SELECT AVG(SafetyStockLevel) AS AvgSafetyStockLevel
FROM Production.Product;

--2. How much does it cost to store and maintain the inventory?
SELECT *
FROM Production.ProductInventory

SELECT *
FROM Production.Location

--3. What is the order lead time (time it takes to receive a product after placing an order)? 
WITH cte_lead_time (WorkOrderID, TotalResourceHrs)	AS (
		SELECT WorkOrderID, SUM(ActualResourceHrs) AS TotalResourceHrs
		FROM Production.WorkOrderRouting
		WHERE YEAR(ModifiedDate) = '2014'
		GROUP BY WorkOrderID
)
SELECT AVG(TotalResourceHrs) AS AvgLeadTime
FROM cte_lead_time;


--4. What is the Fill rate (percentage of customer orders that are fulfilled on time and in full)?
SELECT COUNT(*) AS TotalFulfilledOrders, 
		(COUNT(*) * 100.00/(SELECT COUNT(*) FROM Sales.SalesOrderHeader WHERE YEAR(OrderDate) = '2014')) AS FillRate
FROM Sales.SalesOrderHeader
WHERE DueDate >= ShipDate AND YEAR(OrderDate) = '2014';

--5. What is the Backorder rate (percentage of customer orders that cannot be fulfilled on time)?
SELECT COUNT(*) AS TotalUnfulfilledOrders, 
		(COUNT(*) * 100.00/(SELECT COUNT(*) FROM Sales.SalesOrderHeader WHERE YEAR(OrderDate) = '2014')) AS BackOrderRate
FROM Sales.SalesOrderHeader
WHERE DueDate < ShipDate AND YEAR(OrderDate) = '2014'

--6. Calculate the Gross Margin 
SELECT ProductID, (((ListPrice - StandardCost)/ListPrice) * 100) AS GrossMargin
FROM Production.Product
WHERE ListPrice <> 0 AND StandardCost <> 0;

