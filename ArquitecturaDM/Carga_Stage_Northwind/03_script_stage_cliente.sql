--USANDO LA BASE DE DATOS STAGE_NORTHWND
use Stage_Northwind
GO

CREATE TABLE [dbo].[Stage_Cliente](
    [Cliente_Codigo] [char](5) NOT NULL,
    [Cliente_Nombre] [varchar](40) NOT NULL,
    [Cliente_Compania] [varchar](40) NULL,
    [Cliente_Direccion] [varchar](60) NULL,
    [Cliente_Ciudad] [varchar](15) NULL,
    [Cliente_Region] [varchar](15) NULL,
    [Cliente_Pais] [varchar](15) NULL,
    [Cliente_Postal] [varchar](10) NULL,
    [ETLLoad] [datetime] NULL,
    [ETLExecution] [int] NULL
)