--------- EXPLORING DATA ------------
USE AdventureWorks2019;

--------- D A T A B A S E   I N F O R M A T I O N -----------

--- Let's look at the tables
SELECT *
FROM INFORMATION_SCHEMA.TABLES;

SELECT COUNT(*)
FROM INFORMATION_SCHEMA.TABLES;

SELECT COUNT(*)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

SELECT TABLE_SCHEMA, COUNT(*) AS NB_TABLES
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
GROUP BY TABLE_SCHEMA;



--------- P E R S O N   S C H E M A -----------
--Tables in this schema
SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'Person' AND TABLE_TYPE = 'BASE TABLE';

--let's take a look at the table Person
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Person' AND TABLE_NAME = 'Person';

--let's take a look at the table BusinessEntity
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Person' AND TABLE_NAME = 'BusinessEntity';

---Table thatcontains BusinessEntityID as a key
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'BusinessEntityID' AND TABLE_NAME NOT LIKE 'v%';

---Table thatcontains BusinessEntityID as primary key
SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_NAME LIKE 'PK%BusinessEntityID'; 

--Let's look closer to the person table
SELECT *
FROM Person.Person;

--Number of person register in this database
SELECT COUNT(*)
FROM Person.Person;

--How many PersonType are there?
SELECT DISTINCT PersonType
FROM Person.Person;

-- Percentage of person type
SELECT PersonType, COUNT(*) AS nb_person 
FROM Person.Person 
GROUP BY PersonType;

SELECT *
FROM Person.Address;

--------- H U M A N   R E S S O U R C E   S C H E M A -----------
--Tables in this schema
SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'HumanResources' AND TABLE_TYPE = 'BASE TABLE';

--- Let's look at the different Department in Company

Select *
FROM HumanResources.Department;

-- Number of Department
Select COUNT(*)
FROM HumanResources.Department;

Select COUNT(DISTINCT GroupName)
FROM HumanResources.Department;

--- Let's look at the employees
Select *
FROM HumanResources.Employee;

-- Number of employee
Select COUNT(*)
FROM HumanResources.Employee;

-- Gender percentage
SELECT Gender, COUNT(*) AS nb_employee , (COUNT(*) * 100/(SELECT COUNT(*) FROM HumanResources.Employee)) AS 'Percentage'
FROM HumanResources.Employee 
GROUP BY Gender;

-- Marital status percentage
SELECT MaritalStatus, COUNT(*) AS nb_employee , (COUNT(*) * 100.00/(SELECT COUNT(*) FROM HumanResources.Employee)) AS 'Percentage'
FROM HumanResources.Employee 
GROUP BY MaritalStatus;

-- Employee Age
SELECT BusinessEntityID, YEAR(CONVERT(date,GETDATE())) - YEAR(BirthDate) as Age 
FROM HumanResources.Employee;

-- Average Employee Age
SELECT AVG(YEAR(CONVERT(date,GETDATE())) - YEAR(BirthDate)) as AverageAge 
FROM HumanResources.Employee;

-- Youngest Employee Age
SELECT MIN(YEAR(CONVERT(date,GETDATE())) - YEAR(BirthDate)) as Age 
FROM HumanResources.Employee;

-- Oldest Employee Age
SELECT MAX(YEAR(CONVERT(date,GETDATE())) - YEAR(BirthDate)) as Age 
FROM HumanResources.Employee; 

-- Employee Seniority
SELECT BusinessEntityID, YEAR(CONVERT(date,GETDATE())) - YEAR(HireDate) as Age 
FROM HumanResources.Employee;

-- Most Senior Employee 
SELECT  MAX(YEAR(CONVERT(date,GETDATE())) - YEAR(HireDate)) as Age 
FROM HumanResources.Employee;

-- Most junior Employee 
SELECT  MIN(YEAR(CONVERT(date,GETDATE())) - YEAR(HireDate)) as Age 
FROM HumanResources.Employee;

-- Employees with most Vacation hours
SELECT BusinessEntityID, JobTitle, MAX(VacationHours) as VacationHours
FROM HumanResources.Employee
GROUP BY BusinessEntityID, JobTitle
HAVING MAX(VacationHours)>=80
ORDER BY VacationHours DESC;

-- Employees with less Vacation hours
SELECT BusinessEntityID, JobTitle, MIN(VacationHours) as VacationHours
FROM HumanResources.Employee
GROUP BY BusinessEntityID, JobTitle
HAVING MIN(VacationHours)<=10
ORDER BY VacationHours;

