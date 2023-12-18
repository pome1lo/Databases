alter session set nls_date_format='dd-mm-yyyy hh24:mi:ss';
grant create tablespace, drop tablespace to ADMIN_USER;
alter user ADMIN_USER quota unlimited on table_space_1;
alter user ADMIN_USER quota unlimited on table_space_2;
alter user ADMIN_USER quota unlimited on table_space_3;
alter user ADMIN_USER quota unlimited on table_space_4;

--drop tablespace table_space_1 including contents and datafiles;
--drop tablespace table_space_2 including contents and datafiles;
--drop tablespace table_space_3 including contents and datafiles;
--drop tablespace table_space_4 including contents and datafiles;

create tablespace table_space_1
    datafile 'table_space_1.dbf' size 7 m autoextend on
    maxsize unlimited extent management local;

create tablespace table_space_2
    datafile 'table_space_2.dbf' size 7 m autoextend on
    maxsize unlimited extent management local;

create tablespace table_space_3
    datafile 'table_space_3.dbf' size 7 m autoextend on
    maxsize unlimited extent management local;

create tablespace table_space_4
    datafile 'table_space_4.dbf' size 7 m autoextend on
    maxsize unlimited extent management local;


-- TASK №1, 5
DROP TABLE T_RANGE;
CREATE TABLE T_RANGE (
    ID      NUMBER,
    TIME_ID DATE
)

PARTITION BY RANGE (ID) (
    PARTITION P0 VALUES LESS THAN (100) TABLESPACE TABLE_SPACE_1,
    PARTITION P1 VALUES LESS THAN (200) TABLESPACE TABLE_SPACE_2,
    PARTITION P2 VALUES LESS THAN (300) TABLESPACE TABLE_SPACE_3,
    PARTITION PMAX VALUES LESS THAN (MAXVALUE) TABLESPACE TABLE_SPACE_4
);


BEGIN
    FOR I IN 1..400
    LOOP
        INSERT INTO T_RANGE(ID, TIME_ID) VALUES (I, SYSDATE);
    END LOOP;
END;

SELECT * FROM T_RANGE PARTITION(P0);
SELECT * FROM T_RANGE PARTITION(P1);
SELECT * FROM T_RANGE PARTITION(P2);
SELECT * FROM T_RANGE PARTITION(PMAX);

SELECT TABLE_NAME, PARTITION_NAME, HIGH_VALUE, TABLESPACE_NAME FROM USER_TAB_PARTITIONS
    WHERE TABLE_NAME = 'T_RANGE';

-- TASK №2, 5
DROP TABLE T_INTERVAL;
CREATE TABLE T_INTERVAL (
    ID      NUMBER,
    TIME_ID DATE
)
    PARTITION BY RANGE (TIME_ID)
    INTERVAL (numtoyminterval(1, 'month')) (
    PARTITION P0 VALUES LESS THAN (TO_DATE('1-12-2010', 'dd-mm-yyyy')) TABLESPACE TABLE_SPACE_1,
    PARTITION P1 VALUES LESS THAN (TO_DATE('1-12-2015', 'dd-mm-yyyy')) TABLESPACE TABLE_SPACE_2,
    PARTITION P2 VALUES LESS THAN (TO_DATE('1-12-2020', 'dd-mm-yyyy')) TABLESPACE TABLE_SPACE_3
);

INSERT INTO T_INTERVAL(ID, TIME_ID) VALUES (50, '01-02-2008');
INSERT INTO T_INTERVAL(ID, TIME_ID) VALUES (105, '01-01-2009');
INSERT INTO T_INTERVAL(ID, TIME_ID) VALUES (105, '01-01-2007');
INSERT INTO T_INTERVAL(ID, TIME_ID) VALUES (205, '01-01-2019');
INSERT INTO T_INTERVAL(ID, TIME_ID) VALUES (305, '01-01-2013');
INSERT INTO T_INTERVAL(ID, TIME_ID) VALUES (405, '01-01-2017');
INSERT INTO T_INTERVAL(ID, TIME_ID) VALUES (505, '01-01-2022');
COMMIT;

SELECT * FROM T_INTERVAL PARTITION (P0);
SELECT * FROM T_INTERVAL PARTITION (P1);
SELECT * FROM T_INTERVAL PARTITION (P2);
SELECT * FROM T_INTERVAL PARTITION (SYS_P725);

SELECT TABLE_NAME, PARTITION_NAME, HIGH_VALUE, TABLESPACE_NAME FROM USER_TAB_PARTITIONS
WHERE TABLE_NAME = 'T_INTERVAL';


-- TASK №3, 5
DROP TABLE T_HASH;
CREATE TABLE T_HASH (
    STR VARCHAR2(50),
    ID  NUMBER
)
PARTITION BY HASH (STR) (
    PARTITION K0 TABLESPACE TABLE_SPACE_1,
    PARTITION K1 TABLESPACE TABLE_SPACE_2,
    PARTITION K2 TABLESPACE TABLE_SPACE_3,
    PARTITION K3 TABLESPACE TABLE_SPACE_4
);

