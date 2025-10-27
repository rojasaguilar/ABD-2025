--21400767_U3P2.SQL
--PRACTICA 2
--UNIDAD 3
--AUTOR: RAMSES ROJAS AGUILAR
--21400767
--BREVE DESCRIPCIÓN

/* 1. CONSULTAR LOS INDICES QUE TIENE
CADA TABLA POR SEPARADO*/

USE Northwind;

EXEC sp_helpindex [Ventas.Orders];
EXEC sp_helpindex [Ventas.EmployeeTerritories];
EXEC sp_helpindex [Personas.CustomerCustomerDemo];
EXEC sp_helpindex [Personas.CustomerDemographics];
EXEC sp_helpindex [Personas.Customers];
EXEC sp_helpindex [Personas.Employees];
EXEC sp_helpindex [Ventas.Categories];
EXEC sp_helpindex [Ventas.Order Details];
EXEC sp_helpindex [Ventas.Products];
EXEC sp_helpindex [Ventas.Shippers];
EXEC sp_helpindex [Ventas.Suppliers];
EXEC sp_helpindex [Ventas.Territories];

/* 2. CONULSTAR LOS INDICES DE TODA 
LA BASE DE DATOS */

SELECT * FROM SYS.indexes

--tarea diseniar consulta que aparezcan datos principales del index 
-- 1. cómo se llama, 
-- 2. si es clusterieado 
-- 3. como se llama el obejto que contiene el ídnie

select i.name as nombreIndex, i.type_desc as TipoIndex, o.name as Objeto from sys.indexes i
inner join sys.tables o on i.object_id = o.object_id;

--VERSION MÁS COMPLETA
SELECT Sc.name as 'ESQUEMA',
		T.name as 'TABLA',
		S.type_desc as 'TIPO INDICE'
FROM SYS.indexes s
INNER JOIN sys.tables T
ON(T.object_id = S.object_id)
INNER JOIN SYS.schemas sc
on(sc.schema_id = t.schema_id)
where s.index_id > 0 and 
sc.name IN ('Ventas', 'Personas', 'DBO')
order by sc.name;


--3. CREAR DOS INDICES PARA LAS ORDERS Y UN INDICE PARA LA TABLA ORDER DETAILS

CREATE INDEX INX_CUSTOMERDATE
ON Ventas.ORDERS (customerid,orderDate);

CREATE NONCLUSTERED INDEX INX_EMPLOYEEDATE
ON Ventas.Orders(employeeId, orderdate);

EXEC sp_helpindex [Ventas.Orders];

EXEC sp_helpindex [Ventas.Order Details];


CREATE NONCLUSTERED INDEX INX_ProductQuantity
on Ventas.[Order Details](ProductId, Quantity);

--4. CREAR UNA TABLA LLAMADA MovimientosInventario
-- id,productId, tipoMov, fechaMov, quantity
-- INDICE DE LA LLAVE PRMIARIA PERO NO CLUSTERED
-- INDICE POR PRODUCTID

CREATE TABLE Ventas.MovimientosInventario (
idMovimiento int IDENTITY(1,1),
productId INT,
tipoMov VARCHAR(10),
quantity SMALLINT,
fechaMov DATETIME
)
--CREAR INDICE CLUSTERED
CREATE CLUSTERED INDEX inx_movimientosprod
on Ventas.MovimientosInventario(productId);

--CREAR PK --AUTOMATEICAMENTE INDICE
ALTER TABLE Ventas.MovimientosInventario
ADD CONSTRAINT PK_MovInventario
PRIMARY KEY NONCLUSTERED(idMovimiento);

--CREAR FOREIGN KEY CON PRODUCTOS
ALTER TABLE Ventas.MovimientosInventario
ADD CONSTRAINT FK_MovProducts
FOREIGN KEY(productId)
REFERENCES Ventas.Products(productId);

--VERIFICAR INDICES DE LA TABLA RECIEN CREADA
EXEC sp_helpindex [Ventas.MovimientosInventario];

