-- 1. На основе таблиц AUDITORIUM и AUDITORIUM_TYPE разработать запрос, вычисляющий для каждого типа аудиторий максимальную, минимальную,
-- среднюю вместимость аудиторий, суммарную вме-стимость всех аудиторий и общее количе-ство аудиторий данного типа. 
-- Результирующий набор должен содер-жать столбец с наименованием типа ауди-торий и столбцы с вычисленными величи-нами. 
-- Использовать внутреннее соединение таблиц, секцию GROUP BY и агрегатные функции. 
USE UNIVER;

SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPE AS [Type], 
	AVG(AUDITORIUM.AUDITORIUM_CAPACITY) AS [Average], 
	MIN(AUDITORIUM_CAPACITY) AS [Min], 
	MAX(AUDITORIUM_CAPACITY) AS [Max]  FROM AUDITORIUM JOIN AUDITORIUM_TYPE 
		ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
		 GROUP BY AUDITORIUM_TYPE.AUDITORIUM_TYPE


-- 2. На основе таблиц AUDITORIUM и AUDITORIUM_TYPE разработать запрос, вычисляющий для каждого типа аудиторий максимальную, 
-- минимальную, среднюю вместимость аудиторий, суммарную вме-стимость всех аудиторий и общее количе-ство аудиторий данного типа. 
-- Результирующий набор должен содер-жать столбец с наименованием типа ауди-торий и столбцы с вычисленными величи-нами. 
-- Использовать внутреннее соединение таблиц, секцию GROUP BY и агрегатные функции. 

SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPE AS [Type], 
	AVG(AUDITORIUM.AUDITORIUM_CAPACITY) AS [Average], 
	MIN(AUDITORIUM_CAPACITY) AS [Min], 
	MAX(AUDITORIUM_CAPACITY) AS [Max],
	COUNT(AUDITORIUM.AUDITORIUM_TYPE) AS [Count],
	SUM(AUDITORIUM.AUDITORIUM_CAPACITY) AS [Sum capacity]
	FROM AUDITORIUM JOIN AUDITORIUM_TYPE 
		ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
		 GROUP BY AUDITORIUM_TYPE.AUDITORIUM_TYPE


--3. Разработать запрос на основе таблицы PROGRESS, который будет содержать значения экзаменационных оценок и их ко-личество в заданном интервале. 
--Сортировка строк должна осуществлять-ся в порядке, обратном величине оценки.
--Использовать подзапрос в секции FROM, в подзапросе применить GROUP BY и CASE. 

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

--4. Разработать SELECT-запроса на осно-ве таблиц FACULTY, GROUPS, STUDENT и PROGRESS, который содержит 
--среднюю экзаменационную оценку для каждого курса каждой специальности и фа-культета. Строки отсортировать
--в порядке убыва-ния средней оценки. Средняя оценка должна рассчитываться с точностью до двух знаков после запятой.
--Использовать внутреннее соединение таблиц, агрегатную функцию AVG и встро-енные функции CAST и ROUND.

SELECT ROUND(AVG( CAST(PROGRESS.NOTE AS float(4))), 2) AS [Avg note], FACULTY.FACULTY_NAME, GROUPS.PROFESSION, GROUPS.YEAR_FIRST
  FROM PROGRESS INNER JOIN STUDENT ON  PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
	INNER JOIN GROUPS ON GROUPS.IDGROUP = STUDENT.IDGROUP 
	INNER JOIN FACULTY ON FACULTY.FACULTY = GROUPS.FACULTY
	GROUP BY GROUPS.PROFESSION,
			 GROUPS.YEAR_FIRST,
			 FACULTY_NAME
	ORDER BY [Avg note] desc 

--5. Переписать SELECT-запрос, разрабо-танный в задании 4, так чтобы в расчете среднего значения 
--оценок использовались оценки только по дисциплинам с кодами БД и ОАиП. Использовать WHERE.

SELECT ROUND(AVG( CAST(PROGRESS.NOTE AS float(4))), 2) AS [Avg note], FACULTY.FACULTY_NAME, GROUPS.PROFESSION, GROUPS.YEAR_FIRST, PROGRESS.SUBJECT 
  FROM PROGRESS INNER JOIN STUDENT ON  PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
	INNER JOIN GROUPS ON GROUPS.IDGROUP = STUDENT.IDGROUP 
	INNER JOIN FACULTY ON FACULTY.FACULTY = GROUPS.FACULTY
	WHERE PROGRESS.SUBJECT IN ('БД','ОАиП')
	GROUP BY GROUPS.PROFESSION,
			 GROUPS.YEAR_FIRST,
			 FACULTY_NAME,
			 PROGRESS.SUBJECT
	ORDER BY [Avg note] desc 


--6. На основе таблиц FACULTY, GROUPS, STUDENT и PROGRESS разра-ботать запрос, в котором
--выводятся специ-альность, дисциплины и средние оценки при сдаче экзаменов на факультете ТОВ.

SELECT PROGRESS.SUBJECT, GROUPS.PROFESSION, AVG(PROGRESS.NOTE) AS [Avg note] 
FROM PROGRESS, STUDENT, GROUPS, FACULTY
	WHERE FACULTY.FACULTY IN ('ТОВ')
	GROUP BY PROGRESS.SUBJECT,
			 GROUPS.PROFESSION

--7. На основе таблицы PROGRESS опре-делить для каждой дисциплины количество студентов, получивших оценки 8 и 9. 
--Использовать группировку, секцию HAVING, сортировку. 

SELECT PROGRESS.SUBJECT, COUNT(PROGRESS.IDSTUDENT) AS [Count stud]FROM PROGRESS
	GROUP BY PROGRESS.SUBJECT, PROGRESS.NOTE
	HAVING PROGRESS.NOTE BETWEEN 8 AND 9 

			 