-- Employees with most SickLeave hours
SELECT BusinessEntityID, JobTitle, MAX(SickLeaveHours) as SickLeaveHours
FROM HumanResources.Employee
GROUP BY BusinessEntityID, JobTitle
HAVING MAX(SickLeaveHours)>=60
ORDER BY SickLeaveHours DESC;

-- Employees with less SickLeave hours
SELECT BusinessEntityID, JobTitle, MIN(SickLeaveHours) as SickLeaveHours
FROM HumanResources.Employee
GROUP BY BusinessEntityID, JobTitle
HAVING MIN(SickLeaveHours)<=20
ORDER BY SickLeaveHours;

--- Let's look at the employees pay history and department history

-- Pay Rate Changes over time: let's add the employee names for more convinience 
SELECT E.BusinessEntityID, P.FirstName, P.LastName, E.JobTitle, E.HireDate, PH.RateChangeDate, 
		PH.Rate
FROM HumanResources.Employee E
JOIN HumanResources.EmployeePayHistory PH
ON E.BusinessEntityID = PH.BusinessEntityID
JOIN Person.Person P
ON P.BusinessEntityID = PH.BusinessEntityID
ORDER BY E.BusinessEntityID;

-- Employee whose got pay rate 
SELECT BusinessEntityID, COUNT(*) AS Pay_Changes 
FROM HumanResources.EmployeePayHistory
GROUP BY BusinessEntityID
HAVING COUNT(*) > 1;

-- Average Hourly Pay
SELECT AVG(Rate) AS Average_Pay
FROM HumanResources.EmployeePayHistory;

-- Lowest Hourly Pay
SELECT MIN(Rate) AS Lowest_Pay
FROM HumanResources.EmployeePayHistory;

-- Highest Hourly Pay
SELECT MAX(Rate) AS Highest_Pay
FROM HumanResources.EmployeePayHistory;

-- Average Hourly Pay by Department
SELECT  DH.DepartmentID, D.Name, AVG(PH.Rate) AS Average_Pay
FROM HumanResources.EmployeePayHistory PH
JOIN HumanResources.EmployeeDepartmentHistory DH
ON PH.BusinessEntityID = DH.BusinessEntityID
JOIN HumanResources.Department D
ON DH.DepartmentID = D.DepartmentID
WHERE DH.EndDate IS NULL
GROUP BY DH.DepartmentID, D.Name;

-- Departments History
SELECT * 
FROM HumanResources.EmployeeDepartmentHistory;

SELECT * 
FROM HumanResources.EmployeeDepartmentHistory
WHERE HumanResources.EmployeeDepartmentHistory.EndDate IS NOT NULL;
--GROUP BY BusinessEntityID

--- Employees whose have switch department
SELECT BusinessEntityID, COUNT(*) as DepartmentTransition
FROM HumanResources.EmployeeDepartmentHistory
GROUP BY BusinessEntityID
HAVING COUNT(*) > 1;

--- Percentage of employee by shift
SELECT PH.ShiftID, S.Name, COUNT(*) AS nb_employee , 
		(COUNT(*) * 100.00/(SELECT COUNT(*) FROM HumanResources.EmployeeDepartmentHistory)) AS 'Percentage'
FROM HumanResources.EmployeeDepartmentHistory PH 
INNER JOIN HumanResources.Shift S
ON PH.ShiftID = S.ShiftID
GROUP BY PH.ShiftID , S.Name;

-- Job Candidate whose got hired
SELECT JC.JobCandidateID, JC.BusinessEntityID, P.PersonType, P.FirstName, P.MiddleName, P.LastName 
FROM HumanResources.JobCandidate JC
JOIN Person.Person P
ON JC.BusinessEntityID = P.BusinessEntityID
WHERE JC.BusinessEntityID IS NOT NULL;

--------- P R O D U C T I O N   S C H E M A -----------
--Tables in this schema
SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'Production' AND TABLE_TYPE = 'BASE TABLE';

--Number of tables in this schema
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'Production' AND TABLE_TYPE = 'BASE TABLE';

---Let's look closer to the product table
SELECT * 
FROM Production.Product;

--Number of product
SELECT COUNT(*) 
FROM Production.Product;

SELECT * 
FROM Production.ProductCategory;

SELECT * 
FROM Production.ProductCostHistory;

SELECT * 
FROM Production.ProductlistPriceHistory;

SELECT * 
FROM Production.ProductInventory;

