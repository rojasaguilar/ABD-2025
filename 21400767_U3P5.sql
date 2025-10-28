--21400767_U3P5.SQL
--PRACTICA 5
--UNIDAD 3
--AUTOR: RAMSES ROJAS AGUILAR
--21400767
--BREVE DESCRIPCIÓN

--PRACTICA 5. BD SII
-- 1. Crear una base de datos llamada SII
	CREATE DATABASE SII
	ON PRIMARY (
	NAME = 'SII', 
	FILENAME = 'C:\ABD2025\SII.mdf'
	)
	LOG ON (
	 NAME = 'SII_log', 
	 FILENAME = 'C:\ABD2025\SII.ldf'
	)
-- 2. Crea las tablas siguientes :

	CREATE TABLE Carreras(
	carreraID VARCHAR(7) CONSTRAINT PK_Carreras
	PRIMARY KEY,
	nombre VARCHAR(60),
	fechaInicio DATE,
	fechaFin DATE
	);

	CREATE TABLE Alumnos(
	AlumnoId INT IDENTITY(1,1) CONSTRAINT Pk_Alumnos
	PRIMARY KEY,
	numeroControl VARCHAR(9),
	nombreAlumno VARCHAR(30),
	apellidoPaterno VARCHAR(30),
	apellidoMaterno VARCHAR (30),
	carreraId VARCHAR(7),
	semestre tinyint,
	telefono VARCHAR(15),
	email VARCHAR(200),
	tutor VARCHAR(200)
	);

	CREATE TABLE Materias (
	idMateria VARCHAR(10) CONSTRAINT PK_Materias
	PRIMARY KEY,
	nombreMateria VARCHAR(100),
	carreraId VARCHAR(7),
	creditos CHAR(1),
	modulo bit,
	semestre tinyint
	);

-- 6. Crear las tablas siguientes
--Departamentos: Son los departamentos a los que pertenecen los maestros y el personal.
CREATE TABLE Departamentos(
    departamentoID int identity(1,1) CONSTRAINT PK_Departamentos PRIMARY KEY ,
    nombreDepartamento VARCHAR(100)
);
--Maestros: 
/*
cada maestro pertenece a un departamento, y puede dar materias en
distintas carreras..
*/
CREATE TABLE Maestros(
    maestroID INT IDENTITY(1,1) CONSTRAINT PK_Maestros PRIMARY KEY,
    nombreMaestro VARCHAR(50),
    apellidoPaterno VARCHAR(30),
    apellidoMaterno VARCHAR(30),
    departamentoID int,
    email VARCHAR(200),
    telefono VARCHAR(15),
);

--Materias Abiertas:
/*debe llevar el horario, semestre (ene-jun), año, maestro que lo
imparte.*/
CREATE TABLE MateriasAbiertas(
    idMateriaAbierta INT IDENTITY(1,1) CONSTRAINT PK_MateriasAbiertas PRIMARY KEY,
    idMateria VARCHAR(10),
    carreraID VARCHAR(7),
    maestroID INT,
    semestre CHAR(1),
    anio INT,
    horario VARCHAR(100),
);

--Horario Alumno: 
/*
en donde vendrá la materia tomada de las abiertas en el semestre y
año correspondiente
*/
CREATE TABLE HorarioAlumno(
    idHorario INT IDENTITY(1,1) CONSTRAINT PK_HorarioAlumno PRIMARY KEY,
    alumnoID INT,
    idMateriaAbierta INT,
   
);

-- 10. Relaciona las tablas para que quede la base de datos correctamente.
	ALTER TABLE MAESTROS
	ADD CONSTRAINT FK_MAESTRO_DEPAR FOREIGN KEY(departamentoID) REFERENCES Departamentos(departamentoID)

	ALTER TABLE MateriasAbiertas
	ADD CONSTRAINT FK_MAAB_MATERIA FOREIGN KEY (idMateria) REFERENCES Materias(idMateria);

	ALTER TABLE MateriasAbiertas
	ADD CONSTRAINT FK_MAAB_CARRERA FOREIGN KEY (carreraID) REFERENCES Carreras(carreraID);

	ALTER TABLE MateriasAbiertas
	ADD CONSTRAINT FK_MAAB_MAESTRO FOREIGN KEY (maestroID) REFERENCES Maestros(maestroID);


	ALTER TABLE HorarioAlumno
	ADD CONSTRAINT FK_horario_alumno FOREIGN KEY (alumnoID) REFERENCES Alumnos(AlumnoID);

	ALTER TABLE HorarioAlumno
	ADD CONSTRAINT FK_horario_materia FOREIGN KEY (idMateriaAbierta) REFERENCES MateriasAbiertas(idMateriaAbierta)

