# A Deep Dive Into W3Store Sales

## 1. Project Overview
This project illustrates the full data pipeline from cleaning and normalization in MySQL to interactive visualization in Power BI. It focuses on transforming raw sales data from W3Stores, covering customers, products, suppliers, shippers, and employees, into structured, reliable insights. The result is a dynamic dashboard that enables clear analysis of sales performance and operational trends.

---

## 2. Objectives
This project aims to answer the following questions through data modeling and interactive dashboards:
- How are total sales, quantity, and order value performing across different years, countries (cities), and suppliers?
- Which products, categories, and shippers are contributing most to sales and volume?
- What is the monthly trend and growth rate?
- What is the geographical distribution of customers and sales, and how does it vary by region?
- What are the suppliers' market share overally & by product category, and what is their contribution to overall performance?
By using dynamic slicers (Year, Country, Supplier), the dashboards enable users to explore these questions in a flexible and insightful way.

---

## 3. Tools & Technologies
- *MySQL 8.0* – Database management and transformations.
- *Power BI Desktop* – Visualization and data modeling.
- *VS Code* – SQL scripting and repository management.

---

## 4. Dataset
The raw data contains:
- *Customer details* (names, addresses, countries)
- *Supplier details* (names, contact, addresses)
- *Product details* (categories, prices, units)
- *Orders and order details* (quantities, dates, shippers)
- *Employee details* (names, birth dates, notes)

---

## 5. ETL Pipeline

### 5.1 Extraction
Load raw CSV into MySQL:
```sql
LOAD DATA LOCAL INFILE 'raw_data.csv'
INTO TABLE RawData
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;
```

## 5.2 Transformation
- Convert date formats
- Remove duplicates using ROW_NUMBER() over all columns
- Normalize into separate tables: Customers, Suppliers, Products, Orders, and OrderDetails

## 5.3 Loading

Insert into normalized tables, e.g.,
```sql
TRUNCATE TABLE Customers;

INSERT INTO Customers (CustomerID, FirstName, LastName, CustomerName, ContactName, Address, City, PostalCode, Country, Phone)
SELECT DISTINCT CustomerID, FirstName, LastName, CustomerName, ContactName_x, Address_x, City_x, PostalCode_x, Country_x, Phone_x
FROM RawData
WHERE CustomerID IS NOT NULL;
```

## 6. Database Schema

Tables:
- Customers – Customer info
- Suppliers – Supplier info
- Products – Product details
- Orders – Order info (links Customers and Shippers)
- OrderDetails – Product quantities per order

Relationships:
- Customers → Orders (1:M)
- Orders → OrderDetails (1:M)
- Products → OrderDetails (1:M)
- Suppliers → Products (1:M)

## 7. Power BI Analysis

## 7.1 Modeling
- Create relationships:
- Customers[CustomerID] → Orders[CustomerID]
- Orders[OrderID] → OrderDetails[OrderID]
- Products[ProductID] → OrderDetails[ProductID]
- Suppliers[SupplierID] → Products[SupplierID]
 
<img width="888" height="589" alt="Relationships" src="https://github.com/user-attachments/assets/940fa512-1544-4228-8354-d5f9e1916152" />

## 7.2 Measures (DAX)

### Total Sales
```dax
Total Sales = SUMX(OrderDetails, OrderDetails[Quantity] * Products[Price])
```

### 

## 8. Dashboards
### Overview Dashboard:
<img width="1203" height="593" alt="W3Store Dashboard" src="https://github.com/user-attachments/assets/f3ed7576-1025-4aca-a74d-7ac86b408ea4" />

### Other Visuals:
- Total Sales by Country 
<img width="1079" height="482" alt="Sales By Country" src="https://github.com/user-attachments/assets/adb8fd96-b289-442e-a456-2442ff93f3c8" />

- Sales Trend Over Time 
<img width="1222" height="573" alt="Sales Trend" src="https://github.com/user-attachments/assets/bff5a0c1-41df-4fd9-93a8-44706aa8ea1f" />
 
- Top Products by Revenue
<img width="1220" height="574" alt="Top 5 Products" src="https://github.com/user-attachments/assets/ff2ab3c7-4826-4ffe-9a68-dcf64d118cbb" />

- Top Customers by Orders
<img width="1070" height="565" alt="Top 5 Customers" src="https://github.com/user-attachments/assets/30f11386-741a-486f-9ef8-1ca240290638" />

- Category-wise Sales Performance 
 <img width="1068" height="572" alt="Pie Chart Products Category" src="https://github.com/user-attachments/assets/05da145d-36a0-492d-903c-5dd1d0515b4c" />


Filters:
- Date range slicer
- Supplier slicer
- Customer country slicer
 