--------- P U R C H A S I N G   S C H E M A -----------
--Tables in this schema
SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'Purchasing' AND TABLE_TYPE = 'BASE TABLE';

--Number of tables in this schema
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'Purchasing' AND TABLE_TYPE = 'BASE TABLE';

---Let's look closer to the vendor table
--Vendors are companies from whom Adventure Works Cycles purchases parts or other goods.
SELECT * 
FROM Purchasing.Vendor;

--Number of vendors
SELECT COUNT(*) 
FROM Purchasing.Vendor;

--CreditRating is used to rate vendors from 1 to 5, 1 being the highest rank.
-- 1 = Superior, 2 = Excellent, 3 = Above average, 4 = Average, 5 = Below average
-- let's see which vendor is below average

-- Average Vendor
SELECT * 
FROM Purchasing.Vendor
WHERE CreditRating = 4;

-- Above Average Vendor
SELECT * 
FROM Purchasing.Vendor
WHERE CreditRating = 3;

-- Excellent Vendor
SELECT * 
FROM Purchasing.Vendor
WHERE CreditRating = 2;

-- Superior Vendor
SELECT * 
FROM Purchasing.Vendor
WHERE CreditRating = 1;

--PreferredVendorStatus is used to distinguish preferred vendors.
--0 = Do not use if another vendor is available. 1 = Preferred over other vendors supplying the same product. Default: 1
-- Not preferred Vendor
SELECT * 
FROM Purchasing.Vendor
WHERE PreferredVendorStatus = 0;

-- ActiveFlag is use to see vendors used and the one not used anymore.
--0 = Vendor no longer used. 1 = Vendor is actively used.
-- Not active Vendor
SELECT * 
FROM Purchasing.Vendor
WHERE ActiveFlag = 0;

--Superior Vendor not used anymore
-- Average Vendor
SELECT * 
FROM Purchasing.Vendor
WHERE CreditRating = 1 AND ActiveFlag = 0;

--- Let's look at ProductVendor table
SELECT * 
FROM Purchasing.ProductVendor;

--Number of product vendor
SELECT * 
FROM Purchasing.ProductVendor;

--Number of product with multiples vendors
SELECT ProductID, COUNT(*) 
FROM Purchasing.ProductVendor
GROUP BY ProductID;

--- Let's look at product with no vendors
SELECT * 
FROM Purchasing.ProductVendor PV
RIGHT JOIN Production.Product P 
ON PV.ProductID = P.ProductID
WHERE PV.BusinessEntityID IS NULL;

SELECT COUNT(*) 
FROM Purchasing.ProductVendor PV
RIGHT JOIN Production.Product P 
ON PV.ProductID = P.ProductID
WHERE PV.BusinessEntityID IS NULL;

---LeadTime in days
--Averag lead for all vendors
SELECT AVG(AverageLeadTime)
FROM Purchasing.ProductVendor;

--Average lead time by product
SELECT ProductID, AVG(AverageLeadTime)
FROM Purchasing.ProductVendor
GROUP BY ProductID; 

--Shortest lead time 
SELECT MIN(AverageLeadTime)
FROM Purchasing.ProductVendor; 

--Longest lead time 
SELECT MAX(AverageLeadTime)
FROM Purchasing.ProductVendor; 

--Average Standard Price by Vendor
SELECT ProductID, AVG(StandardPrice)
FROM Purchasing.ProductVendor
GROUP BY ProductID;

--Lowest Standard Price by Vendor
SELECT ProductID, MIN(StandardPrice)
FROM Purchasing.ProductVendor
GROUP BY ProductID;

--Highest Standard Price by Vendor
SELECT ProductID, MAX(StandardPrice)
FROM Purchasing.ProductVendor
GROUP BY ProductID;

--Product on Order
SELECT *
FROM Purchasing.ProductVendor
WHERE OnOrderQty IS NOT NULL;

---Line Total by PurchaseOrder
SELECT ProductID, SUM(LineTotal) 
FROM Purchasing.PurchaseOrderDetail
GROUP BY ProductID;

---Line Total by PurchaseOrder and year
--2011
SELECT PurchaseOrderID, SUM(LineTotal) 
FROM Purchasing.PurchaseOrderDetail
WHERE YEAR(ModifiedDate) = 2011
GROUP BY PurchaseOrderID;

--2012
SELECT PurchaseOrderID, SUM(LineTotal) 
FROM Purchasing.PurchaseOrderDetail
WHERE YEAR(ModifiedDate) = 2012
GROUP BY PurchaseOrderID;

