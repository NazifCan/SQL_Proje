--VIEWS


--1--TEDARİKÇİ BİLGİLERİNİ DÖNEN VİEW
Create view GetSuppliersInfoView
as
	Select S.Supplier_Id,S.Contact_Name,S.Contact_Title,S.Phone
	From Suppliers S

--2--CUSTOMER BİLGİLERİNİ VEREN VİEW
Create view GetCustomersInfoView
as
Select Customers.First_Name,Customers.Last_Name,Customers.Email From Customers


--3--HER BİR MÜŞTERİNİN TOPLAM SİPARİŞ MİKTARINI DÖNEN VİEW
Create view TotalOrdersByCustomersView
as
	Select C.Customer_Id,C.First_Name,C.Last_Name,Count(O.Customer_Id) AS Total_Orders
	FROM CUSTOMERS C
	INNER JOIN ORDERS O ON C.Customer_Id=O.Customer_Id
	GROUP BY C.Customer_Id,C.First_Name,C.Last_Name
	
--4--HER BİR TEDARİKÇİNİN TEDARİK ETTİĞİ ÜRÜN SAYISI
Create view ProductCountBySuppliersView
as
	Select S.Supplier_Id,S.Company_Name,S.Contact_Name,S.Address,Count(SP.Product_Id) as SuppliedProductCount
	from Suppliers S
	Inner join Supplier_Product SP on S.Supplier_Id=SP.Supplier_id
	group By S.Supplier_Id,S.Company_Name,S.Contact_Name,S.Address


--5--KATEGORİLERE GÖRE TOPLAM SATIŞLARI VEREN VİEW
CREATE VIEW TotalSalesByCategoryView
 as
	SELECT C.Category_Id,C.Category_Name, Sum(O.Quantity) as TotalSales
	From Categories C
	inner Join Products P on C.Category_Id=P.Category_Id
	inner join Orders O on P.Product_Id=O.Product_Id
	group by C.Category_Id,C.Category_Name