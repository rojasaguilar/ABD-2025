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

/* 2. CONULSTAR LOS INDICES DE TODA 
LA BASE DE DATOS */

SELECT * FROM SYS.indexes

--tarea diseniar consulta que aparezcan datos principales del index 
-- 1. cómo se llama, 
-- 2. si es clusterieado 
-- 3. como se llama el obejto que contiene el ídnie

select i.name as nombreIndex, i.type_desc as TipoIndex, o.name as Objeto from sys.indexes i
inner join sys.objects o on i.object_id = o.object_id;
