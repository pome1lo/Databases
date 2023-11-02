--TASK 1

--GRANT CREATE SEQUENCE TO U1_PAA_PDB;
--ALTER USER U1_PAA_PDB QUOTA UNLIMITED ON USERS;

/*--TASK 2 Создание последовательности S1

CREATE SEQUENCE S1
  START WITH 1000
  INCREMENT BY 10
  NOMINVALUE
  NOMAXVALUE
  NOCYCLE
  NOCACHE
  NOORDER;

SELECT S1.NEXTVAL FROM DUAL;
SELECT S1.NEXTVAL FROM DUAL;
SELECT S1.NEXTVAL FROM DUAL;

SELECT S1.CURRVAL FROM DUAL;


--TASK 3. Создание последовательности S2
CREATE SEQUENCE S2
  START WITH 10
  INCREMENT BY 10
  MAXVALUE 100
  NOCYCLE
  NOCACHE
  NOORDER;

-- Получение всех значений последовательности
DECLARE
   i NUMBER;
BEGIN
   FOR i IN 1..10 LOOP
      DBMS_OUTPUT.PUT_LINE(S2.NEXTVAL);
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

--TASK 5 Создание последовательности S3
CREATE SEQUENCE S3
  START WITH 10
  INCREMENT BY -10
  MINVALUE -100
  NOCYCLE
  NOCACHE
  ORDER;

-- Получение всех значений последовательности
DECLARE
   i NUMBER;
BEGIN
   FOR i IN 1..12 LOOP
      DBMS_OUTPUT.PUT_LINE(S3.NEXTVAL);
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/


-- TASK 6 Создание последовательности S4
CREATE SEQUENCE S4
  START WITH 1
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 10
  CYCLE
  CACHE 5
  NOORDER;

-- Продемонстрировать цикличность генерации значений последовательностью S4.
DECLARE
   i NUMBER;
BEGIN
   FOR i IN 1..15 LOOP
      DBMS_OUTPUT.PUT_LINE(S4.NEXTVAL);
   END LOOP;
END;
/

--TASK 7. Получите список всех последовательностей в словаре базы данных, владельцем которых является пользователь XXX.
SELECT sequence_name FROM all_sequences WHERE sequence_owner = 'U1_PAA_PDB';


--TASK 8 Создание таблицы T1
CREATE TABLE T1 (
  N1 NUMBER(20),
  N2 NUMBER(20),
  N3 NUMBER(20),
  N4 NUMBER(20)
) STORAGE ( BUFFER_POOL KEEP );

-- Изменить максимальное значение
--ALTER SEQUENCE S2 MAXVALUE 1000;
--ALTER SEQUENCE S2 CYCLE;


BEGIN
   FOR i IN 1..5 LOOP
      INSERT INTO T1 (N1, N2, N3, N4) VALUES (S1.NEXTVAL, S2.NEXTVAL, S3.NEXTVAL, S4.NEXTVAL);
   END LOOP;
   COMMIT;
END;
/*/


-- 2. Создание последовательности S1
CREATE SEQUENCE S1
  START WITH 1000
  INCREMENT BY 10
  NOMINVALUE
  NOMAXVALUE
  NOCYCLE
  NOCACHE
  NOORDER;

-- Получение нескольких значений последовательности
SELECT S1.NEXTVAL FROM dual;
SELECT S1.NEXTVAL FROM dual;
SELECT S1.NEXTVAL FROM dual;

-- Получение текущего значения последовательности
SELECT S1.CURRVAL FROM dual;

-- 3. Создание последовательности S2
CREATE SEQUENCE S2
  START WITH 10
  INCREMENT BY 10
  MAXVALUE 100
  NOCYCLE
  NOCACHE
  NOORDER;

-- Получение всех значений последовательности
DECLARE
   i NUMBER;
BEGIN
   FOR i IN 1..10 LOOP
      DBMS_OUTPUT.PUT_LINE(S2.NEXTVAL);
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

-- 5. Создание последовательности S3
CREATE SEQUENCE S3
  START WITH 100
  INCREMENT BY -10
  MINVALUE -100
  MAXVALUE 1000
  NOCYCLE
  NOCACHE
  ORDER;

-- Получение всех значений последовательности
DECLARE
   i NUMBER;
BEGIN
   FOR i IN 1..12 LOOP
      DBMS_OUTPUT.PUT_LINE(S3.NEXTVAL);
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

-- 6. Создание последовательности S4
CREATE SEQUENCE S4
  START WITH 1
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 10
  CYCLE
  CACHE 5
  NOORDER;

-- Продемонстрировать цикличность генерации значений последовательностью S4.
DECLARE
   i NUMBER;
BEGIN
   FOR i IN 1..15 LOOP
      DBMS_OUTPUT.PUT_LINE(S4.NEXTVAL);
   END LOOP;
END;
/

