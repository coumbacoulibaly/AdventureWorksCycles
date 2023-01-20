# 🚲 Adventure Works Cycle : Product Analysis

## Solution

View the complete syntax [here](https://github.com/coumbacoulibaly/AdventureWorksCycles/blob/master/Product%20Analysis/Product_Analysis.sql).

***

### 1. How much time it takes for the factory to manufacture a product in average? let also see it throught out the years?
````sql
-- Average day of order completion in 2014
SELECT AVG( DATEDIFF( day, StartDate, EndDate ) ) as AvgCompletionDay
FROM Production.WorkOrder
WHERE YEAR(ModifiedDate) = '2014';

-- Average day of order completion in past years
SELECT  YEAR(ModifiedDate) as [Year], AVG( DATEDIFF( day, StartDate, EndDate ) ) as AvgCompletionDay
FROM Production.WorkOrder
GROUP BY YEAR(ModifiedDate);
````
#### Steps:

#### Answer:


***

### 2. How many orders has passed the inspection this year (2014) without any scraped items?
````sql
SELECT COUNT(*) AS TotalNumberOrder
FROM Production.WorkOrder
WHERE ScrappedQty = 0 AND YEAR(ModifiedDate) = '2014';

````
#### Steps:
Use **COUNT** to find out ```TotalNumberOrder``` and ***WHERE*** to filter the result.


#### Answer:


***
### 3. How product was scraped this year? find the scrape rate (percentage of production that is discarded as waste)

````sql
SELECT SUM( OrderQty ) AS TotalOrderQty, 
		SUM( ScrappedQty ) AS TotalScrappedQty, 
		ROUND( ( SUM( ScrappedQty ) * 100.00 / SUM(OrderQty ) ), 3 ) AS ScrapRate
FROM Production.WorkOrder
WHERE YEAR(ModifiedDate) = '2014';
````

#### Steps:
Use **SUM** to find out ```TotalOrderQty```, ```TotalScrappedQty``` and ```ScrapRate```.

#### Answer:


***

### 4. What was the most frequent scrap reason?
````sql
SELECT TOP 5 WO.ScrapReasonID, SR.[Name] AS ScrapReason, COUNT(*) as NumberOfOrder
FROM Production.WorkOrder WO
INNER JOIN Production.ScrapReason SR
ON WO.ScrapReasonID = SR.ScrapReasonID
GROUP BY WO.ScrapReasonID, SR.[Name]
ORDER BY NumberOfOrder DESC;
````
#### Steps:
**SELECT** the top 5 ```ScrapReason``` with the highest ```NumberOfOrder```.


#### Answer:

***

### 5. What is the lead time (time it takes to complete a manufacturing process from the start of production to the delivery of the finished product)?
````sql
WITH cte_lead_time (WorkOrderID, TotalResourceHrs)	AS (
SELECT WorkOrderID, SUM(ActualResourceHrs) AS TotalResourceHrs
FROM Production.WorkOrderRouting
WHERE YEAR(ModifiedDate) = '2014'
GROUP BY WorkOrderID
)
SELECT AVG(TotalResourceHrs) AS AvgLeadTime
FROM cte_lead_time;
````
#### Steps:

#### Answer :


***

### 6. What is the Yield of the factory (the proportion of good units produced out of total units started)?
````sql
SELECT SUM( OrderQty ) AS TotalOrderQty, 
		SUM( StockedQty ) AS TotalStockedQty, 
		ROUND( ( SUM( StockedQty ) * 100.00 / SUM(OrderQty ) ), 3 ) AS Yield
FROM Production.WorkOrder
WHERE YEAR(ModifiedDate) = '2014';
````
#### Steps:


#### Answer:

***