--2013
SELECT PurchaseOrderID, SUM(LineTotal) 
FROM Purchasing.PurchaseOrderDetail
WHERE YEAR(ModifiedDate) = 2013
GROUP BY PurchaseOrderID;

--2014
SELECT PurchaseOrderID, SUM(LineTotal) 
FROM Purchasing.PurchaseOrderDetail
WHERE YEAR(ModifiedDate) = 2014
GROUP BY PurchaseOrderID;

--2015
SELECT PurchaseOrderID, SUM(LineTotal) 
FROM Purchasing.PurchaseOrderDetail
WHERE YEAR(ModifiedDate) = 2015
GROUP BY PurchaseOrderID;

--- PurchaseOrderHeader
SELECT * 
FROM Purchasing.PurchaseOrderHeader;

--Status stand for order current status. 1 = Pending; 2 = Approved; 3 = Rejected; 4 = Complete
--Let's see rejected orders
SELECT * 
FROM Purchasing.PurchaseOrderHeader
WHERE Status = 3;

--Rejected orders By employee
SELECT EmployeeID, COUNT(EmployeeID) 
FROM Purchasing.PurchaseOrderHeader
WHERE Status = 3
GROUP BY EmployeeID;

--Freight Amount by year
SELECT YEAR(OrderDate) as Year , SUM(Freight) as TotalFreight 
FROM Purchasing.PurchaseOrderHeader
GROUP BY YEAR(OrderDate);

--Tax Amount by year
SELECT YEAR(OrderDate) as Year , SUM(TaxAmt) as TotalTaxAmt 
FROM Purchasing.PurchaseOrderHeader
GROUP BY YEAR(OrderDate);

--Order Amount without taxes by year
SELECT YEAR(OrderDate) as Year , SUM(SubTotal) as TotalAmt 
FROM Purchasing.PurchaseOrderHeader
GROUP BY YEAR(OrderDate);

--TotalDue by year
SELECT YEAR(OrderDate) as Year , SUM(TotalDue) as TotalDue
FROM Purchasing.PurchaseOrderHeader
GROUP BY YEAR(OrderDate);

--- ShippingMethods Table
--Average Shipping times
SELECT YEAR(OrderDate) as Year, AVG( DATEDIFF( day, OrderDate, ShipDate ) ) as AverageShippingTime
FROM Purchasing.PurchaseOrderHeader
GROUP BY YEAR(OrderDate);

--Shipping methods
SELECT POH.PurchaseOrderID, SM.ShipMethodID, SM.Name, POH.Freight
FROM Purchasing.PurchaseOrderHeader POH
JOIN Purchasing.ShipMethod SM
ON POH.ShipMethodID = SM.ShipMethodID;

-- Most used shipping methods
SELECT SM.ShipMethodID, SM.Name, COUNT(SM.ShipMethodID) as Nb_Shipping 
FROM Purchasing.PurchaseOrderHeader POH
JOIN Purchasing.ShipMethod SM
ON POH.ShipMethodID = SM.ShipMethodID
GROUP BY  SM.ShipMethodID, SM.Name
ORDER BY Nb_Shipping DESC;

--Cheapest Shipping methods
SELECT * 
FROM Purchasing.ShipMethod
ORDER BY ShipRate;


--------- S A L E S   S C H E M A -----------
--Tables in this schema
SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'Sales' AND TABLE_TYPE = 'BASE TABLE';

--Number of tables in this schema
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'Sales' AND TABLE_TYPE = 'BASE TABLE';

--Let's start with the Salesperson
SELECT *
FROM Sales.SalesPerson;

--Salesperson who already met their salesquota
SELECT *
FROM Sales.SalesPerson
WHERE SalesQuota < SalesYTD;

--Percentage already met 
SELECT BusinessEntityID, SalesQuota, SalesYTD, ((SalesYTD / SalesQuota) * 100) as 'Percentage'
FROM Sales.SalesPerson
WHERE SalesQuota < SalesYTD
ORDER BY Percentage DESC;

--Salesperson (SP) without salesquota
SELECT *
FROM Sales.SalesPerson
WHERE SalesQuota IS NULL;

--SP With the highest commission
SELECT BusinessEntityID, CommissionPct
FROM Sales.SalesPerson
ORDER BY CommissionPct DESC;

--SP who makes highest sales last year
SELECT BusinessEntityID,SalesLastYear
FROM Sales.SalesPerson
ORDER BY SalesLastYear DESC;

--SP who have highest Bonus
SELECT BusinessEntityID, Bonus
FROM Sales.SalesPerson
ORDER BY Bonus DESC;

--SP number by territory
SELECT SP.TerritoryID, ST.Name, ST.CountryRegionCode, COUNT(SP.BusinessEntityID) AS SP_Number
FROM Sales.SalesPerson SP
JOIN Sales.SalesTerritory ST
ON SP.TerritoryID = ST.TerritoryID
GROUP BY SP.TerritoryID, ST.Name, ST.CountryRegionCode;

-- Let's see how many times SPs' Salesquota have change
SELECT *
FROM Sales.SalesPersonQuotaHistory;

SELECT BusinessEntityID, COUNT(QuotaDate) as Change_number
FROM Sales.SalesPersonQuotaHistory
GROUP BY BusinessEntityID;

--SP Last quota change
SELECT S.BusinessEntityID, S.QuotaDate, S.SalesQuota
FROM Sales.SalesPersonQuotaHistory S
INNER JOIN 
(SELECT BusinessEntityID, MAX(QuotaDate) as LastChange
FROM Sales.SalesPersonQuotaHistory
GROUP BY BusinessEntityID) SM
ON S.BusinessEntityID = SM.BusinessEntityID AND S.QuotaDate = SM.LastChange;

-- Areas with the highest Sales Last year 
SELECT *
FROM Sales.SalesTerritory
ORDER BY SalesLastYear DESC;

-- Areas with the highest Sales so far this year 
SELECT *
FROM Sales.SalesTerritory
ORDER BY SalesYTD DESC;

--SP who have change territory multiple times
SELECT BusinessEntityID, COUNT(TerritoryID) as Number_Change
FROM Sales.SalesTerritoryHistory
GROUP BY BusinessEntityID
HAVING COUNT(TerritoryID) >1;


-- Let's look at the stores 
SELECT *
FROM Sales.Store;

--Number of Store
SELECT COUNT(*) AS Store_Number
FROM Sales.Store;

--Number of Store by SPs
SELECT SalesPersonID, COUNT(*) AS Store_Number
FROM Sales.Store
GROUP BY SalesPersonID;

--Retrieving store information
WITH XMLNAMESPACES ('http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey' AS ns)
SELECT BusinessEntityID, 
   [Name], SalesPersonID,
   Demographics.value('(/ns:StoreSurvey/ns:AnnualSales)[1]','money') AS AnnualSales,
   Demographics.value('(/ns:StoreSurvey/ns:AnnualRevenue)[1]','money') AS AnnualRevenue,
   Demographics.value('(/ns:StoreSurvey/ns:YearOpened)[1]','int') AS YearOpened,
   Demographics.value('(/ns:StoreSurvey/ns:BusinessType)[1]','varchar(50)') AS BusinessType,
   Demographics.value('(/ns:StoreSurvey/ns:Specialty)[1]','varchar(128)') AS Speciality,
   Demographics.value('(/ns:StoreSurvey/ns:SquareFeet)[1]','int') AS SquareFeet,
   Demographics.value('(/ns:StoreSurvey/ns:NumberEmployees)[1]','int') AS NumberEmployee
FROM Sales.Store;

-- Average annual revenue by store
SELECT AVG(AnnualRevenue) as AverageAnnualRevenue
FROM Sales.vStoreWithDemographics;

-- Number of store by business type
SELECT BusinessType, COUNT(BusinessEntityID)
FROM Sales.vStoreWithDemographics
GROUP BY BusinessType;

--- O R D E R S ---
SELECT *
FROM Sales.SalesOrderHeader;

-- Number of Order by Year
SELECT YEAR(ModifiedDate) as [YEAR], COUNT(*) as TotalOrder
FROM Sales.SalesOrderHeader
GROUP BY YEAR(ModifiedDate)
ORDER BY TotalOrder DESC;

-- Total Sales by year
SELECT YEAR(ModifiedDate) as [YEAR], SUM(SubTotal) as TotalSales
FROM Sales.SalesOrderHeader
GROUP BY YEAR(ModifiedDate)
ORDER BY TotalSales DESC;

--Why is 2014 Sales lower than 2013
-- First assumption 2014 year is not yet end
SELECT *
FROM Sales.SalesOrderHeader
WHERE YEAR(ModifiedDate) = 2014
ORDER BY ModifiedDate DESC; -- First assumption true the lastest record of  2014 is from july so the is not finished yet

