---------------------------------------
-- ADVENTURE WORKS CYCLE : HR ANALYSIS --
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
SELECT COUNT(*) AS TotalNumberEmployee
FROM HumanResources.Employee;


--2. What is the number of employees by department?
SELECT d.[Name] AS Department, 
		COUNT(*) AS TotalNumberEmployee, 
		ROUND ((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM HumanResources.Employee)), 2) AS 'Percentage'
FROM HumanResources.Employee e
INNER JOIN HumanResources.EmployeeDepartmentHistory edh
ON e.BusinessEntityID = edh.BusinessEntityID
INNER JOIN HumanResources.Department d
ON edh.DepartmentID = d.DepartmentID
GROUP BY d.[Name];

--3. What is the number of employees by region?
WITH cte_country (AddressID, Country)AS (
	SELECT A.AddressID, CR.[Name] AS Country
	FROM Person.StateProvince SP 
	INNER JOIN Person.[Address] A
	ON A.StateProvinceID = SP.StateProvinceID
	INNER JOIN Person.CountryRegion CR
	ON CR.CountryRegionCode = SP.CountryRegionCode
)
SELECT c.Country, 
		COUNT(*) AS TotalNumberEmployee, 
		ROUND ((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM HumanResources.Employee)), 2) AS 'Percentage'
FROM cte_country c
INNER JOIN Person.BusinessEntityAddress bea
ON c.AddressID = bea.AddressID
INNER JOIN HumanResources.Employee e
ON bea.BusinessEntityID = e.BusinessEntityID
GROUP BY c.Country;

SELECT *
FROM Person.BusinessEntityAddress

--4. What is the number of employees by gender?
SELECT Gender, 
		COUNT(*) AS TotalNumberEmployee , 
		ROUND((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM HumanResources.Employee)), 2) AS 'Percentage'
FROM HumanResources.Employee 
GROUP BY Gender;

--5. What is the number of employees by organization level?
SELECT OrganizationLevel, 
		COUNT(*) AS TotalNumberEmployee , 
		ROUND((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM HumanResources.Employee)), 2) AS 'Percentage'
FROM HumanResources.Employee 
GROUP BY OrganizationLevel;

--6. What is the number of employees by Tenure range level?
WITH cte_tenurerange (BusinessEntityID, Tenure_Range) AS (
	SELECT BusinessEntityID,
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
	FROM HumanResources.Employee -- 2014 because the database had no significance that year.
)
SELECT Tenure_Range, 
		COUNT(*) AS TotalNumberEmployee , 
		ROUND((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM cte_tenurerange)), 2) AS 'Percentage'
FROM cte_tenurerange
GROUP BY Tenure_Range;

--7. What the average age of employee? find the youngest and the oldest employeed
-- Average Employee Age
SELECT AVG(2014 - YEAR(BirthDate)) as AverageAge 
FROM HumanResources.Employee;

-- Youngest Employee Age
SELECT MIN(2014 - YEAR(BirthDate)) as MinAge 
FROM HumanResources.Employee;

-- Oldest Employee Age
SELECT MAX(2014 - YEAR(BirthDate)) as MaxAge 
FROM HumanResources.Employee; 

--8. What are the marital status percentage in the company?
SELECT MaritalStatus, 
		COUNT(*) AS TotalNumberEmployee , 
		(COUNT(*) * 100.00/(SELECT COUNT(*) FROM HumanResources.Employee)) AS 'Percentage'
FROM HumanResources.Employee 
GROUP BY MaritalStatus;

--9. What is the number of employees by shift?
SELECT S.Name AS Shift, COUNT(*) AS TotalNumberEmployee , 
		(COUNT(*) * 100.00/(SELECT COUNT(*) FROM HumanResources.EmployeeDepartmentHistory)) AS 'Percentage'
FROM HumanResources.EmployeeDepartmentHistory PH 
INNER JOIN HumanResources.Shift S
ON PH.ShiftID = S.ShiftID
WHERE PH.EndDate IS NULL
GROUP BY PH.ShiftID , S.Name;

--Employee Gender DiversityName

--1. What is the percentage of gender by department?
SELECT d.[Name] AS Department, e.Gender, 
		COUNT(*) AS TotalNumberEmployee , 
		ROUND((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM HumanResources.Employee)), 2) AS 'Percentage'
