
if not exists (select name from sys.databases WHERE name =N'miniDB')
begin
	create database miniDB
	COLLATE Latin1_General_100_CI_AS_SC_UTF8;
end
go

use miniDB;
go

-- Creacion de tablas 
IF OBJECT_ID ('clientes', 'U') IS NOT NULL DROP TABLE clientes;

CREATE TABLE clientes(
 idcliente int not null, 
 nombre nvarchar(100),
 edad int,
 ciudad nvarchar(100),
 CONSTRAINT pk_clientes
 PRIMARY KEY (idcliente)
);
GO

IF OBJECT_ID ('productos', 'U') IS NOT NULL DROP TABLE productos;

CREATE TABLE productos(
	Idproducto int primary key, 
	Nombre NVARCHAR (200),
	Categoria NVARCHAR(200),
	Precio DECIMAL(12,2)
);

/*
=================== Insercion de registros en las tablas ===================
*/

INSERT INTO clientes
VALUES(1, 'Ana Torres', 25, 'Ciudad de México');

INSERT INTO clientes (idcliente, nombre, edad, ciudad)
VALUES(2, 'Luis Perez', 34, 'Guadalajara');

INSERT INTO clientes (idcliente, edad, nombre, ciudad)
VALUES(3, 29, 'Soyla Vaca', NULL);

INSERT INTO clientes (idcliente, nombre, edad)
VALUES(4, 'Natacha', 41); 

INSERT INTO clientes (idcliente, nombre, edad, ciudad)
VALUES (5, 'Sofia Lopez', 19, 'Chapulhuacan'),
	(6, 'Laura Hernandez', 38, NULL),
	(7, 'Victor Trujillo', 25, 'Zacualtipan');

GO

CREATE OR ALTER PROCEDURE sp_add_customer
@id int, @Nombre NVARCHAR(100), @edad INT, @ciudad NVARCHAR(100)
AS
BEGIN
	INSERT INTO clientes (idcliente, nombre, edad, ciudad)
	VALUES (@id, @Nombre, @edad, @ciudad);
END;
GO

EXEC sp_add_customer 8, 'Carlos Ruiz', 41, 'Monterrey';
EXEC sp_add_customer 9, 'Jose Angel Perez', 74, 'Salte si Puedes';

SELECT * FROM	 clientes

SELECT COUNT(*) AS [Numero de CLientes]
FROM clientes;

-- Mostrar todos los clientes ordenados por edad de menor a mayor
SELECT UPPER (nombre) AS 'Cliente', edad, UPPER(ciudad)
FROM clientes
ORDER BY edad DESC;	

-- Listar los clientes que viven en Guadalajara
SELECT UPPER (nombre) AS 'Cliente', edad, UPPER(ciudad)
FROM clientes
WHERE ciudad = 'Guadalajara'
ORDER BY edad DESC;	

-- Listar los clientes con una edad mayor o igual a 30
SELECT UPPER (nombre) AS 'Cliente', edad, UPPER(ciudad)
FROM clientes
WHERE edad >=30;

-- Listar los clientes cuya ciudad sea nula
SELECT UPPER (nombre) AS 'Cliente', edad, UPPER(ciudad)
FROM clientes
WHERE ciudad IS NULL;

-- Remplazar en la consulta las ciudades nulas por la palabra DESCONOCIDA (sin modificar los datos originales)
SELECT UPPER (nombre) AS 'Cliente', edad,  ISNULL(UPPER(ciudad), 'DESCONOCIDO') as 'ciudad'
FROM clientes

-- Selecciona los clientes que tengan edad entre 20 y 35 y que vivan en Puebla o Monterrey
SELECT UPPER (nombre) AS 'Cliente', edad,  ISNULL(UPPER(ciudad), 'DESCONOCIDO') as 'ciudad'
FROM clientes
where edad between 20 and 35
	AND
	ciudad in ('Guadalajara', 'Chapulhuacan');

/*
 ======================= Actualizacion de datos =======================
*/

SELECT * FROM clientes;

UPDATE clientes
SET ciudad = 'Xochitlan'
WHERE idcliente = 5;

UPDATE clientes
SET ciudad = 'Sin ciudad'
WHERE ciudad IS NULL;

UPDATE clientes
SET edad = 30
WHERE idcliente between 3 and 6

UPDATE clientes
SET ciudad = 'Metropoli'
WHERE ciudad IN ('Ciudad de México', 'Guadalajara', 'Monterrey');