-- Total Tax amount by year
SELECT YEAR(ModifiedDate) as [YEAR], SUM(TaxAmt) as TotalTax
FROM Sales.SalesOrderHeader
GROUP BY YEAR(ModifiedDate)
ORDER BY TotalTax DESC;

-- Total Freight amount by year
SELECT YEAR(ModifiedDate) as [YEAR], SUM(Freight) as TotalFreight
FROM Sales.SalesOrderHeader
GROUP BY YEAR(ModifiedDate)
ORDER BY TotalFreight DESC;

-- Average Shipping time
SELECT AVG( DATEDIFF( day, ShipDate, DueDate ))  as AverageShippingTime
FROM Sales.SalesOrderHeader;

-- Online Order Percentage; 1 = Online Order, 0 = Order placed by Salesperson
SELECT OnlineOrderFlag, COUNT(*) as NumberOfOrder, 
	(COUNT(*) * 100.00/(SELECT COUNT(*) FROM Sales.SalesOrderHeader)) AS 'Percentage'
FROM Sales.SalesOrderHeader
GROUP BY OnlineOrderFlag 
ORDER BY NumberOfOrder DESC;

-- Online Order Sales
SELECT OnlineOrderflag, SUM(SubTotal) as TotalSales
FROM Sales.SalesOrderHeader
GROUP BY OnlineOrderFlag;

-- Shopping Cart
SELECT *
FROM Sales.ShoppingCartItem;

--Sales By Territory
SELECT SOH.TerritoryID, ST.CountryRegionCode, ST.Name, SUM(SOH.SubTotal) as TotalSales
FROM Sales.SalesOrderHeader SOH
JOIN Sales.SalesTerritory ST
ON SOH.TerritoryID = ST.TerritoryID
GROUP BY SOH.TerritoryID, ST.CountryRegionCode, ST.Name;

--Order Details
SELECT *
FROM Sales.SalesOrderDetail;

--Product with the most ordered by year
WITH cte_product_ordered ([YEAR], ProductID, OrderNumber) AS (
SELECT YEAR(ModifiedDate) as [YEAR], 
		ProductID, 
		COUNT(*) as OrderNumber
FROM Sales.SalesOrderDetail
GROUP BY YEAR(ModifiedDate), ProductID
)

SELECT PO.[YEAR], PO.ProductID, PO.OrderNumber
FROM cte_product_ordered PO
INNER JOIN 
(SELECT [YEAR], MAX(OrderNumber) as MaxOrderNumber
FROM cte_product_ordered 
GROUP BY [YEAR]) POM
ON PO.[YEAR] = POM.[YEAR] AND PO.OrderNumber = POM.MaxOrderNumber;

-- Reason of Sales  
SELECT OSR.SalesOrderID, OSR.SalesReasonID, SR.[Name], SR.ReasonType
FROM Sales.SalesOrderHeaderSalesReason OSR
INNER JOIN Sales.SalesReason SR
ON OSR.SalesReasonID = SR.SalesReasonID;

-- Number Sales by reason 
SELECT SR.[Name], COUNT(*) as OrderNumber
FROM Sales.SalesOrderHeaderSalesReason OSR
INNER JOIN Sales.SalesReason SR
ON OSR.SalesReasonID = SR.SalesReasonID
GROUP BY SR.[Name]
ORDER BY OrderNumber DESC;

-- Most Reason of sales by year
WITH cte_sales_reason ([YEAR], [Name], OrderNumber) as (
SELECT YEAR(OSR.ModifiedDate) as [YEAR], 
		SR.[Name], 
		COUNT(*) as OrderNumber
FROM Sales.SalesOrderHeaderSalesReason OSR
INNER JOIN Sales.SalesReason SR
ON OSR.SalesReasonID = SR.SalesReasonID
GROUP BY YEAR(OSR.ModifiedDate), SR.[Name]
)
SELECT CSR.[YEAR], CSR.[NAME], CSR.OrderNumber
FROM cte_sales_reason CSR
INNER JOIN 
(SELECT [YEAR], MAX(OrderNumber) as MaxOrderNumber
FROM cte_sales_reason 
GROUP BY [YEAR]) CSRM
ON CSR.[YEAR] = CSRM.[YEAR] AND CSR.OrderNumber = CSRM.MaxOrderNumber;

-- Special Offer
SELECT *
FROM Sales.SpecialOffer;

