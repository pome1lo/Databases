--1. ���������� ��� �������, ����-��� ������� � �� UNIVER. 
--������� ��������� ��������� �������. ��������� �� ������� (�� ����� 1000 �����). 
--����������� SELECT-������. ��-������ ���� ������� � ���������� ��� ���������. 
--������� ���������������� ������, ����������� ��������� SELECT-�������.
USE UNIVER 
exec SP_HELPINDEX 'AUDITORIUM_TYPE';
exec SP_HELPINDEX 'AUDITORIUM';
exec SP_HELPINDEX 'FACULTY';
exec SP_HELPINDEX 'GROUPS';
exec SP_HELPINDEX 'PROFESSION';
exec SP_HELPINDEX 'PROGRESS';
exec SP_HELPINDEX 'PULPIT';
exec SP_HELPINDEX 'STUDENT';
exec SP_HELPINDEX 'SUBJECT';
exec SP_HELPINDEX 'TEACHER';

-- � ������� ��������� ��������� SP_HELPINDEX ����� �������� �������� ��������, ��������� � �������� ��������
CREATE table #TEST
(
	TIND int,
	TFIELD varchar(100)
);
SET nocount on; -- �� �������� ��������� � ����� �����
DECLARE @i int = 0;
WHILE @i < 1000
begin
	INSERT #TEST(TIND, TFIELD)
		values(floor(20000*RAND()),REPLICATE('data ',3));
	IF(@i % 100 = 0) 
		PRINT @i;
	SET @i = @i + 1;
end;

SELECT * FROM #TEST where TIND between 1500 and 2500 order by TIND 

--����� ��������� ������� (Estimated Subtree Cost) ���������� �� ����������� ����, ���� �������� ������ � ���������� Table Scan 
--(��� ����� 0,011). ����� ���-������� ������� ����� ���������� ���������� �������, ���� �������� �������� ���

checkpoint;  --�������� ��
DBCC DROPCLEANBUFFERS;  --�������� �������� ���

CREATE clustered index #TEST_CL on #TEST(TIND asc)  --������ ���������������� ������

SELECT * FROM #TEST where TIND between 1500 and 2500 order by TIND 


DROP index #TEST_CL ON #TEST
DROP TABLE #TEST




--2. ������� ��������� ��������� �������. ��������� �� ������� (10000 ����� ��� ������). 
--����������� SELECT-������. ��-������ ���� ������� � ���������� ��� ���������. 
--������� ������������������ ��-���������� ��������� ������. 
--������� ��������� ������ ��-��������.

--������������������ ������� �� ������ �� ���������� ������� ����� � �������
--������� ������������������ ��-���������� ��������� ������. 

CREATE table #TEST2
(
	TKEY int,
	CC int identity(1,1),
	TF varchar(100)
);
SET nocount on;
DECLARE @it int = 0;
WHILE @it < 20000
	begin
		INSERT #TEST2(TKEY, TF)
			values(floor(20000*RAND()),REPLICATE('text ',3));
	SET @it = @it + 1;
	end;

SELECT count(*)[���������� �����] FROM #TEST2;
SELECT * FROM #TEST2

--������� �� ���������� �������� - ���������
--��������� ������������, ������������������ ������ #TEST2_NONCLU �� ���� �������� TKEY � CC ������� #EX:
CREATE index #TEST2_NONCLU on #TEST2(TKEY, CC)					
--����������� �� ��������� ����������
SELECT * from  #TEST2 where  TKEY > 1500 and  CC < 4500;  
SELECT * from  #TEST2 order by  TKEY, CC
--����������� ��������� ������, ��� ��� ���� �� �������� �������������
SELECT * from  #TEST2 where  TKEY = 556 and  CC > 3			

DROP index #TEST2_NONCLU on #TEST2
DROP TABLE #TEST2

--3. ������� ��������� ��������� �������. ��������� �� ������� (�� ����� 10000 �����). 
--����������� SELECT-������. ��-������ ���� ������� � ���������� ��� ���������. 
--������� ������������������ ��-���� ��������, ����������� ���-������ SELECT-�������. 

CREATE table #TEST3
(
	TKEY int,
	CC int identity(1,1),
	TF varchar(100)
);
SET nocount on;
DECLARE @iter int = 0;
WHILE @iter < 20000
	begin
		INSERT #TEST3(TKEY, TF)
			values(floor(20000*RAND()),REPLICATE('text',3));
	SET @iter = @iter + 1;
	end;

--��������� ��� include �����������
SELECT CC from #TEST3 where TKEY>15000 
CREATE  index #TEST3_TKEY_X on #TEST3(TKEY) INCLUDE (CC)
SELECT CC from #TEST3 where TKEY>15000 

DROP index #TEST3_TKEY_X on #TEST3
DROP TABLE #TEST3

--4. ������� � ��������� ��������� ��������� �������. 
--����������� SELECT-������, ��-������ ���� ������� � ���������� ��� ���������. 
--������� ������������������ ����������� ������, ��������-��� ��������� SELECT-�������.


