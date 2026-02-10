--USANDO LA BASE DE DATOS STAGE_NORTHWND
use Stage_Northwind
GO

CREATE TABLE [dbo].[Stage_Ventas](
    [Cliente_Codigo] [char](5) NOT NULL,
    [Empleado_Codigo] [int] NOT NULL,
    [Producto_Codigo] [int] NOT NULL,
    [Ventas_OrderDate] [datetime] NOT NULL,
    [Ventas_NOrden] [int] NOT NULL,
    [Ventas_Monto] [decimal](15, 2) NOT NULL,
    [Ventas_Unidades] [int] NOT NULL,
    [Ventas_PUnitario] [decimal](15, 2) NOT NULL,
    [Ventas_Descuento] [decimal](15, 2) NOT NULL,
    [ETLLoad] [datetime] NULL,
    [ETLExecution] [int] NULL
)
GO