INSERT INTO T_HASH (STR, ID) VALUES ('QWERTY', 1);
INSERT INTO T_HASH (STR, ID) VALUES ('SOME STRING', 2);
INSERT INTO T_HASH (STR, ID) VALUES ('ABCDEFG', 3);
INSERT INTO T_HASH (STR, ID) VALUES ('BBBBBBBB', 4);
INSERT INTO T_HASH (STR, ID) VALUES ('XX', 7);
INSERT INTO T_HASH (STR, ID) VALUES ('UUUU', 14);
INSERT INTO T_HASH (STR, ID) VALUES ('qwertyqwerty', 32);
COMMIT;

SELECT * FROM T_HASH PARTITION (K0);
SELECT * FROM T_HASH PARTITION (K1);
SELECT * FROM T_HASH PARTITION (K2);
SELECT * FROM T_HASH PARTITION (K3);

-- TASK №4, 5
DROP TABLE T_LIST;
CREATE TABLE T_LIST (
    OBJ CHAR(3)
)
PARTITION BY LIST(OBJ) (
    PARTITION L0 VALUES ('a') TABLESPACE TABLE_SPACE_1,
    PARTITION L1 VALUES ('b') TABLESPACE TABLE_SPACE_2,
    PARTITION L2 VALUES ('c') TABLESPACE TABLE_SPACE_3,
    PARTITION L3 VALUES (DEFAULT) TABLESPACE TABLE_SPACE_4
);

INSERT INTO T_LIST(OBJ) VALUES('a');
INSERT INTO T_LIST(OBJ) VALUES('b');
INSERT INTO T_LIST(OBJ) VALUES('c');
INSERT INTO T_LIST(OBJ) VALUES('d');
INSERT INTO T_LIST(OBJ) VALUES('e');
COMMIT;

SELECT * FROM T_LIST PARTITION (L0);
SELECT * FROM T_LIST PARTITION (L1);
SELECT * FROM T_LIST PARTITION (L2);
SELECT * FROM T_LIST PARTITION (L3);

-- TASK №6

-- В Oracle PL/SQL, команда ALTER TABLE T_INTERVAL ENABLE ROW MOVEMENT; используется для включения
-- возможности перемещения строк между секциями12. Когда вы обновляете значение ключа секционирования,
-- строка может быть перемещена из одной секции в другую. Это называется перемещением строк между
-- секциями1. Если вы не включите перемещение строк, то при попытке обновить строку таким образом,
-- чтобы она попала в другую секцию, вы получите ошибку2.

ALTER TABLE T_RANGE ENABLE ROW MOVEMENT;
SELECT * FROM T_RANGE PARTITION(PMAX);

UPDATE T_RANGE SET ID=2 WHERE ID=300;
SELECT * FROM T_RANGE PARTITION(P0) ORDER BY ID;
---------------------------------------

ALTER TABLE T_INTERVAL ENABLE ROW MOVEMENT;
SELECT * FROM T_INTERVAL PARTITION(P0);

UPDATE T_INTERVAL SET TIME_ID=TO_DATE('01-02-2017') WHERE ID=50;
SELECT * FROM T_INTERVAL PARTITION(P2);
---------------------------------------


ALTER TABLE T_HASH ENABLE ROW MOVEMENT;
SELECT * FROM T_HASH PARTITION(K2);

UPDATE T_HASH SET STR='zxcvbnm' WHERE ID=3;
SELECT * FROM T_HASH PARTITION(K3);
---------------------------------------


ALTER TABLE T_LIST ENABLE ROW MOVEMENT;
SELECT * FROM T_LIST PARTITION(L0);

UPDATE T_LIST SET OBJ='b' WHERE OBJ='a';
SELECT * FROM T_LIST PARTITION(L1);
---------------------------------------


-- TASK №7
ALTER TABLE T_RANGE MERGE PARTITIONS P1, P2 INTO PARTITION P5 TABLESPACE TABLE_SPACE_4;
SELECT * FROM T_RANGE PARTITION(P5);

-- TASK №8
ALTER TABLE T_RANGE SPLIT PARTITION P5 AT (200)
INTO (PARTITION P1 TABLESPACE TABLE_SPACE_1, PARTITION P2 TABLESPACE TABLE_SPACE_2);
--SELECT * FROM T_RANGE PARTITION(P5);
SELECT * FROM T_RANGE PARTITION(P1);
SELECT * FROM T_RANGE PARTITION(P2);

-- TASK №9
DROP TABLE T_RANGE1;
CREATE TABLE T_RANGE1 (
    ID      NUMBER,
    TIME_ID DATE
);
ALTER TABLE T_RANGE EXCHANGE PARTITION P0 WITH TABLE T_RANGE1 WITHOUT VALIDATION;
SELECT * FROM T_RANGE PARTITION (P0);
SELECT * FROM T_RANGE1;