CREATE table #TEST4
(
	TKEY int,
	CC int identity(1,1),
	TF varchar(100)
);
SET nocount on;
DECLARE @iter4 int = 0;
WHILE @iter4 < 20000
	begin
		INSERT #TEST4(TKEY, TF)
			values(floor(20000*RAND()),REPLICATE('text',3));
	SET @iter4 = @iter4 + 1;
	end;

SELECT TKEY from  #TEST4 where TKEY between 5000 and 19999; 
SELECT TKEY from  #TEST4 where TKEY>15000 and  TKEY < 20000; 
SELECT TKEY from  #TEST4 where TKEY=17000;

--������������������ ����������� ������
CREATE index #TEST4_WHERE on #TEST4(TKEY) where (TKEY>=15000 and TKEY < 20000);  

SELECT TKEY from  #TEST4 where TKEY > 15000 and  TKEY < 20000;  
SELECT TKEY from  #TEST4 where TKEY = 17000;

DROP index #TEST4_WHERE on #TEST4
DROP TABLE #TEST4


--5. ��������� ��������� ������-��� �������. 
--������� ������������������ ��-����. ������� ������� ���������-��� �������. 
--����������� �������� �� T-SQL, ���������� �������� �������� � ������ ������������ ������� ���� 90%. 
--������� ������� ������������ �������
--��������� ��������� ��������-����� �������, ������� ������� ������������. 
--��������� ��������� ����-������� ������� � ������� ������� ������������ �������.

--������������ �������� ������� ������ �� �� ����������. 

use tempdb
CREATE table #TEST5
(
	TKEY int,
	CC int identity(1,1),
	TF varchar(100)
);
SET nocount on;
DECLARE @iter5 int = 0;
WHILE @iter5 < 20000
	begin
		INSERT #TEST5(TKEY, TF)
			values(floor(20000*RAND()),REPLICATE('text',3));
	SET @iter5 = @iter5 + 1;
	end;

CREATE index #TEST5_TKEY ON #TEST5(TKEY); 
INSERT top(10000) #TEST5(TKEY, TF) select TKEY, TF from #TEST5;

--�������� ���������� � ������� ������������ ������� ����� � ������� ���-�������: 
 SELECT name [������], avg_fragmentation_in_percent [������������ (%)]			--������� ������������ �������
        FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), 
        OBJECT_ID(N'#TEST5'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii 
		ON ss.object_id = ii.object_id and ss.index_id = ii.index_id 
		WHERE name is not null;

--��� ���������� �� ������������ ������� ������������� ��� ����������� �����-���: ������������� � ����������� �������.
--������������� (REORGANIZE) ����������� ������, �� ����� ��� ������������ ����� ������ ������ �� ����� ������ ������

ALTER index #TEST5_TKEY on #TEST5 reorganize --������������� (-����� �� ������)
 SELECT name [������], avg_fragmentation_in_percent [������������ (%)]			--������� ������������ �������
        FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), 
        OBJECT_ID(N'#TEST5'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii 
		ON ss.object_id = ii.object_id and ss.index_id = ii.index_id 
		WHERE name is not null;

--�������� ����������� (REBUILD) ����������� ��� ���� ������, ������� ����� �� ���������� ������� ������������ ����� ����

ALTER index #TEST5_TKEY on #TEST5 rebuild with (online = off) --����������� (������ ����� �������) �������� ����� ��� ������ => �����=0
 SELECT name [������], avg_fragmentation_in_percent [������������ (%)]			--������� ������������ �������
        FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), 
        OBJECT_ID(N'#TEST5'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii 
		ON ss.object_id = ii.object_id and ss.index_id = ii.index_id 
		WHERE name is not null;


DROP index #TEST5_TKEY on #TEST5
DROP TABLE #TEST5

--6. ����������� ������, �����-���������� ���������� ��������� 
--FILLFACTOR ��� �������� �����-�������������� �������.

--������� ������������ ����� � ��������� ������� ���������, ���� ��� �������� ��� ��������� ������� ������������ 
--��������� FILLFACTOR � PAD_INDEX. 

use tempdb;
CREATE table #TEST6
(
	TKEY int,
	CC int identity(1,1),
	TF varchar(100)
);
SET nocount on;
DECLARE @iter6 int = 0;
WHILE @iter6 < 20000
	begin
		INSERT #TEST6(TKEY, TF)
			values(floor(20000*RAND()),REPLICATE('text',3));
	SET @iter6 = @iter6 + 1;
	end;

--�������� FILLFACTOR ��������� ������� ���������� ��������� ������� ���-���� ������.
CREATE index #TEST6_TKEY on #TEST6(TKEY) with (fillfactor = 65);

INSERT top(10000) #TEST6(TKEY, TF) select TKEY, TF from #TEST6;
--INSERT top(100) percent INTO #TEST6(TKEY, TF) 
--                       SELECT TKEY, TF  FROM #TEST6;

SELECT name [������], avg_fragmentation_in_percent [������������ (%)]
       FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),    
       OBJECT_ID(N'#TEST6'), NULL, NULL, NULL) ss  JOIN sys.indexes ii 
                                     ON ss.object_id = ii.object_id and ss.index_id = ii.index_id  
                                                                                          WHERE name is not null;

drop index #TEST6_TKEY on #TEST6
drop table #TEST6

