--1. На основе таблиц FACULTY, GROUPS, STUDENT и PROGRESS разра-ботать SELECT-запрос, в котором выводят-ся специальность, 
--дисциплины и средние оценки при сдаче экзаменов на факультете ТОВ. 
--Использовать группировку по полям FACULTY, PROFESSION, SUBJECT.

--Добавить в запрос конструкцию ROLLUP и проанализировать результат.
USE UNIVER;

SELECT GROUPS.PROFESSION AS [Специальность], PROGRESS.SUBJECT [Дисциплина], AVG(PROGRESS.NOTE) [Ср балл]--, FACULTY.FACULTY
  FROM STUDENT, GROUPS, PROGRESS, FACULTY
	WHERE FACULTY.FACULTY_NAME IN ('Технология органических веществ')
	GROUP BY ROLLUP (GROUPS.PROFESSION, PROGRESS.SUBJECT, FACULTY.FACULTY)

--SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, AVG(PROGRESS.NOTE)
--  FROM STUDENT INNER JOIN GROUPS ON GROUPS.IDGROUP = STUDENT.IDGROUP 
--        INNER JOIN PROGRESS ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
--		INNER JOIN FACULTY ON FACULTY.FACULTY = GROUPS.FACULTY
--	WHERE FACULTY.FACULTY_NAME LIKE 'Технология органических веществ'
--	GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT, FACULTY.FACULTY

--2. Выполнить SELECT-запрос из п. 1 с использованием CUBE-группировки.

SELECT GROUPS.PROFESSION AS [Специальность], PROGRESS.SUBJECT [Дисциплина], AVG(PROGRESS.NOTE) [Ср балл]--, FACULTY.FACULTY
  FROM STUDENT, GROUPS, PROGRESS, FACULTY
	WHERE FACULTY.FACULTY_NAME IN ('Технология органических веществ')
	GROUP BY CUBE (GROUPS.PROFESSION, PROGRESS.SUBJECT, FACULTY.FACULTY)

--3. На основе таблиц GROUPS, STU-DENT и PROGRESS разработать SELECT-запрос, в котором определяются результаты сдачи экзаменов.
--В запросе должны отражаться специаль-ности, дисциплины, средние оценки студен-тов на факультете ТОВ.
--Отдельно разработать запрос, в котором определяются результаты сдачи экзаменов на факультете ХТиТ.
--Объединить результаты двух запросов с использованием операторов UNION и UN-ION ALL. Объяснить результаты. 

SELECT GROUPS.PROFESSION AS [Специальность], PROGRESS.SUBJECT [Дисциплина], AVG(PROGRESS.NOTE) [Ср балл], GROUPS.FACULTY AS [Факультет]
  FROM STUDENT, GROUPS, PROGRESS
	WHERE GROUPS.FACULTY IN ('ТОВ')
	GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY
  UNION --ALL
SELECT GROUPS.PROFESSION AS [Специальность], PROGRESS.SUBJECT [Дисциплина], AVG(PROGRESS.NOTE) [Ср балл], GROUPS.FACULTY AS [Факультет]
  FROM STUDENT, GROUPS, PROGRESS
	WHERE GROUPS.FACULTY IN ('ХТиТ')
	GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY
--4. Получить пересечение двух множеств строк, созданных в результате выполнения запросов пункта 3. Объяснить результат.
--Использовать оператор INTERSECT.

SELECT GROUPS.PROFESSION AS [Специальность], PROGRESS.SUBJECT [Дисциплина], AVG(PROGRESS.NOTE) [Ср балл], GROUPS.FACULTY AS [Факультет]
  FROM STUDENT, GROUPS, PROGRESS
	WHERE GROUPS.FACULTY IN ('ТОВ')
	GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY
  INTERSECT 
SELECT GROUPS.PROFESSION AS [Специальность], PROGRESS.SUBJECT [Дисциплина], AVG(PROGRESS.NOTE) [Ср балл], GROUPS.FACULTY AS [Факультет]
  FROM STUDENT, GROUPS, PROGRESS
	WHERE GROUPS.FACULTY IN ('ХТиТ') -- заменить на тов
	GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY

--5. Получить разницу между множеством строк, созданных в результате запросов пункта 3. Объяснить результат. 
--Использовать оператор EXCEPT.

SELECT GROUPS.PROFESSION AS [Специальность], PROGRESS.SUBJECT [Дисциплина], AVG(PROGRESS.NOTE) [Ср балл], GROUPS.FACULTY AS [Факультет]
  FROM STUDENT, GROUPS, PROGRESS
	WHERE GROUPS.FACULTY IN ('ТОВ')
	GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY
  EXCEPT 
SELECT GROUPS.PROFESSION AS [Специальность], PROGRESS.SUBJECT [Дисциплина], AVG(PROGRESS.NOTE) [Ср балл], GROUPS.FACULTY AS [Факультет]
  FROM STUDENT, GROUPS, PROGRESS
	WHERE GROUPS.FACULTY IN ('ХТиТ') -- заменить на тов
	GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY