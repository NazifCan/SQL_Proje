--TRİGGERS

--1--BİR MÜŞTERİ SİLİNDİĞİNDE ONA AİT SİPARİŞLERİ SİLEN TRİGGER
CREATE TRIGGER trg_RemoveCustomersAndOrders
ON Customers
AFTER DELETE
as
Begin
	set nocount on

	delete from customers
	where Customer_Id in(select Customer_Id from deleted)
end

--2--İLERİ TARİHLİ BİR SİPARİŞ GİRİLDİĞİNDE SİPARİŞ TARİHİNİ INSERT TARİHİNE GÜNCELLEYEN TRİGGER
CREATE TRIGGER trg_UpdateOrderDate
on Orders
After Insert
as
BEGIN
	SET NOCOUNT ON

	UPDATE Orders
    SET Order_Date = GETDATE()
    FROM inserted
    WHERE Orders.Order_Date > GETDATE();			
END

--3--İPTAL EDİLEN SİPARİŞTEKİ ÜRÜNÜN STOKTAKİ MİKTARINI ARTTIRAN TRİGGER
CREATE TRIGGER trg_UpdateProductStockForCancelOrder
ON Orders
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
 
    UPDATE Products
    SET Units_In_Stock = Units_In_Stock + deleted.Quantity
    FROM deleted 
    WHERE Products.Product_Id = deleted.Product_Id
END

--4--SİPARİŞİ OLUŞTURULAN ÜRÜNÜN STOKTAKİ MİKTARINI AZALTAN TRİGGER
CREATE Trigger trg_UpdateStock
on Orders
After Insert
as 
Begin
	set Nocount on

	Update Products
	set Units_In_Stock= Units_In_Stock-i.Quantity
	from Products P
	inner join inserted i on P.Product_Id=I.Product_Id
end

--5--EĞER BİR ÜRÜN SİLİNİRSE O ÜRÜNLE ALAKALI SİPARİŞLERİ SİLEN TRİGGER
CREATE TRIGGER trg_DeleteProductOrders
ON Products
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProductID INT;
    SELECT @ProductID = Product_Id FROM deleted;
    DELETE FROM Orders WHERE Product_Id = @ProductID;
END

--6--EĞER BİR TEDARİKÇİ SİLİNİRSE SUPPLİER_PRODUCT TABLOSUNDA TEDARİK ETTİĞİ ÜRÜNLERİ GÖSTEREN SATIRLARI SİLEN TRİGGER
CREATE TRIGGER trg_DeleteSuppliersProduct
ON Suppliers
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    Delete From Supplier_Product
	where Supplier_id in(Select Supplier_id from deleted)  
END

