-- Customers
INSERT INTO Customers (CustomerID, CustomerName, ContactName, Address, City, PostalCode, Country)
SELECT DISTINCT 
    CustomerID, 
    CustomerName, 
    `ContactName.x`, 
    `Address.x`, 
    `City.x`, 
    `PostalCode.x`, 
    `Country.x`
FROM W3Store_Raw_Data;

-- Employees
INSERT INTO Employees (EmployeeID, FirstName, LastName, BirthDate, Notes)
SELECT DISTINCT 
    EmployeeID, 
    FirstName, 
    LastName, 
    STR_TO_DATE(BirthDate, '%d/%m/%Y'), 
    Notes
FROM W3Store_Raw_Data;

-- Suppliers
INSERT INTO Suppliers (SupplierID, SupplierName, ContactName, Address, City, PostalCode, Country, Phone)
SELECT DISTINCT 
    SupplierID, 
    SupplierName, 
    `ContactName.y`, 
    `Address.y`, 
    `City.y`, 
    `PostalCode.y`, 
    `Country.y`, 
    `Phone.y`
FROM W3Store_Raw_Data;

-- Shippers
INSERT INTO Shippers (ShipperID, ShipperName, Phone)
SELECT DISTINCT 
    ShipperID, 
    ShipperName, 
    `Phone.x`
FROM W3Store_Raw_Data;

-- Product Categories
INSERT INTO Categories (CategoryID, CategoryName, Description)
SELECT DISTINCT 
    CategoryID, 
    CategoryName, 
    Description
FROM W3Store_Raw_Data;

-- Products
INSERT INTO Products (ProductID, ProductName, SupplierID, CategoryID, Unit, Price)
SELECT DISTINCT 
    ProductID, 
    ProductName, 
    SupplierID, 
    CategoryID, 
    Unit, 
    Price
FROM W3Store_Raw_Data;

-- Orders
INSERT INTO Orders (OrderID, CustomerID, EmployeeID, ShipperID, OrderDate)
SELECT DISTINCT 
    OrderID, 
    CustomerID, 
    EmployeeID, 
    ShipperID, 
    STR_TO_DATE(OrderDate, '%d/%m/%Y')
FROM W3Store_Raw_Data;

-- Order Details
INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity)
SELECT DISTINCT 
    OrderDetailID, 
    OrderID, 
    ProductID, 
    Quantity
FROM W3Store_Raw_Data;
