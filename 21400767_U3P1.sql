--21400767_U3P1.SQL
--PRACTICA 1
--UNIDAD 3
--AUTOR: RAMSES ROJAS AGUILAR
--21400767
--BREVE DESCRIPCIÓN

USE Northwind;
--1. VERIFICAR QUE ESQUEMAS EXISTEN
SELECT * FROM sys.schemas;

--2. CREAR DOS ESQUEMAS BD NORTHWIND
CREATE SCHEMA Personas;
CREATE SCHEMA Ventas;

--3. VERIFICAR QUE TABLAS TIENE CADA ESQUEMA
SELECT o.name, s.name
FROM SYS.objects o
INNER JOIN SYS.SCHEMAS s
ON (s.schema_id = o.schema_id)
WHERE TYPE = 'U'
ORDER BY o.type desc;

--4. CAMBIAR LAS TABLAS AL ESQUEMA QUE DEBEN ESTAR
ALTER SCHEMA Ventas
TRANSFER Orders;

ALTER SCHEMA Ventas 
TRANSFER [dbo].[Order Details];

ALTER SCHEMA Ventas 
TRANSFER dbo.Products;

ALTER SCHEMA Ventas
TRANSFER dbo.Shippers;

ALTER SCHEMA Ventas
TRANSFER dbo.Categories;

ALTER SCHEMA Ventas
TRANSFER dbo.Suppliers;

ALTER SCHEMA Ventas
TRANSFER dbo.Region;

ALTER SCHEMA Ventas
TRANSFER dbo.Territories;

ALTER SCHEMA Ventas
TRANSFER dbo.EmployeeTerritories;

ALTER SCHEMA Personas
TRANSFER dbo.Employees;

ALTER SCHEMA Personas
TRANSFER dbo.Customers;

ALTER SCHEMA Personas
TRANSFER dbo.CustomerCustomerDemo;

ALTER SCHEMA Personas
TRANSFER dbo.CustomerDemographics;

--TRANSFERIR TODAS LAS TABLAS A OTRO SCHEMA (solo en los dos que ya creamos)
--MOSTRAR TODAS LAS TABLAS CON UN ORDER BY DIFERENTE A LA LLAVE PRIMARIA

SELECT * FROM Personas.Employees
ORDER BY HireDate;

SELECT * FROM Ventas.Categories
ORDER BY CategoryName desc;

SELECT * FROM Personas.Customers
ORDER BY City desc;

SELECT * FROM Ventas.Shippers
ORDER BY CompanyName desc;

SELECT * FROM Ventas.Orders
ORDER BY Freight;

SELECT * FROM Ventas.Products
ORDER BY QuantityPerUnit desc;

SELECT * FROM Ventas.[Order Details]
ORDER BY UnitPrice;

SELECT * FROM Ventas.Region
ORDER BY RegionDescription;

SELECT * FROM Ventas.Territories
ORDER BY TerritoryDescription;

SELECT * FROM Ventas.[EmployeeTerritories]
ORDER BY TerritoryID desc;

-- MODIFICAR LAS FECHAS DE TODAS LAS TABLAS (SON DE 199X A 2025,2024,2023)

UPDATE Personas.Employees 
set HireDate = Case
WHEN YEAR(HireDate) = 1992 THEN DATEADD(YEAR, 31, HireDate) 
WHEN YEAR(HireDate) = 1993 THEN DATEADD(YEAR, 31, HireDate) 
WHEN YEAR(HireDate) = 1994 THEN DATEADD(YEAR, 31, HireDate)
ELSE HireDate
END;

UPDATE Ventas.Orders
set OrderDate = DATEADD(YEAR, 27, OrderDate)

UPDATE Ventas.Orders
set ShippedDate = DATEADD(YEAR, 27, ShippedDate),
RequiredDate = DATEADD(YEAR, 27, RequiredDate)

UPDATE Personas.Employees 
set BirthDate = DATEADD(YEAR, 20, BirthDate) 

--7 CREAR UN ROL
CREATE ROLE Capturista;
CREATE ROLE Vendedor;

--AL ROL CAPTURISTA: LECTURA Y ESCRITURA

EXEC sp_addrolemember db_datawriter, Capturista
EXEC sp_addrolemember db_datareader, Capturista

--TAREA
/*
AL ROL VENDEDOR DAR PERMISOS PARA CREAR TABLAS, VISTAS, ETC,
LEER, ESCRIBIR, CREAR USUARIOS */


EXEC sp_addrolemember db_ddladmin, Vendedor --PARA PODER HACER VISTAS Y DEMAS
EXEC sp_addrolemember db_datawriter, Vendedor --PARA PODER CREAR leer
EXEC sp_addrolemember db_datareader, Vendedor --PARA PODER CREAR escribir
EXEC sp_addrolemember db_accessadmin, Vendedor --PARA PODER CREAR USUARIOS

/*
CREAR 3 USUARIOS Y SUS LOGIN RESPECTIVOS Y AGREGARLOS 
PARA QUE SEAN CAPTURISTAS 
*/

--CAPTURISTA1
	CREATE LOGIN capturista1
	WITH PASSWORD = '1234',
	DEFAULT_DATABASE = Northwind
	GO

	CREATE USER capturista1
	FOR LOGIN capturista1;

--CAPTURISTA2
	CREATE LOGIN capturista2
	WITH PASSWORD = '1234',
	DEFAULT_DATABASE = Northwind;

	CREATE USER capturista2
	FOR LOGIN capturista2;

--CAPTURISTA3
	CREATE LOGIN capturista3
	WITH PASSWORD = '1234',
	DEFAULT_DATABASE = Northwind;

	CREATE USER capturista3
	FOR LOGIN capturista3;

--ASIGNAR LOS ROLES
ALTER ROLE Capturista ADD MEMBER Capturista1;
ALTER ROLE Capturista ADD MEMBER Capturista2;
ALTER ROLE Capturista ADD MEMBER Capturista3;

/*
CREAR 5 USUARIOS Y SUS LOGINS Y AGREGARLOS AL ROL DE VENDEDOR
*/
CREATE LOGIN vendedor1
WITH PASSWORD = '1234',
DEFAULT_DATABASE = Northwind;

CREATE USER vendedor1
FOR LOGIN vendedor1;

CREATE LOGIN vendedor2
WITH PASSWORD = '1234',
DEFAULT_DATABASE = Northwind;

CREATE USER vendedor2
FOR LOGIN vendedor2;

CREATE LOGIN vendedor3
WITH PASSWORD = '1234',
DEFAULT_DATABASE = Northwind;

CREATE USER vendedor3
FOR LOGIN vendedor3;

CREATE LOGIN vendedor4
WITH PASSWORD = '1234',
DEFAULT_DATABASE = Northwind;

CREATE USER vendedor4
FOR LOGIN vendedor4;

CREATE LOGIN vendedor5
WITH PASSWORD = '1234',
DEFAULT_DATABASE = Northwind;

CREATE USER vendedor5
FOR LOGIN vendedor5;

ALTER ROLE Vendedor ADD MEMBER vendedor1;
ALTER ROLE Vendedor ADD MEMBER vendedor2;
ALTER ROLE Vendedor ADD MEMBER vendedor3;
ALTER ROLE Vendedor ADD MEMBER vendedor4;
ALTER ROLE Vendedor ADD MEMBER vendedor5;

SELECT sc.name, o.name
FROM sys.objects o
JOIN sys.schemas sc
ON (o.schema_id = sc.schema_id)
WHERE o.type = 'U';
