--21400767_U3P4.SQL
--PRACTICA 4
--UNIDAD 3
--AUTOR: RAMSES ROJAS AGUILAR
--21400767
--BREVE DESCRIPCIÓN
/*
PRACTICA 4. BD AEROPUERTO
*/

--1. Adjunta la BD Aeropuerto que se te subió al drive

--2. Crea el diagrama

--3. Analiza la bd consultando lo que tiene cada tabla
USE AEROPUERTO;
	SELECT * FROM dbo.AEROLINEA;
	SELECT * FROM dbo.AEROPUERTO;
	SELECT * FROM dbo.AVION;
	SELECT * FROM dbo.PAIS;
	SELECT * FROM dbo.PASAJERO;
	SELECT * FROM dbo.RESERVA;
	SELECT * FROM dbo.VUELO;
--4. Crea al menos dos esquemas tu decide cuales de acuerdo a las tablas que tiene y cámbialas 
-- 1. Crear los esquemas
	CREATE SCHEMA Administracion;
	CREATE SCHEMA Operaciones;

	-- 2. Mover tablas al esquema Administracion
	ALTER SCHEMA Administracion TRANSFER dbo.AEROLINEA;
	ALTER SCHEMA Administracion TRANSFER dbo.AVION;
	ALTER SCHEMA Administracion TRANSFER dbo.PAIS;
	ALTER SCHEMA Administracion TRANSFER dbo.AEROPUERTO;

	-- 3. Mover tablas al esquema Operaciones
	ALTER SCHEMA Operaciones TRANSFER dbo.PASAJERO;
	ALTER SCHEMA Operaciones TRANSFER dbo.RESERVA;
	ALTER SCHEMA Operaciones TRANSFER dbo.VUELO;

--5. Consulta los índices que tiene cada tabla.
	SELECT 
		t.name AS Tabla,
		i.name AS Indice,
		i.type_desc AS TipoIndice,
		i.is_unique AS EsUnico,
		c.name AS Columna
	FROM 
		sys.indexes i
	INNER JOIN 
		sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
	INNER JOIN 
		sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
	INNER JOIN 
		sys.tables t ON i.object_id = t.object_id
	WHERE 
		t.name IN ('AEROLINEA', 'AEROPUERTO', 'AVION', 'PAIS', 'PASAJERO', 'RESERVA', 'VUELO')
	ORDER BY 
		t.name, i.name, ic.key_ordinal;

--6. Consulta los índices que tiene toda la base de datos
	SELECT 
		s.name AS Esquema,
		t.name AS Tabla,
		i.name AS Indice,
		i.type_desc AS TipoIndice,
		i.is_unique AS EsUnico,
		c.name AS Columna,
		ic.key_ordinal AS OrdenColumna
	FROM 
		sys.indexes i
	INNER JOIN 
		sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
	INNER JOIN 
		sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
	INNER JOIN 
		sys.tables t ON i.object_id = t.object_id
	INNER JOIN
		sys.schemas s ON t.schema_id = s.schema_id
	WHERE 
		i.type_desc IN ('CLUSTERED', 'NONCLUSTERED') -- Solo índices principales y secundarios
	ORDER BY 
		s.name, t.name, i.name, ic.key_ordinal;

--7. Consulta los usuarios que tiene cada role

	SELECT 
		r.name AS Rol,
		m.name AS Usuario
	FROM 
		sys.database_role_members rm
	INNER JOIN 
		sys.database_principals r ON rm.role_principal_id = r.principal_id
	INNER JOIN 
		sys.database_principals m ON rm.member_principal_id = m.principal_id
	ORDER BY 
		r.name, m.name;

--8. Consulta los objetos que tiene cada esquema
	SELECT 
		s.name AS Esquema,
		o.name AS Objeto,
		o.type_desc AS TipoObjeto
	FROM 
		sys.objects o
	INNER JOIN 
		sys.schemas s ON o.schema_id = s.schema_id
		WHERE o.type = 'U'
	ORDER BY 
		s.name, o.name;

--9. Verifica el índice de fragmentación de los índices de la tabla de vuelos y
--reorganízalos o reconstrúyelos en caso necesario, solo lo que la documentación recomienda.
	SELECT 
		i.name AS Indice,
		ips.index_type_desc AS TipoIndice,
		ips.avg_fragmentation_in_percent,
		ips.page_count
	FROM 
		sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('Operaciones.VUELO'), NULL, NULL, 'LIMITED') ips
	INNER JOIN 
		sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id;

--10. Crear tres logins a nivel de servidor:
	--login_gerente
	CREATE LOGIN login_gerente with password = '1234'
	--login_operativo
	CREATE LOGIN login_operativo with password = '1234'
	--login_consulta
	CREATE LOGIN login_consulta with password = '1234'

--11. Crear tres usuarios dentro de la base de datos AEROPUERTO que estén asociados
--a los logins creados anteriormente:
	--usuario_gerente
	CREATE USER usuario_gerente FOR LOGIN login_gerente
	--usuario_operativo
	CREATE USER usuario_operativo FOR LOGIN login_operativo
	--usuario_consulta
	CREATE USER usuario_consulta FOR LOGIN login_consulta

--12. Crear tres roles personalizados dentro de la base de datos:
	--rol_gerencia: administración completa del sistema, puede consultar, insertar,
	--modificar y eliminar información.
	CREATE ROLE rol_gerencia;
	ALTER ROLE db_owner ADD MEMBER rol_gerencia;

	--rol_operativo: usuarios encargados de las operaciones diarias (reservas, vuelos,
	--pasajeros, etc.)
	create role rol_operativo;
	ALTER ROLE db_datareader ADD MEMBER rol_operativo
	ALTER ROLE db_datawriter ADD MEMBER rol_operativo

	--rol_lectura: usuarios de consulta, supervisores o personal de auditoría.
	create role rol_lectura;
	ALTER ROLE db_datareader ADD MEMBER rol_lectura
-- 13. Asignar permisos a cada rol según su función dentro del sistema (administración operación o consulta).
	--rol_gerencia: herendando de otros roles.
	ALTER ROLE db_owner ADD MEMBER rol_gerencia;

	--rol_operativo: con GRANT
	GRANT SELECT ON SCHEMA::Administracion TO rol_operativo;
	GRANT SELECT ON SCHEMA::Operaciones TO rol_operativo;

	GRANT INSERT, UPDATE, DELETE ON SCHEMA::Administracion TO rol_operativo;
	GRANT INSERT, UPDATE, DELETE ON SCHEMA::Operaciones TO rol_operativo;

	--rol_lectura: herendando de otros roles.
	ALTER ROLE db_datareader ADD MEMBER rol_lectura

--14. Agregar los usuarios creados a los roles personalizados correspondientes.

	ALTER ROLE rol_gerencia add member usuario_gerente;
	ALTER ROLE rol_operativo add member usuario_operativo;
	ALTER ROLE rol_lectura add member usuario_consulta;

--15. Verificar los roles y usuarios creados utilizando comandos del sistema sp_helpuser
--y sp_helprolemember y-o consulta select para ver los miembros de cada role.


	EXEC sp_helpuser;

	EXEC sp_helprolemember 'rol_lectura';
	EXEC sp_helprolemember 'rol_operativo';
	EXEC sp_helprolemember 'rol_gerencia';

--16. Conectarse al servidor usando cada uno de los logins creados y comprobar que los
--permisos funcionan correctamente (realizando consultas, inserciones o actualizaciones).



--17. Registrar las acciones realizadas por cada usuario y anotar qué operaciones tuvo permitido realizar y cuáles no.

