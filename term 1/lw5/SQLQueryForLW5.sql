-- 1. �� ������ ������ FACULTY, PULPIT � PROFESSION ������������ ������ ������������ ������, ������� ��������� 
-- �� ����������, �������������� ���������� �� �������������, � ������������ �������� ���������� ����� ���������� 
-- ��� ����������. ������������ � ������ WHERE �������� IN c ����������������� ����������� � ������� PROFESSION. 
USE UNIVER;
SELECT PULPIT.PULPIT_NAME AS [������������ �������], FACULTY.FACULTY_NAME AS [������������ ����������] FROM PULPIT, FACULTY INNER JOIN PROFESSION 
ON FACULTY.FACULTY = PROFESSION.FACULTY
	WHERE PULPIT.FACULTY = FACULTY.FACULTY AND
		PROFESSION.PROFESSION_NAME in (SELECT PROFESSION.PROFESSION_NAME FROM PROFESSION
					WHERE (PROFESSION.PROFESSION_NAME LIKE '%����������%') OR 
						  (PROFESSION.PROFESSION_NAME LIKE '%����������%'))

-- 2. ���������� ������ ������ 1 ����� �������, ����� ��� �� ��������� ��� ������� � ����������� INNER JOIN ������ 
-- FROM �������� �������. ��� ���� ��������� ���������� ������� ������ ���� ����������� ���������� ��������� �������. 

USE UNIVER;
SELECT PULPIT.PULPIT_NAME AS [������������ �������], FACULTY.FACULTY_NAME AS [������������ ����������] 
  FROM FACULTY INNER JOIN PULPIT
	ON FACULTY.FACULTY = PULPIT.FACULTY
		INNER JOIN PROFESSION ON PROFESSION.FACULTY = FACULTY.FACULTY
					WHERE (PROFESSION.PROFESSION_NAME LIKE '%����������%') OR 
						  (PROFESSION.PROFESSION_NAME LIKE '%����������%')



-- 3. ���������� ������, ����������� 1 ����� ��� ������������� ����������. ����������: ������������ ���������� INNER JOIN ���� ������. 					

USE UNIVER;
SELECT PULPIT.PULPIT_NAME AS [������������ �������], FACULTY.FACULTY_NAME AS [������������ ����������] FROM PULPIT, FACULTY INNER JOIN PROFESSION 
ON FACULTY.FACULTY = PROFESSION.FACULTY
	WHERE PULPIT.FACULTY = FACULTY.FACULTY AND
		(PROFESSION.PROFESSION_NAME LIKE '%����������%' OR 
		PROFESSION.PROFESSION_NAME LIKE '%����������%')


-- 4. �� ������ ������� AUDITORIUM ������������ ������ ��������� ����� ������� ������������ ��� ������� ���� ���������. ��� ����
-- ��������� ������� ������������� � ������� �������� �����������. ����������: ������������ ������������� ��������� c �������� TOP � ORDER BY. 

USE UNIVER;
SELECT AUDITORIUM.AUDITORIUM_NAME AS [��������], AUDITORIUM.AUDITORIUM_CAPACITY AS [�����������], AUDITORIUM.AUDITORIUM_TYPE AS [���] FROM AUDITORIUM
	WHERE AUDITORIUM.AUDITORIUM_CAPACITY = (SELECT TOP(1) AUDITORIUM.AUDITORIUM_CAPACITY FROM AUDITORIUM
		WHERE AUDITORIUM.AUDITORIUM_CAPACITY = AUDITORIUM.AUDITORIUM_CAPACITY
		ORDER BY AUDITORIUM.AUDITORIUM_TYPE DESC)

-- 5. �� ������ ������ FACULTY � PULPIT ������������ ������ ������������ ����������� �� ������� ��� �� ����� ������� (������� PULPIT). 
-- ������������ �������� EXISTS � ��������������� ���������. 

USE UNIVER;
SELECT FACULTY.FACULTY_NAME AS [������������ ����������] FROM FACULTY
	WHERE NOT EXISTS (SELECT * FROM PULPIT
		WHERE PULPIT.FACULTY = FACULTY.FACULTY) -- ����� ��� ��� � �����



-- 6. �� ������ ������� PROGRESS ������������ ������, ���������� ������� �������� ������ (������� NOTE) �� �����������,
-- ������� ��������� ����: ����, �� � ����. ����������: ������������ ��� ����������������� ���������� � ������ SELECT; 
-- � ����������� ��������� ���������� ������� AVG. 

