-- Create the Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Category VARCHAR(50),
    Price DECIMAL(10, 2)
);

-- Create the Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Region VARCHAR(50)
);

-- Create the Sales table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    CustomerID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert sample data into Products
INSERT INTO Products (ProductID, ProductName, Category, Price) VALUES
(1, 'Laptop', 'Electronics', 999.99),
(2, 'Headphones', 'Electronics', 49.99),
(3, 'T-Shirt', 'Clothing', 19.99),
(4, 'Jeans', 'Clothing', 39.99),
(5, 'Sneakers', 'Footwear', 59.99);

-- Insert sample data into Customers
INSERT INTO Customers (CustomerID, CustomerName, Region) VALUES
(101, 'Alice Johnson', 'North'),
(102, 'Bob Smith', 'South'),
(103, 'Charlie Brown', 'East'),
(104, 'Diana Prince', 'West'),
(105, 'Eve Davis', 'North');

-- Insert sample data into Sales
INSERT INTO Sales (SaleID, ProductID, CustomerID, Quantity, SaleDate) VALUES
(1, 1, 101, 2, '2023-01-15'),
(2, 2, 102, 5, '2023-02-10'),
(3, 3, 103, 10, '2023-03-05'),
(4, 4, 104, 3, '2023-04-20'),
(5, 5, 105, 4, '2023-05-12'),
(6, 1, 102, 1, '2023-06-01'),
(7, 2, 103, 8, '2023-07-15'),
(8, 3, 101, 15, '2023-08-22');

