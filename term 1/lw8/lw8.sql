USE UNIVER;

--1. ����������� ������������� � ������ ���-����������. ������������� ������ ���� ��-������� �� ������ SELECT-������� 
--� ������� TEACHER � ��������� ��������� �������: ���, ��� �������������, ���, ��� �������. 

CREATE VIEW [�������������] AS 
  SELECT TEACHER.TEACHER_NAME AS [���],
	   TEACHER.GENDER AS [���],
	   TEACHER.PULPIT AS [��� �������],
	   TEACHER.TEACHER AS [���] FROM TEACHER;

--2. ����������� � ������� ������������� � ������ ���������� ������. ������������� ������ ���� ��������� �� ������ 
--SELECT-������� � �������� FACULTY � PULPIT. ������������� ������ ��������� ������-��� �������: ���������, 
--���������� ������ (����������� �� ������ ����� ������� PULPIT). 

CREATE VIEW [���������� ������] AS 
  SELECT FACULTY.FACULTY_NAME AS [���������], COUNT(PULPIT.PULPIT) AS [���������� ������] 
    FROM PULPIT INNER JOIN FACULTY ON PULPIT.FACULTY = FACULTY.FACULTY
	GROUP BY FACULTY.FACULTY_NAME

--3. ����������� � ������� ������������� � ������ ���������. ������������� ������ ���� ��������� �� ������ 
--������� AUDITO-RIUM � ��������� �������: ���, ���������-��� ���������. ������������� ������ ���������� 
--������ ���������� ��������� (� ������� AUDITO-RIUM_ TYPE ������, ������������ � �����-�� ��) � ��������� 
--���������� ��������� IN-SERT, UPDATE � DELETE. --NO: AVG COUNT .. UNION GROUP BY ���� �������

CREATE VIEW [���������] AS
  SELECT AUDITORIUM AS [���], AUDITORIUM_NAME AS [���] FROM AUDITORIUM
	WHERE AUDITORIUM_TYPE LIKE '��%' 

--4. ����������� � ������� ������������� � ������ ����������_���������. 
--������������� ������ ���� ��������� �� ������ SELECT-������� � ������� AUDITO-RIUM � ��������� ��������� �������: ���, ������������ ���������. 
--������������� ������ ���������� ������ ���������� ��������� (� ������� AUDITO-RIUM_TYPE ������, ������������ � �����-��� ��). 

CREATE VIEW [����������_���������] AS
  SELECT AUDITORIUM AS [���], AUDITORIUM_NAME AS [���] FROM AUDITORIUM
    WHERE AUDITORIUM_TYPE LIKE '��%'

--5. ����������� ������������� � ������ ���-�������. ������������� ������ ���� ��-������� �� ������ SELECT-������� 
--� ������� SUBJECT, ���������� ��� ���������� � ��-�������� ������� � ��������� ��������� �������: ���,
--������������ ���������� � ��� �������. ������������ TOP � ORDER BY.

CREATE VIEW [����������] AS
  SELECT TOP 5 SUBJECT AS [���], SUBJECT_NAME AS [������������], PULPIT AS [��� �������] FROM SUBJECT
    ORDER BY SUBJECT_NAME -- ����� 26 ���������

--6. �������� ������������� ������-����_������, ��������� � ������� 2 ���, ����� ��� ���� ��������� � ������� ��������.
--������������������ �������� ����������-��� ������������� � ������� ��������. ������������ ����� SCHEMABINDING. 


ALTER VIEW [���������� ������] WITH SCHEMABINDING AS
  SELECT FACULTY.FACULTY_NAME AS [���������], COUNT(PULPIT.PULPIT) AS [���������� ������] 
    FROM dbo.PULPIT INNER JOIN dbo.FACULTY ON PULPIT.FACULTY = FACULTY.FACULTY
	GROUP BY FACULTY.FACULTY_NAME