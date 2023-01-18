# 🚲 Adventure Works Cycle : Product Analysis

## Solution

View the complete syntax [here](https://github.com/coumbacoulibaly/AdventureWorksCycles/blob/master/Product%20Analysis/Product_Analysis.sql).

***

### 1. How many product do we manufacture?
````sql
SELECT COUNT(*) AS TotalNumberProduct
FROM Production.Product;
````
#### Steps:
Use **COUNT** to count all the rows in the ```Product``` table 

#### Answer:
![Question1](https://user-images.githubusercontent.com/119062221/213140793-5f54e803-7bef-4439-a73b-fd0bcb8b590a.png)

***

### 2. How many product do we have by category? by sub-category?
````sql
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

````
#### Steps:
- Use **COUNT** and **GROUP BY** to find out ```TotalNumberProduct``` by each Subcategory and Category.
- To calculate ```TotalNumberProduct``` by each Category, use **JOIN** to merge ```ProductSubcategory```, ```Product``` and ```ProductCategory``` tables as the first one is linking the two tables.

#### Answer:
![Question2_1](https://user-images.githubusercontent.com/119062221/213142054-85e9825c-bb28-4978-b226-58add765fa68.png)
![Question2_2](https://user-images.githubusercontent.com/119062221/213142100-a3deb373-a4bb-4bfb-811a-20267412f0f4.png)

***
### 3. How many product do we have by productline? by style? by class?

````sql
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

````

#### Steps:
Use **COUNT** and **GROUP BY** to find out ```TotalNumberProduct``` by each Productline, Style and Class.

#### Answer:
![Question3_1](https://user-images.githubusercontent.com/119062221/213143607-17c24e83-69ed-4761-a1b6-c7a634f04d9d.png)
![Question3_2](https://user-images.githubusercontent.com/119062221/213143610-122eccd0-d521-4cae-bb63-0ed999429567.png)
![Question3_3](https://user-images.githubusercontent.com/119062221/213143597-120a43da-d811-48b2-8f9c-868b55861bd7.png)

***

### 4. What are the product that aren't sell by the company anymore?
````sql
SELECT *
FROM Production.Product 
WHERE SellEndDate IS NOT NULL;
````
#### Steps:
**SELECT** all product where ```SellEndDate``` is not null.

#### Answer:
![Question4](https://user-images.githubusercontent.com/119062221/213144573-3f7a7411-d5cc-47f1-9b35-16972885fbdc.png)

***

### 5. How many product model do we have?
````sql
SELECT COUNT(*) AS TotalNumberModel 
FROM Production.ProductModel;
````
#### Steps:
Use **COUNT** to count all the rows in the ```ProductModel``` table 
#### Answer :
![Question5](https://user-images.githubusercontent.com/119062221/213145450-7ca3d2bd-5707-4dba-ab94-b76c33d2423f.png)

***

### 6. What is the average cost of product? by category? by sub-category? by productline? by style? by class?
````sql

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
````
#### Steps:
Use **AVG** to find out ```AverageProductCost``` for each Category, Subcategory, Productline, Style and Class.

#### Answer:
![Question6_1](https://user-images.githubusercontent.com/119062221/213149374-afa9f5a9-5ae1-4a43-a968-92b2abfb1208.png)
![Question6_2](https://user-images.githubusercontent.com/119062221/213148951-8b520083-d38b-416e-8e81-6a195cd8c66d.png)
![Question6_3](https://user-images.githubusercontent.com/119062221/213148957-f1dc2935-edf4-4387-9d1b-841becb9339a.png)
![Question6_4](https://user-images.githubusercontent.com/119062221/213148959-9528aded-5a31-4ef2-994c-cd42dbb30d3e.png)
![Question6_5](https://user-images.githubusercontent.com/119062221/213148963-07afd822-ab31-4b03-a6f8-ee32b5c1354e.png)
![Question6_6](https://user-images.githubusercontent.com/119062221/213148965-33164abe-f87e-4aaa-95b8-9a0ea5bbfd8a.png)
***



### 7. What is the average listing price of product? by category? by sub-category? by productline? by style? by class?
````sql
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
````
#### Steps:
Use **AVG** to find out ```AverageProductListingPrice``` for each Category, Subcategory, Productline, Style and Class.

#### Answer:
![Question7_1](https://user-images.githubusercontent.com/119062221/213150931-db6304f9-6b6a-4c8c-8876-da966cdd7cbb.png)
![Question7_2](https://user-images.githubusercontent.com/119062221/213150940-733045cd-1c55-409e-b0d6-57324298d76b.png)
![Question7_3](https://user-images.githubusercontent.com/119062221/213150947-fb43b717-a955-445f-b03b-d608e60344e8.png)
![Question7_4](https://user-images.githubusercontent.com/119062221/213150950-c94a0a93-8846-48bb-9e55-a6d1475b8a99.png)
![Question7_5](https://user-images.githubusercontent.com/119062221/213150954-52074aba-3a03-4c73-ae08-ed5f88979460.png)
![Question7_6](https://user-images.githubusercontent.com/119062221/213150964-4f47dea1-2a60-4ae0-af4b-8c431e102980.png)
***
### 8. How many product did we sell through our channels (resellers, marketing, online stores, refferals)?
````sql
-- Online Store Orders 
SELECT COUNT(*) AS TotalNumberOrder
FROM Sales.SalesOrderHeader
WHERE OnlineOrderFlag = '1' AND YEAR(OrderDate) = '2014'; -- OnlineOrderFlag : 1= Order coming from onlinestore, 0= Order coming from physical stores

-- Resallers Orders 
SELECT COUNT(*) AS TotalNumberOrder
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL AND YEAR(OrderDate) = '2014';-- Salesperson are always the one placing order for reseller of their territory

--Orders from marketing and referrals 
SELECT sr.[Name] AS Channels, COUNT(so.SalesOrderID) AS TotalNumberOrder
FROM Sales.SalesOrderHeaderSalesReason so
JOIN Sales.SalesReason sr 
ON so.SalesReasonID = sr.SalesReasonID AND YEAR(so.ModifiedDate) = '2014' 
AND (SR.ReasonType = 'Marketing' OR SR.ReasonType = 'Promotion' OR SR.[Name] = 'Review') -- SalesReason register the purchase reason of the customer
GROUP BY sr.[Name];
````
#### Steps:
- Use mainly **COUNT** and **WHERE** to find and filter the results

#### Answer:
![Question8_1](https://user-images.githubusercontent.com/119062221/213204902-73914e29-e92f-4dce-b932-70f928333e73.png)
![Question8_2](https://user-images.githubusercontent.com/119062221/213204865-16581351-35db-4a4a-a79a-aacd6a39a4ad.png)
![Question8_3](https://user-images.githubusercontent.com/119062221/213204881-21fbe516-adba-4606-9373-f4eed370f65a.png)


***
### 9. How many purchase do we have by product during the year?
````sql
SELECT od.ProductID, p.[Name] AS Product, COUNT(*) AS TotalNumberOrder
FROM Sales.SalesOrderDetail od
JOIN Sales.SalesOrderHeader oh
ON od.SalesOrderID = oh.SalesOrderID 
JOIN Production.Product p
ON p.ProductID = od.ProductID
WHERE YEAR(oh.OrderDate) = '2014'
GROUP BY od.ProductID, p.[Name]
ORDER BY TotalNumberOrder DESC;
````
#### Steps:
- **JOIN** ````SalesOrderDetail````, ````SalesOrderHeader```` and ````Product```` to find orders for all products.
- Filter to only retrieve orders from ***2014***

#### Answer:
![Question9](https://user-images.githubusercontent.com/119062221/213206342-67699097-2845-4066-a49e-a939ec428a5f.png)


***

### 10. Which product is the most purchase by customers during the past years?
````sql
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

````
#### Steps:
- Create a temp table to find orders for all products.
- ***Self JOIN*** the temp table to find the ````MaxOrderNumber````.
#### Answer:
![Question10](https://user-images.githubusercontent.com/119062221/213207921-451034a6-155d-4355-8018-27502d7242c2.png)

**Note:** This screenshot contains only a part of result table as it is contains many rows.
***
### 11. Which products are the most purchase by category? by sub-category?
````sql
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
	SELECT  c.Category,
			c.SubcategoryName,
			od.ProductID, 
			c.ProductName, 
			COUNT(*) as OrderNumber
	FROM Sales.SalesOrderDetail od
	JOIN Sales.SalesOrderHeader oh
	ON od.SalesOrderID = oh.SalesOrderID 
	FULL JOIN cte_Category c
	ON c.ProductID = od.ProductID
	WHERE YEAR(oh.OrderDate) = '2014'
	GROUP BY c.Category, c.SubcategoryName, od.ProductID, c.ProductName
)
SELECT  po.Category, po.SubcategoryName, po.ProductID, po.ProductName, po.OrderNumber
FROM cte_product_ordered po
INNER JOIN 
(SELECT Category, MAX(OrderNumber) as MaxOrderNumber
FROM cte_product_ordered 
GROUP BY Category) pom
ON po.Category = pom.Category AND po.OrderNumber = pom.MaxOrderNumber
ORDER BY po.OrderNumber DESC;
````
#### Steps:
Same Steps as Question 10 just add a new temp table to calculate the number of by category and by subcategory.

#### Answer:
![Question11_1](https://user-images.githubusercontent.com/119062221/213208912-2a8952a7-041f-478f-97cd-f83c7fa9a2b8.png)
![Question11_2](https://user-images.githubusercontent.com/119062221/213208922-1a00bfac-3a9a-40cf-9bcb-b4c5eadcb147.png)

***
### 12. What is the total revenue by each product this year?
````sql
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
````
#### Steps:
- Create a temp table to calculate ````TotalNumberOrder```` by product and filter 2014.
- Multiply ````TotalNumberOrder```` by the respective ````ListPrice```` of the product to find the revenue of each product.
#### Answer:
![Question12](https://user-images.githubusercontent.com/119062221/213210349-28b1f830-dee5-4afa-aa47-1561949e7977.png)

***

### 13. Which product makes the highest revenue this year by category? by sub-category?
````sql
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
````
#### Steps:
- Add 2 temp tables to find the category and subcategory for each product.
- ***Self JOIN*** the ````cte_revenue```` temp table to find the ````MaxTotalRevenue```` for each category and subcategory.
#### Answer:
![Question13_1](https://user-images.githubusercontent.com/119062221/213212262-88f4e60f-8260-4eab-aac3-b5cf8a8fd500.png)
![Question13_2](https://user-images.githubusercontent.com/119062221/213212288-21c85033-47a7-44d4-bf1d-95d5869db977.png)

***