--11. Inserta registros al menos 10 en cada tabla.

-- ===========================
-- 1. INSERTS EN CARRERAS
-- ===========================
	INSERT INTO Carreras (carreraID, nombre, fechaInicio, fechaFin) VALUES
	('CARR001', 'Ingeniería en Sistemas', '2020-08-01', '2025-06-30'),
	('CARR002', 'Licenciatura en Administración', '2021-01-15', '2026-01-15'),
	('CARR003', 'Contaduría Pública', '2019-08-01', '2024-06-30'),
	('CARR004', 'Ingeniería Industrial', '2020-08-01', '2025-06-30'),
	('CARR005', 'Derecho', '2018-08-01', '2023-06-30'),
	('CARR006', 'Medicina', '2021-08-01', '2027-06-30'),
	('CARR007', 'Arquitectura', '2020-08-01', '2025-06-30'),
	('CARR008', 'Psicología', '2019-08-01', '2024-06-30'),
	('CARR009', 'Ingeniería Civil', '2020-08-01', '2025-06-30'),
	('CARR010', 'Química', '2021-01-15', '2026-01-15');

	-- ===========================
	-- 2. INSERTS EN DEPARTAMENTOS
	-- ===========================
	INSERT INTO Departamentos (nombreDepartamento) VALUES
	('Sistemas'),
	('Administración'),
	('Contabilidad'),
	('Ingeniería Industrial'),
	('Derecho'),
	('Medicina'),
	('Arquitectura'),
	('Psicología'),
	('Ingeniería Civil'),
	('Química');

	-- ===========================
	-- 3. INSERTS EN MAESTROS
	-- ===========================
	INSERT INTO Maestros (nombreMaestro, apellidoPaterno, apellidoMaterno, departamentoID, email, telefono) VALUES
	('Juan', 'Pérez', 'Gómez', 1, 'juan.perez@uni.edu', '555-0101'),
	('María', 'López', 'Ramírez', 2, 'maria.lopez@uni.edu', '555-0102'),
	('Carlos', 'Sánchez', 'Morales', 3, 'carlos.sanchez@uni.edu', '555-0103'),
	('Ana', 'García', 'Hernández', 4, 'ana.garcia@uni.edu', '555-0104'),
	('Luis', 'Martínez', 'Torres', 5, 'luis.martinez@uni.edu', '555-0105'),
	('Sofía', 'Ramírez', 'Vega', 6, 'sofia.ramirez@uni.edu', '555-0106'),
	('Miguel', 'Hernández', 'Flores', 7, 'miguel.hernandez@uni.edu', '555-0107'),
	('Lucía', 'González', 'Pacheco', 8, 'lucia.gonzalez@uni.edu', '555-0108'),
	('Ricardo', 'Torres', 'Santos', 9, 'ricardo.torres@uni.edu', '555-0109'),
	('Fernanda', 'Cruz', 'Ríos', 10, 'fernanda.cruz@uni.edu', '555-0110');

	-- ===========================
	-- 4. INSERTS EN MATERIAS
	-- ===========================
	INSERT INTO Materias (idMateria, nombreMateria, carreraId, creditos, modulo, semestre) VALUES
	('MAT001', 'Programación I', 'CARR001', '4', 0, 1),
	('MAT002', 'Matemáticas I', 'CARR001', '4', 0, 1),
	('MAT003', 'Contabilidad I', 'CARR003', '4', 0, 1),
	('MAT004', 'Derecho Constitucional', 'CARR005', '4', 0, 1),
	('MAT005', 'Fisiología', 'CARR006', '5', 1, 1),
	('MAT006', 'Arquitectura I', 'CARR007', '4', 0, 1),
	('MAT007', 'Psicología General', 'CARR008', '4', 0, 1),
	('MAT008', 'Estática', 'CARR009', '4', 0, 1),
	('MAT009', 'Química Orgánica', 'CARR010', '5', 1, 1),
	('MAT010', 'Administración I', 'CARR002', '4', 0, 1);

	-- ===========================
	-- 5. INSERTS EN ALUMNOS
	-- ===========================
	INSERT INTO Alumnos (numeroControl, nombreAlumno, apellidoPaterno, apellidoMaterno, carreraId, semestre, telefono, email, tutor) VALUES
	('NC001', 'Pedro', 'Luna', 'Martínez', 'CARR001', 1, '555-1001', 'pedro.luna@uni.edu', 'Dr. Juan Pérez'),
	('NC002', 'Laura', 'Santos', 'Ramírez', 'CARR002', 1, '555-1002', 'laura.santos@uni.edu', 'Dra. María López'),
	('NC003', 'Diego', 'Hernández', 'Vega', 'CARR003', 1, '555-1003', 'diego.hernandez@uni.edu', 'Dr. Carlos Sánchez'),
	('NC004', 'Sofía', 'Gómez', 'Torres', 'CARR004', 1, '555-1004', 'sofia.gomez@uni.edu', 'Dra. Ana García'),
	('NC005', 'Luis', 'Martínez', 'Flores', 'CARR005', 1, '555-1005', 'luis.martinez@uni.edu', 'Dr. Luis Martínez'),
	('NC006', 'Valeria', 'Ramírez', 'Pacheco', 'CARR006', 1, '555-1006', 'valeria.ramirez@uni.edu', 'Dra. Sofía Ramírez'),
	('NC007', 'Ricardo', 'González', 'Santos', 'CARR007', 1, '555-1007', 'ricardo.gonzalez@uni.edu', 'Dr. Miguel Hernández'),
	('NC008', 'Fernanda', 'Cruz', 'Ríos', 'CARR008', 1, '555-1008', 'fernanda.cruz@uni.edu', 'Dra. Lucía González'),
	('NC009', 'Miguel', 'Torres', 'Vega', 'CARR009', 1, '555-1009', 'miguel.torres@uni.edu', 'Dr. Ricardo Torres'),
	('NC010', 'Ana', 'López', 'Ramírez', 'CARR010', 1, '555-1010', 'ana.lopez@uni.edu', 'Dra. Fernanda Cruz');

	-- ===========================
	-- 6. INSERTS EN MATERIASABIERTAS
	-- ===========================
	INSERT INTO MateriasAbiertas (idMateria, carreraID, maestroID, semestre, anio, horario) VALUES
	('MAT001', 'CARR001', 1, 'E', 2025, 'Lunes 8-10, Miércoles 8-10'),
	('MAT002', 'CARR001', 1, 'E', 2025, 'Martes 10-12, Jueves 10-12'),
	('MAT003', 'CARR003', 3, 'E', 2025, 'Lunes 14-16, Miércoles 14-16'),
	('MAT004', 'CARR005', 5, 'E', 2025, 'Martes 8-10, Jueves 8-10'),
	('MAT005', 'CARR006', 6, 'E', 2025, 'Lunes 10-12, Miércoles 10-12'),
	('MAT006', 'CARR007', 7, 'E', 2025, 'Martes 14-16, Jueves 14-16'),
	('MAT007', 'CARR008', 8, 'E', 2025, 'Lunes 12-14, Miércoles 12-14'),
	('MAT008', 'CARR009', 9, 'E', 2025, 'Martes 12-14, Jueves 12-14'),
	('MAT009', 'CARR010', 10, 'E', 2025, 'Lunes 16-18, Miércoles 16-18'),
	('MAT010', 'CARR002', 2, 'E', 2025, 'Martes 16-18, Jueves 16-18');

	-- ===========================
	-- 7. INSERTS EN HORARIOALUMNO
	-- ===========================
	INSERT INTO HorarioAlumno (alumnoID, idMateriaAbierta) VALUES
	(1, 1),
	(1, 2),
	(2, 10),
	(2, 2),
	(3, 3),
	(4, 4),
	(5, 5),
	(6, 6),
	(7, 7),
	(8, 8),
	(9, 9),
	(10, 10);

