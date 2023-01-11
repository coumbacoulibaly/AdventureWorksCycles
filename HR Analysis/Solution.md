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

