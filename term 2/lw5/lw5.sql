-- Задание 1 --
-- show sga
SELECT SUM(VALUE) FROM V$SGA;

-- Задание 2 --
SELECT * FROM V$SGA;

-- Задание 3 --
SELECT COMPONENT, GRANULE_SIZE, CURRENT_SIZE / GRANULE_SIZE AS RATIO FROM V$SGA_DYNAMIC_COMPONENTS;

-- Задание 4 --
SELECT CURRENT_SIZE FROM V$SGA_DYNAMIC_FREE_MEMORY;

-- Задание 5 --
SELECT NAME, VALUE FROM V$PARAMETER WHERE NAME IN ('sga_target', 'sga_max_size');

-- Задание 6 --
SELECT COMPONENT, MIN_SIZE, CURRENT_SIZE FROM V$SGA_DYNAMIC_COMPONENTS
     WHERE COMPONENT = 'DEFAULT buffer cache' or
           COMPONENT = 'KEEP buffer cache' or
           COMPONENT = 'RECYCLE buffer cache';

--Задание 7 --
CREATE TABLE PAA_TABLE_KEEP (
    ID NUMBER(2)
) STORAGE ( BUFFER_POOL KEEP );

INSERT INTO PAA_TABLE_KEEP (ID) VALUES (1);
INSERT INTO PAA_TABLE_KEEP (ID) VALUES (2);
INSERT INTO PAA_TABLE_KEEP (ID) VALUES (3);
INSERT INTO PAA_TABLE_KEEP (ID) VALUES (4);

COMMIT;

DROP TABLE  PAA_TABLE_KEEP PURGE;
FLASHBACK TABLE  PAA_TABLE_KEEP TO  BEFORE DROP;
SELECT * FROM  PAA_TABLE_KEEP;

SELECT SEGMENT_NAME, TABLESPACE_NAME, BUFFER_POOL FROM USER_SEGMENTS
    WHERE SEGMENT_NAME LIKE 'PAA_TABLE_KEEP';

-- Задание 8 --

CREATE TABLE PAA_TABLE_DEFAULT (
    Id number(2)
) STORAGE ( BUFFER_POOL DEFAULT );

INSERT INTO PAA_TABLE_DEFAULT (ID) VALUES (1);
INSERT INTO PAA_TABLE_DEFAULT (ID) VALUES (2);
INSERT INTO PAA_TABLE_DEFAULT (ID) VALUES (3);

COMMIT;

SELECT SEGMENT_NAME, TABLESPACE_NAME, BUFFER_POOL FROM USER_SEGMENTS
    WHERE SEGMENT_NAME LIKE 'PAA_TABLE_DEFAULT';

DROP TABLE  PAA_TABLE_DEFAULT PURGE;


-- Задание 9 --
SELECT NAME, HASH  FROM v$parameter WHERE name = 'log_buffer';

-- Задание 10 --
SELECT * FROM V$SGASTAT WHERE NAME = 'free memory' AND POOL = 'large pool';

-- Задание 11 --
SELECT USERNAME, SID, SERVER, STATUS FROM V$SESSION WHERE USERNAME iS NOT NULL;

-- Задание 12 --
SELECT NAME, DESCRIPTION FROM V$BGPROCESS;

-- Задание 13 --
SELECT * FROM v$process;

-- Задание 14 --
SELECT COUNT(*) FROM V$BGPROCESS WHERE PADDR != '00' AND NAME LIKE 'DBW%';

-- Задание 15 --
SELECT * FROM V$SESSION where  USERNAME is not null;

-- Задание 16 --
SELECT * FROM V$DISPATCHER;

-- Задание 17 --

--services.msc
--OracleOraDB21Home1TNSListener

-- Задание 18 --
--C:\app\User\product\21c\homes\OraDB21Home1\network\admin

-- Задание 19 --

-- lsnrctl start listener_name: Запускает слушателя с указанным именем
-- lsnrctl stop listener_name: Останавливает слушателя с указанным именем
-- lsnrctl status listener_name: Показывает статус слушателя с указанным именем
-- lsnrctl services listener_name: Показывает список сервисов, зарегистрированных у слушателя с указанным именем
-- lsnrctl reload listener_name: Перезагружает конфигурацию слушателя с указанным именем

-- Задание 20 --
SELECT NAME FROM DBA_SERVICES;