UPDATE clientes
SET nombre = 'Juan Perez',
	edad = 27,
	ciudad = 'Ciudad Gotica'
WHERE idcliente = 2;

UPDATE clientes
SET nombre = 'Cliente Premium'
WHERE nombre like 'A%'

UPDATE clientes
SET nombre = 'Silver Customer'
WHERE nombre like '%er%'

UPDATE clientes
SET edad = (edad * 2)
WHERE edad >= 30 and ciudad = 'Metropoli'

/*
 ============== Eliminar Datos ==============
*/

DELETE FROM clientes
WHERE edad BETWEEN 25 AND 30;

DELETE clientes 
WHERE nombre LIKE '%r';

TRUNCATE TABLE clientes;

DELETE FROM clientes

/*
 ===================== Store Procedures de Update, Delete y Agregar =====================
*/

-- Modificar los datos por ID

GO
CREATE OR ALTER PROCEDURE sp_update_customers
@id int, @Nombre NVARCHAR(100), @edad INT, @ciudad NVARCHAR(100)
AS
BEGIN
	UPDATE clientes
	SET nombre = @Nombre,
		edad = @edad,
		ciudad = @ciudad
	WHERE idcliente = @id;
END;

EXEC sp_update_customers 7, 'Benito kano', 24, 'Lima los pies';
GO

select * from clientes

EXEC  sp_update_customers 
@ciudad='Martinez de la Torre',
@edad = 56,
@id = 3,
@Nombre = 'Toribio Trompudo';

-- Ejercicio completo donde se pueda ingresar datos en una tabla principal (encabezado) y una tabla detalle, utilizando un sp
GO
-- Tabla principal
CREATE TABLE ventas(
 IdVenta INT IDENTITY (1,1) PRIMARY KEY,
 FechaVenta DATETIME NOT NULL DEFAULT GETDATE(),
Cliente NVARCHAR(100) NOT NULL,
Total DECIMAL (10,2) NULL
);

-- Tabla detalle
CREATE TABLE DetalleVenta(
	IdDetalle INT IDENTITY (1,1) PRIMARY KEY,
	IdVenta INT NOT NULL,
	Producto NVARCHAR(100) NOT NULL,
	Cantidad INT NOT NULL,
	Precio DECIMAL(10,2) NOT NULL
	CONSTRAINT pk_detalleVenta_venta
	FOREIGN KEY(IdVenta)
	REFERENCES Ventas(IdVenta)
);
GO
-- Crear un tipo de tabla (Table Type)

-- Este tipo de tabla servira como estructura para enviar los detalles al sp

CREATE TYPE TipoDetalleVenta AS TABLE (
	Producto NVARCHAR(100),
	Cantidad INT,
	Precio DECIMAL(10,2)
);

GO
-- Crear el store procedure
-- El sp insertara el encabezado y luego todos los detalles utilizando el tipo de tabla

CREATE OR ALTER PROCEDURE InsertasVentaConDetalle
@Cliente nvarchar(100),
@Detalles TipoDetalleVenta READONLY
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @IdVenta INT;
	BEGIN TRY
		BEGIN TRANSACTION;

		-- Insertar en tabla principal
		INSERT INTO ventas(Cliente)
		VALUES(@Cliente);
		-- Obtener el ID recien generado
		SET @IdVenta = SCOPE_IDENTITY();

		-- Insertar los detalles (tabla detalles)
		INSERT INTO DetalleVenta(IdVenta, Producto, Cantidad, Precio)
		SELECT @IdVenta, Producto, Cantidad, Precio
		FROM @Detalles;

		-- Calcular el total de venta
		UPDATE ventas
		SET Total = (SELECT SUM(Cantidad * Precio) FROM @Detalles)
		WHERE IdVenta = @IdVenta;

		COMMIT TRANSACTION;

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	THROW;
END CATCH;
END;
go

-- Ejecutar el SP con datos de prueba
GO
-- Declarar una variable tipo tabla
DECLARE @MisDetalles AS TipoDetalleVenta

-- Insertar productor en el Type Table
INSERT INTO @MisDetalles (Producto, Cantidad, Precio)
VALUES
('Laptop', 1, 15000),
('Mouse', 2, 300),
('Teclado', 1, 500),
('Pantalla', 5, 4500);

