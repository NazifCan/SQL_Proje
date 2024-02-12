Create database SQLProjeVT
use SQLProjeVT

CREATE TABLE Customers(
	Customer_Id INT PRIMARY KEY IDENTITY(1,1),
	First_Name nvarchar(50),
	Last_Name nvarchar(50),
	Email nvarchar(50),
	Password nvarchar(50)
)

CREATE TABLE Orders(
	Order_Id INT PRIMARY KEY IDENTITY(1,1),
	Customer_Id int FOREIGN KEY REFERENCES Customers(Customer_Id),
	Product_Id int FOREIGN KEY REFERENCES Products(Product_Id),
	Quantity int,
	Order_Date date,
)

CREATE TABLE Products(
	Product_Id INT PRIMARY KEY IDENTITY(1,1),
	Product_Name nvarchar(50),
	Category_Id INT FOREIGN KEY REFERENCES Categories(Category_Id),
	Unit_Price decimal(10, 2),
	Units_In_Stock int,
)

CREATE TABLE Categories(
	Category_Id INT PRIMARY KEY IDENTITY(1,1),
	Category_Name nvarchar(50) ,
	Description text,
)

CREATE TABLE Suppliers(
	Supplier_Id int primary key IDENTITY(1,1),
	Company_Name nvarchar(40),
	Contact_Name nvarchar(30),
	Contact_Title nvarchar(30),
	Address nvarchar(60),
	City nvarchar(15),
	Region nvarchar(15),
	Country nvarchar(15),
	Phone nvarchar(24),
)

CREATE TABLE Supplier_Product(
	Supplier_id int FOREIGN KEY REFERENCES Suppliers(Supplier_Id),
	Product_id int FOREIGN KEY REFERENCES Products(Product_Id) 
)



--SÜTUNLARA RASTGELE VERİ EKLEME
UPDATE [TABLO_ADI]
SET [SÜTUN_ADI] = ROUND(RAND(CHECKSUM(NEWID())) * 100000 + 1, 0)

--RASTGELE TARİH EKLEME
UPDATE [TABLO_ADI]
SET [SÜTUN_ADI]= DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 730, '2022-02-08')