-- Special Offer with the Highest discount
SELECT MAX(DiscountPct)
FROM Sales.SpecialOffer;

SELECT *
FROM Sales.SpecialOfferProduct;


--- C U S T O M E R S ---
SELECT *
FROM Sales.Customer;

--Number of Customers
SELECT COUNT(*) as NumberCustomers
FROM Sales.Customer;

--Customer registered in the person table
SELECT COUNT(*) as NumberCustomers
FROM Sales.Customer
WHERE PersonID IS NOT NULL;

--Customers number by territory
SELECT c.TerritoryID, ST.CountryRegionCode, ST.Name, COUNT(*) as NumberCustomers
FROM Sales.Customer c 
JOIN Sales.SalesTerritory ST 
ON c.TerritoryID = ST.TerritoryID
GROUP BY c.TerritoryID, ST.CountryRegionCode, ST.Name
ORDER BY NumberCustomers DESC;

-- Customer INFO
SELECT c.CustomerID, c.PersonID, p.FirstName, p.MiddleName, p.LastName, p.PersonType
FROM Sales.Customer c 
JOIN Person.Person p 
ON c.PersonID = p.BusinessEntityID;

--Individual Customers Analysis
SELECT * 
FROM Sales.Customer c 
JOIN Person.Person p 
ON c.PersonID = p.BusinessEntityID
WHERE p.PersonType = 'IN'; 

--Number of Individual Customers
SELECT COUNT(*) 
FROM Sales.Customer c 
JOIN Person.Person p 
ON c.PersonID = p.BusinessEntityID
WHERE p.PersonType = 'IN';

--Retrieving store demographic information
WITH XMLNAMESPACES ('http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey' AS ns)
SELECT BusinessEntityID, FirstName, MiddleName,
   LastName, 
   Demographics.value('(/ns:IndividualSurvey/ns:TotalPurchaseYTD)[1]','money') AS TotalPurchaseYTD,
   Demographics.value('(/ns:IndividualSurvey/ns:DateFirstPurchase)[1]','date') AS DateFirstPurchase,
   Demographics.value('(/ns:IndividualSurvey/ns:BirthDate)[1]','date') AS BirthDate,
   Demographics.value('(/ns:IndividualSurvey/ns:MaritalStatus)[1]','varchar(18)') AS MaritalStatus,
   Demographics.value('(/ns:IndividualSurvey/ns:YearlyIncome)[1]','varchar(128)') AS YearlyIncome,
   Demographics.value('(/ns:IndividualSurvey/ns:Gender)[1]','varchar(18)') AS Gender,
   Demographics.value('(/ns:IndividualSurvey/ns:TotalChildren)[1]','int') AS TotalChildren,
   Demographics.value('(/ns:IndividualSurvey/ns:NumberChildrenAtHome)[1]','int') AS NumberChildrenAtHome,
   Demographics.value('(/ns:IndividualSurvey/ns:Education)[1]','varchar(50)') AS Education,
   Demographics.value('(/ns:IndividualSurvey/ns:Occupation)[1]','varchar(50)') AS Occupation,
   Demographics.value('(/ns:IndividualSurvey/ns:HomeOwnerFlag)[1]','int') AS HomeOwnerFlag,
   Demographics.value('(/ns:IndividualSurvey/ns:NumberCarsOwned)[1]','int') AS NumberCarsOwned,
   Demographics.value('(/ns:IndividualSurvey/ns:CommuteDistance)[1]','varchar(50)') AS CommuteDistance
FROM Person.Person
WHERE PersonType = 'IN';

-- Let's continue with views tables
SELECT *
FROM Sales.vPersonDemographics
WHERE DateFirstPurchase IS NOT NULL;

--Customer Number by marital Status
SELECT MaritalStatus, COUNT(*) as NumberCustomer, 
	(COUNT(*) * 100.00/(SELECT COUNT(*) FROM Sales.vPersonDemographics WHERE DateFirstPurchase IS NOT NULL)) AS 'Percentage'
FROM Sales.vPersonDemographics
WHERE DateFirstPurchase IS NOT NULL
GROUP BY MaritalStatus 
ORDER BY NumberCustomer DESC;

--Customer Number by Education
SELECT Education, COUNT(*) as NumberCustomer, 
	(COUNT(*) * 100.00/(SELECT COUNT(*) FROM Sales.vPersonDemographics WHERE DateFirstPurchase IS NOT NULL)) AS 'Percentage'
