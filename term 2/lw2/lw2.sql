--ALTER DATABASE OPEN

--#TASK 1
CREATE TABLESPACE TS_PAA
    DATAFILE 'D:\FILES\TS_PAA.dbf'
    SIZE 7m
    REUSE AUTOEXTEND ON NEXT 10m
    MAXSIZE 20m;
COMMIT;
DROP TABLESPACE TS_PAA INCLUDING CONTENTS AND DATAFILES;

--#TASK 2
CREATE TEMPORARY TABLESPACE TS_PAA_TEMP
    TEMPFILE 'D:\FILES\University\3 course\1 term\DB\lw2\TS_PAA_TEMP.dbf'
    SIZE 5m
    REUSE AUTOEXTEND ON NEXT 3m
    MAXSIZE 30m;
COMMIT;
DROP TABLESPACE TS_PAA_TEMP INCLUDING CONTENTS AND DATAFILES;

--#TASK 3
SELECT TABLESPACE_NAME, STATUS, contents  from dba_tablespaces;

--#TASK 4

alter session set "_oracle_script"=true;
CREATE ROLE RL_PAACORE;

grant create session, create table, create view, create procedure to RL_PAACORE;
grant drop any table, drop any view, drop any procedure to RL_PAACORE;

--#TASK 5
SELECT * FROM DBA_ROLES WHERE role='RL_PAACORE';
SELECT * FROM DBA_SYS_PRIVS WHERE grantee='RL_PAACORE';



--#TASK 6 -- ***

alter session set "_ORACLE_SCRIPT" = true;


CREATE PROFILE PR_PAACORE LIMIT
    PASSWORD_LIFE_TIME 180
    SESSIONS_PER_USER 3
    FAILED_LOGIN_ATTEMPTS 7
    PASSWORD_LOCK_TIME 1
    PASSWORD_REUSE_TIME 10
    PASSWORD_GRACE_TIME DEFAULT
    CONNECT_TIME 180
    IDLE_TIME 30;


--#TASK 7
select * from DBA_PROFILES;
select * from DBA_PROFILES where profile='PR_PAACORE';
select * from DBA_PROFILES where profile='DEFAULT';

--#TASK 8
CREATE USER PAACORE identified by 12345
  default tablespace TS_PAA
  quota unlimited on TS_PAA
  temporary tablespace TS_PAA_TEMP
  profile PF_PAACORE
  account unlock
  password expire;

GRANT RL_PAACORE to PAACORE;

GRANT CREATE TABLE to PAACORE;
GRANT CREATE TABLESPACE, ALTER TABLESPACE to PAACORE;
COMMIT;

DROP USER PAACORE;
DROP ROLE RL_PAACORE;
--#TASK 9 ***
PAACORE/12345@//localhost:1521/pdb_1
12345
12345

--#TASK 10

CREATE TABLE PAA_TABLE(
id number GENERATED ALWAYS AS IDENTITY primary key,
word varchar2(50) NOT NULL);

INSERT  into PAA_TABLE(word) values('Apple');
INSERT  into PAA_TABLE(word) values('Juice');
INSERT  into PAA_TABLE(word) values('Banana');


CREATE VIEW three_entries AS SELECT * FROM PAA_TABLE WHERE id<=3;

SELECT * FROM PAA_TABLE;
SELECT * FROM three_entries;


DROP TABLE PAA_TABLE;
DROP VIEW three_entries;

--#TASK 11

CREATE TABLESPACE PAA_QDATA OFFLINE
  DATAFILE 'D:\FILES\University\3 course\1 term\DB\lw2\PAA_QDATA.txt'
  SIZE 10m REUSE
  AUTOEXTEND ON NEXT 5m
  MAXSIZE 20M;

ALTER TABLESPACE PAA_QDATA online;

ALTER USER PAACORE QUOTA 2M ON PAA_QDATA;

DROP TABLESPACE PAA_QDATA;

CREATE TABLE table1 (c NUMBER);

INSERT INTO table1(c) VALUES(3);
INSERT INTO table1(c) VALUES(1);
INSERT INTO table1(c) VALUES(2);

SELECT * FROM table1;

DROP TABLE table1;