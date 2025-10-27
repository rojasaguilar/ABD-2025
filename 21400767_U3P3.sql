--21400767_U3P3.SQL
--PRACTICA 3
--UNIDAD 3
--AUTOR: RAMSES ROJAS AGUILAR
--21400767
--BREVE DESCRIPCIÓN
/*
Practica 3. BD ITTEPIC
Solo debes hacer la creación de roles y creación de usuario 1 con sa (usuario dbo)
*/


-- 1. Crea la base de datos

CREATE DATABASE BDITTEPIC
ON PRIMARY (
NAME = 'BDITTEPIC', 
FILENAME = 'C:\ABD2025\BDITTEPIC.mdf'
)
LOG ON (
 NAME = 'Northwind_log', 
 FILENAME = 'C:\ABD2025\BDITTEPIC.ldf'
)

--2. Crea tres roles:
	/*
	• El primero: es un rol que puede hacer respaldos, modificaciones al esquema de la
	bd, realizar consultas en la bd, crear usuarios(logins).
	• El segundo: solo puede consultar, insertar, actualizar y eliminar registros.
	• El tercero : solo podrá consultar
	*/

	--1er rol (hacer respaldos, modificaciones al esquema de la bd, realizar consultas en la bd, crear usuarios(logins))

	CREATE LOGIN bacSchReaLog WITH PASSWORD = '1234';
	ALTER SERVER ROLE securityadmin ADD MEMBER bacSchReaLog; --PARA PODER HACER LOGINS

	USE BDITTEPIC;
	CREATE ROLE bacSchReaLog;

	EXEC sp_addrolemember db_backupoperator, bacSchReaLog
	EXEC sp_addrolemember db_ddladmin, bacSchReaLog
	EXEC sp_addrolemember db_datareader, bacSchReaLog
	EXEC sp_addrolemember db_owner ,  bacSchReaLog

	--2do rol (consultar, insertar, actualizar y eliminar registros.)
	CREATE ROLE crudRole;

	EXEC sp_addrolemember 'db_datawriter', 'crudRole'
	EXEC sp_addrolemember 'db_datareader', 'crudRole'


	--3er rol  (solo podrá consultar)
	CREATE ROLE readOnlyRole;

	EXEC sp_addrolemember 'db_datareader', 'readOnlyRole'


-- 3. Crear un usuario y agrégalo al rol 1
	CREATE user bacSchReaLogUser for login bacSchReaLog;
	EXEC sp_addrolemember 'bacSchReaLog', 'bacSchReaLogUser';

--4. Conéctate con el usuario que pertenece al rol 1 y realiza lo siguiente:
	--Crear un usuario y lo agregas al rol 2
	use BDITTEPIC;
	CREATE LOGIN crudLogin with password = '1234';
	CREATE USER crudUser for login crudLogin;
	EXEC sp_addrolemember 'crudRole', 'crudUser';

	--Crear un usuario y lo agregas al rol 3.
	CREATE LOGIN readOnlyLogin with password = '1234';
	CREATE USER readOnlyUser for login readOnlyLogin;
	EXEC sp_addrolemember 'readOnlyRole', 'readOnlyUser';


--5. Crea los esquemas Esquemas:
	--catálogos
	CREATE SCHEMA catalogos;
	--participantes
	CREATE SCHEMA participantes;
	--impartidos
	CREATE SCHEMA impartidos;


--6. Crea Tablas:
CREATE TABLE CATALOGOS.CURSOS
( CUR_ID INT IDENTITY(1,1) PRIMARY KEY,
CUR_NOMBRE VARCHAR(50),
CUR_DESCRIPTICION VARCHAR(300),
INT_ID INT
);
CREATE TABLE CATALOGOS.TALLER
( TAR_ID INT IDENTITY(1,1) PRIMARY KEY,
TAR_NOMBRE VARCHAR(50),
TAR_DESCRIPTICION VARCHAR(300),
INT_ID INT
);
CREATE TABLE CATALOGOS.DIPLOMADOS
( DIP_ID INT IDENTITY(1,1) PRIMARY KEY,
DIP_NOMBRE VARCHAR(50),
DIP_DESCRIPTICION VARCHAR(300),

INT_ID INT
);
CREATE TABLE MANUALES
( MANUAL_ID INT IDENTITY(1,1) PRIMARY KEY,
ID_CUDIPTA VARCHAR(50), --FK PARA CUALQUIER TIPO CURSO, TALLER ,
DIPLOMADO
MANUAL_URL VARCHAR(150)
);

CREATE TABLE PARTICIPANTES.CURSOSABIERTOS
( IMP_ID INT PRIMARY KEY,
ID_CUDIPTA VARCHAR(50), --FK PARA CUALQUIER TIPO CURSO, TALLER ,
DIPLOMADO
IMP_FECHAINI DATE,
IMP_FECHAFIN DATE,
);

CREATE TABLE INSTRUCTORES
( INT_ID INT IDENTITY(1,1) PRIMARY KEY,
INT_NOMBRE VARCHAR(50),
INT_PROFESION VARCHAR(30) );

CREATE TABLE DIPLOMADOS.LISTAS
( LIS_ID INT PRIMARY KEY,
IMP_ID INT,
ID_TRAB INT,
LIS_ESTATUS CHAR(1));

CREATE TABLE TRABAJADOR
(ID_TRAB INT PRIMARY KEY,
NOMBRE_TRAB VARCHAR(100),
DEPTO_TRAB VARCHAR(60)
);

/*7. Ve el diagrama y Debe agregar la FK para que la bd quede como lo indica..
8. Cambia las tablas que quedaron en diferente esquema al diagrama.
9. Consultar en que esquemas quedaron cada tabla mostrando el esquema, el objeto
10.Ponga diferentes esquemas por default a cada usuario.
11. Conéctate con el usuario correspondiente e Inserte, modifique y borre al menos dos
registros en distintas tablas.
12. Conéctate con el usuario correspondiente y consulta los registros de cada tabla y
realiza al menos dos consultas mas con INNER JOIN y WHERE, tu decides cuales.
13. Regresa a SA y consulta cuantos usuarios hay en cada rol.
14. Genere el diagrama de la bd (dbo)
15. Describe como quedo la bd con comentarios.
16. Crear al menos tres índices adicionales en las tablas que tu elijas
17. Consulta los índices de la base de datos mostrando el esquema, nombre de objeto,
nombre de indice y tipo de indice
18. Consulta los porcentajes de fragmentación de los índices
*/