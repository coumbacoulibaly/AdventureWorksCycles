![MasterHead](https://user-images.githubusercontent.com/119062221/205323914-5955d947-14af-4ec3-9020-b5f33b6e4133.png)
# :bicyclist: Adventure Works Cycles 
The AdventureWorks databases are sample databases that were originally published by Microsoft to show how to design a SQL Server database using SQL Server 2008. The database supports a fictitious company called Adventure Works Cycles. 

Adventure Works Cycles is a large, multinational manufacturing company that produces and distributes metal and composite bicycles to commercial markets in North America, Europe, and Asia. The headquarters for Adventure Works Cycles is Bothell, Washington, where the company employs 500 workers. Additionally, Adventure Works Cycles employs several regional sales teams throughout its market base.

I utilized this sample database to sharpen my SQL skill and broaden my understanding of business-related data analytics applications.
## 📚 Table of Contents
- [Database Overview](#database-overview)
- [HR Analysis](#hr-analysis)
- [Product Analysis](#product-analysis)
- [Manufacturing Analysis](#manufacturing-analysis)
- [Inventory Analysis](#inventory-analysis)
- [Customers Analysis](#customers-analysis)
- [Sales Analysis](#sales-analysis)

***
## Database Overview
This database contains 72 tables which are divided into 5 schemas
- **dbo** : have 3 tables they contain general informations about the database
- **Person** : 13 tables which contains all informations related to recorded in the database like employee, customers, vendors, etc.
- **Human Resources** : 6 tables focused on employee and the company administrations informations.
- **Production** : the largest schema with 25 tables mainly on the product and manufacturing informations. furthermore in the analysis, Ihave divided this schema into 3 subschema – product, manufactring and inventory. This help understand easily the processes in this section.
- **Purschasing** : 5 tables with informations on the different supplyers which are called here vendors.
- **Sales** : 19 tables which contains informations on customers, store, salespeople, etc.

### Business Entity
This table have a big role for the whole organization of the database. Despite the fact that it is part of the Person schema, it is primary key is present in almost every schema. This is because it represent core elements of the business. A business entity is anything or anyone who interacts with the business like stores, customers, supplyers, employee, etc. After some reverse engineering, I came to the conclusion with these findings:
The _BusinessEntity_ table is directly link to _Person_, _Store_ and _Vendors_ on a one-to-one relationship. _Person_ is further related, also in a one-to-one fashion, to _Employee_, which is further related one-to-one with _SalesPerson_. For all of these tables, the primary key is the same, called _BusinessEntityID_. It's a hierarchal organization that help you understand supertype-subtype relationships.

<img src="https://user-images.githubusercontent.com/119062221/205937446-7479b8d2-ed18-4c84-9f07-f7361e5a235f.jpg" alt="Image" width="500" height="300" >

### ER Diagram
The following picture shows the entity diagram of the database.


<img src="https://user-images.githubusercontent.com/119062221/205907267-4fc33c5f-7208-41d2-a3ea-886d68796257.jpg" alt="Image" width="700" height="400">

***

## HR Analysis
#### Business Tasks 
Adventure Works Cycles HR Manager wants a more employee-centric culture in the company. To attain this goal, he wants to use data to answer few questions about the employee, especially about their work experience in the company and overall satisfaction.
View here the case study and here my solution.

#### HR Dashboard

***

## Product Analysis
#### Business Tasks
Adventure Works Cycles Product team wants see the company different product performance on the market. For this they to use data to analyze trends and product feature to improve.
View here the case study and here my solution.

#### Product Performance Dashboard

***

## Manufacturing Analysis
#### Business Tasks
The production control team at AWC wish to  to analyze their manufacturing processes. For this goal, they want to use data to monitor the factory work capacity and improve performance and yield.
View here the case study and here my solution.

### Manufacturing Analytics Dashboard
***

## Inventory Analysis
#### Business Tasks
The producton team, also want to an inventory anlysis using data. They want to know the stock level and other compoments essential to the product stock flow.
View here the case study and here my solution.

#### Inventory Analysis Dashboard
***

## Customers Analysis
#### Business Tasks
The marketing teams wants to better undertand their customers. For this aim, they wish to use data to know their buying patterns and how much money they’ve spent on products.
View here the case study and here my solution.

#### Customers Analysis Dashboad 
***

## Sales Analysis
#### Business Tasks
Sales team wish to know the differents sales trends for this year and past years also. They want to use data to find area to improve in their strategy and increase revenue.
View here the case study and here my solution.

#### Sales Analysis Dashboard
***