--6. INSERTA EN LA TABLA CLIENTES 10 REG
SELECT * FROM Personas.Customers;
INSERT INTO Personas.Customers (CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax) VALUES
('DLFAI', 'Alfreds Futterkiste', 'Maria Anders', 'Sales Representative', 'Obere Str. 57', 'Berlin', NULL, '12209', 'Germany', '030-0074321', '030-0076545'),
('CONAX', 'Bon App', 'Laurence Lebihan', 'Owner', '12 rue des Bouchers', 'Marseille', NULL, '13008', 'France', '91.24.45.40', '91.24.45.41'),
('CFDF', 'Cactus Comidas para llevar', 'Patricio Simpson', 'Sales Agent', 'Cerrito 333', 'Buenos Aires', NULL, '1010', 'Argentina', '(1) 135-5555', '(1) 135-4892'),
('ESAS', 'Eastern Connection', 'Ann Devon', 'Sales Agent', '35 King George', 'London', NULL, 'WX3 6FW', 'UK', '(171) 555-0297', '(171) 555-3373'),
('YGHJ', 'Frankenversand', 'Peter Franken', 'Marketing Manager', 'Berliner Platz 43', 'München', NULL, '80805', 'Germany', '089-0877310', '089-0877451'),
('CVDF', 'Island Trading', 'Helen Bennett', 'Marketing Manager', 'Garden House Crowther Way', 'Cowes', 'Isle of Wight', 'PO31 7PJ', 'UK', '(198) 555-8888', NULL),
('CWED', 'Königlich Essen', 'Philip Cramer', 'Sales Associate', 'Maubelstr. 90', 'Brandenburg', NULL, '14776', 'Germany', '0555-09876', '0555-09877'),
('LMKJ', 'La maison Asie', 'Annette Roulet', 'Sales Manager', '1 rue Alsace-Lorraine', 'Toulouse', NULL, '31000', 'France', '61.77.61.10', '61.77.61.11'),
('QUEC', 'Queen Cozinha', 'Lúcia Carvalho', 'Marketing Assistant', 'Alameda dos Canàrios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil', '(11) 555-1189', '(11) 555-1180'),
('RTGBV', 'Richter Supermarkt', 'Michael Holz', 'Sales Representative', 'Grenzacherweg 237', 'Genève', NULL, '1203', 'Switzerland', '0897-034555', '0897-034556');

--7. BORRA LOS DETALLE DE ORDEN Y SUS ORDENES
--RESPECTIVAS DE 10 CLIENTES Y BORRA LOS CLIENTES

select top 10 CustomerID from Ventas.Orders
group by CustomerID;

select * from ventas.Orders;
select * from Ventas.[Order Details];

delete od from Ventas.[Order Details] od
inner join Ventas.Orders o
on (o.OrderID = od.OrderID)
where o.CustomerID in (
    'ALFKI', 'ANATR', 'ANTON', 'AROUT', 'BERGS',
    'BLAUS', 'BLONP', 'BOLID', 'BONAP', 'BOTTM'
);

delete from Ventas.Orders 
where CustomerID in (
    'ALFKI', 'ANATR', 'ANTON', 'AROUT', 'BERGS',
    'BLAUS', 'BLONP', 'BOLID', 'BONAP', 'BOTTM'
);

DELETE FROM Personas.Customers
where CustomerID in (
    'ALFKI', 'ANATR', 'ANTON', 'AROUT', 'BERGS',
    'BLAUS', 'BLONP', 'BOLID', 'BONAP', 'BOTTM'
);

--8. INSERTA 5 CLIENTES
INSERT INTO Personas.Customers (CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax) VALUES
('HGJS', 'Blauer See Delikatessen', 'Hanna Moos', 'Sales Representative', 'Forsterstr. 57', 'Mannheim', NULL, '68306', 'Germany', '0621-08460', '0621-08924'),
('IKGN', 'Océano Atlántico Ltda.', 'Yvonne Moncada', 'Sales Manager', 'Ing. Gustavo Moncada 8585 Piso 20-A', 'Buenos Aires', NULL, '1010', 'Argentina', '(1) 432-5555', '(1) 432-5556'),
('ASKD', 'Folk och fä HB', 'Maria Larsson', 'Owner', 'Åkergatan 24', 'Bräcke', NULL, 'S-844 67', 'Sweden', '0695-34 67 21', NULL),
('LOKJ', 'Godos Cocina Típica', 'José Pedro Freyre', 'Sales Manager', 'C/ Romero, 33', 'Sevilla', NULL, '41101', 'Spain', '(95) 555-8200', '(95) 555-8201'),
('PLKMN', 'Hungry Coyote Import Store', 'Yoshi Latimer', 'Sales Representative', 'City Center Plaza 516 Main St.', 'Elgin', 'OR', '97827', 'USA', '(503) 555-6874', '(503) 555-2376');


--9. BORRAR DE NUEVO 5 CLIENTES, SUS ORDENES Y
-- Y SUS DETALLES
select top 5 CustomerID from Ventas.Orders
group by CustomerID;

select * from ventas.Orders;
select * from Ventas.[Order Details];

delete od from Ventas.[Order Details] od
inner join Ventas.Orders o
on (o.OrderID = od.OrderID)
where o.CustomerID in (
   'BSBEV', 'CACTU', 'CENTC','CHOPS','COMMI'
);

delete from Ventas.Orders 
where CustomerID in (
   'BSBEV', 'CACTU', 'CENTC','CHOPS','COMMI'
);

DELETE FROM Personas.Customers
where CustomerID in (
   'BSBEV', 'CACTU', 'CENTC','CHOPS','COMMI'
);

--10. INSERTA 5 CLIENTES