FROM HumanResources.EmployeeDepartmentHistory dh 
INNER JOIN HumanResources.Employee e
ON e.BusinessEntityID = dh.BusinessEntityID
INNER JOIN HumanResources.Department d 
ON d.DepartmentID = dh.DepartmentID
WHERE dh.EndDate IS NULL
GROUP BY Gender,d.[Name];

--2. What is the percentage of gender by region?
WITH cte_country (AddressID, Country)AS (
	SELECT A.AddressID, CR.[Name] AS Country
	FROM Person.StateProvince SP 
	INNER JOIN Person.[Address] A
	ON A.StateProvinceID = SP.StateProvinceID
	INNER JOIN Person.CountryRegion CR
	ON CR.CountryRegionCode = SP.CountryRegionCode
)
SELECT c.Country, e.Gender, 
		COUNT(*) AS TotalNumberEmployee, 
		ROUND ((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM HumanResources.Employee)), 2) AS 'Percentage'
FROM cte_country c
INNER JOIN Person.BusinessEntityAddress bea
ON c.AddressID = bea.AddressID
INNER JOIN HumanResources.Employee e
ON bea.BusinessEntityID = e.BusinessEntityID
GROUP BY c.Country, e.Gender;

--3. What is the percentage of gender by organization level?
SELECT OrganizationLevel, Gender,
		COUNT(*) AS TotalNumberEmployee , 
		ROUND((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM HumanResources.Employee)), 2) AS 'Percentage'
FROM HumanResources.Employee 
GROUP BY OrganizationLevel,Gender;

--4. What is the percentage of gender by tenure range?
WITH cte_tenurerange (BusinessEntityID, Tenure_Range) AS (
	SELECT BusinessEntityID,
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
	FROM HumanResources.Employee -- 2014 because the database had no significance that year.
)
SELECT ca.Tenure_Range, e.Gender,
		COUNT(*) AS TotalNumberEmployee , 
		ROUND((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM cte_tenurerange)), 2) AS 'Percentage'
FROM cte_tenurerange ca
JOIN HumanResources.Employee e 
ON e.BusinessEntityID = ca.BusinessEntityID
GROUP BY ca.Tenure_Range, e.Gender;

--5. What is the percentage of gender by age?
WITH cte_agerange (BusinessEntityID, Age_Range) AS (
	SELECT BusinessEntityID,
	CASE
		WHEN (2014 - YEAR(BirthDate)) < 18 
			THEN '< 18 years'
		WHEN (2014 - YEAR(BirthDate)) BETWEEN 18 AND 20 
			THEN '18-30 years'
		WHEN (2014 - YEAR(BirthDate)) BETWEEN 30 AND 39
			THEN '30-40 years'
		WHEN (2014 - YEAR(BirthDate)) BETWEEN 40 AND 49 
			THEN '40-50 years'
		WHEN (2014 - YEAR(BirthDate)) BETWEEN 50 AND 59 
			THEN '50-60 years'
		ELSE '> 60 years'
	END AS Age_Range
	FROM HumanResources.Employee -- 2014 because the database had no significance that year.
)
SELECT ca.Age_Range, e.Gender,
		COUNT(*) AS TotalNumberEmployee , 
		ROUND((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM cte_agerange)), 2) AS 'Percentage'
FROM cte_agerange ca
JOIN HumanResources.Employee e 
ON e.BusinessEntityID = ca.BusinessEntityID
GROUP BY ca.Age_Range, e.Gender;

---Employee Salaries

--1. What is the  total annual salary in the company? Salaries are in hourly rate so we nee 
--Let's find first annual salaries for everyone
WITH cte_lastratechange ( BusinessEntityID, LastRateChangeDate ) AS (
		SELECT BusinessEntityID, MAX(RateChangeDate) as LastRateChangeDate
		FROM HumanResources.EmployeePayHistory
		GROUP BY BusinessEntityID
),
cte_annual_salary ( BusinessEntityID, Annual_Salary) AS(
		SELECT lrc.BusinessEntityID, ((( e.Rate*40)*4)*12) AS Annual_Salary
		FROM cte_lastratechange lrc
		INNER JOIN HumanResources.EmployeePayHistory e
		ON e.BusinessEntityID = lrc.BusinessEntityID 
		AND e.RateChangeDate = lrc.LastRateChangeDate
)
SELECT SUM(Annual_Salary) AS TotalAnnualSalaries
FROM cte_annual_salary;