FROM Sales.vPersonDemographics
WHERE DateFirstPurchase IS NOT NULL
GROUP BY Education 
ORDER BY NumberCustomer DESC;

--Customer Number by Gender
SELECT Gender, COUNT(*) as NumberCustomer, 
	(COUNT(*) * 100.00/(SELECT COUNT(*) FROM Sales.vPersonDemographics WHERE DateFirstPurchase IS NOT NULL)) AS 'Percentage'
FROM Sales.vPersonDemographics
WHERE DateFirstPurchase IS NOT NULL
GROUP BY Gender 
ORDER BY NumberCustomer DESC;

--Customer Number by Occupation
SELECT Occupation, COUNT(*) as NumberCustomer, 
	(COUNT(*) * 100.00/(SELECT COUNT(*) FROM Sales.vPersonDemographics WHERE DateFirstPurchase IS NOT NULL)) AS 'Percentage'
FROM Sales.vPersonDemographics
WHERE DateFirstPurchase IS NOT NULL
GROUP BY Occupation 
ORDER BY NumberCustomer DESC;

--Customer Number by YearlyIncome
SELECT Yearlyincome, COUNT(*) as NumberCustomer, 
	(COUNT(*) * 100.00/(SELECT COUNT(*) FROM Sales.vPersonDemographics WHERE DateFirstPurchase IS NOT NULL)) AS 'Percentage'
FROM Sales.vPersonDemographics
WHERE DateFirstPurchase IS NOT NULL
GROUP BY YearlyIncome 
ORDER BY NumberCustomer DESC;

--Average Purchases By income Category
SELECT Yearlyincome, AVG(TotalPurchaseYTD) as AverageTotalPurchaseYTD
FROM Sales.vPersonDemographics 
WHERE DateFirstPurchase IS NOT NULL
GROUP BY YearlyIncome
ORDER BY AverageTotalPurchaseYTD DESC;

--Average Purchases By Gender
SELECT Gender, AVG(TotalPurchaseYTD) as AverageTotalPurchaseYTD
FROM Sales.vPersonDemographics 
WHERE DateFirstPurchase IS NOT NULL
GROUP BY Gender
ORDER BY AverageTotalPurchaseYTD DESC;

--Average Purchases By Ocuppation
SELECT Occupation, AVG(TotalPurchaseYTD) as AverageTotalPurchaseYTD
FROM Sales.vPersonDemographics 
WHERE DateFirstPurchase IS NOT NULL
GROUP BY Occupation
ORDER BY AverageTotalPurchaseYTD DESC;

--Average Purchases By Education
SELECT Education, AVG(TotalPurchaseYTD) as AverageTotalPurchaseYTD
FROM Sales.vPersonDemographics 
WHERE DateFirstPurchase IS NOT NULL
GROUP BY Education
ORDER BY AverageTotalPurchaseYTD DESC;

--Average Purchases By MaritalStatus
SELECT MaritalStatus, AVG(TotalPurchaseYTD) as AverageTotalPurchaseYTD
FROM Sales.vPersonDemographics 
WHERE DateFirstPurchase IS NOT NULL
GROUP BY MaritalStatus
ORDER BY AverageTotalPurchaseYTD DESC;

--Customer Number by HomeOwners
SELECT HomeOwnerFlag, COUNT(*) as HomeOwners, 
	(COUNT(*) * 100.00/(SELECT COUNT(*) FROM Sales.vPersonDemographics WHERE DateFirstPurchase IS NOT NULL)) AS 'Percentage'
FROM Sales.vPersonDemographics
WHERE DateFirstPurchase IS NOT NULL
GROUP BY HomeOwnerFlag 
ORDER BY HomeOwners DESC;

-- Average number of children
SELECT AVG(TotalChildren)
FROM Sales.vPersonDemographics
WHERE DateFirstPurchase IS NOT NULL; 

-- Average number of Car owned
SELECT AVG(NumberCarsOwned)
FROM Sales.vPersonDemographics
WHERE DateFirstPurchase IS NOT NULL; 





SELECT *
FROM Sales.vPersonDemographics
WHERE DateFirstPurchase IS NOT NULL;






SELECT COUNT(*) 
FROM Sales.Customer c 
JOIN Person.Person p 
ON c.PersonID = p.BusinessEntityID
WHERE p.PersonType = 'SC';

SELECT *
FROM Sales.Customer;

SELECT *
FROM Sales.Store;

SELECT *
FROM Sales.SalesOrderHeader;    