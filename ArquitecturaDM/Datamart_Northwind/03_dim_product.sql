-- DimProduct

SELECT [Producto_Codigo]
      ,CAST([Producto_Nombre] as nvarchar(40)) AS [Producto_Nombre]
      ,CAST([CategoriaProducto_Nombre] AS nvarchar (15)) AS [Categoria_nombre]
      ,CAST([ProveedorNombre] AS nvarchar (40)) AS [ProveedorNombre]
      ,[ETLLoad]
      ,[ETLExecution]
  FROM [Stage_Northwind].[dbo].[Stage_Producto]


  select * from Datamart_Northwind.dbo.dim_employee

select * from NORTHWIND_METADATA.dbo.ETLExecution

select * from Stage_Northwind.dbo.Dim_Empleado_Mod