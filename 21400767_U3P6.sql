--21400767_U3P6.SQL
--PRACTICA 6
--UNIDAD 3
--AUTOR: RAMSES ROJAS AGUILAR
--21400767
--BREVE DESCRIPCIÓN

-- A)Vamos crear una BD llamada : BDParticiones
 CREATE DATABASE BDParticiones
 ON PRIMARY (
 NAME='BDParticiones.mdf',
 FILENAME = 'C:\ABD2025\BDParticiones.mdf' )
 LOG ON (
 NAME='BDParticiones.ldf',
 FILENAME = 'C:\ABD2025\BDParticiones.ldf');
 
 USE BDParticiones;

 -- B) Vamos crear una tabla
 -- CREAR UNA TABLA Reports
 CREATE TABLE Reports
 (IdReport int identity(1,1) PRIMARY KEY,
 ReportDate date not null default getdate(),
 ReportName varchar (100),
 ReportNumber varchar (20),
 ReportDescription varchar (max)
 )
 
 --C) Llenaremos la tabla (copia todo el código y ejecútalo completo 
 -- Desde la declaración de las variables hasta el go después del commit
 DECLARE @i int
 DECLARE @fecha date
 SET @i = 1

  BEGIN TRAN
 WHILE @i<=100000
 BEGIN
 IF @i BETWEEN 1 AND 3000
 SET @fecha = '2021/01/15'
 IF @i BETWEEN 3001 AND 4000
 SET @fecha = '2021/01/31'
 IF @i BETWEEN 4001 AND 7000
 SET @fecha = '2021/02/15'
 IF @i BETWEEN 7001 AND 9000
 SET @fecha = '2021/02/28'
 IF @i BETWEEN 9001 AND 10000
 SET @fecha = '2021/03/15'
 IF @i BETWEEN 10001 AND 12000
 SET @fecha = '2021/03/30'
 IF @i BETWEEN 12001 AND 15000
 SET @fecha = '2021/04/15'
 IF @i BETWEEN 15001 AND 17000
 SET @fecha = '2021/04/30'
 IF @i BETWEEN 17001 AND 19000
 SET @fecha = '2021/05/15'
 IF @i BETWEEN 19001 AND 21000
 SET @fecha = '2021/05/30'
 IF @i BETWEEN 21001 AND 22000
 SET @fecha = '2021/06/15'
 IF @i BETWEEN 22001 AND 23500
 SET @fecha = '2021/07/15'
 IF @i BETWEEN 23501 AND 24000
 SET @fecha = '2021/08/15'
  IF @i BETWEEN 24001 AND 24500
 SET @fecha = '2022/08/30'
 IF @i BETWEEN 24501 AND 26000
 SET @fecha = '2022/09/30'
 IF @i BETWEEN 26001 AND 27000
 SET @fecha = '2022/10/15'
 IF @i BETWEEN 27001 AND 28000
 SET @fecha = '2022/11/15'
 IF @i BETWEEN 28001 AND 29000
 SET @fecha = '2022/12/15'
 IF @i BETWEEN 29001 AND 30000
 SET @fecha = '2022/12/31'
 IF @i BETWEEN 30001 AND 35000
 SET @fecha = '2023/01/15'
 IF @i BETWEEN 35001 AND 40000
 SET @fecha = '2023/02/15'
 IF @i BETWEEN 40001 AND 45000
 SET @fecha = '2023/03/15'
 IF @i BETWEEN 45001 AND 48240
 SET @fecha = '2023/04/15'
 IF @i BETWEEN 48241 AND 49000
 SET @fecha = '2023/05/20'
 IF @i BETWEEN 49001 AND 50000
 SET @fecha = '2023/06/15'
 IF @i BETWEEN 50001 AND 51000
 SET @fecha = '2023/07/15'
 IF @i BETWEEN 51001 AND 52000
 SET @fecha = '2023/08/15'
 IF @i BETWEEN 52001 AND 53000
 SET @fecha = '2023/09/15'
 IF @i BETWEEN 53001 AND 54000
 SET @fecha = '2023/10/15'
 IF @i BETWEEN 54001 AND 55000
 SET @fecha = '2023/11/15'
 IF @i BETWEEN 55001 AND 57800
 SET @fecha = '2023/12/15'
 IF @i BETWEEN 57801 AND 59000
 SET @fecha = '2024/01/15'
 IF @i BETWEEN 59001 AND 61500
 SET @fecha = '2024/01/30'
 IF @i BETWEEN 61501 AND 65000
 SET @fecha = '2024/02/15'
 IF @i BETWEEN 65001 AND 67000
 SET @fecha = '2024/03/30'
 IF @i BETWEEN 67001 AND 70000
 SET @fecha = '2024/04/15'
 IF @i BETWEEN 70001 AND 73400
 SET @fecha = '2024/05/15'
 IF @i BETWEEN 73401 AND 76900
 SET @fecha = '2024/05/30'
 IF @i BETWEEN 76901 AND 80000
 SET @fecha = '2024/06/30'
 IF @i BETWEEN 80001 AND 83000
 SET @fecha = '2024/07/15'
 IF @i BETWEEN 83001 AND 85000
 SET @fecha = '2024/08/30'
 IF @i BETWEEN 85001 AND 87600
 SET @fecha = '2024/09/30'
 IF @i BETWEEN 87601 AND 90000
 SET @fecha = '2024/10/15'
 IF @i BETWEEN 90001 AND 92000
 SET @fecha = '2024/10/30'
 IF @i BETWEEN 92001 AND 95000
 SET @fecha = '2024/11/15'
 IF @i BETWEEN 95001 AND 96700
 SET @fecha = '2024/12/15'
 IF @i BETWEEN 96701 AND 98800
 SET @fecha = '2024/12/31'
 IF @i between 98801 and 99000
 SET @fecha = '2025/01/15'
 IF @i between 99001 and 99500
 SET @fecha = '2025/02/15'
 IF @i between 99501 and 99800
 SET @fecha = '2025/02/28'
 IF @i> 99801 
SET @fecha = '2024/03/15'


 INSERT INTO Reports
 (ReportDate,ReportName,ReportNumber,
 ReportDescription
 )
 VALUES
 (
 @fecha,
 'ReportName' + CONVERT (varchar (20), @i) ,
 CONVERT (varchar (20), @i),
 REPLICATE ('Report', 1000)
 )
 SET @i=@i+1
 END
 COMMIT TRAN-- VERIFICAR LA INSERCION
 SELECT COUNT(*) FROM Reports
 SELECT * FROM Reports


 SET STATISTICS IO ON
 SET STATISTICS TIME ON
 SELECT * FROM Reports
 WHERE YEAR(ReportDate) = '2023'
 SET STATISTICS IO OFF 
 SET STATISTICS TIME OFF;

 /*
 SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 1 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

(27800 rows affected)
Table 'Reports'. Scan count 1, logical reads 100373, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 312 ms,  elapsed time = 1701 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

Completion time: 2025-10-27T09:32:41.6045240-07:00
 */


 SET STATISTICS IO ON
 SET STATISTICS TIME ON
 SELECT * FROM Reports
 SET STATISTICS IO OFF 
 SET STATISTICS TIME OFF;

 /*
 
(100000 rows affected)
Table 'Reports'. Scan count 1, logical reads 100373, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 735 ms,  elapsed time = 5178 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

Completion time: 2025-10-27T09:22:30.8837443-07:00

 */

 --5. AGREGAR UN CAMPO EMPLEADO
 ALTER TABLE Reports
 ADD Empleado smallint;

 --6. AGREGAR UNA TABLA EMPLEADO
 CREATE TABLE Employees
 (
 EmpleadoId smallint  identity(1,1) primary key,
 EmpleadoNombre varchar(100),
 EmpleadoEmail VARCHAR(200),
 EmpleadoSueldo MONEY DEFAULT 10000
 );

 INSERT INTO Employees (EmpleadoNombre, EmpleadoEmail)
 values ('Empleado Reports', 'empleado@gmail.com')
 GO 10

 select * from Reports;
 select * from Employees;

 update Reports
 SET EMPLEADO = 5;

 --7. CREAR LA FK
 ALTER TABLE REPORTS 
 ADD CONSTRAINT FK_ReportEmployee
 FOREIGN KEY(Empleado) references Employees(EmpleadoId);

 --8. PARTICIONAR LA TABLA REPORTS USANDO UNA TABLA PUENTE
	--A) CREAR FILEGROUPS
	ALTER DATABASE BDParticiones
	ADD FILEGROUP FILE2022;

	ALTER DATABASE BDParticiones
	ADD FILEGROUP FILE2023;

	ALTER DATABASE BDParticiones
	ADD FILEGROUP FILE2024;

	ALTER DATABASE BDParticiones
	ADD FILEGROUP FILE2025;

	--B) CREAR LOS DATAFILES
	USE MASTER;

	ALTER DATABASE BDParticiones
	ADD FILE (
	NAME = 'Particion2022.ndf',
	filename = 'C:\ABD2025\DISCO1\Particion2022.ndf' --SIMULANDO QUE TENEMOS VARIOS DISCOS, CREAREMOS LOS ARCHIVOS EN DIF. CARPETAS
	) TO FILEGROUP FILE2022;

	ALTER DATABASE BDParticiones
	ADD FILE (
	NAME = 'Particion2023.ndf',
	filename = 'C:\ABD2025\DISCO2\Particion2023.ndf' --SIMULANDO QUE TENEMOS VARIOS DISCOS, CREAREMOS LOS ARCHIVOS EN DIF. CARPETAS
	) TO FILEGROUP FILE2023;

	ALTER DATABASE BDParticiones
	ADD FILE (
	NAME = 'Particion2024.ndf',
	filename = 'C:\ABD2025\DISCO3\Particion2024.ndf' --SIMULANDO QUE TENEMOS VARIOS DISCOS, CREAREMOS LOS ARCHIVOS EN DIF. CARPETAS
	) TO FILEGROUP FILE2024;

	ALTER DATABASE BDParticiones
	ADD FILE (
	NAME = 'Particion2025.ndf',
	filename = 'C:\ABD2025\DISCO4\Particion2025.ndf' --SIMULANDO QUE TENEMOS VARIOS DISCOS, CREAREMOS LOS ARCHIVOS EN DIF. CARPETAS
	) TO FILEGROUP FILE2025;

	--C) CREAR LA FUNCIÓN DE PARTICIÓN (TAREA POR LA IZQUIERDA O LA DERECHA)
	CREATE PARTITION FUNCTION f_partitiondate(date)
	as RANGE LEFT FOR VALUES ('2022-12-31', '2023-12-31', '2024-12-31');