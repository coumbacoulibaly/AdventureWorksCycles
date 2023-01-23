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

--4. What is the days of supply (number of days that inventory will last at the current rate of consumption)?
SELECT pin.ProductID, od.ProductID, 
		SUM(od.OrderQty) AS QtySold, --Quantity of the product that has been sold since January 2014 to June 2014
		SUM(pin.Quantity) AS StockLevel -- Current Stock level at August 2014
		--((6 * SUM(pin.Quantity))/ SUM(od.OrderQty)) AS MonthsOfSupply
FROM Production.ProductInventory pin
FULL JOIN Sales.SalesOrderDetail od
ON od.ProductID = pin.ProductID
WHERE YEAR(pin.ModifiedDate) = 2014 AND YEAR(od.ModifiedDate) = 2014
GROUP BY pin.ProductID, od.ProductID;

SELECT ProductID, SUM(OrderQty) AS QtySold
FROM Sales.SalesOrderDetail
WHERE YEAR(ModifiedDate) = 2014
GROUP BY ProductID

SELECT ProductID, SUM(Quantity) AS StockLevel
FROM Production.ProductInventory
WHERE YEAR(ModifiedDate) = 2014
GROUP BY ProductID;

SELECT *
FROM Production.ProductInventory
WHERE YEAR(ModifiedDate) = 2014;

SELECT * 
FROM Sales.SalesOrderDetail
WHERE YEAR(ModifiedDate) = 2014




--5. What is the Fill rate (percentage of customer orders that are fulfilled on time and in full)?
SELECT COUNT(*) AS TotalFulfilledOrders, 
		(COUNT(*) * 100.00/(SELECT COUNT(*) FROM Sales.SalesOrderHeader WHERE YEAR(OrderDate) = '2014')) AS FillRate
FROM Sales.SalesOrderHeader
WHERE DueDate >= ShipDate AND YEAR(OrderDate) = '2014';

--6. What is the Backorder rate (percentage of customer orders that cannot be fulfilled on time)?
SELECT COUNT(*) AS TotalUnfulfilledOrders, 
		(COUNT(*) * 100.00/(SELECT COUNT(*) FROM Sales.SalesOrderHeader WHERE YEAR(OrderDate) = '2014')) AS BackOrderRate
FROM Sales.SalesOrderHeader
WHERE DueDate < ShipDate AND YEAR(OrderDate) = '2014'

---- Throught out the years
--SELECT YEAR(OrderDate) AS [Years],
--		COUNT(*) AS TotalUnfulfilledOrders, 
--		(COUNT(*) * 100.00/(SELECT COUNT(*) FROM Sales.SalesOrderHeader WHERE YEAR(OrderDate) = '2014')) AS BackOrderRate
--FROM Sales.SalesOrderHeader
--WHERE DueDate < ShipDate 
--GROUP BY YEAR(OrderDate);

--SELECT COUNT(*) 
--FROM Production.WorkOrderRouting 
--WHERE ScheduledEndDate < ActualEndDate AND YEAR(ActualStartDate) = '2014'

--SELECT *
--FROM Sales.SalesOrderHeader
--WHERE DueDate >= ShipDate AND YEAR(OrderDate) = '2014'

--7. What is the inventory turnover (number of times inventory is sold and replaced over a given period)?


--8. Calculate the Gross Margin (Net sales - cost of goods sold)
SELECT ProductID, (ListPrice - StandardCost  ) AS GrossMargin
FROM Production.Product
WHERE ListPrice <> 0 AND StandardCost <> 0;

