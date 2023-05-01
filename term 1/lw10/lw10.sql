--1. Определить все индексы, кото-рые имеются в БД UNIVER. 
--Создать временную локальную таблицу. Заполнить ее данными (не менее 1000 строк). 
--Разработать SELECT-запрос. По-лучить план запроса и определить его стоимость. 
--Создать кластеризованный индекс, уменьшающий стоимость SELECT-запроса.
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

-- С помощью системной процедуры SP_HELPINDEX можно получить перечень индексов, связанных с заданной таблицей
CREATE table #TEST
(
	TIND int,
	TFIELD varchar(100)
);
SET nocount on; -- не выводить сообщение о вводе строк
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

--Общая стоимость запроса (Estimated Subtree Cost) появляется во всплывающем окне, если подвести курсор к компоненту Table Scan 
--(она равна 0,011). Чтобы объ-ективно оценить время выполнения следующего запроса, надо очистить буферный кэш

checkpoint;  --фиксация БД
DBCC DROPCLEANBUFFERS;  --очистить буферный кэш

CREATE clustered index #TEST_CL on #TEST(TIND asc)  --создаём кластеризованный индекс

SELECT * FROM #TEST where TIND between 1500 and 2500 order by TIND 


DROP index #TEST_CL ON #TEST
DROP TABLE #TEST




--2. Создать временную локальную таблицу. Заполнить ее данными (10000 строк или больше). 
--Разработать SELECT-запрос. По-лучить план запроса и определить его стоимость. 
--Создать некластеризованный не-уникальный составной индекс. 
--Оценить процедуры поиска ин-формации.

--Некластеризованные индексы не влияют на физический порядок строк в таблице
--Создать некластеризованный не-уникальный составной индекс. 

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

SELECT count(*)[количество строк] FROM #TEST2;
SELECT * FROM #TEST2

--индексы по нескольким столбцам - составные
--составной неуникальный, некластеризованный индекс #TEST2_NONCLU по двум столбцам TKEY и CC таблицы #EX:
CREATE index #TEST2_NONCLU on #TEST2(TKEY, CC)					
--оптимизатор не принимает индексатор
SELECT * from  #TEST2 where  TKEY > 1500 and  CC < 4500;  
SELECT * from  #TEST2 order by  TKEY, CC
--оптимизатор принимает индекс, так как одно из значений зафиксировано
SELECT * from  #TEST2 where  TKEY = 556 and  CC > 3			

DROP index #TEST2_NONCLU on #TEST2
DROP TABLE #TEST2

--3. Создать временную локальную таблицу. Заполнить ее данными (не менее 10000 строк). 
--Разработать SELECT-запрос. По-лучить план запроса и определить его стоимость. 
--Создать некластеризованный ин-декс покрытия, уменьшающий сто-имость SELECT-запроса. 

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

--стоимость при include уменьшается
SELECT CC from #TEST3 where TKEY>15000 
CREATE  index #TEST3_TKEY_X on #TEST3(TKEY) INCLUDE (CC)
SELECT CC from #TEST3 where TKEY>15000 

DROP index #TEST3_TKEY_X on #TEST3
DROP TABLE #TEST3

--4. Создать и заполнить временную локальную таблицу. 
--Разработать SELECT-запрос, по-лучить план запроса и определить его стоимость. 
--Создать некластеризованный фильтруемый индекс, уменьшаю-щий стоимость SELECT-запроса.


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

--некластеризованный фильтруемый индекс
CREATE index #TEST4_WHERE on #TEST4(TKEY) where (TKEY>=15000 and TKEY < 20000);  

SELECT TKEY from  #TEST4 where TKEY > 15000 and  TKEY < 20000;  
SELECT TKEY from  #TEST4 where TKEY = 17000;

DROP index #TEST4_WHERE on #TEST4
DROP TABLE #TEST4


--5. Заполнить временную локаль-ную таблицу. 
--Создать некластеризованный ин-декс. Оценить уровень фрагмента-ции индекса. 
--Разработать сценарий на T-SQL, выполнение которого приводит к уровню фрагментации индекса выше 90%. 
--Оценить уровень фрагментации индекса
--Выполнить процедуру реоргани-зации индекса, оценить уровень фрагментации. 
--Выполнить процедуру пере-стройки индекса и оценить уровень фрагментации индекса.

--Фрагментация индексов снижает эффект от их применения. 

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

--Получить информацию о степени фрагментации индекса можно с помощью опе-раторов: 
 SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]			--степень фрагментации индекса
        FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), 
        OBJECT_ID(N'#TEST5'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii 
		ON ss.object_id = ii.object_id and ss.index_id = ii.index_id 
		WHERE name is not null;

--Для избавления от фрагментации индекса предусмотрены две специальные опера-ции: реорганизация и перестройка индекса.
--Реорганизация (REORGANIZE) выполняется быстро, но после нее фрагментация будет убрана только на самом нижнем уровне

ALTER index #TEST5_TKEY on #TEST5 reorganize --реорганизация (-фрагм на нижнем)
 SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]			--степень фрагментации индекса
        FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), 
        OBJECT_ID(N'#TEST5'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii 
		ON ss.object_id = ii.object_id and ss.index_id = ii.index_id 
		WHERE name is not null;

--Операция перестройки (REBUILD) затрагивает все узлы дерева, поэтому после ее выполнения степень фрагментации равна нулю

ALTER index #TEST5_TKEY on #TEST5 rebuild with (online = off) --перестройка (меняет ветки местами) проходит через все дерево => фрагм=0
 SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]			--степень фрагментации индекса
        FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), 
        OBJECT_ID(N'#TEST5'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii 
		ON ss.object_id = ii.object_id and ss.index_id = ii.index_id 
		WHERE name is not null;


DROP index #TEST5_TKEY on #TEST5
DROP TABLE #TEST5

--6. Разработать пример, демон-стрирующий применение параметра 
--FILLFACTOR при создании некла-стеризованного индекса.

--Уровнем фрагментации можно в некоторой степени управлять, если при создании или изменении индекса использовать 
--параметры FILLFACTOR и PAD_INDEX. 

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

--Параметр FILLFACTOR указывает процент заполнения индексных страниц ниж-него уровня.
CREATE index #TEST6_TKEY on #TEST6(TKEY) with (fillfactor = 65);

INSERT top(10000) #TEST6(TKEY, TF) select TKEY, TF from #TEST6;
--INSERT top(100) percent INTO #TEST6(TKEY, TF) 
--                       SELECT TKEY, TF  FROM #TEST6;

SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
       FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),    
       OBJECT_ID(N'#TEST6'), NULL, NULL, NULL) ss  JOIN sys.indexes ii 
                                     ON ss.object_id = ii.object_id and ss.index_id = ii.index_id  
                                                                                          WHERE name is not null;

drop index #TEST6_TKEY on #TEST6
drop table #TEST6

