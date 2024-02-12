--FUNCTIONS


--SCALED-VALUED FUNCTION
--1--TOPLAM ÜCRETİ HESAPLAYAN FONKSİYON
CREATE function CalculateTotalPrice(
	@Product_Id int,
	@Quantity int
)
returns decimal(10,2) 
as
Begin
	declare @TotalPrice decimal(10,2)

	declare @UnitPrice decimal(10,2)
	Select @UnitPrice= Unit_Price from Products
	where Product_Id = @Product_Id

	Set @TotalPrice = @UnitPrice * @Quantity

	return @TotalPrice
end

--TABLE-VALUED FUNCTIONS
--2--CUSTOMER_ID PARAMETRESİNİ ALIP MÜŞTERİ BİLGİLERİNİ DÖNDÜREN FONKSİYON
CREATE function GetCustomersInfo(	
	@Customer_Id int
) 
returns table 
as return
(
	Select * from Customers
	where Customer_Id=@Customer_Id
)

--3--PRODUCT_ID PARAMETRESINI ALIP CATEGORİSİYLE İLGİLİ BİLGİLER DÖNDÜREN FONKSİYON
CREATE Function GetCategoryOfProduct(
	@Product_Id int
)
returns table
as return
(
	Select P.Product_Id,P.Product_Name,C.Category_Id,C.Category_Name,C.Description from Categories C
	inner join Products P on C.Category_Id=P.Category_Id
	where Product_Id=@Product_Id
)