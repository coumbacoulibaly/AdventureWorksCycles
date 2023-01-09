---------------------------------------
--ADVENTURE WORKS CYCLE : HR ANALYSIS--
---------------------------------------

--Author: Coumba Coulibaly
--Date: 09/01/2023 
--Tool used: MS SQL Server

USE AdventureWorks2019;


------------------------
--CASE STUDY QUESTIONS--
------------------------

-- Employee Demographics
--1. What is the total number of employees in the company?
SELECT COUNT(*) AS Nbr_Employee
FROM HumanResources.Employee;


--2. What is the number of employees by department?
SELECT d.[Name], 
		COUNT(*) AS Nbr_Employee, 
		ROUND ((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM HumanResources.Employee)), 2) AS 'Percentage'
FROM HumanResources.Employee e
INNER JOIN HumanResources.EmployeeDepartmentHistory edh
ON e.BusinessEntityID = edh.BusinessEntityID
INNER JOIN HumanResources.Department d
ON edh.DepartmentID = d.DepartmentID
GROUP BY d.[Name];

--3. What is the number of employees by region?
WITH cte_country AS (
	SELECT A.AddressID, CR.Name
	FROM Person.StateProvince SP 
	INNER JOIN Person.[Address] A
	ON A.StateProvinceID = SP.StateProvinceID
	INNER JOIN Person.CountryRegion CR
	ON CR.CountryRegionCode = SP.CountryRegionCode
)

SELECT c.[Name], 
		COUNT(*) AS Nbr_Employee, 
		ROUND ((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM HumanResources.Employee)), 2) AS 'Percentage'
FROM cte_country c
INNER JOIN Person.BusinessEntityAddress bea
ON c.AddressID = bea.AddressID
INNER JOIN HumanResources.Employee e
ON bea.BusinessEntityID = e.BusinessEntityID
GROUP BY c.[Name];

--4. What is the number of employees by gender?
SELECT Gender, 
		COUNT(*) AS nb_employee , 
		ROUND((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM HumanResources.Employee)), 2) AS 'Percentage'
FROM HumanResources.Employee 
GROUP BY Gender;

--5. What is the number of employees by organization level?
SELECT OrganizationLevel, 
		COUNT(*) AS nb_employee , 
		ROUND((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM HumanResources.Employee)), 2) AS 'Percentage'
FROM HumanResources.Employee 
GROUP BY OrganizationLevel;

--6. What is the number of employees by Tenure range level?
SELECT BusinessEntityID, (2014 - YEAR(HireDate)) as Age 
FROM HumanResources.Employee;

SELECT BusinessEntityID, (2014 - YEAR(HireDate)) as Age,
CASE
    WHEN (2014 - YEAR(HireDate)) < 1 
		THEN '< 1 year'
    WHEN (2014 - YEAR(HireDate)) BETWEEN 1 AND 2 
		THEN '1-3 years'
	WHEN (2014 - YEAR(HireDate)) BETWEEN 3 AND 5
		THEN '3-6 years'
	WHEN (2014 - YEAR(HireDate)) BETWEEN 6 AND 9 
		THEN '6-10 years'
    ELSE '> 10 years'
END AS Tenure_Range
FROM HumanResources.Employee;

--- 2014 because the database had no significance that year.

--7. What the average age of employee? find the youngest and the oldest employeed

--8. What are the marital status percentage in the company?

--9. What is the number of employees by shift?
