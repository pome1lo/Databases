-- TASK 1 --
SELECT * FROM DBA_TABLESPACES;

-- TASK 2 --
--DROP TABLESPACE PAA_QDATA INCLUDING CONTENTS AND DATAFILES;
CREATE TABLESPACE PAA_QDATA
DATAFILE 'C:\LabWork\lw4\PAA_QDATA.dbf'
SIZE 10M
AUTOEXTEND ON NEXT 5M
MAXSIZE 20M
OFFLINE;

ALTER TABLESPACE  PAA_QDATA ONLINE ;

--DROP USER PAA;
CREATE USER PAA identified by 12345
  default tablespace PAA_QDATA
  quota unlimited on PAA_QDATA;

GRANT INSERT ON PAA_T1 TO PAA;
GRANT CREATE SESSION TO PAA;
GRANT CREATE TABLE TO PAA;

ALTER USER PAA QUOTA 2M ON PAA_QDATA;

--DROP TABLE PAA_T1;
CREATE TABLE PAA_T1 (
    Id number(5) primary key,
    Name nvarchar2(20)
) TABLESPACE PAA_QDATA;


INSERT INTO  PAA_T1 (Id, Name) VALUES (1, 'Oleg');
INSERT INTO  PAA_T1 (Id, Name) VALUES (2, 'Anton');
INSERT INTO  PAA_T1 (Id, Name) VALUES (3, 'Kirill');

-- TASK 3 --
SELECT DISTINCT * FROM DBA_SEGMENTS WHERE TABLESPACE_NAME = 'PAA_QDATA';

-- TASK 4 --
DROP TABLE PAA_T1; --purge;
SELECT DISTINCT * FROM DBA_SEGMENTS WHERE TABLESPACE_NAME = 'PAA_QDATA';
SELECT * FROM USER_RECYCLEBIN; -- корзина
COMMIT;

-- TASK 5 --
FLASHBACK TABLE  PAA_T1 TO  BEFORE DROP;
SELECT * FROM  PAA_T1;
SELECT DISTINCT * FROM DBA_SEGMENTS WHERE TABLESPACE_NAME = 'PAA_QDATA';

-- TASK 6 --
BEGIN
FOR k in 5..10000
    LOOP
    INSERT INTO PAA_T1 (Id) VALUES (k);
    end loop;
    COMMIT;
END;
SELECT * FROM  PAA_T1;

-- TASK 7 --
SELECT SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, BYTES, BLOCKS, EXTENTS, BUFFER_POOL FROM DBA_SEGMENTS WHERE TABLESPACE_NAME = 'PAA_QDATA';
SELECT * FROM USER_EXTENTS WHERE TABLESPACE_NAME = 'PAA_QDATA';

-- TASK 8 --
DROP TABLESPACE PAA_QDATA INCLUDING CONTENTS AND DATAFILES;

-- TASK 9 --
SELECT GROUP#, STATUS, MEMBERS FROM V$LOG;
-- журналы повтора являются файлами, содержащими записи обо всех
-- изменениях данных в базе данных Oracle. Журналы повтора используются для
-- обеспечения целостности и восстановления данных в случае сбоев или ошибок.

-- TASK 10 --
SELECT * FROM V$LOGFILE;

-- TASK 11 --
ALTER SESSION SET CONTAINER = CDB$ROOT;
ALTER SYSTEM SWITCH LOGFILE;
SELECT GROUP#, STATUS, MEMBERS FROM V$LOG;

-- TASK 12 --
ALTER SESSION SET CONTAINER = CDB$ROOT;

ALTER SESSION SET CONTAINER = XEPDB1;
ROLLBACK;

ALTER DATABASE ADD LOGFILE GROUP 4 'C:\app\User\product\21c\oradata\XE/redo004.log'
SIZE  50M BLOCKSIZE 512;
ALTER  DATABASE  ADD LOGFILE MEMBER 'C:\app\User\product\21c\oradata\XE\redo0041.log' TO GROUP 4;
ALTER  DATABASE  ADD LOGFILE MEMBER 'C:\app\User\product\21c\oradata\XE\redo0042.log' TO GROUP 4;
SELECT * FROM V$LOG;

SELECT CURRENT_SCN FROM V$DATABASE;
-- SCN (System Change Number) в Oracle — это логическая, внутренняя метка времени,
-- используемая базой данных Oracle1. SCN упорядочивает события, которые происходят
-- в базе данных, что необходимо для выполнения свойств ACID транзакции1.

-- TASK 13 --
ALTER SYSTEM CHECKPOINT;
ALTER DATABASE DROP LOGFILE GROUP 4;

-- TASK 14 --
SELECT NAME, LOG_MODE FROM V$DATABASE;
SELECT INSTANCE_NAME, ARCHIVER, ACTIVE_STATE FROM V$INSTANCE;

-- TASK 15 --
SELECT MAX(sequence#) FROM v$archived_log;

-- TASK 16 --
-- sqlplus
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;

SELECT NAME, LOG_MODE FROM V$DATABASE;

-- TASK 17 --
SELECT * FROM V$LOG;
ALTER SYSTEM SET LOG_ARCHIVE_DEST_1 ='LOCATION=C:\app\User\product\21c\oradata\XE\Archive';
ALTER SYSTEM SWITCH LOGFILE;

SELECT sequence#, name FROM v$archived_log ORDER BY sequence# DESC; -- номер последнего архивного файла.
SELECT group#, sequence#, first_change#, next_change# FROM v$log ORDER BY group#;
SELECT * FROM V$ARCHIVED_LOG;

-- TASK 18 --
-- sqlplus
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE NOARCHIVELOG;
ALTER DATABASE OPEN;

select name, log_mode from v$database;

-- TASK 19 --
SELECT * FROM V$CONTROLFILE;

-- TASK 20 (В консоли)
-- В консоли: SHOW PARAMETER CONTROL;

-- TASK 21 (В консоли)
-- В консоли: SHOW PARAMETER spfile;

-- TASK 22 --
CREATE PFILE = 'PAA_PFILE.ora' FROM SPFILE;
-- C:\app\User\product\21c\dbhomeXE\database

-- TASK 23 --
SELECT * FROM V$PWFILE_USERS;
-- C:\app\User\product\21c\dbhomeXE\bin\orapwd.exe

-- TASK 24 --
SELECT * FROM V$DIAG_INFO;
--