-- Ejecutar el SP
exec InsertasVentaConDetalle @Cliente='Uriel Edgar', @Detalles=@MisDetalles

select* from ventas
select* from DetalleVenta

-- Funciones integradas

-- Funciones
SELECT
UPPER(Nombre) AS Mayusculas,
LOWER(Nombre) AS Minusculas,
LEN(Nombre) AS Longitud,
SUBSTRING(Nombre, 1,3)
FROM clientes;

INSERT INTO clientes(idcliente, nombre, edad, ciudad)
VALUES (8, 'Luis López', 45, 'Achichilco');

INSERT INTO clientes(idcliente, nombre, edad, ciudad)
VALUES (9, ' German Galindo', 32, 'Achichilco2 ');

INSERT INTO clientes(idcliente, nombre, edad, ciudad)
VALUES (10, ' Jaen Porfirio ', 19, 'Achichilco3 ');

INSERT INTO clientes(idcliente, nombre, edad, ciudad)
VALUES (11, ' Roberto Estrada ', 19, 'Chapulhuacan ');

SELECT
Nombre AS 'Nombre fuente',
UPPER(Nombre) AS Mayusculas,
LOWER(Nombre) AS Minusculas,
LEN(Nombre) AS Longitud,
SUBSTRING(Nombre, 1,3) AS Prefijo,
LTRIM(Nombre) AS 'Sin Espacios Izquierda',
CONCAT(Nombre, '-', Edad) AS 'Nombre Edad',
UPPER(REPLACE(TRIM(Ciudad), 'Chapulhuacan', 'Chapu')) AS 'Ciudad Normal'
FROM clientes;

-- Crear una tabla a partir de una consulta

SELECT TOP 0
idcliente,
Nombre AS 'Nombre fuente',
UPPER(Nombre) AS Mayusculas,
LOWER(Nombre) AS Minusculas,
LEN(Nombre) AS Longitud,
SUBSTRING(Nombre, 1,3) AS Prefijo,
LTRIM(Nombre) AS 'Sin Espacios Izquierda',
CONCAT(Nombre, '-', Edad) AS 'Nombre Edad',
UPPER(REPLACE(TRIM(Ciudad), 'Chapulhuacan', 'Chapu')) AS 'Ciudad Normal'
INTO stage_clientes
FROM clientes;

-- Agrega un constraint a la tabla (primary key)

ALTER TABLE stage_clientes
ADD CONSTRAINT pk_stage_clientes
PRIMARY KEY (idcliente);


select * from stage_clientes;

-- Insertar datos a partir de una consulta

INSERT INTO stage_clientes (idcliente,[Nombre fuente], Mayusculas, Minusculas, Longitud, Prefijo, [Sin Espacios Izquierda], [Nombre Edad], [Ciudad Normal])
SELECT
idcliente,
Nombre AS 'Nombre fuente',
UPPER(Nombre) AS Mayusculas,
LOWER(Nombre) AS Minusculas,
LEN(Nombre) AS Longitud,
SUBSTRING(Nombre, 1,3) AS Prefijo,
LTRIM(Nombre) AS 'Sin Espacios Izquierda',
CONCAT(Nombre, '-', Edad) AS 'Nombre Edad',
UPPER(REPLACE(TRIM(Ciudad), 'Chapulhuacan', 'Chapu')) AS 'Ciudad Normal'
FROM clientes;

-- Funciones de Fecha

USE NORTHWND

GO
SELECT 
	OrderDate, 
	GETDATE(),
	DATEADD(DAY,10,OrderDate) AS [FechaMas10Dias],
	DATEPART(QUARTER,OrderDate) AS [Trimestre],
	DATENAME(MONTH, OrderDate) AS [MesConNombre],
	DATEPART(MONTH, OrderDate) AS [MesConNumero],
	DATENAME(WEEKDAY,OrderDate) AS [NombreDIA],
	DATEDIFF(DAY,OrderDate,GETDATE()) AS [DiasTranscurridos],
	DATEDIFF(YEAR,OrderDate,GETDATE()) AS [A♫osTranscurridos],
	DATEDIFF(YEAR,'2004-06-17',GETDATE()) AS [EdadPEPE]

FROM Orders

-- Manejo de valores Nulos