--12. Mostrar cuales índices tiene cada tabla.

	SELECT 
		s.name AS Esquema,
		t.name AS Tabla,
		i.name AS Indice,
		i.type_desc AS TipoIndice,
		i.is_unique AS EsUnico,
		i.is_primary_key AS EsPK
	FROM 
		sys.indexes i
	INNER JOIN 
		sys.tables t ON i.object_id = t.object_id
	INNER JOIN
		sys.schemas s ON t.schema_id = s.schema_id
	WHERE 
		i.name IS NOT NULL -- Ignora índices internos de sistema
	ORDER BY 
		s.name, t.name, i.name;

--13. Consulta los índices de la base de datos mostrando el esquema, nombre de objeto,
--nombre de indice y tipo de indice

	SELECT
		s.name AS Esquema,
		t.name AS Objeto,
		i.name AS Indice,
		i.type_desc AS TipoIndice
	FROM
		sys.indexes i
	INNER JOIN
		sys.tables t ON i.object_id = t.object_id
	INNER JOIN
		sys.schemas s ON t.schema_id = s.schema_id
	WHERE
		i.name IS NOT NULL  -- Ignora índices internos
	ORDER BY
		s.name, t.name, i.name;

--14. Crear el índice clustereado por número control, recuerda que para hacerlo primero
--tienes que quitar el índice clustereado que ya existe y volver a crear la PK no
--clustereada.

	ALTER TABLE Alumnos DROP CONSTRAINT Pk_Alumnos;

	ALTER TABLE Alumnos
	ADD CONSTRAINT Pk_Alumnos PRIMARY KEY NONCLUSTERED (AlumnoId);

	CREATE CLUSTERED INDEX IX_Alumnos_NumeroControl
	ON Alumnos (numeroControl);

