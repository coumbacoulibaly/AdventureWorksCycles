# 🚲 Adventure Works Cycle : Manufacturing Analysis

## Solution

View the complete syntax [here](https://github.com/coumbacoulibaly/AdventureWorksCycles/blob/master/Manufacturing%20Analysis/Manufacturing_Analysis.sql).

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
Use **AVG** and **DATEDIFF** to calculate the average days between the order ````StartDate```` and ````EndDate````
#### Answer:
![Question1](https://user-images.githubusercontent.com/119062221/213715112-68029f17-d4be-4984-aafa-9603199ca8fe.png)
![Question1_2](https://user-images.githubusercontent.com/119062221/213715155-deaa7c8f-1997-4626-9652-83cd0058f4b8.png)

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
![Question2](https://user-images.githubusercontent.com/119062221/213715191-bb60f065-f4c6-4f02-b941-bf31881c7797.png)

***
### 3. How product was scraped this year? find the scrape rate (percentage of production that is discarded as waste)

````sql
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
````

#### Steps:
Use **SUM** to find out ```TotalOrderQty```, ```TotalScrappedQty``` and ```ScrapRate```.

#### Answer:
![Question3](https://user-images.githubusercontent.com/119062221/213715265-f4f130df-c0af-4781-a8e1-83ba2856c6d2.png)
![Question3_1](https://user-images.githubusercontent.com/119062221/213717904-18cc18cd-8107-481e-8c81-1b8775deb46c.png)

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
![Question4](https://user-images.githubusercontent.com/119062221/213715330-f78ce5b3-df10-41a3-9421-d5996a769d9f.png)


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
- Create a temp table ````cte_lead_time```` to calculate ````TotalResourceHrs```` allocate to each order.
- Use **AVG** to find the average time in hour.
#### Answer :
![Question5](https://user-images.githubusercontent.com/119062221/213716872-adbfaf9a-e36e-463f-93ae-df4e4c421279.png)

***

### 6. What is the Yield of the factory (the proportion of good units produced out of total units started)?
````sql
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
````
#### Steps:
Use **SUM** to find out ```TotalOrderQty```, ```TotalStockedQty``` and ```Yield```.

#### Answer:
![Question6](https://user-images.githubusercontent.com/119062221/213717029-36324484-fc49-424b-bb09-86f9d389b37c.png)
![Question6_2](https://user-images.githubusercontent.com/119062221/213718013-db4ff8d0-1720-420e-ab58-cff73cb16919.png)

***


