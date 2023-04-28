--1 �� ������ ������ AUDITORIUM_ TYPE � AUDITORIUM ������������ �������� ����� ��������� � 
-- ��������������� �� ������������ ����� ���������. ������������ ���������� ������ INNER JOIN. 
USE UNIVER;
SELECT AUDITORIUM_NAME AS [Name],, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME FROM AUDITORIUM INNER JOIN AUDITORIUM_TYPE 
	ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE;

--2 �� ������ ������ AUDITORIUM_TYPE � AUDITORIUM ������������ �������� ����� ��������� � ���������������
-- �� ������������ ����� ���������, ������ ������ �� ���������, � ������������ ������� ������������ 
-- ��������� ���������. ������������ ���������� ������ INNER JOIN � �������� LIKE. 
USE UNIVER;
SELECT AUDITORIUM_TYPENAME, AUDITORIUM_TYPE.AUDITORIUM_TYPE FROM AUDITORIUM INNER JOIN AUDITORIUM_TYPE 
	ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
	WHERE AUDITORIUM_TYPENAME LIKE '%���������%';

--3 �� ������ ������ PRORGESS, STUDENT, GROUPS, SUBJECT, PULPIT � FACULTY ������������ �������� ���������,
-- ���������� ��������������� ������ �� 6 �� 8. �������������� ����� ������ ��������� �������: ���������, 
-- �������, �������������, ����������, ��� ��������, ������. � ������� ������ ������ ���� �������� ���������������
-- ������ ��������: �����, ����, ������. ��������� ������������� � ������� �������� �� ������� PROGRESS.NOTE.
-- ������������ ���������� INNER JOIN, �������� BETWEEN � ��������� CASE.
USE UNIVER
SELECT  FACULTY.FACULTY AS [���������], PULPIT.PULPIT[�������], STUDENT.NAME[��� ��������], GROUPS.PROFESSION[�������������], SUBJECT.SUBJECT[����������],
	CASE 
		WHEN NOTE = 6 THEN '�����'
		WHEN NOTE = 7 THEN '����'
		WHEN NOTE = 8 THEN '������'
	END [������]
		FROM PROGRESS 
		Inner Join STUDENT ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		Inner Join GROUPS ON STUDENT.IDGROUP = GROUPS.IDGROUP
		Inner Join SUBJECT ON PROGRESS.SUBJECT = SUBJECT.SUBJECT
		Inner Join FACULTY ON GROUPS.FACULTY = FACULTY.FACULTY
		Inner Join PULPIT ON SUBJECT.PULPIT = PULPIT.PULPIT
		WHERE Note BETWEEN 6 AND 8
		ORDER BY PROGRESS.NOTE desc, FACULTY.FACULTY, PULPIT.PULPIT, GROUPS.PROFESSION, STUDENT.NAME
	--?

--4 �� ������ ������ PULPIT � TEACHER �������� ������ �������� ������ � �������������� �� ���� ��������. 
-- �������������� ����� ������ ��������� ��� �������: ������� � �������������. ���� �� ������� ��� 
-- ��������������, �� � ������� ������������� ������ ���� �������� ������ ***. 
-- ����������: ������������ ���������� ������ LEFT OUTER JOIN � ������� isnull.
SELECT PULPIT.PULPIT_NAME,
	CASE
		WHEN(TEACHER.TEACHER_NAME IS NULL) then '***'
		ELSE TEACHER.TEACHER_NAME
		END [NAME]
	FROM PULPIT LEFT OUTER JOIN TEACHER
	ON PULPIT.PULPIT = TEACHER.PULPIT;

--5 ������ ��� ������� �������� �� �������, ��� ���������� FULL OUTER JOIN ���� ������ �������� ������������� ���������.
-- ������� ��� ����� �������: ������, ��������� �������� �������� ������ ����� (� �������� FULL OUTER JOIN) ������� � �� �������� ������ ������; 
-- ������, ��������� �������� �������� ������ ������ ������� � �� ���������� ������ �����; 
-- ������, ��������� �������� �������� ������ ������ ������� � ����� ������;
-- ������������ � �������� ��������� IS NULL � IS NOT NULL.

CREATE TABLE EXAMPLE_1 (    
	EXAMPLE_FIELD varchar(30) primary key,  
    EXP1 varchar(30)       
 )
CREATE TABLE EXAMPLE_2 (    
	EXAMPLE_FIELD varchar(30), --not null foreign key references EXAMPLE_1(EXAMPLE_FIELD),  
    EXP2 varchar(30) primary key
 )

