-- 1. �� ������ ������ AUDITORIUM � AUDITORIUM_TYPE ����������� ������, ����������� ��� ������� ���� ��������� ������������, �����������,
-- ������� ����������� ���������, ��������� ���-�������� ���� ��������� � ����� ������-���� ��������� ������� ����. 
-- �������������� ����� ������ �����-���� ������� � ������������� ���� ����-����� � ������� � ������������ ������-����. 
-- ������������ ���������� ���������� ������, ������ GROUP BY � ���������� �������. 
USE UNIVER;

SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPE AS [Type], 
	AVG(AUDITORIUM.AUDITORIUM_CAPACITY) AS [Average], 
	MIN(AUDITORIUM_CAPACITY) AS [Min], 
	MAX(AUDITORIUM_CAPACITY) AS [Max]  FROM AUDITORIUM JOIN AUDITORIUM_TYPE 
		ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
		 GROUP BY AUDITORIUM_TYPE.AUDITORIUM_TYPE


-- 2. �� ������ ������ AUDITORIUM � AUDITORIUM_TYPE ����������� ������, ����������� ��� ������� ���� ��������� ������������, 
-- �����������, ������� ����������� ���������, ��������� ���-�������� ���� ��������� � ����� ������-���� ��������� ������� ����. 
-- �������������� ����� ������ �����-���� ������� � ������������� ���� ����-����� � ������� � ������������ ������-����. 
-- ������������ ���������� ���������� ������, ������ GROUP BY � ���������� �������. 

SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPE AS [Type], 
	AVG(AUDITORIUM.AUDITORIUM_CAPACITY) AS [Average], 
	MIN(AUDITORIUM_CAPACITY) AS [Min], 
	MAX(AUDITORIUM_CAPACITY) AS [Max],
	COUNT(AUDITORIUM.AUDITORIUM_TYPE) AS [Count],
	SUM(AUDITORIUM.AUDITORIUM_CAPACITY) AS [Sum capacity]
	FROM AUDITORIUM JOIN AUDITORIUM_TYPE 
		ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
		 GROUP BY AUDITORIUM_TYPE.AUDITORIUM_TYPE


--3. ����������� ������ �� ������ ������� PROGRESS, ������� ����� ��������� �������� ��������������� ������ � �� ��-�������� � �������� ���������. 
--���������� ����� ������ ������������-�� � �������, �������� �������� ������.
--������������ ��������� � ������ FROM, � ���������� ��������� GROUP BY � CASE. 

SELECT * FROM (SELECT CASE WHEN NOTE between 4 AND 6 then 'from 4 to 6'
			 WHEN NOTE between 6 AND 8 then 'from 6 to 8'
			 WHEN NOTE between 8 AND 10 then 'from 8 to 10'
			 else '< 4'
			 END [note],
			 COUNT (*) [Count]
		 FROM PROGRESS GROUP BY
			 CASE WHEN NOTE between 4 AND 6 then 'from 4 to 6'
			 WHEN NOTE between 6 AND 8 then 'from 6 to 8'
			 WHEN NOTE between 8 AND 10 then 'from 8 to 10'
			 else '< 4'
			 END) AS [s]
	ORDER BY NOTE desc

--4. ����������� SELECT-������� �� ����-�� ������ FACULTY, GROUPS, STUDENT � PROGRESS, ������� �������� 
--������� ��������������� ������ ��� ������� ����� ������ ������������� � ��-��������. ������ �������������
--� ������� �����-��� ������� ������. ������� ������ ������ �������������� � ��������� �� ���� ������ ����� �������.
--������������ ���������� ���������� ������, ���������� ������� AVG � �����-����� ������� CAST � ROUND.

SELECT ROUND(AVG( CAST(PROGRESS.NOTE AS float(4))), 2) AS [Avg note], FACULTY.FACULTY_NAME, GROUPS.PROFESSION, GROUPS.YEAR_FIRST
  FROM PROGRESS INNER JOIN STUDENT ON  PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
	INNER JOIN GROUPS ON GROUPS.IDGROUP = STUDENT.IDGROUP 
	INNER JOIN FACULTY ON FACULTY.FACULTY = GROUPS.FACULTY
	GROUP BY GROUPS.PROFESSION,
			 GROUPS.YEAR_FIRST,
			 FACULTY_NAME
	ORDER BY [Avg note] desc 

--5. ���������� SELECT-������, �������-������ � ������� 4, ��� ����� � ������� �������� �������� 
--������ �������������� ������ ������ �� ����������� � ������ �� � ����. ������������ WHERE.

SELECT ROUND(AVG( CAST(PROGRESS.NOTE AS float(4))), 2) AS [Avg note], FACULTY.FACULTY_NAME, GROUPS.PROFESSION, GROUPS.YEAR_FIRST, PROGRESS.SUBJECT 
  FROM PROGRESS INNER JOIN STUDENT ON  PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
	INNER JOIN GROUPS ON GROUPS.IDGROUP = STUDENT.IDGROUP 
	INNER JOIN FACULTY ON FACULTY.FACULTY = GROUPS.FACULTY
	WHERE PROGRESS.SUBJECT IN ('��','����')
	GROUP BY GROUPS.PROFESSION,
			 GROUPS.YEAR_FIRST,
			 FACULTY_NAME,
			 PROGRESS.SUBJECT
	ORDER BY [Avg note] desc 


--6. �� ������ ������ FACULTY, GROUPS, STUDENT � PROGRESS �����-������ ������, � �������
--��������� �����-��������, ���������� � ������� ������ ��� ����� ��������� �� ���������� ���.

SELECT PROGRESS.SUBJECT, GROUPS.PROFESSION, AVG(PROGRESS.NOTE) AS [Avg note] 
FROM PROGRESS, STUDENT, GROUPS, FACULTY
	WHERE FACULTY.FACULTY IN ('���')
	GROUP BY PROGRESS.SUBJECT,
			 GROUPS.PROFESSION

--7. �� ������ ������� PROGRESS ����-������ ��� ������ ���������� ���������� ���������, ���������� ������ 8 � 9. 
--������������ �����������, ������ HAVING, ����������. 

SELECT PROGRESS.SUBJECT, COUNT(PROGRESS.IDSTUDENT) AS [Count stud]FROM PROGRESS
	GROUP BY PROGRESS.SUBJECT, PROGRESS.NOTE
	HAVING PROGRESS.NOTE BETWEEN 8 AND 9 

			 
