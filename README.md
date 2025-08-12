# A Deep Dive Into W3Store Sales

## Table of Contents

- [Project Overview](#project-overview)  
- [Objectives](#objectives)  
- [Tools](#tools)  
- [Data Source & Structure](#data-source--structure)  
- [SQL Data Analysis](#sql-data-analysis)  
- [ETL Pipeline](#etl-pipeline)  
  - [Extraction](#extraction)  
  - [Transformation](#transformation)  
  - [Loading](#loading)  
- [Database Schema](#database-schema)  
- [Power BI Analysis](#power-bi-analysis)  
  - [Modeling](#modeling)  
  - [Measures (DAX)](#measures-dax)  
- [Code Index](#code-index)  
- [Findings](#findings)  
- [Conclusion](#conclusion)  
- [Recommendations](#recommendations) 

## Project Overview
This project illustrates the full data pipeline from cleaning and normalization in MySQL to interactive visualization in Power BI. It focuses on transforming raw sales data from W3Stores, covering customers, products, suppliers, shippers, and employees, into structured, reliable insights. The result is a dynamic dashboard that enables clear analysis of sales performance and operational trends.


## Objectives
This project aims to answer the following questions through data modeling and interactive dashboards:
- How are total sales, quantity, and orders performing across different years, countries (cities), and suppliers?
- Which products, categories, and shippers are contributing most to sales and volume?
- What is the monthly trend and growth rate?
- What is the geographical distribution of customers and sales, and how does it vary by region?
- What are the suppliers' market share overally & by product category, and what is their contribution to overall performance?
By using dynamic slicers (Year, Country, Supplier), the dashboards enable users to explore these questions in a flexible and insightful way.


## Tools
- *MySQL 8.0* – Database management and transformations.
- *Power BI Desktop* – Visualization and data modeling.
- *VS Code* – SQL scripting and repository management.


## Data Source & Structure
The raw data contains:
- *Customer details* (names, addresses, countries)
- *Supplier details* (names, contact, addresses)
- *Product details* (categories, prices, units)
- *Orders and order details* (quantities, dates, shippers)
- *Employee details* (names, birth dates, notes)
- *Shipper details* (names, contact)


## SQL Data Analysis

## ETL Pipeline

### Extraction
Load raw CSV into MySQL:
```sql
LOAD DATA LOCAL INFILE 'raw_data.csv'
INTO TABLE RawData
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;
```

### Transformation
- Convert date formats
- Remove duplicates using ROW_NUMBER() over all columns
- Normalize into separate tables: Customers, Suppliers, Shippers, Products, Orders, and OrderDetails

### Loading

Insert into normalized tables, e.g.,
```sql
TRUNCATE TABLE Customers;

INSERT INTO Customers (CustomerID, FirstName, LastName, CustomerName, ContactName, Address, City, PostalCode, Country, Phone)
SELECT DISTINCT CustomerID, FirstName, LastName, CustomerName, ContactName_x, Address_x, City_x, PostalCode_x, Country_x, Phone_x
FROM RawData
WHERE CustomerID IS NOT NULL;
```

## Database Schema

Tables:
- Customers – Customer info
- Suppliers – Supplier info
- Products – Product details
- Orders – Order info (links Customers and Shippers)
- OrderDetails – Product quantities per order
- Shipper - Shippers info

Relationships:
- Customers → Orders (1:M)
- Orders → OrderDetails (1:M)
- Products → OrderDetails (1:M)
- Suppliers → Products (1:M)
- Shipper → Customers (1:M)

## Power BI Analysis

### Modeling
- Create relationships:
- Customers[CustomerID] → Orders[CustomerID]
- Orders[OrderID] → OrderDetails[OrderID]
- Products[ProductID] → OrderDetails[ProductID]
- Suppliers[SupplierID] → Products[SupplierID]
 
   <img width="850" height="400" alt="Relationships" src="https://github.com/user-attachments/assets/940fa512-1544-4228-8354-d5f9e1916152" />

### Measures (DAX)

1. Total Sales
```dax
Total Sales = SUMX(Order Details, Order Details[Quantity] * Products[Price])
```
2. Total Quantity
```dax
Total Quantity = SUMX(Order Details, Order Details[Quantity])
```
   
3. Average Order Quantity
```dax
AOV = 
DIVIDE(
    [Total Sales Value],
    DISTINCTCOUNT('Raw Data'[OrderID])
)
```
4. Month-over-Month Percentage Growth
```dax
MoM% = 
IF (
    ISFILTERED(Orders[OrderDate]),
    ERROR("Time intelligence measures must use a full date table."),
    VAR __PREV_MONTH = CALCULATE(
        [Selected Metric Value],
        DATEADD(Orders[OrderDate].[Date], -1, MONTH)
    )
    RETURN DIVIDE([Selected Metric Value] - __PREV_MONTH, __PREV_MONTH)
```

5. Market Share
```dax
Supplier Market Share % = 
DIVIDE(
    [Selected Metric Value],
    CALCULATE(
        [Selected Metric Value],
        ALL('Supplier')
    )
)
```


---
## Findings
---
**_1. How are total sales, quantity, and orders performing across different years, countries (cities), and suppliers?_**
- The Overview dashboard below shows the total sales (by value and quantity), number of orders, customers and Average Order Value (AOV) as the KPIs. The dynamic slicers allows viewing of the sales by time(YEAR), by demographic location(COUNTRY, CITY) and by Supplier (SUPPLIER).

   <img width="600" height="450" alt="Overview W3Store" src="https://github.com/user-attachments/assets/b78ae32e-0297-49a5-9ad1-84be712a0ce4" />

**_2. Which products, categories, and shippers are contributing most to sales and volume?_**
- Refering to the above image, Beverages Category contributes to most sales by value with Cote de Blaye, which is a product in this category having most sales by value as shown below.

   <img width="600" height="450" alt="Category Sales" src="https://github.com/user-attachments/assets/8eb628f7-19f0-4211-908f-09bb4d1b8828" />

   <img width="600" height="450" alt="Top 5 Products" src="https://github.com/user-attachments/assets/34295e32-59ff-47ca-a5da-2ca1aa17c096" />

- By quantity, the diagrams below shop top 5 Products and Top selling categories:

   <img width="600" height="300" alt="Quantity of Top 5 Products" src="https://github.com/user-attachments/assets/c90cc999-a88b-47f1-aff4-3f560d6eb413" />

   <img width="600" height="300" alt="Quantity by Category" src="https://github.com/user-attachments/assets/6841f1f0-116a-4592-8e88-103a9def0dc7" />

- United Package contributes to most shipped sales by value (39.3%)

   <img width="600" height="450" alt="Top Shippers Pie Chart" src="https://github.com/user-attachments/assets/7c346d20-008f-43c8-b074-18ea9bc1a06d" />


**_3. What is the monthly trend and growth rate?_**
- The trend line below shows that there was a dip in overall sales in September 1996 (**-14.5% MoM**) and January 1997 (**35.8% MoM**) recorded the highest sales.

   <img width="600" height="450" alt="Monthly Sales Trend" src="https://github.com/user-attachments/assets/5e838eed-6633-42ce-8364-e30f3aa550f2" />

- The table below shows Month-over-Month growth rate - February 1997 recorded a significant decline of **75.4%** in sales

<img width="250" height="200" alt="MoM" src="https://github.com/user-attachments/assets/57d21c8b-4baf-4f29-a161-013837f81b78" />

**_4. What is the geographical distribution of customers and sales, and how does it vary by region?_**_
- The diagram below shows the geographical distribution of W3Store's top 5 Customers by value:

   <img width="600" height="450" alt="Customers Distribution" src="https://github.com/user-attachments/assets/92544eba-a0fe-4742-a983-e7eab28d526d" />

- The following countries dominated sales by number of customers, orders placed and total sales (both by quantity & value):

   <img width="500" height="250" alt="Metrics by Country" src="https://github.com/user-attachments/assets/2d5293a8-33e4-42b0-ac2d-c76e939b3c72" />

**_5. What are the suppliers' market share overally & by product category, and what is their contribution to overall performance?_**

- The diagram below shows the overall Market share by Supplier:

<img width="850" height="450" alt="Supplier Market Share" src="https://github.com/user-attachments/assets/78b98d24-dabf-4e7c-b811-7bcbc415ed3b" />

- Overally, **_Aux Joyeux ecclesiastiques_** (Beverage Supplier) dominated the market share (37% of overall sales by value) in November 1996 to January 1997 (32%) but had no sales in February 1997. This formed an opportunity for **_Plutzer_** (Confections Supplier) to dominate the market with 25% Market Share (an increase of 18% compared to previous month).

By descending order of sales value by Category, the following table shows the top Suppliers by Market Share in the current month (February 1997):

<img width="600" height="250" alt="Market Share by Category" src="https://github.com/user-attachments/assets/b7565ca9-40a6-404d-87ef-4852a90a759d" />

## Conclusion
The W3Store sales analysis successfully demonstrates the integration of SQL-based ETL processes with Power BI visualization to deliver actionable business intelligence. The data reveals clear patterns in sales trends, supplier dominance, and regional performance. The dashboards provide a dynamic, user-friendly interface for decision-makers to explore KPIs, monitor growth, and evaluate supplier performance with precision.

## Recommendations
1. Supplier Performance Optimization – Engage with underperforming suppliers to understand challenges and replicate best practices from top performers.
2. Product Portfolio Management – Focus marketing efforts on top-selling categories like Beverages while exploring strategies to boost sales in underperforming ones like Produce.
3. Seasonal Trend Planning – Leverage monthly trend insights to plan promotional activities during historically low-performing months like February.
Logistics Efficiency – Strengthen partnerships with top shippers to maintain delivery reliability and customer satisfaction.
4. Data Quality Maintenance – Continue periodic data cleaning and schema normalization to ensure accurate, reliable reporting.

## Reference
You can access the raw data and codes used for this project [here](https://github.com/ken-warren/SalesStoreAnalysis/tree/main/assets)

