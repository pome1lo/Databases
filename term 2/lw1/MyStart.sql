CREATE table PAA_t(
    coll1 number(3) primary key,
    coll2 varchar2(50)
);

INSERT INTO PAA_t(coll1, coll2) values (1, 'value 1');
INSERT INTO PAA_t(coll1, coll2) values (2, 'value 2');
INSERT INTO PAA_t(coll1, coll2) values (3, 'value 3');
INSERT INTO PAA_t(coll1, coll2) values (4, 'value 4');
INSERT INTO PAA_t(coll1, coll2) values (5, 'value 5');
INSERT INTO PAA_t(coll1, coll2) values (6, 'value 6');
INSERT INTO PAA_t(coll1, coll2) values (8, 'value 8');

COMMIT;

SELECT coll1, coll2 FROM PAA_t;

SELECT coll1, coll2 FROM PAA_t
    WHERE MOD(coll1, 2) = 1;

SELECT MIN(coll1) FROM PAA_t;
SELECT MAX(coll1) FROM PAA_t;

DELETE FROM PAA_t WHERE COLL1 = 1;

COMMIT;

CREATE TABLE PAA_t1(
    id number primary key,
    coll_id number(3),
    string nvarchar2(50),

    CONSTRAINT fk_coll_id
        FOREIGN KEY (coll_id)
        REFERENCES PAA_t(coll1)
);



INSERT INTO PAA_t1(id, coll_id, string) values (6, 6,'string 6');
INSERT INTO PAA_t1(id, coll_id, string) values (3, 3,'string 3');
INSERT INTO PAA_t1(id, coll_id, string) values (5, 5,'string 5');

SELECT coll1, string FROM PAA_t
    LEFT JOIN PAA_t1 ON PAA_t.coll1 = PAA_t1.coll_id;

SELECT coll1, string FROM PAA_t
    RIGHT JOIN PAA_t1 ON PAA_t.coll1 = PAA_t1.coll_id;

SELECT coll1, string FROM PAA_t
    INNER JOIN PAA_t1 ON PAA_t.coll1 = PAA_t1.coll_id;


DROP TABLE PAA_t1;
DROP TABLE PAA_t;
