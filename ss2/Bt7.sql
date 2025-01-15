create database Bt7;
use Bt7;
CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL,
    Price DECIMAL(20, 5) NOT NULL
);
CREATE TABLE Invoice (
    InvoiceID INT PRIMARY KEY,
    PurchaseDate DATE NOT NULL,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);
CREATE TABLE InvoiceDetails (
    InvoiceID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    PRIMARY KEY (InvoiceID, ProductID),
    FOREIGN KEY (InvoiceID) REFERENCES Invoice(InvoiceID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);
-- b,
ALTER TABLE InvoiceDetails
ADD CONSTRAINT FK_InvoiceDetails_Invoice
FOREIGN KEY (InvoiceID) REFERENCES Invoice(InvoiceID);

ALTER TABLE InvoiceDetails
ADD CONSTRAINT FK_InvoiceDetails_Product
FOREIGN KEY (ProductID) REFERENCES Product(ProductID);
-- c,
SELECT 
    Invoice.InvoiceID AS InvoiceNumber,
    Invoice.PurchaseDate AS PurchaseDate,
    Customer.CustomerName AS CustomerName,
    Product.ProductName AS ProductName,
    InvoiceDetails.Quantity AS Quantity,
    Product.Price AS UnitPrice,
    (InvoiceDetails.Quantity * Product.Price) AS TotalPrice
FROM 
    Invoice
JOIN 
    Customer ON Invoice.CustomerID = Customer.CustomerID
JOIN 
    InvoiceDetails ON Invoice.InvoiceID = InvoiceDetails.InvoiceID
JOIN 
    Product ON InvoiceDetails.ProductID = Product.ProductID
ORDER BY 
    Invoice.InvoiceID;


