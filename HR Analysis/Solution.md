# 🏢: Adventure Works Cycle : HR Analysis

## Solution

View the complete syntax [here](https://github.com/coumbacoulibaly/AdventureWorksCycles/blob/master/HR%20Analysis/HR_Analysis.sql).

***

### Employee Demographics
#### 1. What is the total number of employees in the company?
````sql
SELECT COUNT(*) AS TotalNumberEmployee
FROM HumanResources.Employee;
````
#### Steps:
Use **COUNT** to count all the rows in the ```Employee``` table 

#### Answer:
![Question1](https://user-images.githubusercontent.com/119062221/211762317-1e84e0e6-55db-4782-a0cc-86fa087c0778.png)

***

#### 2. What is the number of employees by department?
````sql
SELECT d.[Name] AS Department, 
		COUNT(*) AS TotalNumberEmployee, 
		ROUND ((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM HumanResources.Employee)), 2) AS 'Percentage'
FROM HumanResources.Employee e
INNER JOIN HumanResources.EmployeeDepartmentHistory edh
ON e.BusinessEntityID = edh.BusinessEntityID
INNER JOIN HumanResources.Department d
ON edh.DepartmentID = d.DepartmentID
GROUP BY d.[Name];
````
#### Steps:
- Use **COUNT** and **GROUP BY** to find out ```TotalNumberEmployee``` by each department.
- Use **JOIN** to merge ```EmployeeDepartmentHistory```, ```Employee``` and ```Department``` tables as the first one is linking the two tables.

#### Answer:
![Question2](https://user-images.githubusercontent.com/119062221/211766501-a3f78be5-6c50-46c9-93b5-f62444e2dc49.png)

***
#### 3. What is the number of employees by region?
````sql
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
````

#### Steps:
- Create a temp table ```cte_country``` to find employees country as this is not found in ```Address``` table rather in ```CountryRegion``` table through ```StateProvince``` table.
- Use **JOIN** to merge ```cte_country```, ```BusinessEntityAddress``` and ```Employee``` tables as employee addresses are in the ```BusinessEntityAddress``` table.

#### Answer:
![Question3](https://user-images.githubusercontent.com/119062221/211773806-99d1d792-0d19-4006-a4d8-062578486099.png)

***

#### 4. What is the number of employees by gender?
````sql
SELECT Gender, 
		COUNT(*) AS TotalNumberEmployee , 
		ROUND((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM HumanResources.Employee)), 2) AS 'Percentage'
FROM HumanResources.Employee 
GROUP BY Gender;
````
#### Steps:
Use **COUNT** and **GROUP BY** to find out ```TotalNumberEmployee``` by each Gender.

#### Answer:
![Question4](https://user-images.githubusercontent.com/119062221/211777717-d4c652b6-e41c-49a6-860b-67e54587fdf0.png)

***

#### 5. What is the number of employees by organization level?
````sql
SELECT OrganizationLevel, 
		COUNT(*) AS TotalNumberEmployee , 
		ROUND((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM HumanResources.Employee)), 2) AS 'Percentage'
FROM HumanResources.Employee 
GROUP BY OrganizationLevel;
````
#### Steps:
Use **COUNT** and **GROUP BY** to find out ```TotalNumberEmployee``` by each Organization level.
#### Answer :
![Question5](https://user-images.githubusercontent.com/119062221/211778450-902cd880-e1e9-4cf5-b446-e74dadf96e25.png)
***

#### 6. What is the number of employees by Tenure range level?
````sql
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
````
#### Steps:
- Create a temp table ```cte_tenurerange``` to find the Tenure range for each employee using ***CASE...WHEN*** statement.
- Use **COUNT** and **GROUP BY** to find out ```TotalNumberEmployee``` in each Tenure range.

#### Answer:
![Question6](https://user-images.githubusercontent.com/119062221/211781274-c286367b-2f1d-4d7b-966f-cb151c6a8918.png)
***


#### 7. What the average age of employee? find the youngest and the oldest employeed
````sql
-- Average Employee Age
SELECT AVG(2014 - YEAR(BirthDate)) as AverageAge 
FROM HumanResources.Employee;

-- Youngest Employee Age
SELECT MIN(2014 - YEAR(BirthDate)) as Age 
FROM HumanResources.Employee;

-- Oldest Employee Age
SELECT MAX(2014 - YEAR(BirthDate)) as Age 
FROM HumanResources.Employee; 
````
#### Steps:
Use aggregation functions **AVG**, **MIN** and **MAX**.

#### Answer:
![Question7_1](https://user-images.githubusercontent.com/119062221/211782706-3bc62535-e3f6-4c44-94da-ca68ed3a6c12.png)
![Question7_2](https://user-images.githubusercontent.com/119062221/211783733-134a0c57-4701-4c73-9547-40f9bd4178d4.png)
![Question7_3](https://user-images.githubusercontent.com/119062221/211783314-b77dbcce-2773-4806-ac6d-218df08be221.png)
***
### 8. What are the marital status percentage in the company?
````sql
SELECT MaritalStatus, 
		COUNT(*) AS TotalNumberEmployee , 
		(COUNT(*) * 100.00/(SELECT COUNT(*) FROM HumanResources.Employee)) AS 'Percentage'
FROM HumanResources.Employee 
GROUP BY MaritalStatus;
````
#### Steps:
Use **COUNT** and **GROUP BY** to find out ```TotalNumberEmployee``` by each Marital Status.

#### Answer:
![image](https://user-images.githubusercontent.com/119062221/211784395-a8073e52-985e-458d-ade3-436fefb735d9.png)
***
#### 9. What is the number of employees by shift?
````sql
SELECT S.Name AS Shift, COUNT(*) AS TotalNumberEmployee , 
		(COUNT(*) * 100.00/(SELECT COUNT(*) FROM HumanResources.EmployeeDepartmentHistory)) AS 'Percentage'
FROM HumanResources.EmployeeDepartmentHistory PH 
INNER JOIN HumanResources.Shift S
ON PH.ShiftID = S.ShiftID
WHERE PH.EndDate IS NULL --EndDate determine if the employee is still in this department or has change department. EndDate= NULL current department. EndDate not NULL old deparment
GROUP BY PH.ShiftID , S.Name;
````
#### Steps:
- Use **COUNT** and **GROUP BY** to find out ```TotalNumberEmployee``` by each Shift.
- Use **JOIN** to merge ```Shift``` and ```EmployeeDepartmentHistory``` tables to find the shift of each employee.

#### Answer:
![Question9](https://user-images.githubusercontent.com/119062221/211786969-a12dea07-85f1-4bc3-8bc6-8120663bd9ba.png)

***

### Employee Gender DiversityName

#### 1. What is the percentage of gender by department?
````sql
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
````
#### Steps:
- Use **COUNT** and **GROUP BY** to find out ```TotalNumberEmployee``` by gender in each department.
- Use **JOIN** to merge ```EmployeeDepartmentHistory```, ```Employee``` and ```Department``` tables as the first one is linking the two tables.

#### Answer:
![Question1](https://user-images.githubusercontent.com/119062221/211790512-9c0339a9-2c9e-4dce-a069-124f61bcd54d.png)

**Note:** This screenshot contains only a part of result table as it is contains many rows.
***
#### 2. What is the percentage of gender by region?
````sql
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
````
#### Steps:
Use the same steps as in Employee Demographics Question 3. Only add the gender column.

#### Answer:
![Question2](https://user-images.githubusercontent.com/119062221/211791585-0b999307-5dfa-44cb-abe3-0f260c4112a0.png)

***
#### 3. What is the percentage of gender by organization level?
````sql
SELECT OrganizationLevel, Gender,
		COUNT(*) AS TotalNumberEmployee , 
		ROUND((COUNT(*) * 100.00 /(SELECT COUNT(*) FROM HumanResources.Employee)), 2) AS 'Percentage'
FROM HumanResources.Employee 
GROUP BY OrganizationLevel,Gender;
````
#### Steps:
Use **COUNT** and **GROUP BY** to find out ```TotalNumberEmployee``` by gender for each Organization level.

#### Answer:
![Question3](https://user-images.githubusercontent.com/119062221/211794002-05baba7e-e3b2-422a-ba88-29273bea9b90.png)
***

#### 4. What is the percentage of gender by tenure range?
````sql
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
````
#### Steps:
Use the same steps as in Employee Demographics Question 6. Only add the gender column.

#### Answer:
![Question4](https://user-images.githubusercontent.com/119062221/211793951-2d7d6d50-53ee-4945-93ff-4ce853f23c35.png)
***

#### 5. What is the percentage of gender by age?
````sql	
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
````
#### Steps:
- Create a temp table ```cte_agerange``` to find the age range for each employee using ***CASE...WHEN*** statement.
- Use **COUNT** and **GROUP BY** to find out ```TotalNumberEmployee``` in each age range by gender.

#### Answer:
![Question5](https://user-images.githubusercontent.com/119062221/211795804-f253480b-9ea2-4635-9ac3-36354c9156f2.png)
***
### Employee Salaries
#### 1. What is the  total annual salary in the company? Salaries are in hourly rate so we nee 
````sql
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
````

#### Steps:
- Create 2 temp tables: first one search for the current pay rate of each employee. The second one calculate the annual salary of each employee as thes are in hourly rate.
- Use **SUM** to find ```TotalAnnualSalaries```.

#### Answer:
![Question1](https://user-images.githubusercontent.com/119062221/211809357-29ed8b60-78c8-4759-8aed-012dae3e47e9.png)
***
#### 2. What is the  average annual salary in the company?
````sql
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
````
#### Steps:
Use the same steps as in Question 1. Only change **SUM** into **AVG**.

#### Answer:
![Question2](https://user-images.githubusercontent.com/119062221/211810253-5d3fe080-ba84-421f-a323-1d74c1f26c1e.png)
***
#### 3. What is the number of employee by annual salary range?
````sql
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
````
#### Steps:
- Add a new temp table ```cte_salaryrange``` to last two to calculate the salary range for each employee.
- Use **COUNT** and **GROUP BY** to find out ```TotalNumberEmployee``` for each salary range.

#### Answer:
![Question3](https://user-images.githubusercontent.com/119062221/211812443-3107c443-7d12-4cd1-90fe-3f3002196e8e.png)
***

#### 4. What is the average annual salary by department?
````sql
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
````

#### Steps:
- Use the same temp table as in Question 1. 
- Use **JOIN** to merge ```EmployeeDepartmentHistory```, ```cte_annual_salary``` and ```Department``` to find the average salary in each department.

#### Answer:
![Question4](https://user-images.githubusercontent.com/119062221/211813597-11e2ba22-78fa-496f-8cf2-4e09f4938b6e.png)
***

#### 5. What is the  average annual salary by region?
````sql
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
````
#### Steps:
Use the temp table ```cte_country``` to the query to find the different region
Use **JOIN** to merge ```cte_country```, ```cte_annual_salary``` and ```BusinessEntityAddress``` to find the average annual salary by region.

#### Answer:
![Question5](https://user-images.githubusercontent.com/119062221/211815486-b62d4f32-9619-4b39-a5c3-4c7c351e149e.png)
****

#### 6. What is the  average annual salary by organization level?
````sql
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
````
#### Steps:
Use the same temp tables. Add ```OrganizationLevel``` column to find the average salary by each category.

#### Answer:
![Question6](https://user-images.githubusercontent.com/119062221/211817153-f9699d9e-869f-489d-856d-d8dfe0d2b267.png)
***

#### 7. What is the  average annual salary by tenure range?
````sql
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
````

#### Steps:
Add the temp table ```cte_tenurerange``` and join it with  ```cte_annual_salary``` to find the average salary for each tenure range

#### Answer:
![Question7](https://user-images.githubusercontent.com/119062221/211819187-75a66782-ab28-4e95-a979-da52edb62c81.png)
***

#### 8. What is the  average annual salary by age?
````sql
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
````
#### Steps:
Same as the last question just add the temp table ````cte_agerange````

#### Answer:
![Question8](https://user-images.githubusercontent.com/119062221/211820725-1da60510-b7c6-4cc5-ab5e-f8d55eab3222.png)
***
### 9. What is the  average annual salary by gender?
````sql
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
````
#### Steps:
Same as question 6, just remplace ```OrganizationLevel``` by ```Gender```.

#### Answer:
![Question9](https://user-images.githubusercontent.com/119062221/211821818-325ddfc5-f344-4559-ba0e-746493682262.png)
****

#### 10. Which employee get a promotion or pay raise since hired?
````sql
SELECT BusinessEntityID, COUNT(*) AS PayRaise 
FROM HumanResources.EmployeePayHistory
GROUP BY BusinessEntityID
HAVING COUNT(*) > 1;
````

#### Steps:
Use **COUNT** and **HAVING** to search for every employee with more then pay raise.

#### Answer:
![Question10](https://user-images.githubusercontent.com/119062221/211825740-b3e4806d-83e3-4ed8-9a42-45c52ce6c0b1.png)
***

### Employee Leaves

#### 1. What is the  total leaves hour for all employee?
````sql
SELECT SUM(SickLeaveHours + VacationHours) as AverageLeavesHours
FROM HumanResources.Employee;
````
#### Steps:
Use **SUM** and Add ````SickLeaveHours```` and ````VacationHours````

#### Answer:
![Question1](https://user-images.githubusercontent.com/119062221/211826991-35a1f31f-9b8f-4cbb-922a-f81e10ad66a8.png)
****

#### 2. What is the  average sick leaves hours and vacations hours in the company?
````sql
SELECT AVG(SickLeaveHours) as AverageSickLeaveHours, AVG(VacationHours) as AverageVacationHours
FROM HumanResources.Employee;
````

#### Steps:
Use **AVG** for ````SickLeaveHours```` and ````VacationHours````

#### Answer:
![Question2](https://user-images.githubusercontent.com/119062221/211827870-1a06dd1f-ca71-4d33-bd07-2ee5d5355833.png)
***

#### 3. What is the  average sick leaves and vacations hour hour by department?
````sql
SELECT d.[Name] AS Department, AVG(e.SickLeaveHours) as AverageSickLeaveHours, 
		AVG(e.VacationHours) as AverageVacationHours
FROM HumanResources.EmployeeDepartmentHistory dh
JOIN HumanResources.Employee e
ON dh.BusinessEntityID = e.BusinessEntityID
JOIN HumanResources.Department d
ON d.DepartmentID = dh.DepartmentID
WHERE dh.EndDate IS NULL
GROUP BY d.[Name];
````
#### Answer:
![Question3](https://user-images.githubusercontent.com/119062221/211828524-d6380f88-0b6e-415d-8949-f97079fafa84.png)
***

#### 4. What is the  average sick leaves  hours and vacations hours by organization level?
````sql
SELECT OrganizationLevel, AVG(SickLeaveHours) as AverageSickLeaveHours, 
		AVG(VacationHours) as AverageVacationHours
FROM HumanResources.Employee
GROUP BY OrganizationLevel;
````
#### Answer:
![Question4](https://user-images.githubusercontent.com/119062221/211829332-f3cdf74d-8449-4ca2-8ac7-0f9e6bf2137f.png)
***

#### 5. What is the  average sick leaves hours and vacations hours by gender?
````sql
SELECT Gender, AVG(SickLeaveHours) as AverageSickLeaveHours, 
		AVG(VacationHours) as AverageVacationHours
FROM HumanResources.Employee
GROUP BY Gender;
````
#### Answer:
![Question5](https://user-images.githubusercontent.com/119062221/211830176-966f8225-303b-4973-bf8a-22c4457e3809.png)
***





