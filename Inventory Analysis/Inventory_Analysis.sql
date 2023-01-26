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

--2. How much does it cost to store in the different inventory locations?
SELECT LocationID, [Name], CostRate
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

--6. What is the months of supply of the bikes (number of months that inventory will last at the current rate of consumption)?
WITH cte_bom (BillOfMaterialsID, ComponentID, ProductID, ProductName, PerAssemblyQty, ProductSubcategoryID) AS (
		SELECT bom.BillOfMaterialsID, 
		bom.ComponentID, 
		p.ProductID, 
		p.[Name] AS ProductName, 
		bom.PerAssemblyQty, 
		p.ProductSubcategoryID
		FROM Production.BillOfMaterials bom
		JOIN Production.Product p
		ON p.ProductID = bom.ComponentID
		WHERE BOMLevel = 0 --retrieve all bike finished products, all Bill of materials which are not component of other products. 
), 
cte_bike_stock_qty (ProductID, ProductName, StockLevel) AS (
	SELECT pin.ProductID, cbom.ProductName, SUM(pin.Quantity) AS StockLevel
	FROM Production.ProductInventory pin
	INNER JOIN cte_bom cbom
	ON cbom.ProductID = pin.ProductID
	GROUP BY pin.ProductID, cbom.ProductName -- Calculate the quantity of bike currently in the inventory
), 
cte_qtysold (ProductID, QtySold) AS(
	SELECT ProductID, SUM(OrderQty) AS QtySold
	FROM Sales.SalesOrderDetail
	WHERE YEAR(ModifiedDate) = 2014
	GROUP BY ProductID --Calculate the quantity of items sold within the  past six months
)
SELECT bsq.ProductID, bsq.ProductName, bsq.StockLevel, qs.QtySold, 
		((bsq.StockLevel *6)/qs.QtySold) AS MonthOfSupply -- Calculate the number of months the current stock will last compare to quantity sold in past 6 months
FROM cte_bike_stock_qty bsq
JOIN cte_qtysold qs
ON bsq.ProductID = qs.ProductID;

--7. Calculate the Gross Margin 
SELECT ProductID, (((ListPrice - StandardCost)/ListPrice) * 100) AS GrossMargin
FROM Production.Product
WHERE ListPrice <> 0 AND StandardCost <> 0;