USE miniBD

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    SecondaryEmail NVARCHAR(100),
    Phone NVARCHAR(20),
    Salary DECIMAL(10,2),
    Bonus DECIMAL(10,2)
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, SecondaryEmail, Phone, Salary, Bonus)
VALUES (1, 'Ana', 'Lopez', 'ana.lopez@empresa.com',NULL,'555-2345', 12000, 100),
       (2, 'Carlos', 'Ramirez', NULL, 'c.ramirez@empresa.com', NULL, 9500, NULL),
       (3, 'Laura', 'Gomez', NULL, NULL, '555-8900', 0, 500),
       (4, 'Jorge', 'Diaz', 'jorge.diaz@empresa.com', NULL, NULL, 15000, 0);

-- Ejecucion 1 - ISNULL

--Mostrar el nombre completo del empleado junto con su numero de telefono.
--sino tiene telefono, mostrar el texto 'No disponible'

SELECT 
	CONCAT(FirstName,' ',LastName) AS [FullName],
	ISNULL(Phone,'No disponible')
FROM Employees;

-- Ejercicio 2 . Mostrar el nombre del empleado y su correo de contacto

SELECT CONCAT(FirstName, ' ', LastName) as 'Nombre Completo',
email, 
secondaryEmail,
COALESCE(email,secondaryEmail, 'Sin correo') AS Correo_Contacto
from Employees;

-- Ejercicio 3 . NULLIF
-- Mostrar el nombre del empleado, un salario y el resultado de NULLIF(salary, 0) para detectar quien tiene salario 0

SELECT CONCAT(FirstName, ' ', LastName) AS 'Nombre completo',
Salary,
NULLIF(salary, 0) AS 'Salario evaluable'
FROM Employees

-- Evita error de division por 0

SELECT FirstName, Bonus, (Bonus/NULLIF(salary, 0)) AS Bonus_Salario
FROM Employees

-- Expresiones condicionales CASE
-- Permite crear condiciones dentro de una consulta

SELECT
	UPPER(CONCAT(FirstName, ' ', LastName)) AS 'Full name',
	ROUND(salary,2) AS 'Salario',
	CASE WHEN ROUND(salary,2) >= 10000 THEN 'Alto'
	WHEN ROUND(salary,2) BETWEEN 5000 and 9999 THEN 'Medio'
	ELSE 'Bajo'
END AS 'Nivel Salarial'
FROM Employees;

-- Combinar funciones y CASE

-- Seleccionar el nombre del producto, la fecha de la orden, el nombre del cliente en mayuscula, validar si el telefono es null, 
-- poner la palabra no disponible y comprobar la fecha de la orden restando los dias de la fecha de orden con respecto a la fecha
-- de hoy, si estos dias son menores a 30 entonces mostrar la palabra RECIENTE y si no ANTIGUO, el campo debe llamarse 'Estado de Pedido',
-- utiliza la base de datos NORTHWIND

SELECT * FROM Employees
SELECT * FROM Orders
select * from Customers

SELECT p.ProductName, o.OrderDate, UPPER(c.CompanyName) AS 'Nombre del cliente',
ISNULL(c.Phone, 'No disponible') AS 'Telefono',
CASE WHEN DATEDIFF(day, o.OrderDate, GETDATE()) < 30 THEN 'Reciente'
ELSE 'Antiguo'
END AS 'Estado de Pedido'
FROM Products AS p
INNER JOIN [Order Details] AS od
ON p.ProductID = od.ProductID
INNER JOIN Orders as o
ON o.OrderID = od.OrderID
INNER JOIN Customers as c
ON c.CustomerID = o.CustomerID

-- Crear tabla a partir de esta consulta

SELECT p.ProductName, o.OrderDate, UPPER(c.CompanyName) AS 'Nombre del cliente',
ISNULL(c.Phone, 'No disponible') AS 'Telefono',
CASE WHEN DATEDIFF(day, o.OrderDate, GETDATE()) < 30 THEN 'Reciente'
ELSE 'Antiguo'
END AS 'Estado de Pedido'
INTO tablaformateada
FROM Products AS p
INNER JOIN [Order Details] AS od
ON p.ProductID = od.ProductID
INNER JOIN Orders as o
ON o.OrderID = od.OrderID
INNER JOIN Customers as c
ON c.CustomerID = o.CustomerID

CREATE OR ALTER VIEW v_pedidosAntiguos
AS

select [Nombre del cliente], ProductName, [Estado de Pedido]
from tablaformateada
WHERE [Estado de Pedido] = 'Antiguo';

select* from tablaformateada

select * from v_pedidosAntiguos

