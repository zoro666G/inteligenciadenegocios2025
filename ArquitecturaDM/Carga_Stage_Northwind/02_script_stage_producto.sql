--USANDO LA BASE DE DATOS STAGE_NORTHWND
use Stage_Northwind
GO

CREATE TABLE [dbo].[Stage_Producto](
    [Producto_Codigo] [int] NOT NULL,
    [Producto_Nombre] [varchar](50) NOT NULL,
    [Producto_PUnitario] [decimal](15, 2) NULL,
    [CategoriaProducto_Codigo] [int] NOT NULL,
    [ProveedorNombre] [varchar](40) NULL,
    [ETLLoad] [datetime] NULL,
    [ETLExecution] [int] NULL
)
GO