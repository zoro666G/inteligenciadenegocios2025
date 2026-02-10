--USANDO LA BASE DE DATOS STAGE_NORTHWND
use Stage_Northwind
GO

--VALIDANDO SI EXISTE LA TABLA Stage_Empleado
IF EXISTS(SELECT NAME FROM SYS.tables WHERE NAME='Stage_Empleado')
BEGIN
    DROP TABLE Stage_Empleado
END
GO

--CREANDO LA TABLA [Stage_Empleado]
CREATE TABLE [dbo].[Stage_Empleado](
    [Empleado_Codigo] [int] NOT NULL,
    [Empleado_Apellido] [varchar](40) NOT NULL,
    [Empleado_Nombre] [varchar](20) NULL,
    [Empleado_NombreCompleto] [varchar](70) NOT NULL,
    [Empleado_Direccion] [varchar](120) NULL,
    [Empleado_Ciudad] [varchar](15) NULL,
    [Empleado_Region] [varchar](15) NULL,
    [Empleado_Pais] [varchar](15) NULL,
    [Empleado_Postal] [varchar](10) NULL,
    [ETLLoad] [datetime] NULL,
    [ETLExecution] [int] NULL
)
GO


-- Consulta Origen de Datos [Load_Northwind].dbo.[Employees]

SELECT EmployeeID,
		CAST(LastName AS VARCHAR(40)) AS [LastName],
		CAST(FirstName AS VARCHAR(20)) AS [FirstName],
		CONCAT(CAST(FirstName AS VARCHAR(20)), ' ', CAST(LastName AS VARCHAR(40))) AS [FullName],
		CAST([Address] AS VARCHAR(120)) AS [Address],
		CAST([City] AS VARCHAR(15)) AS [City],
		ISNULL(CAST([Region] AS VARCHAR(15)), 'SR') AS [Region],
		CAST([Country] AS VARCHAR(15)) AS [Country],
		CAST([PostalCode] AS VARCHAR(40)) AS [PostalCode]
FROM Load_Northwind.dbo.Employees;

-- Insertar registro en Metadata
INSERT INTO ETLExecution (userName, MachineName, PackageName, ETLLoad)
VALUES (?, ?, ?, GETDATE());

-- Obtener el ultimo ID del Metadata
SELECT TOP(1) ID
FROM ETLExecution
WHERE packageName = ?;

-- Actualizar la cantidad de filas en el metadata
UPDATE ETLEXECUTION
SET ETLCountRows = ?
WHERE ID = ?;

SELECT * FROM 
Stage_Northwind.dbo.Stage_Empleado

SELECT * FROM
Load_Northwind.dbo.Employees
ORDER BY ETLExecution DESC

SELECT * FROM
NORTHWIND_METADATA.dbo.ETLExecution
ORDER BY ID DESC

TRUNCATE TABLE Load_Northwind.[dbo].[Employees]
TRUNCATE TABLE Stage_Northwind.[dbo].[Stage_Empleado]
TRUNCATE TABLE NORTHWIND_METADATA.[dbo].[ETLExecution]