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
 NAME = 'BDITTEPIC_log', 
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
	ID_CUDIPTA VARCHAR(50), --FK PARA CUALQUIER TIPO CURSO, TALLER ,DIPLOMADO
	MANUAL_URL VARCHAR(150)
	);

	CREATE TABLE PARTICIPANTES.CURSOSABIERTOS
	( IMP_ID INT PRIMARY KEY,
	ID_CUDIPTA VARCHAR(50), --FK PARA CUALQUIER TIPO CURSO, TALLER ,DIPLOMADO
	IMP_FECHAINI DATE,
	IMP_FECHAFIN DATE,
	);

	CREATE TABLE INSTRUCTORES
	( INT_ID INT IDENTITY(1,1) PRIMARY KEY,
	INT_NOMBRE VARCHAR(50),
	INT_PROFESION VARCHAR(30) );

	CREATE TABLE LISTAS
	( LIS_ID INT PRIMARY KEY,
	IMP_ID INT,
	ID_TRAB INT,
	LIS_ESTATUS CHAR(1));

	CREATE TABLE TRABAJADOR
	(ID_TRAB INT PRIMARY KEY,
	NOMBRE_TRAB VARCHAR(100),
	DEPTO_TRAB VARCHAR(60)
	);

--7. Ve el diagrama y Debe agregar la FK para que la bd quede como lo indica..

--8. Cambia las tablas que quedaron en diferente esquema al diagrama.
	ALTER SCHEMA impartidos 
	transfer instructores;

	ALTER SCHEMA impartidos
	TRANSFER participantes.CURSOSABIERTOS;

	ALTER SCHEMA catalogos
	TRANSFER manuales;

	ALTER SCHEMA participantes
	transfer LISTAS;

	ALTER SCHEMA participantes
	transfer trabajador;

--9. Consultar en que esquemas quedaron cada tabla mostrando el esquema, el objeto
	select s.name as nombreEsquema, o.name as nombreObjeto 
	from sys.schemas s
	inner join sys.objects o on(o.schema_id = s.schema_id)
	where type = 'U'

--10.Ponga diferentes esquemas por default a cada usuario.
	alter user readOnlyUser with default_schema = catalogos;
	alter user crudUser with default_schema = impartidos;
	alter user bacSchReaLogUser with default_schema = participantes;

	SELECT name, default_schema_name 
	FROM sys.database_principals
	WHERE type_desc = 'SQL_USER';

--11. Conéctate con el usuario correspondiente e Inserte, modifique y borre al menos dos
--registros en distintas tablas.

EXEC AS USER = 'crudUser';

	INSERT INTO impartidos.instructores (INT_NOMBRE, INT_PROFESION)
	VALUES ('Natalia López', 'Diseñadora'), ('Ramses Rojas', 'Programador')

	UPDATE impartidos.instructores
	SET INT_PROFESION = 'Diseñadora Senior'
	WHERE INT_NOMBRE = 'Natalia López';

	UPDATE impartidos.instructores
	SET INT_PROFESION = 'Programador Senior'
	WHERE INT_NOMBRE = 'Ramses Rojas';

	DELETE FROM impartidos.instructores
	WHERE INT_NOMBRE = 'Natalia López';

--12. Conéctate con el usuario correspondiente y consulta los registros de cada tabla y
--realiza al menos dos consultas mas con INNER JOIN y WHERE, tu decides cuales.

	EXEC AS USER = 'readOnlyUser';

	select * from catalogos.CURSOS
	select * from catalogos.CURSOS
	select * from catalogos.TALLER
	select * from catalogos.MANUALES
	select * from impartidos.instructores
	select * from impartidos.cursosabiertos
	select * from participantes.listas
	select * from participantes.trabajador

	SELECT 
		ca.IMP_ID,
		ca.ID_CUDIPTA,
		i.INT_NOMBRE AS Instructor,
		i.INT_PROFESION AS Profesion,
		ca.IMP_FECHAINI,
		ca.IMP_FECHAFIN
	FROM impartidos.CURSOSABIERTOS ca
	INNER JOIN impartidos.INSTRUCTORES i
		ON ca.ID_CUDIPTA LIKE CONCAT('%', i.INT_ID, '%')
	ORDER BY ca.IMP_FECHAINI;

	SELECT 
		l.LIS_ID,
		t.NOMBRE_TRAB AS Trabajador,
		t.DEPTO_TRAB AS Departamento,
		ca.ID_CUDIPTA AS CursoOTaller,
		l.LIS_ESTATUS
	FROM participantes.LISTAS l
	INNER JOIN participantes.TRABAJADOR t 
		ON l.ID_TRAB = t.ID_TRAB
	INNER JOIN impartidos.CURSOSABIERTOS ca
		ON l.IMP_ID = ca.IMP_ID
	WHERE l.LIS_ESTATUS = 'A'
	ORDER BY t.NOMBRE_TRAB;	

--13. Regresa a SA y consulta cuantos usuarios hay en cada rol.
	select 
	p.name as nombreRol, count(r.member_principal_id) as cantidadUsuarios
	from sys.database_role_members r
	inner join sys.database_principals p
		on (p.principal_id = r.role_principal_id)
	group by p.name
	order by nombreRol;

--14. Genere el diagrama de la bd (dbo)

--15. Describe como quedo la bd con comentarios.

--16. Crear al menos tres índices adicionales en las tablas que tu elijas

	--ÍNIDCE PARA OBTENER LOS CURSOS DEL INSTRUCTOR X
	CREATE INDEX IX_CURSOS_INT_ID ON CATALOGOS.CURSOS(INT_ID);
	CREATE INDEX IX_TALLER_INT_ID ON CATALOGOS.TALLER(INT_ID);
	CREATE INDEX IX_DIPLOMADOS_INT_ID ON CATALOGOS.DIPLOMADOS(INT_ID);

	--CUANDO SE QUIERA REALIZAR OPERACIONES QUE INVOLUCREN LAS LISTAS Y LOS EMPLEADOS
	CREATE INDEX IX_LISTAS_ID_TRAB ON participantes.LISTAS(ID_TRAB);

--17. Consulta los índices de la base de datos mostrando el esquema, nombre de objeto,
--nombre de indice y tipo de indice

	SELECT  
		s.name AS Esquema,
		t.name AS Objeto,
		ind.name AS NombreIndice,
		ind.type_desc AS TipoIndice
	FROM sys.indexes ind
	INNER JOIN sys.objects t 
		ON ind.object_id = t.object_id
	INNER JOIN sys.schemas s 
		ON t.schema_id = s.schema_id
	WHERE t.type = 'U' 
	ORDER BY s.name, t.name;


--18. Consulta los porcentajes de fragmentación de los índices

	SELECT  
		s.name AS Esquema,
		t.name AS Tabla,
		i.name AS Indice,
		ips.avg_fragmentation_in_percent AS PorcentajeFragmentacion,
		ips.page_count AS NumeroPaginas
	FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS ips
	INNER JOIN sys.indexes AS i 
		ON ips.object_id = i.object_id AND ips.index_id = i.index_id
	INNER JOIN sys.tables AS t 
		ON i.object_id = t.object_id
	INNER JOIN sys.schemas AS s 
		ON t.schema_id = s.schema_id
	WHERE i.type > 0  -- excluye heaps (sin índice clustered)
	ORDER BY ips.avg_fragmentation_in_percent DESC;