--15. Crear un índice por el nombre completo empezando por apellido paterno
	CREATE NONCLUSTERED INDEX IX_Alumnos_NombreCompleto
	ON Alumnos (apellidoPaterno, apellidoMaterno, nombreAlumno);
--16. Crea al menos dos índices a cada tabla dependiendo de las consultas que tu consideres
--más comunes en dichas tablas.

	--CARRERAS
	CREATE NONCLUSTERED INDEX IX_Carreras_Nombre
	ON Carreras (nombre);

	CREATE NONCLUSTERED INDEX IX_Carreras_Fechas
	ON Carreras (fechaInicio, fechaFin);

	--ALUMNOS
	CREATE NONCLUSTERED INDEX IX_Alumnos_Carrera
	ON Alumnos (carreraId);

	CREATE NONCLUSTERED INDEX IX_Alumnos_Apellido
	ON Alumnos (apellidoPaterno, apellidoMaterno);

	--MATERIAS
	-- Índice nonclustered por carreraId
	CREATE NONCLUSTERED INDEX IX_Materias_Carrera
	ON Materias (carreraId);

	-- Índice nonclustered por semestre
	CREATE NONCLUSTERED INDEX IX_Materias_Semestre
	ON Materias (semestre);

	--DEPARTAMENTOS
	-- Índice nonclustered por nombreDepartamento
	CREATE NONCLUSTERED INDEX IX_Departamentos_Nombre
	ON Departamentos (nombreDepartamento);

	-- Índice nonclustered por departamentoID (ya PK, pero útil para joins rápidos)
	CREATE NONCLUSTERED INDEX IX_Departamentos_ID
	ON Departamentos (departamentoID);

	--MAESTROS
	-- Índice nonclustered por departamentoID (FK)
	CREATE NONCLUSTERED INDEX IX_Maestros_Departamento
	ON Maestros (departamentoID);

	-- Índice nonclustered por nombre completo
	CREATE NONCLUSTERED INDEX IX_Maestros_NombreCompleto
	ON Maestros (nombreMaestro, apellidoPaterno, apellidoMaterno);

	--MATERIAS ABIERTAS
	-- Índice nonclustered por carreraID
	CREATE NONCLUSTERED INDEX IX_MateriasAbiertas_Carrera
	ON MateriasAbiertas (carreraID);

	-- Índice nonclustered por maestroID y semestre
	CREATE NONCLUSTERED INDEX IX_MateriasAbiertas_Maestro
	ON MateriasAbiertas (maestroID, semestre);

	-- HORARIO ALUMNO
	-- Índice nonclustered por alumnoID
	CREATE NONCLUSTERED INDEX IX_HorarioAlumno_Alumno
	ON HorarioAlumno (alumnoID);

	-- Índice nonclustered por idMateriaAbierta
	CREATE NONCLUSTERED INDEX IX_HorarioAlumno_MateriaAbierta
	ON HorarioAlumno (idMateriaAbierta);

--17. Crea un índice clustereado en la tabla de maestros con el nombre completo del mismo.
	ALTER TABLE Maestros DROP CONSTRAINT PK_Maestros;

	ALTER TABLE Maestros
	ADD CONSTRAINT PK_Maestros PRIMARY KEY NONCLUSTERED (maestroID);

	CREATE CLUSTERED INDEX IX_Maestros_NombreCompleto
	ON Maestros (nombreMaestro, apellidoPaterno, apellidoMaterno);

--18. Muestra el porcentaje de fragmentación de los índices de la bd y reorganiza o
--reconstruye hasta llegar a un 0% de fragmentación.
SELECT 
    DB_NAME() AS BaseDatos,
    s.name AS Esquema,
    t.name AS Tabla,
    i.name AS Indice,
    i.type_desc AS TipoIndice,
    ips.avg_fragmentation_in_percent,
    ips.page_count
FROM 
    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
INNER JOIN sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
INNER JOIN sys.tables t ON i.object_id = t.object_id
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
ORDER BY 
    ips.avg_fragmentation_in_percent DESC;
