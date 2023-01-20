---------------------------------------
-- ADVENTURE WORKS CYCLE : MANUFACTURING ANALYSIS --
---------------------------------------

--Author: Coumba Coulibaly
--Date: 09/01/2023 
--Tool used: MS SQL Server


USE AdventureWorks2019;


------------------------
--CASE STUDY QUESTIONS--
------------------------

--1. How much time it takes for the factory to manufacture a product in average? let also see it throught out the years?

-- Average day of order completion in 2014
SELECT AVG( DATEDIFF( day, StartDate, EndDate ) ) as AvgCompletionDay
FROM Production.WorkOrder
WHERE YEAR(ModifiedDate) = '2014';

-- Average day of order completion in past years
SELECT  YEAR(ModifiedDate) as [Year], AVG( DATEDIFF( day, StartDate, EndDate ) ) as AvgCompletionDay
FROM Production.WorkOrder
GROUP BY YEAR(ModifiedDate);

--2. How many orders has passed the inspection this year (2014) without any scraped items?
SELECT COUNT(*) AS TotalNumberOrder
FROM Production.WorkOrder
WHERE ScrappedQty = 0 AND YEAR(ModifiedDate) = '2014';

--3. How many products was scraped this year? find the scrap rate (percentage of production that is discarded as waste)

SELECT SUM( OrderQty ) AS TotalOrderQty, 
		SUM( ScrappedQty ) AS TotalScrappedQty, 
		ROUND( ( SUM( ScrappedQty ) * 100.00 / SUM(OrderQty ) ), 3 ) AS ScrapRate
FROM Production.WorkOrder
WHERE YEAR(ModifiedDate) = '2014';

-- Throught out the years
SELECT YEAR(ModifiedDate) AS [Years], SUM( OrderQty ) AS TotalOrderQty, 
		SUM( ScrappedQty ) AS TotalScrappedQty, 
		ROUND( ( SUM( ScrappedQty ) * 100.00 / SUM(OrderQty ) ), 3 ) AS ScrapRate
FROM Production.WorkOrder
GROUP BY YEAR(ModifiedDate)
ORDER BY ScrapRate;

--4. What was the most frequent scrap reason?
SELECT TOP 5 WO.ScrapReasonID, SR.[Name] AS ScrapReason, COUNT(*) as NumberOfOrder
FROM Production.WorkOrder WO
INNER JOIN Production.ScrapReason SR
ON WO.ScrapReasonID = SR.ScrapReasonID
GROUP BY WO.ScrapReasonID, SR.[Name]
ORDER BY NumberOfOrder DESC;

--5. What is the average lead time (time it takes to complete a manufacturing process from the start of production to the delivery of the finished product)?
WITH cte_lead_time (WorkOrderID, TotalResourceHrs)	AS (
SELECT WorkOrderID, SUM(ActualResourceHrs) AS TotalResourceHrs
FROM Production.WorkOrderRouting
WHERE YEAR(ModifiedDate) = '2014'
GROUP BY WorkOrderID
)
SELECT AVG(TotalResourceHrs) AS AvgLeadTime
FROM cte_lead_time;

--6. What is the Yield of the factory (the proportion of good units produced out of total units started)?
SELECT SUM( OrderQty ) AS TotalOrderQty, 
		SUM( StockedQty ) AS TotalStockedQty, 
		ROUND( ( SUM( StockedQty ) * 100.00 / SUM(OrderQty ) ), 3 ) AS Yield
FROM Production.WorkOrder
WHERE YEAR(ModifiedDate) = '2014';

-- Throught out the years
SELECT YEAR(ModifiedDate) AS [Years], SUM( OrderQty ) AS TotalOrderQty, 
		SUM( StockedQty ) AS TotalStockedQty, 
		ROUND( ( SUM( StockedQty ) * 100.00 / SUM(OrderQty ) ), 3 ) AS Yield
FROM Production.WorkOrder
GROUP BY YEAR(ModifiedDate)
ORDER BY Yield;