INSERT INTO Personas.Customers (CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax) VALUES
('ASDCX', 'Vins et alcools Chevalier', 'Paul Henriot', 'Accounting Manager', '59 rue de lAbbaye', 'Reims', NULL, '51100', 'France', '26.47.15.10', '26.47.15.11'),
('ZXCVB', 'Die Wandernde Kuh', 'Rita Müller', 'Sales Representative', 'Adenauerallee 900', 'Stuttgart', NULL, '70563', 'Germany', '0711-020361', '0711-035428'),
('QAZXS', 'Blondel père et fils', 'Frédérique Citeaux', 'Marketing Manager', '24 place Kléber', 'Strasbourg', NULL, '67000', 'France', '88.60.15.31', '88.60.15.32'),
('RDXZS', 'Save-a-lot Markets', 'Jose Pavarotti', 'Sales Representative', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', '(208) 555-8097', NULL),
('QWERT', 'Princesa Isabel Vinhos', 'Isabel de Castro', 'Owner', 'Estrada da Saúde n. 58', 'Lisboa', NULL, '1756', 'Portugal', '(1) 356-5634', '(1) 356-5635');

--11. CONSULTA DE NUEVO Y VE SI YA LOGRASTE
--FRAGMENTAR EL INDICE DE PK DE LA TABLA

SELECT 
    dbschemas.name AS SchemaName,
    dbtables.name AS TableName,
    dbindexes.name AS IndexName,
    indexstats.avg_fragmentation_in_percent,
    indexstats.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('Ventas.Orders'), NULL, NULL, 'LIMITED') AS indexstats
INNER JOIN sys.tables dbtables
    ON dbtables.object_id = indexstats.object_id
INNER JOIN sys.schemas dbschemas
    ON dbtables.schema_id = dbschemas.schema_id
INNER JOIN sys.indexes AS dbindexes
    ON dbindexes.object_id = indexstats.object_id
    AND indexstats.index_id = dbindexes.index_id
WHERE dbindexes.is_primary_key = 1;

SELECT 
    dbschemas.name AS SchemaName,
    dbtables.name AS TableName,
    dbindexes.name AS IndexName,
    indexstats.avg_fragmentation_in_percent,
    indexstats.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('Ventas.Order Details'), NULL, NULL, 'LIMITED') AS indexstats
INNER JOIN sys.tables dbtables
    ON dbtables.object_id = indexstats.object_id
INNER JOIN sys.schemas dbschemas
    ON dbtables.schema_id = dbschemas.schema_id
INNER JOIN sys.indexes AS dbindexes
    ON dbindexes.object_id = indexstats.object_id
    AND indexstats.index_id = dbindexes.index_id
WHERE dbindexes.is_primary_key = 1;

SELECT 
    dbschemas.name AS SchemaName,
    dbtables.name AS TableName,
    dbindexes.name AS IndexName,
    indexstats.avg_fragmentation_in_percent,
    indexstats.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('Personas.Customers'), NULL, NULL, 'LIMITED') AS indexstats
INNER JOIN sys.tables dbtables
    ON dbtables.object_id = indexstats.object_id
INNER JOIN sys.schemas dbschemas
    ON dbtables.schema_id = dbschemas.schema_id
INNER JOIN sys.indexes AS dbindexes
    ON dbindexes.object_id = indexstats.object_id
    AND indexstats.index_id = dbindexes.index_id
WHERE dbindexes.is_primary_key = 1;

--TODOS JUNTOS
SELECT OBJECT_NAME(IDX.OBJECT_ID) AS Table_Name,
IDX.name AS Index_Name,
IDXPS.index_type_desc AS Index_Type,
IDXPS.avg_fragmentation_in_percent AS
Fragmentation_Percentage
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL,
NULL, NULL, NULL) IDXPS
INNER JOIN sys.indexes IDX
ON IDX.object_id = IDXPS.object_id
AND IDX.index_id = IDXPS.index_id
where OBJECT_NAME(IDX.OBJECT_ID) = 'Orders'
--ORDER BY Fragmentation_Percentage DESC

--RECONSTRUIR Y REORGANIZAR INDICES DE ORDERS
ALTER INDEX CustomerID
ON Ventas.orders
REBUILD;

ALTER INDEX CustomerID
on Ventas.orders
REORGANIZE;

--RECONSTRUIR Y REORGANIZAR INDICES DE LA TABLA
ALTER INDEX ALL
ON Ventas.orders
REBUILD;

ALTER INDEX ALL
on Ventas.orders
REORGANIZE;

SELECT o.OrderID, o.OrderDate,
	   (e.FirstName + ' ' + e.LastName) as empleado,
	   c.CompanyName as cliente
from Ventas.Orders o 
inner join Personas.Employees e
on (e.EmployeeID = o.EmployeeID)
inner join Personas.Customers c 
on (c.CustomerID = o.CustomerID)
order by c.CompanyName