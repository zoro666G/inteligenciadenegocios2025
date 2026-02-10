-- Crear la tabla products
CREATE TABLE [dbo].[Products](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [nvarchar](40) NOT NULL,
	[CompanyName] [nvarchar](40) NULL,
	[CategoryName] [nvarchar](15) NULL,
	[QuantityPerUnit] [nvarchar](20) NULL,
	[UnitPrice] [money] NULL,
	[UnitsInStock] [smallint] NULL,
	[UnitsOnOrder] [smallint] NULL,
	[ReorderLevel] [smallint] NULL,
	[Discontinued] [bit] NOT NULL,
	[ETLLoad] datetime, 
	[ETLExecution] int);

	-- Consulta de origen

	SELECT pr.ProductID, pr.ProductName, sp.CompanyName ,ca.CategoryName, pr.QuantityPerUnit, pr.UnitPrice, pr.UnitsInStock, 
		pr.UnitsOnOrder, pr.ReorderLevel, pr.Discontinued
	FROM (
		SELECT ProductID, ProductName, QuantityPerUnit, UnitPrice, UnitsInStock, 
		UnitsOnOrder, ReorderLevel, Discontinued, CategoryID, SupplierID
		FROM NORTHWND.dbo.Products
	) AS pr
	INNER JOIN 
	(
		SELECT CategoryID, CategoryName
		FROM NORTHWND.dbo.Categories
	) AS ca
	ON pr.CategoryID = ca.CategoryID
	INNER JOIN
	(
	SELECT SupplierID, CompanyName
	FROM NORTHWND.dbo.Suppliers
	) AS sp
	ON sp.SupplierID = pr.SupplierID