insert into EXAMPLE_1   (EXAMPLE_FIELD,  EXP1 )   
	values ('1 Example1', 'EXP1'),
		   ('2 Example1', 'EXP1'),
		   ('3 Example1', 'EXP1'),
		   ('4 Example1', 'EXP1');

insert into EXAMPLE_2   (EXAMPLE_FIELD,  EXP2 )   
	values ('Example2', '1 EXP2'),
		   ('Example2', '2 EXP2'),
		   ('Example2', '3 EXP2'),
		   ('Example2', '4 EXP2');

-- ������, ��������� �������� �������� ������ ����� (� �������� FULL OUTER JOIN) ������� � �� �������� ������ ������; 
SELECT 
	CASE 
		WHEN(EXAMPLE_1.EXAMPLE_FIELD IS NOT NULL) THEN EXAMPLE_1.EXAMPLE_FIELD
		END [COLUMN1],
	CASE 
		WHEN(EXAMPLE_1.EXP1 IS NOT NULL) THEN EXAMPLE_1.EXP1
		END [COLUMN2]
  FROM EXAMPLE_1 FULL OUTER JOIN EXAMPLE_2 
		ON EXAMPLE_1.EXAMPLE_FIELD = EXAMPLE_2.EXAMPLE_FIELD
	WHERE EXAMPLE_1.EXAMPLE_FIELD IS NOT NULL;

-- ������, ��������� �������� �������� ������ ������ ������� � �� ���������� ������ �����; 
SELECT 
	CASE 
		WHEN(EXAMPLE_2.EXAMPLE_FIELD IS NOT NULL) THEN EXAMPLE_2.EXAMPLE_FIELD
		END [COLUMN1],
	CASE 
		WHEN(EXAMPLE_2.EXP2 IS NOT NULL) THEN EXAMPLE_2.EXP2
		END [COLUMN2]
  FROM EXAMPLE_1 FULL OUTER JOIN EXAMPLE_2 
		ON EXAMPLE_2.EXAMPLE_FIELD = EXAMPLE_1.EXAMPLE_FIELD
	WHERE EXAMPLE_2.EXAMPLE_FIELD IS NOT NULL;

-- ������, ��������� �������� �������� ������ ������ ������� � ����� ������;
SELECT * FROM EXAMPLE_1 FULL OUTER JOIN EXAMPLE_2 
		ON EXAMPLE_2.EXAMPLE_FIELD = EXAMPLE_1.EXAMPLE_FIELD

--6 ����������� SELECT-������ �� ������ CROSS JOIN-���������� ������ AUDITORIUM_TYPE � 
--  AUDITORIUM, ������������ ���������, ����������� ���������� ������� � ������� 1.
USE UNIVER;
SELECT AUDITORIUM_NAME, AUDITORIUM_TYPE.AUDITORIUM_TYPE FROM AUDITORIUM CROSS JOIN AUDITORIUM_TYPE 
	WHERE AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
	


--X_MyBase SCRIPTS
USE Puzikov_MyBase;
--1 ������� ����� ���� ����������� � �� ������ �������
SELECT BUYER_.Name_ AS NAME, ORDERS_.OrderNumber AS ORDER_ID  FROM ORDERS_ INNER JOIN BUYER_ ON ORDERS_.Telephone = BUYER_.Telephone;

--2 ������� ������ ������� � ����� ����������� ���������� � ����� ����� �
SELECT BUYER_.Name_ AS NAME, ORDERS_.OrderNumber AS ORDER_ID FROM ORDERS_ INNER JOIN BUYER_ 
	ON ORDERS_.Telephone = BUYER_.Telephone AND BUYER_.Name_ LIKE '%o%';

--3 


--4 �������������� ����� ������ ��������� ��� �������: ������� ���������� � �������� ��������. ���� �� ������� null
--  �� � ������� ������ ���� �������� ������ ***. 
USE Puzikov_MyBase;
SELECT ORDERS_.Telephone,
	CASE
		WHEN(Description_ IS NULL) then '***'
		ELSE Description_
		END [DESC]
	FROM PRODUCT_ LEFT OUTER JOIN ORDERS_
	ON PRODUCT_.ProductName = ORDERS_.ProductName;

--5

--6

USE Puzikov_MyBase;
SELECT BUYER_.Name_ AS NAME, ORDERS_.OrderNumber AS ORDER_ID  FROM ORDERS_ CROSS JOIN BUYER_ 
	WHERE ORDERS_.Telephone = BUYER_.Telephone;