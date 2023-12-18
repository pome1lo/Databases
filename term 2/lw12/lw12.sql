--grant create trigger, drop any trigger to ADMIN_USER;
alter session set nls_date_format='dd-mm-yyyy hh24:mi:ss';


-- TASK №1
DROP TABLE PAA_TABLE;

CREATE TABLE PAA_TABLE (
    A INT PRIMARY KEY,
    B VARCHAR(30)
);

-- TASK №2
BEGIN
    FOR I IN 1..10
    LOOP
        INSERT INTO PAA_TABLE VALUES (I, 'A');
    END LOOP;
END;



SELECT * FROM PAA_TABLE;
INSERT INTO PAA_TABLE VALUES (1337, 'TEST  111');
UPDATE PAA_TABLE SET B = 'TEST   222' WHERE A = 1337;
DELETE PAA_TABLE WHERE A = 1337;

SELECT * FROM AUDIT_;




-- TASK №3, 4
CREATE OR REPLACE TRIGGER INSERT_TR_BEFORE_STATEMENT
    BEFORE INSERT ON PAA_TABLE
BEGIN
    DBMS_OUTPUT.PUT_LINE('3_4 INSERT_TRIGGER_BEFORE_STATEMENT');
    DBMS_OUTPUT.PUT_LINE(' ');
END;

CREATE OR REPLACE TRIGGER UPDATE_TR_BEFORE_STATEMENT
    BEFORE UPDATE ON PAA_TABLE
BEGIN
    DBMS_OUTPUT.PUT_LINE('3_4 UPDATE_TRIGGER_BEFORE_STATEMENT');
    DBMS_OUTPUT.PUT_LINE(' ');
END;

CREATE OR REPLACE TRIGGER DELETE_TR_BEFORE_STATEMENT
    BEFORE DELETE ON PAA_TABLE
BEGIN
    DBMS_OUTPUT.PUT_LINE('3_4 DELETE_TRIGGER_BEFORE_STATEMENT');
    DBMS_OUTPUT.PUT_LINE(' ');
END;

-- TASK №5
CREATE OR REPLACE TRIGGER INSERT_TR_BEFORE_ROW
    BEFORE INSERT ON PAA_TABLE FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('_5  INSERT_TRIGGER_BEFORE_ROW');
    DBMS_OUTPUT.PUT_LINE(' ');
END;

CREATE OR REPLACE TRIGGER UPDATE_TR_BEFORE_ROW
    BEFORE UPDATE ON PAA_TABLE FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('_5  UPDATE_TRIGGER_BEFORE_ROW');
    DBMS_OUTPUT.PUT_LINE(' ');
END;

CREATE OR REPLACE TRIGGER DELETE_TR_BEFORE_ROW
    BEFORE DELETE ON PAA_TABLE FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('_5  DELETE_TRIGGER_BEFORE_ROW');
    DBMS_OUTPUT.PUT_LINE(' ');
END;

-- TASK №6
CREATE OR REPLACE TRIGGER TRIGGER_DML
    BEFORE INSERT OR UPDATE OR DELETE
    ON PAA_TABLE
BEGIN
    IF INSERTING THEN
        DBMS_OUTPUT.PUT_LINE('_6  TRIGGER_DML_BEFORE_INSERT');
    ELSIF UPDATING THEN
        DBMS_OUTPUT.PUT_LINE('_6  TRIGGER_DML_BEFORE_UPDATE');
    ELSIF DELETING THEN
        DBMS_OUTPUT.PUT_LINE('_6  TRIGGER_DML_BEFORE_DELETE');
    END IF;
END;

-- TASK №7
CREATE OR REPLACE TRIGGER INSERT_TR_AFTER_STATEMENT
    AFTER INSERT ON PAA_TABLE
BEGIN
    DBMS_OUTPUT.PUT_LINE('_7  INSERT_TR_AFTER_STATEMENT');
END;

CREATE OR REPLACE TRIGGER UPDATE_TR_AFTER_STATEMENT
    AFTER UPDATE ON PAA_TABLE
BEGIN
    DBMS_OUTPUT.PUT_LINE('_7  UPDATE_TR_AFTER_STATEMENT');
END;

CREATE OR REPLACE TRIGGER DELETE_TR_AFTER_STATEMENT
    AFTER DELETE ON PAA_TABLE
BEGIN
    DBMS_OUTPUT.PUT_LINE('_7   DELETE_TR_AFTER_STATEMENT');
END;

-- TASK №8
CREATE OR REPLACE TRIGGER INSERT_TR_AFTER_ROW
    AFTER INSERT
    ON PAA_TABLE
    FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('_8  INSERT_TR_AFTER_ROW');
END;

CREATE OR REPLACE TRIGGER UPDATE_TR_AFTER_ROW
    AFTER UPDATE
    ON PAA_TABLE
    FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('_8  UPDATE_TR_AFTER_ROW');
END;