USE UNIVER;
SELECT TOP 1 
	(SELECT AVG(NOTE) FROM PROGRESS
		WHERE PROGRESS.SUBJECT LIKE '����')[����],
	(SELECT AVG(NOTE) FROM PROGRESS
		WHERE PROGRESS.SUBJECT LIKE '��')[��],
	(SELECT AVG(NOTE) FROM PROGRESS
		WHERE PROGRESS.SUBJECT LIKE '����')[����]
FROM PROGRESS



-- 7. ����������� SELECT-������, ��������������� ������ ���������� ALL ��������� � �����������
USE UNIVER;
SELECT PROGRESS.NOTE, PROGRESS.SUBJECT FROM PROGRESS 
	WHERE NOTE >=ALL(SELECT PROGRESS.NOTE FROM PROGRESS
		WHERE PROGRESS.SUBJECT LIKE '����')



-- 8. ����������� SELECT-������, ��������������� ������� ���������� ANY ��������� � �����������.

-- ���������� ������������ �������, ���� ������� ������� ��������� ���� �� ���� �������� 
-- ���� ������� �������, ������������ ������� ���������� �� ����� ��:
USE Puzikov_MyBase;
SELECT PRODUCT_.ProductName, PRODUCT_.Price FROM PRODUCT_
	WHERE PRODUCT_.Price >=ANY (SELECT	PRODUCT_.Price FROM PRODUCT_
		WHERE PRODUCT_.ProductName LIKE 'M%'); 







































		-- PAA_MyBase
-- 1 �� ������ ������ ORDERS , BUYER , PRODUCT ������������ ������ ������������ �������, ������� ��������� ������� � ������,
-- � ����������� ������� � ����� ����������� Alex
USE Puzikov_MyBase;
SELECT PRODUCT_.ProductName AS [������������ ������], BUYER_.Name_ AS [��� ����������] FROM PRODUCT_, BUYER_ INNER JOIN ORDERS_ 
ON ORDERS_.Telephone = BUYER_.Telephone
	WHERE PRODUCT_.ProductName = ORDERS_.ProductName AND
		BUYER_.Name_ in (SELECT BUYER_.Name_ FROM BUYER_
					WHERE (BUYER_.Name_ LIKE '%Alex%'))

-- PAA_MyBase
-- 2 ���� ����� ������ � INNER JOIN ������ FROM �������� �������
USE Puzikov_MyBase;
SELECT PRODUCT_.ProductName AS [������������ ������], BUYER_.Name_ AS [��� ����������] 
	FROM PRODUCT_ INNER JOIN ORDERS_
	ON PRODUCT_.ProductName = ORDERS_.ProductName
		INNER JOIN BUYER_ 
		ON ORDERS_.Telephone = BUYER_.Telephone
			WHERE PRODUCT_.ProductName = ORDERS_.ProductName AND BUYER_.Name_ in (SELECT BUYER_.Name_ FROM BUYER_
					WHERE (BUYER_.Name_ LIKE '%Alex%'))


					-- PAA_MyBase
-- �� ������ ������ ORDERS � PRODUCT ������������ ������ ����� ������� �� �� �������� � ������� ��� ��������.

USE Puzikov_MyBase;
SELECT ORDERS_.OrderNumber AS [����� ������] FROM ORDERS_ -------- ??????????????????????????????//////
	WHERE NOT EXISTS (SELECT * FROM PRODUCT_
		WHERE PRODUCT_.ProductName = ORDERS_.ProductName)



		--PAA_MyBase
-- �������� ����� ��������� ������� ��� ��� � ��� � ����

USE Puzikov_MyBase;
SELECT TOP 1 
	(SELECT COUNT(ORDERS_.OrderNumber) FROM ORDERS_ 
		WHERE DateOfTheTransaction LIKE '%2022-05%')[2022-05],
	(SELECT COUNT(ORDERS_.OrderNumber) FROM ORDERS_ 
		WHERE DateOfTheTransaction LIKE '%2022-06%')[2022-02]
FROM ORDERS_


-- ������������ �������, ���� ������� ������� ��������� ��� ����� ��������� ��� �������, 
-- ������������ ������� ���������� �� ����� ��:
USE Puzikov_MyBase;
SELECT PRODUCT_.ProductName, PRODUCT_.Price FROM PRODUCT_
	WHERE PRODUCT_.Price >=ALL (SELECT	PRODUCT_.Price FROM PRODUCT_
		WHERE PRODUCT_.ProductName LIKE 'C%');