-- Crear la tabla employees
CREATE TABLE [dbo].[Employees](
	[EmployeeID] [int] NOT NULL,
	[LastName] [nvarchar](20) NOT NULL,
	[FirstName] [nvarchar](10) NOT NULL,
	[Title] [nvarchar](30) NULL,
	[TitleOfCourtesy] [nvarchar](25) NULL,
	[BirthDate] [datetime] NULL,
	[HireDate] [datetime] NULL,
	[Address] [nvarchar](60) NULL,
	[City] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
	[PostalCode] [nvarchar](10) NULL,
	[Country] [nvarchar](15) NULL,
	[HomePhone] [nvarchar](24) NULL,
	[Extension] [nvarchar](4) NULL,
	[Photo] [image] NULL,
	[Notes] [ntext] NULL,
	[ReportsTo] [int] NULL,
	[PhotoPath] [nvarchar](255) NULL,
	[ETLLoad] datetime, 
	[ETLExecution] int)
GO

TRUNCATE TABLE Employees
-- Consultar la tabla Employees
SELECT * FROM Employees

-- Consultar la tabla ETLExecution
SELECT * FROM [NORTHWIND_METADATA].dbo.ETLExecution;

-- Insertar registros en la tabla ETLExecution

INSERT INTO ETLExecution (UserName, MachineName, PackageName, EtlLoad)
VALUES(?,?,?,GETDATE())

-- Seleccionar el ultimo ID
SELECT TOP 1 ID FROM ETLExecution
WHERE PackageName = ?
ORDER BY ID DESC

SELECT * FROM Northwind_Metadata.dbo.ETLExecution
SELECT * FROM Load_Northwind.dbo.Employees

TRUNCATE TABLE NORTHWIND_METADATA.dbo.ETLExecution
TRUNCATE TABLE Load_Northwind.dbo.Employees

-- Actualizar la tabla ETLExecution para insertar la cantidad de filas
UPDATE ETLExecution
SET EtlCountRows = ?
WHERE ID = ?