--2. What is the  average annual salary in the company?
WITH cte_lastratechange ( BusinessEntityID, LastRateChangeDate ) AS (
		SELECT BusinessEntityID, MAX(RateChangeDate) as LastRateChangeDate
		FROM HumanResources.EmployeePayHistory
		GROUP BY BusinessEntityID
),
cte_annual_salary ( BusinessEntityID, Annual_Salary) AS(
		SELECT lrc.BusinessEntityID, ((( e.Rate*40)*4)*12) AS Annual_Salary
		FROM cte_lastratechange lrc
		INNER JOIN HumanResources.EmployeePayHistory e
		ON e.BusinessEntityID = lrc.BusinessEntityID 
		AND e.RateChangeDate = lrc.LastRateChangeDate
)
SELECT AVG(Annual_Salary) AS AverageAnnualSalaries
FROM cte_annual_salary;

--3. What is the number of employee by annual salary range?
WITH cte_lastratechange ( BusinessEntityID, LastRateChangeDate ) AS (
		SELECT BusinessEntityID, MAX(RateChangeDate) as LastRateChangeDate
		FROM HumanResources.EmployeePayHistory
		GROUP BY BusinessEntityID
),
cte_annual_salary ( BusinessEntityID, Annual_Salary) AS(
		SELECT lrc.BusinessEntityID, ((( e.Rate*40)*4)*12) AS Annual_Salary
		FROM cte_lastratechange lrc
		INNER JOIN HumanResources.EmployeePayHistory e
		ON e.BusinessEntityID = lrc.BusinessEntityID 
		AND e.RateChangeDate = lrc.LastRateChangeDate
),
cte_salaryrange (BusinessEntityID, Annual_Salary, Salary_Range) AS(
		SELECT BusinessEntityID, Annual_Salary,
		CASE
			WHEN Annual_Salary < 20000 
				THEN '< 20K'
			WHEN Annual_Salary BETWEEN 20000 AND 29999 
				THEN '20K-30K'
			WHEN Annual_Salary BETWEEN 30000 AND 39999
				THEN '30K-40K'
			WHEN Annual_Salary BETWEEN 40000 AND 49999 
				THEN '40K-50K'
			WHEN Annual_Salary BETWEEN 50000 AND 59999 
				THEN '50K-60K'
			WHEN Annual_Salary BETWEEN 60000 AND 69999 
				THEN '60K-70k'
			WHEN Annual_Salary BETWEEN 70000 AND 79999 
				THEN '70K-80K'
			WHEN Annual_Salary BETWEEN 80000 AND 89999 
				THEN '80K-90K'
			WHEN Annual_Salary BETWEEN 90000 AND 99999 
				THEN '90K-100K'
			ELSE '> 100K'
		END AS Salary_Range
	FROM cte_annual_salary
)
SELECT Salary_Range,
		COUNT(*) AS TotalNumberEmployee , 
		ROUND((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM cte_salaryrange)), 2) AS 'Percentage'
FROM cte_salaryrange
GROUP BY Salary_Range
ORDER BY TotalNumberEmployee DESC;

--4. What is the average annual salary by department?
WITH cte_lastratechange ( BusinessEntityID, LastRateChangeDate ) AS (
		SELECT BusinessEntityID, MAX(RateChangeDate) as LastRateChangeDate
		FROM HumanResources.EmployeePayHistory
		GROUP BY BusinessEntityID
),
cte_annual_salary ( BusinessEntityID, Annual_Salary) AS(
		SELECT lrc.BusinessEntityID, ((( e.Rate*40)*4)*12) AS Annual_Salary
		FROM cte_lastratechange lrc
		INNER JOIN HumanResources.EmployeePayHistory e
		ON e.BusinessEntityID = lrc.BusinessEntityID 
		AND e.RateChangeDate = lrc.LastRateChangeDate
)
SELECT d.[Name] AS Department, AVG(ans.Annual_Salary) AS AverageAnnualSalaries
FROM HumanResources.EmployeeDepartmentHistory dh 
INNER JOIN cte_annual_salary ans
ON ans.BusinessEntityID = dh.BusinessEntityID
INNER JOIN HumanResources.Department d
ON d.DepartmentID = dh.DepartmentID
WHERE dh.EndDate IS NULL
GROUP BY d.[Name];

