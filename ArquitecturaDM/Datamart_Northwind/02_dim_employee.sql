	SELECT se.Empleado_Codigo,
	CAST(Empleado_NombreCompleto AS NVARCHAR(61)) AS Empleado_NombreCompleto,
	CAST(se.Empleado_Region AS NVARCHAR(15)) AS Empleado_Region,
	CAST(se.Empleado_Ciudad AS NVARCHAR(15)) AS Empleado_Ciudad,
	CAST(se.Empleado_Pais AS NVARCHAR(15)) AS Empleado_Pais
	from Stage_Northwind.dbo.Stage_Empleado AS se;

	CREATE TABLE [dbo].[Dim_Empleado_Mod](
	[IDEmpleado] [int] IDENTITY(1,1) NOT NULL,
	[Empleado_Codigo] [int] NOT NULL,
	[Empleado_NombreCompleto] [nvarchar](70) NOT NULL,
	[Empleado_Ciudad] [nvarchar](50) NULL,
	[Empleado_Region] [nvarchar](50) NULL,
	[Empleado_Pais] [nvarchar](50) NULL,
	[ETLLoad] [datetime] NULL
)

INSERT INTO [Stage_Northwind].[dbo].[Dim_Empleado_Mod]
([Empleado_Codigo], [Empleado_NombreCompleto], [Empleado_Ciudad], [Empleado_Region], [Empleado_Pais], [ETLLoad])
VALUES
(?, ?, ?, ?, ?, GETDATE())