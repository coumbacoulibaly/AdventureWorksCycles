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
WITH cte_country (AddressID, Country)AS (
	SELECT A.AddressID, CR.[Name] AS Country
	FROM Person.StateProvince SP 
	INNER JOIN Person.[Address] A
	ON A.StateProvinceID = SP.StateProvinceID
	INNER JOIN Person.CountryRegion CR
	ON CR.CountryRegionCode = SP.CountryRegionCode
)
SELECT c.Country, 
		COUNT(*) AS Nbr_Employee, 
		ROUND ((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM HumanResources.Employee)), 2) AS 'Percentage'
FROM cte_country c
INNER JOIN Person.BusinessEntityAddress bea
ON c.AddressID = bea.AddressID
INNER JOIN HumanResources.Employee e
ON bea.BusinessEntityID = e.BusinessEntityID
GROUP BY c.Country;

--4. What is the number of employees by gender?
SELECT Gender, 
		COUNT(*) AS Nbr_Employee , 
		ROUND((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM HumanResources.Employee)), 2) AS 'Percentage'
FROM HumanResources.Employee 
GROUP BY Gender;

--5. What is the number of employees by organization level?
SELECT OrganizationLevel, 
		COUNT(*) AS Nbr_Employee , 
		ROUND((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM HumanResources.Employee)), 2) AS 'Percentage'
FROM HumanResources.Employee 
GROUP BY OrganizationLevel;

--6. What is the number of employees by Tenure range level?
WITH cte_age (BusinessEntityID, Tenure_Range) AS (
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
		COUNT(*) AS Nbr_Employee , 
		ROUND((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM cte_age)), 2) AS 'Percentage'
FROM cte_age
GROUP BY Tenure_Range;

--7. What the average age of employee? find the youngest and the oldest employeed
-- Average Employee Age
SELECT AVG(2014 - YEAR(BirthDate)) as AverageAge 
FROM HumanResources.Employee;

-- Youngest Employee Age
SELECT MIN(2014 - YEAR(BirthDate)) as Age 
FROM HumanResources.Employee;

-- Oldest Employee Age
SELECT MAX(2014 - YEAR(BirthDate)) as Age 
FROM HumanResources.Employee; 

--8. What are the marital status percentage in the company?
SELECT MaritalStatus, 
		COUNT(*) AS Nbr_Employee , 
		(COUNT(*) * 100.00/(SELECT COUNT(*) FROM HumanResources.Employee)) AS 'Percentage'
FROM HumanResources.Employee 
GROUP BY MaritalStatus;

--9. What is the number of employees by shift?
SELECT PH.ShiftID, S.Name, COUNT(*) AS Nbr_Employee , 
		(COUNT(*) * 100.00/(SELECT COUNT(*) FROM HumanResources.EmployeeDepartmentHistory)) AS 'Percentage'
FROM HumanResources.EmployeeDepartmentHistory PH 
INNER JOIN HumanResources.Shift S
ON PH.ShiftID = S.ShiftID
GROUP BY PH.ShiftID , S.Name;

--Employee Gender DiversityName

--1. What is the percentage of gender by department?
SELECT d.[Name] AS Department, e.Gender, 
		COUNT(*) AS Nbr_Employee , 
		ROUND((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM HumanResources.Employee)), 2) AS 'Percentage'
FROM HumanResources.EmployeeDepartmentHistory dh 
INNER JOIN HumanResources.Employee e
ON e.BusinessEntityID = dh.BusinessEntityID
INNER JOIN HumanResources.Department d 
ON d.DepartmentID = dh.DepartmentID
WHERE dh.EndDate IS NULL
GROUP BY Gender,d.[Name];

SELECT * 
FROM HumanResources.EmployeeDepartmentHistory;
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
		COUNT(*) AS Nbr_Employee, 
		ROUND ((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM HumanResources.Employee)), 2) AS 'Percentage'
FROM cte_country c
INNER JOIN Person.BusinessEntityAddress bea
ON c.AddressID = bea.AddressID
INNER JOIN HumanResources.Employee e
ON bea.BusinessEntityID = e.BusinessEntityID
GROUP BY c.Country, e.Gender;

--3. What is the percentage of gender by organization level?
SELECT OrganizationLevel, Gender,
		COUNT(*) AS Nbr_Employee , 
		ROUND((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM HumanResources.Employee)), 2) AS 'Percentage'
FROM HumanResources.Employee 
GROUP BY OrganizationLevel,Gender;

--4. What is the percentage of gender by tenure range?
WITH cte_age (BusinessEntityID, Tenure_Range) AS (
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
		COUNT(*) AS Nbr_Employee , 
		ROUND((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM cte_age)), 2) AS 'Percentage'
FROM cte_age ca
JOIN HumanResources.Employee e 
ON e.BusinessEntityID = ca.BusinessEntityID
GROUP BY ca.Tenure_Range, e.Gender;

--5. What is the percentage of gender by age?
WITH cte_age (BusinessEntityID, Age_Range) AS (
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
		COUNT(*) AS Nbr_Employee , 
		ROUND((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM cte_age)), 2) AS 'Percentage'
FROM cte_age ca
JOIN HumanResources.Employee e 
ON e.BusinessEntityID = ca.BusinessEntityID
GROUP BY ca.Age_Range, e.Gender;

---Employee Salaries

--1. What is the  total annual salary in the company? Salaries are write in hourly rate  
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
		COUNT(*) AS Nbr_Employee , 
		ROUND((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM cte_salaryrange)), 2) AS 'Percentage'
FROM cte_salaryrange
GROUP BY Salary_Range;

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


--7. What is the  average annual salary by tenure range?


--8. What is the  average annual salary by age?


--9. What is the  average annual salary by gender?


--10. Which get a promotion or pay raise since hired?

---Employee Leaves

--1. What is the  total leaving hour for all employee?


--2. What is the  average sick leaves hour in the company?


--3. What is the  average vacations hour in the company?


--4. What is the  average sick leaves hour by department?


--5. What is the  average sick leaves hour by organization level?


--6. What is the  average sick leaves hour by gender?


--7. What is the  average sick leaves hour by age range?


--8. What is the  average vacations hour by department?


--9. What is the  average vacations hour by organization level?


--10. What is the  average vacations hour by gender?


--11. What is the  average vacations hour by age renge?