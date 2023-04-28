--1. �� ������ ������ FACULTY, GROUPS, STUDENT � PROGRESS �����-������ SELECT-������, � ������� �������-�� �������������, 
--���������� � ������� ������ ��� ����� ��������� �� ���������� ���. 
--������������ ����������� �� ����� FACULTY, PROFESSION, SUBJECT.

--�������� � ������ ����������� ROLLUP � ���������������� ���������.
USE UNIVER;

SELECT GROUPS.PROFESSION AS [�������������], PROGRESS.SUBJECT [����������], AVG(PROGRESS.NOTE) [�� ����]--, FACULTY.FACULTY
  FROM STUDENT, GROUPS, PROGRESS, FACULTY
	WHERE FACULTY.FACULTY_NAME IN ('���������� ������������ �������')
	GROUP BY ROLLUP (GROUPS.PROFESSION, PROGRESS.SUBJECT, FACULTY.FACULTY)

--SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, AVG(PROGRESS.NOTE)
--  FROM STUDENT INNER JOIN GROUPS ON GROUPS.IDGROUP = STUDENT.IDGROUP 
--        INNER JOIN PROGRESS ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
--		INNER JOIN FACULTY ON FACULTY.FACULTY = GROUPS.FACULTY
--	WHERE FACULTY.FACULTY_NAME LIKE '���������� ������������ �������'
--	GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT, FACULTY.FACULTY

--2. ��������� SELECT-������ �� �. 1 � �������������� CUBE-�����������.

SELECT GROUPS.PROFESSION AS [�������������], PROGRESS.SUBJECT [����������], AVG(PROGRESS.NOTE) [�� ����]--, FACULTY.FACULTY
  FROM STUDENT, GROUPS, PROGRESS, FACULTY
	WHERE FACULTY.FACULTY_NAME IN ('���������� ������������ �������')
	GROUP BY CUBE (GROUPS.PROFESSION, PROGRESS.SUBJECT, FACULTY.FACULTY)

--3. �� ������ ������ GROUPS, STU-DENT � PROGRESS ����������� SELECT-������, � ������� ������������ ���������� ����� ���������.
--� ������� ������ ���������� ��������-�����, ����������, ������� ������ ������-��� �� ���������� ���.
--�������� ����������� ������, � ������� ������������ ���������� ����� ��������� �� ���������� ����.
--���������� ���������� ���� �������� � �������������� ���������� UNION � UN-ION ALL. ��������� ����������. 

SELECT GROUPS.PROFESSION AS [�������������], PROGRESS.SUBJECT [����������], AVG(PROGRESS.NOTE) [�� ����], GROUPS.FACULTY AS [���������]
  FROM STUDENT, GROUPS, PROGRESS
	WHERE GROUPS.FACULTY IN ('���')
	GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY
  UNION --ALL
SELECT GROUPS.PROFESSION AS [�������������], PROGRESS.SUBJECT [����������], AVG(PROGRESS.NOTE) [�� ����], GROUPS.FACULTY AS [���������]
  FROM STUDENT, GROUPS, PROGRESS
	WHERE GROUPS.FACULTY IN ('����')
	GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY
--4. �������� ����������� ���� �������� �����, ��������� � ���������� ���������� �������� ������ 3. ��������� ���������.
--������������ �������� INTERSECT.

SELECT GROUPS.PROFESSION AS [�������������], PROGRESS.SUBJECT [����������], AVG(PROGRESS.NOTE) [�� ����], GROUPS.FACULTY AS [���������]
  FROM STUDENT, GROUPS, PROGRESS
	WHERE GROUPS.FACULTY IN ('���')
	GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY
  INTERSECT 
SELECT GROUPS.PROFESSION AS [�������������], PROGRESS.SUBJECT [����������], AVG(PROGRESS.NOTE) [�� ����], GROUPS.FACULTY AS [���������]
  FROM STUDENT, GROUPS, PROGRESS
	WHERE GROUPS.FACULTY IN ('����') -- �������� �� ���
	GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY

--5. �������� ������� ����� ���������� �����, ��������� � ���������� �������� ������ 3. ��������� ���������. 
--������������ �������� EXCEPT.

SELECT GROUPS.PROFESSION AS [�������������], PROGRESS.SUBJECT [����������], AVG(PROGRESS.NOTE) [�� ����], GROUPS.FACULTY AS [���������]
  FROM STUDENT, GROUPS, PROGRESS
	WHERE GROUPS.FACULTY IN ('���')
	GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY
  EXCEPT 
SELECT GROUPS.PROFESSION AS [�������������], PROGRESS.SUBJECT [����������], AVG(PROGRESS.NOTE) [�� ����], GROUPS.FACULTY AS [���������]
  FROM STUDENT, GROUPS, PROGRESS
	WHERE GROUPS.FACULTY IN ('����') -- �������� �� ���
	GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY