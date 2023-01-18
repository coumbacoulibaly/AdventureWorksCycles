# 🚲: Adventure Works Cycle : Product Analysis

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
### 8. How many product did we sell through our channels (physical stores, marketing, online stores, refferals)?
````sql
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
````
#### Steps:


#### Answer:

***
### 9. How many purchase do we have by product during the year?
````sql

````
#### Steps:


#### Answer:


***

### 10. Which product is the most purchase by customers during the past years?
````sql

````
#### Steps:


#### Answer:


**Note:** This screenshot contains only a part of result table as it is contains many rows.
***
### 11. Which products are the most purchase by category? by sub-category?
````sql

````
#### Steps:


#### Answer:

***
### 12. What is the total revenue by each product this year?
````sql

````
#### Steps:

#### Answer:

***

### 13. Which product makes the highest revenue this year by category? by sub-category?
````sql

````
#### Steps:

#### Answer:

***







