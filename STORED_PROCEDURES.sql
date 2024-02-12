--STORED PROCEDURES

--1--GİRİLEN ÜRÜN İD'SİNE İSTENEN MİKTARDA STOK ARTTIRAN PROCEDURE
CREATE PROCEDURE AddProductStock(
	@Product_Id INT,
	@Units_In_Stock INT
)
as
BEGIN
	
	IF (Select COUNT(*) from Products where Product_Id=@Product_Id)>0
	BEGIN
		UPDATE PRODUCTS 
		SET Products.Units_In_Stock=Products.Units_In_Stock+@Units_In_Stock
		where Product_Id=@Product_Id
	END		
END

--2--MÜŞTERİ OLUŞTURAN PROCEDURE
CREATE procedure [dbo].[CreateCustomer]
	@First_Name nvarchar(50),
	@Last_Name nvarchar(50), 
	@Email nvarchar(50),
	@Password nvarchar(50)

as
Begin
	Insert into Customers(First_Name,Last_Name,Email,Password)
	values(@First_Name,@Last_Name,@Email,@Password)
end

--3--EĞER STOKTA YETERLİ ÜRÜN VARSA SİPARİŞ OLUŞTURAN PROCEDURE
CREATE PROCEDURE CreateOrder
	@Customer_Id INT,
	@Product_Id INT,
	@Quantity INT,
	@Order_Date DATE	
	as
BEGIN
	IF (select Units_In_Stock from Products where Product_Id= @Product_Id ) >= @Quantity
		begin		
			INSERT INTO Orders(Customer_Id,Product_Id,Quantity,Order_Date)
			VALUES(@Customer_Id,@Product_Id,@Quantity,@Order_Date)
		end
	else
		begin
			print 'STOKTA YETERLİ ÜRÜN YOK'
		end
END

--4--üRÜN OLUŞTURAN PROCEDURE
CREATE PROCEDURE CreateProduct(
	@Product_Name nvarchar(50),
	@Category_Id int,
	@Unit_Price decimal(10,2),
	@Units_In_Stock int
)
as
BEGIN
	INSERT INTO Products(Product_Name,Category_Id,Unit_Price,Units_In_Stock)
	VALUES(@Product_Name,@Category_Id,@Unit_Price,@Units_In_Stock)		
END

--5--VERİLEN YILDA EN ÇOK GELİR GETİREN ÜRÜN KATEGORİSİNİ BULAN PROCEDURE
CREATE PROCEDURE GetMostRevenueCategoryOfGivenYear
	@Year date
	as
	Begin
		Select top 1 C.Category_Id,C.Category_Name, sum (P.Unit_Price*O.Quantity) as TotalAmount
		from Categories C
		inner join Products P on C.Category_Id=P.Category_Id
		inner join Orders O on P.Product_Id=O.Product_Id
		where O.Order_Date=@Year
		group by C.Category_Id,C.Category_Name
		order by TotalAmount desc
	end

--6--VERİLEN YILDA EN ÇOK GELİR GETİREN ÜRÜN VE KATEGORİSİ
CREATE PROCEDURE GetMostRevenueProductsWithTheirCategoriesOfGivenYear
	@Year DATE	
	AS
	BEGIN
		SELECT  C.Category_Id,C.Category_Name,P.Product_Name,SUM(P.Unit_Price*O.Quantity) AS TotalAmount
		FROM Categories C
		INNER JOIN Products P ON C.Category_Id=P.Category_Id
		INNER JOIN Orders O ON P.Product_Id=O.Product_Id
		WHERE O.Order_Date=@Year
		GROUP BY C.Category_Id,C.Category_Name,P.Product_Name
		ORDER BY TotalAmount DESC	
	END

--7--VERİLEN TARİH ARALIĞINDA SATILAN ÜRÜN MİKTARLARI
CREATE PROCEDURE GetSoldProductCountBetweenGivenDates
	@StartDate date,
	@EndDate date,
	@Product_Id int	
	as
BEGIN
	
	Select P.Product_Name,P.Product_Id,Sum(Quantity) as TotalQuantity
	from Orders O
	inner join Products P on O.Product_Id = P.Product_Id
	where P.Product_Id =@Product_Id and O.Order_Date between @StartDate and @EndDate
	group by P.Product_Name,P.Product_Id
END

--8-- ÜRÜN AZALMASI DURUMUNDA TEDARİKÇİ BİLGİLERİNİ VEREN PROCEDURE
CREATE PROCEDURE GetSupplierInfoForShortageProducts
	@N int
	as
	Begin
		Select P.Product_Id,P.Product_Name,P.Units_In_Stock,S.Contact_Name,S.Phone,S.Address
		from Supplier_Product SP
		inner join Suppliers S on SP.Supplier_id=S.Supplier_Id
		inner join Products P on SP.Product_id=P.Product_Id
		where P.Units_In_Stock<@N
		group By P.Product_Id,P.Product_Name,P.Units_In_Stock,S.Contact_Name,S.Phone,S.Address
	end	