CREATE OR REPLACE TRIGGER DELETE_TR_AFTER_ROW
    AFTER DELETE
    ON PAA_TABLE
    FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('_8  DELETE_TR_AFTER_ROW');
END;

-- TASK №9
CREATE TABLE AUDIT_ (
    OPERATIONDATE DATE,
    OPERATIONTYPE VARCHAR2(50),
    TRIGGERNAME   VARCHAR2(50),
    DATA          VARCHAR2(40)
);

-- TASK №10
CREATE OR REPLACE TRIGGER TRIGGER_BEFORE_AUDIT
    BEFORE INSERT OR UPDATE OR DELETE
    ON PAA_TABLE
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
         DBMS_OUTPUT.PUT_LINE('10  TRIGGER_BEFORE_AUDIT - INSERT' );
         INSERT INTO AUDIT_ VALUES (
            SYSDATE,
            'INSERT',
            'TRIGGER_BEFORE_AUDIT',
            :NEW.A || ' ' || :NEW.B
         );
    ELSIF UPDATING THEN
        DBMS_OUTPUT.PUT_LINE('10  TRIGGER_BEFORE_AUDIT - UPDATE' );
        INSERT INTO AUDIT_ VALUES (
            SYSDATE,
            'UPDATE',
            'TRIGGER_BEFORE_AUDIT',
             :OLD.A || ' ' || :OLD.B || ' => ' || :NEW.A || ' ' || :NEW.B
        );
    ELSIF DELETING THEN
         DBMS_OUTPUT.PUT_LINE('10  TRIGGER_BEFORE_AUDIT - DELETE' );
         INSERT INTO AUDIT_ VALUES (
            SYSDATE,
            'DELETE',
            'TRIGGER_BEFORE_AUDIT',
            :OLD.A || ' ' || :OLD.B
         );
    END IF;
END;

CREATE OR REPLACE TRIGGER TRIGGER_AFTER_AUDIT
    AFTER INSERT OR UPDATE OR DELETE
    ON PAA_TABLE
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
         DBMS_OUTPUT.PUT_LINE('10  TRIGGER_AFTER_AUDIT - INSERT' );
         INSERT INTO AUDIT_ VALUES (
            SYSDATE,
            'INSERT',
            'TRIGGER_AFTER_AUDIT',
            :NEW.A || ' ' || :NEW.B
         );
    ELSIF UPDATING THEN
        DBMS_OUTPUT.PUT_LINE('10  TRIGGER_AFTER_AUDIT - UPDATE' );
        INSERT INTO AUDIT_ VALUES (
            SYSDATE,
            'UPDATE',
            'TRIGGER_AFTER_AUDIT',
             :OLD.A || ' ' || :OLD.B || ' -> ' || :NEW.A || ' ' || :NEW.B
        );
    ELSIF DELETING THEN
         DBMS_OUTPUT.PUT_LINE('10  TRIGGER_AFTER_AUDIT - DELETE' );
         INSERT INTO AUDIT_ VALUES (
            SYSDATE,
            'DELETE',
            'TRIGGER_AFTER_AUDIT',
            :OLD.A || ' ' || :OLD.B
         );
    END IF;
END;

SELECT * FROM AUDIT_;
--TRUNCATE TABLE AUDIT_;

-- TASK №11
INSERT INTO PAA_TABLE VALUES (1, 'V');


-- TASK №12
DROP TABLE PAA_TABLE;


CREATE TABLE PAA_TABLE (
    A INT PRIMARY KEY,
    B VARCHAR(30)
);
drop table PAA_TABLE;
--DROP TRIGGER TRIGGER_PREVENT_TABLE_DROP;
CREATE OR REPLACE TRIGGER TRIGGER_PREVENT_TABLE_DROP
    BEFORE DROP ON ADMIN_USER.SCHEMA
BEGIN
    IF DICTIONARY_OBJ_NAME = 'PAA_TABLE'
    THEN
        RAISE_APPLICATION_ERROR(-20000, '!!! 😎 YOU CAN NOT DROP TABLE PAA_TABLE !!!');
    END IF;
END;

DROP TABLE PAA_TABLE;

-- TASK №13
DROP TABLE AUDIT_;

-- TASK №14
DROP VIEW PAA_TABLE_VIEW;
CREATE VIEW PAA_TABLE_VIEW AS SELECT * FROM PAA_TABLE;

CREATE OR REPLACE TRIGGER TRIGGER_INSTEAD_OF_INSERT
    INSTEAD OF INSERT ON PAA_TABLE_VIEW
BEGIN
    IF INSERTING THEN
        DBMS_OUTPUT.PUT_LINE('14  TRIGGER_INSTEAD_OF_INSERT');
        INSERT INTO PAA_TABLE VALUES (100, 'WWW');
    END IF;
END TRIGGER_INSTEAD_OF_INSERT;

select *
from PAA_TABLE;
SELECT * FROM PAA_TABLE_VIEW;
INSERT INTO PAA_TABLE_VIEW VALUES (111, 'EEE');