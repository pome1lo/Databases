--USE master;
--CREATE database Puzikov_MyBase;

USE master; 
go
CREATE database Puzikov_MyBase2 on primary
( name = N'Puzikov_MyBase_mdf', filename = N'D:\FILES\University\2 course\2 term\DataBase\lw3\Puzikov_MyBase_mdf.mdf', 
   size = 10240Kb, maxsize=UNLIMITED, filegrowth=1024Kb),
( name = N'Puzikov_MyBase_ndf', filename = N'D:\FILES\University\2 course\2 term\DataBase\lw3\Puzikov_MyBase_ndf.ndf', 
   size = 10240KB, maxsize=1Gb, filegrowth=25%),
filegroup FG1
( name = N'Puzikov_MyBase_fg1_1', filename = N'D:\FILES\University\2 course\2 term\DataBase\lw3\Puzikov_MyBase__fgq-1.ndf', 
   size = 10240Kb, maxsize=1Gb, filegrowth=25%),
( name = N'Puzikov_MyBase_fg1_2', filename = N'D:\FILES\University\2 course\2 term\DataBase\lw3\Puzikov_MyBase_fgq-2.ndf', 
   size = 10240Kb, maxsize=1Gb, filegrowth=25%)
log on
( name = N'Puzikov_MyBase_log', filename=N'D:\FILES\University\2 course\2 term\DataBase\lw3\Puzikov_MyBase_log.ldf',       
   size=10240Kb,  maxsize=2048Gb, filegrowth=10%)
go


--2------------------------


USE Puzikov_MyBase2;
CREATE table BUYER_2 (
	Name_ nvarchar(20),
	Telephone nvarchar(20) primary key,
	Address_ nvarchar(50),
) on FG1;

CREATE table WAREHOUSE_2 (
	Number tinyint primary key,
) on FG1;

CREATE table PRODUCT_2(
	ProductName nvarchar(50) primary key,
	Price money,
	Description_ nvarchar(50),
	StorageLocation nvarchar(50),
	NumberOfCells smallint,
) on FG1;

CREATE table ORDERS_2 (
	OrderNumber int primary key,
	DateOfTheTransaction date,
	Telephone nvarchar(20) foreign key references BUYER_(Telephone),
	WarehouseNumber tinyint not null foreign key references WAREHOUSE_(Number),
	ProductName nvarchar(50) not null foreign key references PRODUCT_(ProductName),
	QuantityOfTheProduct tinyint
) on FG1;

--3------------------------

--ALTER Table WAREHOUSE ADD TestColumn date;
--ALTER Table WAREHOUSE DROP Column TestColumn;

--ALTER Table WAREHOUSE ADD AddressWarehouse nvarchar(50) DEFAULT 'NO INFORMANION';
--ALTER Table WAREHOUSE DROP Column AddressWarehouse;

--4------------------------

INSERT into BUYER_(Name_, Telephone, Address_)
	VALUES('Govard',   375336328742, 'K Street 69'),
		  ('Alexey',   375297094264, 'Warp Drive 13'),
		  ('Donald',   375337896296, 'Broad St. 29'),
		  ('Alexandr', 375291598745, 'Col Road 25'),
		  ('Antonina', 375331596327, 'H Street 9');
INSERT into WAREHOUSE_(Number)
	VALUES(1), (2), (3), (4), (5);
INSERT into PRODUCT_(ProductName, Price, Description_, StorageLocation, NumberOfCells)
	VALUES('Milk',  119, 'fat content 3% Prostokvashino', 'cold from -5°', 1000),
		  ('Chips', 329, 'with crab flavor LAUS', 'not the sun until +20°', 410),
		  ('Water', 109, 'non-carbonated mineral water', 'at all temperatures', 500),
		  ('Juice', 289, 'orange juice without sugar', 'not the sun until +20°', 980),
		  ('Ñrackers', 139, 'with caviar flavor', 'not the sun until +20°', 200);
INSERT into ORDERS_(OrderNumber, DateOfTheTransaction, Telephone, WarehouseNumber, ProductName, QuantityOfTheProduct)
	VALUES(0, '2022-12-11', 375336328742, 1, 'Milk', 10),
		  (1, '2021-11-29', 375331596327, 5, 'rackers', 15),
		  (2, '11-12-2022', 375297094264, 2, 'Chips', 30),
		  (3, '16-12-2022', 375291598745, 4, 'Juice', 50),
		  (4, '29-12-2022', 375337896296, 3, 'Water', 80);


--5------------------------

--SELECT ProductName, Price FROM PRODUCT
--	WHERE Price < 300 AND Price > 200;

SELECT ProductName, Price FROM PRODUCT_;
SELECT count(*) FROM ORDERS_;		

--UPDATE PRODUCT set Price = Price + 20 Where ProductName = 'Milk';

--6------------------------

--USE master 
--go 
--CREATE DATABASE PAA_DB on primary 
--	(name=N'PAA_DB_mdf', filename=N'D:\FILES\University\2 course\2 term\DataBase\lw3\PAA_DB_mdf.mdf',
--	 size=10240Kb , maxsize=UNLIMITED),
--	(name = N'PAA_DB_ndf', filename = N'D:\FILES\University\2 course\2 term\DataBase\lw3\PAA_DB_ndf.ndf', 
--     size = 10240KB, maxsize=1Gb),
----log on
--filegroup FG1
--( name = N'PAA_DB_FG1_1_1', filename = N'D:\BD\PAA_fgq-1.ndf', 
--   size = 10240Kb, maxsize=1Gb, filegrowth=25%),
--( name = N'PAA_DB_FG1_1_2', filename = N'D:\BD\PAA_fgq-2.ndf', 
--   size = 10240Kb, maxsize=1Gb, filegrowth=25%)
--log on
--( name = N'PAA_log', filename=N'D:\BD\PAA_log.ldf',       
--   size=10240Kb,  maxsize=2048Gb, filegrowth=10%)

--7------------------------
-- ..) on FG1;

--9------------------------