--5. What is the  average annual salary by region?
WITH cte_country (AddressID, Country)AS (
	SELECT A.AddressID, CR.[Name] AS CountryR
	FROM Person.StateProvince SP 
	INNER JOIN Person.[Address] A
	ON A.StateProvinceID = SP.StateProvinceID
	INNER JOIN Person.CountryRegion CR
	ON CR.CountryRegionCode = SP.CountryRegionCode
),
cte_lastratechange ( BusinessEntityID, LastRateChangeDate ) AS (
		SELECT BusinessEntityID, MAX(RateChangeDate) as LastRateChangeDate
		FROM HumanResources.EmployeePayHistory
		GROUP BY BusinessEntityID
),
cte_annual_salary ( BusinessEntityID, Annual_Salary) AS(
		SELECT lrc.BusinessEntityID, ((( e.Rate*40)*4)*12) AS Annual_Salary
		FROM cte_lastratechange lrc
		INNER JOIN HumanResources.EmployeePayHistory e
		ON e.BusinessEntityID = lrc.BusinessEntityID 
		AND e.RateChangeDate = lrc.LastRateChangeDate
)
SELECT c.Country, AVG(ans.Annual_Salary) AS AverageAnnualSalaries
FROM Person.BusinessEntityAddress bea 
INNER JOIN cte_country c
ON c.AddressID = bea.AddressID
INNER JOIN cte_annual_salary ans
ON bea.BusinessEntityID = ans.BusinessEntityID
GROUP BY c.Country;

--6. What is the  average annual salary by organization level?
WITH cte_lastratechange ( BusinessEntityID, LastRateChangeDate ) AS (
		SELECT BusinessEntityID, MAX(RateChangeDate) as LastRateChangeDate
		FROM HumanResources.EmployeePayHistory
		GROUP BY BusinessEntityID
),
cte_annual_salary ( BusinessEntityID, Annual_Salary) AS(
		SELECT lrc.BusinessEntityID, ((( e.Rate*40)*4)*12) AS Annual_Salary
		FROM cte_lastratechange lrc
		INNER JOIN HumanResources.EmployeePayHistory e
		ON e.BusinessEntityID = lrc.BusinessEntityID 
		AND e.RateChangeDate = lrc.LastRateChangeDate
)
SELECT e.OrganizationLevel, AVG(ans.Annual_Salary) AS AverageAnnualSalaries
FROM cte_annual_salary ans
INNER JOIN HumanResources.Employee e
ON ans.BusinessEntityID = e.BusinessEntityID
GROUP BY OrganizationLevel;

--7. What is the  average annual salary by tenure range?
WITH cte_tenurerange (BusinessEntityID, Tenure_Range) AS (
	SELECT BusinessEntityID,
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
	FROM HumanResources.Employee 
),
cte_lastratechange ( BusinessEntityID, LastRateChangeDate ) AS (
		SELECT BusinessEntityID, MAX(RateChangeDate) as LastRateChangeDate
		FROM HumanResources.EmployeePayHistory
		GROUP BY BusinessEntityID
),
cte_annual_salary ( BusinessEntityID, Annual_Salary) AS(
		SELECT lrc.BusinessEntityID, ((( e.Rate*40)*4)*12) AS Annual_Salary
		FROM cte_lastratechange lrc
		INNER JOIN HumanResources.EmployeePayHistory e
		ON e.BusinessEntityID = lrc.BusinessEntityID 
		AND e.RateChangeDate = lrc.LastRateChangeDate
)
SELECT ca.Tenure_Range, AVG(ans.Annual_Salary) AS AverageAnnualSalaries
FROM cte_tenurerange ca
JOIN cte_annual_salary ans 
ON ans.BusinessEntityID = ca.BusinessEntityID
GROUP BY ca.Tenure_Range;

--8. What is the  average annual salary by age?
WITH cte_agerange (BusinessEntityID, Age_Range) AS (
	SELECT BusinessEntityID,
	CASE
		WHEN (2014 - YEAR(BirthDate)) < 18 
			THEN '< 18 years'
		WHEN (2014 - YEAR(BirthDate)) BETWEEN 18 AND 20 
			THEN '18-30 years'
		WHEN (2014 - YEAR(BirthDate)) BETWEEN 30 AND 39
			THEN '30-40 years'
		WHEN (2014 - YEAR(BirthDate)) BETWEEN 40 AND 49 
			THEN '40-50 years'
		WHEN (2014 - YEAR(BirthDate)) BETWEEN 50 AND 59 
			THEN '50-60 years'
		ELSE '> 60 years'
	END AS Age_Range
	FROM HumanResources.Employee -- 2014 because the database had no significance that year.
)
,
cte_lastratechange ( BusinessEntityID, LastRateChangeDate ) AS (
		SELECT BusinessEntityID, MAX(RateChangeDate) as LastRateChangeDate
		FROM HumanResources.EmployeePayHistory
		GROUP BY BusinessEntityID
),
cte_annual_salary ( BusinessEntityID, Annual_Salary) AS(
		SELECT lrc.BusinessEntityID, ((( e.Rate*40)*4)*12) AS Annual_Salary
		FROM cte_lastratechange lrc
		INNER JOIN HumanResources.EmployeePayHistory e
		ON e.BusinessEntityID = lrc.BusinessEntityID 
		AND e.RateChangeDate = lrc.LastRateChangeDate
)
SELECT ca.Age_Range, AVG(ans.Annual_Salary) AS AverageAnnualSalaries
FROM cte_agerange ca
JOIN cte_annual_salary ans 
ON ans.BusinessEntityID = ca.BusinessEntityID
GROUP BY ca.Age_Range;

--9. What is the  average annual salary by gender?
WITH cte_lastratechange ( BusinessEntityID, LastRateChangeDate ) AS (
		SELECT BusinessEntityID, MAX(RateChangeDate) as LastRateChangeDate
		FROM HumanResources.EmployeePayHistory
		GROUP BY BusinessEntityID
),
cte_annual_salary ( BusinessEntityID, Annual_Salary) AS(
		SELECT lrc.BusinessEntityID, ((( e.Rate*40)*4)*12) AS Annual_Salary
		FROM cte_lastratechange lrc
		INNER JOIN HumanResources.EmployeePayHistory e
		ON e.BusinessEntityID = lrc.BusinessEntityID 
		AND e.RateChangeDate = lrc.LastRateChangeDate
)
SELECT e.Gender, AVG(ans.Annual_Salary) AS AverageAnnualSalaries
FROM cte_annual_salary ans
JOIN HumanResources.Employee e 
ON e.BusinessEntityID = ans.BusinessEntityID
GROUP BY e.Gender;

--10. Which employee get a promotion or pay raise since hired?
SELECT BusinessEntityID,COUNT(*) AS PayRaise 
FROM HumanResources.EmployeePayHistory
GROUP BY BusinessEntityID
HAVING COUNT(*) > 1;

---Employee Leaves

--1. What is the  total leaves hour for all employee?
SELECT SUM(SickLeaveHours + VacationHours) as AverageLeavesHours
FROM HumanResources.Employee;

--2. What is the  average sick leaves hours and vacations hours in the company?
SELECT AVG(SickLeaveHours) as AverageSickLeaveHours, AVG(VacationHours) as AverageVacationHours
FROM HumanResources.Employee;

--3. What is the  average sick leaves and vacations hour hour by department?
SELECT d.[Name] AS Department, AVG(e.SickLeaveHours) as AverageSickLeaveHours, 
		AVG(e.VacationHours) as AverageVacationHours
FROM HumanResources.EmployeeDepartmentHistory dh
JOIN HumanResources.Employee e
ON dh.BusinessEntityID = e.BusinessEntityID
JOIN HumanResources.Department d
ON d.DepartmentID = dh.DepartmentID
WHERE dh.EndDate IS NULL
GROUP BY d.[Name];

--4. What is the  average sick leaves  hours and vacations hours by organization level?
SELECT OrganizationLevel, AVG(SickLeaveHours) as AverageSickLeaveHours, 
		AVG(VacationHours) as AverageVacationHours
FROM HumanResources.Employee
GROUP BY OrganizationLevel;

--5. What is the  average sick leaves hours and vacations hours by gender?
SELECT Gender, AVG(SickLeaveHours) as AverageSickLeaveHours, 
		AVG(VacationHours) as AverageVacationHours
FROM HumanResources.Employee
GROUP BY Gender;