--7. Получите список всех последовательностей в словаре базы данных, владельцем которых является пользователь XXX.
SELECT sequence_name FROM all_sequences WHERE sequence_owner = 'XXX';

--8. Создайте таблицу T1, имеющую столбцы N1, N2, N3, N4, типа NUMBER (20), кэшируемую и расположенную в буферном пуле KEEP. С помощью оператора INSERT добавьте 7 строк, вводимое значение для столбцов должно формироваться с помощью последовательностей S1, S2, S3, S4.
CREATE TABLE T1 (
    N1 NUMBER(20),
    N2 NUMBER(20),
    N3 NUMBER(20),
    N4 NUMBER(20)
) STORAGE ( BUFFER_POOL KEEP );

ALTER SEQUENCE S2 CYCLE;

BEGIN
    FOR i IN 1..7 LOOP
        INSERT INTO T1 (N1, N2, N3, N4) VALUES (S1.NEXTVAL, S2.NEXTVAL, S3.NEXTVAL, S4.NEXTVAL);
    END LOOP;
    COMMIT;
END;
/


--TASK 9 Создание кластера ABC
CREATE CLUSTER ABC (
  X NUMBER(10),
  V VARCHAR2(12)
) SIZE 200 HASHKEYS 100;

--TASK 10 Создание таблицы A
CREATE TABLE A (
  XA NUMBER(10),
  VA VARCHAR2(12),
  EXTRA_COLUMN VARCHAR2(50)
) CLUSTER ABC (XA, VA);

--TASK 11 Создание таблицы B
CREATE TABLE B (
  XB NUMBER(10),
  VB VARCHAR2(12),
  EXTRA_COLUMN_B VARCHAR2(50)
) CLUSTER ABC (XB, VB);

--TASK 12 Создание таблицы C
CREATE TABLE C (
  XC NUMBER(10),
  VC VARCHAR2(12),
  EXTRA_COLUMN_C VARCHAR2(50)
) CLUSTER ABC (XC, VC);

--TASK 13 Найти созданные таблицы и кластер в представлениях словаря Oracle
SELECT * FROM USER_TABLES WHERE TABLE_NAME IN ('A', 'B', 'C');
SELECT * FROM USER_CLUSTERS WHERE CLUSTER_NAME = 'ABC';

--TASK 14 Создание частного синонима
CREATE SYNONYM U1_PAA_PDB.C_FOR_PAA FOR U1_PAA_PDB.C;

SELECT * FROM U1_PAA_PDB.C_FOR_PAA;


--TASK 15 Создание публичного синонима
CREATE PUBLIC SYNONYM B_FOR_PAA FOR U1_PAA_PDB.B;

SELECT * FROM B_FOR_PAA;

DROP TABLE C;
DROP TABLE B;
DROP TABLE A;

--TASK 16 Создание таблиц A и B и представления V1
CREATE TABLE A (
  ID NUMBER(10) PRIMARY KEY,
  DATA VARCHAR2(50)
);

CREATE TABLE B (
  ID NUMBER(10),
  A_ID NUMBER(10),
  DATA VARCHAR2(50),
  CONSTRAINT fk_A_ID FOREIGN KEY (A_ID) REFERENCES A(ID)
);

BEGIN
   FOR i IN 1..10 LOOP
      INSERT INTO A (ID, DATA) VALUES (i, 'Data ' || i);
      INSERT INTO B (ID, A_ID, DATA) VALUES (i, i, 'Data ' || i);
   END LOOP;
   COMMIT;
END;
/


CREATE VIEW V1 AS SELECT A.ID, A.DATA, B.DATA AS B_DATA FROM A INNER JOIN B ON A.ID = B.A_ID;

SELECT * FROM V1;

--TASK 17. Создание материализованного представления MV
CREATE MATERIALIZED VIEW MV REFRESH COMPLETE START WITH SYSDATE NEXT SYSDATE + INTERVAL '2' MINUTE AS SELECT A.ID, A.DATA, B.DATA AS B_DATA FROM A INNER JOIN B ON A.ID = B.A_ID;

SELECT * FROM MV;


DROP MATERIALIZED VIEW MV;
DROP VIEW V1;
--DROP TABLE C;
DROP TABLE B;
DROP TABLE A;
DROP SYNONYM U1_PAA_PDB.C_FOR_PAA;
DROP PUBLIC SYNONYM B_FOR_PAA;
DECLARE
   CURSOR c IS SELECT table_name FROM user_tables WHERE cluster_name = 'ABC';
   v_sql VARCHAR2(100);
BEGIN
   FOR t IN c LOOP
      v_sql := 'DROP TABLE ' || t.table_name;
      EXECUTE IMMEDIATE v_sql;
   END LOOP;
END;
DROP CLUSTER ABC;
DROP TABLE T1;
DROP SEQUENCE S1;
DROP SEQUENCE S2;
DROP SEQUENCE S3;
DROP SEQUENCE S4;

SELECT * FROM user_tables where cluster_name = 'abc';