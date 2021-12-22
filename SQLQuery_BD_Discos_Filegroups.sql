
CREATE DATABASE COVID19
ON PRIMARY
(
	NAME = Covid19_Data_Primary,
	FILENAME = 'D:\Escola\Projeto_BD2\Disco_C\Covid19_Data_Primary.mdf',
	SIZE = 10MB,
	MAXSIZE = 10GB,
	FILEGROWTH = 15%
),
(
	NAME = Covid19_Data_Primary_2,
	FILENAME = 'D:\Escola\Projeto_BD2\Disco_D\Covid19_Data_Primary_2.ndf',
	SIZE = 10MB,
	MAXSIZE = 10GB,
	FILEGROWTH = 15%
),
FILEGROUP Covid_Filegroup_Tables
(
	NAME = Covid_Data_Tables,
	FILENAME = 'D:\Escola\Projeto_BD2\Disco_C\Covid19_Data_Tables.ndf',
	SIZE = 5MB,
	MAXSIZE = 5GB,
	FILEGROWTH = 10%
),
(
	NAME = Covid19_Data_Tables_2,
	FILENAME = 'D:\Escola\Projeto_BD2\Disco_C\Covid19_Data_Tables_2.ndf',
	SIZE = 5MB,
	MAXSIZE = 5GB,
	FILEGROWTH = 10%
),
FILEGROUP Covid19_Filegroup_Tables_2
(
	NAME = Covid19_Data_Tables_3,
	FILENAME = 'D:\Escola\Projeto_BD2\Disco_C\Covid19_Data_Tables_3.ndf',
	SIZE = 5MB,
	MAXSIZE = 5GB,
	FILEGROWTH = 10%
),
(
	NAME = Covid19_Data_Tables_4,
	FILENAME = 'D:\Escola\Projeto_BD2\Disco_D\Covid19_Data_Tables_4.ndf',
	SIZE = 5MB,
	MAXSIZE = 5GB,
	FILEGROWTH = 10%
),
FILEGROUP Covid19_Filegroup_Tables_3
(
	NAME = Covid19_Data_Tables_5,
	FILENAME = 'D:\Escola\Projeto_BD2\Disco_D\Covid19_Data_Tables_5.ndf',
	SIZE = 5MB,
	MAXSIZE = 5GB,
	FILEGROWTH = 10%
),
(
	NAME = Covid19_Data_Tables_6,
	FILENAME = 'D:\Escola\Projeto_BD2\Disco_D\Covid19_Tables_6.ndf',
	SIZE = 5MB,
	MAXSIZE = 5GB,
	FILEGROWTH = 10%
),
FILEGROUP Covid19_Filegroup_Index
(
	NAME = Covid19_Data_Indexes,
	FILENAME = 'D:\Escola\Projeto_BD2\Disco_E\Covid_Data_Indexes.ndf',
	SIZE = 3MB,
	MAXSIZE = 3GB,
	FILEGROWTH = 5%
)
LOG ON
(
	NAME = Covid19_log,
	FILENAME = 'D:\Escola\Projeto_BD2\Disco_E\Covid19_log.ldf',
	SIZE = 3MB,
	MAXSIZE = 3GB,
	FILEGROWTH = 5%
),
(
	NAME = Covid19_log_2,
	FILENAME = 'D:\Escola\Projeto_BD2\Disco_E\Covid19_log_2.ldf',
	SIZE = 3MB,
	MAXSIZE = 3GB,
	FILEGROWTH = 5%
);
GO


