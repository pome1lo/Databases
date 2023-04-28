USE UNIVER;

--1. Разработать представление с именем Пре-подаватель. Представление должно быть по-строено на основе SELECT-запроса 
--к таблице TEACHER и содержать следующие столбцы: код, имя преподавателя, пол, код кафедры. 

CREATE VIEW [Преподаватель] AS 
  SELECT TEACHER.TEACHER_NAME AS [Имя],
	   TEACHER.GENDER AS [Пол],
	   TEACHER.PULPIT AS [Код кафедры],
	   TEACHER.TEACHER AS [Код] FROM TEACHER;

--2. Разработать и создать представление с именем Количество кафедр. Представление должно быть построено на основе 
--SELECT-запроса к таблицам FACULTY и PULPIT. Представление должно содержать следую-щие столбцы: факультет, 
--количество кафедр (вычисляется на основе строк таблицы PULPIT). 

CREATE VIEW [Количество кафедр] AS 
  SELECT FACULTY.FACULTY_NAME AS [Факультет], COUNT(PULPIT.PULPIT) AS [Количество кафедр] 
    FROM PULPIT INNER JOIN FACULTY ON PULPIT.FACULTY = FACULTY.FACULTY
	GROUP BY FACULTY.FACULTY_NAME

--3. Разработать и создать представление с именем Аудитории. Представление должно быть построено на основе 
--таблицы AUDITO-RIUM и содержать столбцы: код, наименова-ние аудитории. Представление должно отображать 
--только лекционные аудитории (в столбце AUDITO-RIUM_ TYPE строка, начинающаяся с симво-ла ЛК) и допускать 
--выполнение оператора IN-SERT, UPDATE и DELETE. --NO: AVG COUNT .. UNION GROUP BY одна таблица

CREATE VIEW [Аудитории] AS
  SELECT AUDITORIUM AS [Код], AUDITORIUM_NAME AS [Имя] FROM AUDITORIUM
	WHERE AUDITORIUM_TYPE LIKE 'ЛК%' 

--4. Разработать и создать представление с именем Лекционные_аудитории. 
--Представление должно быть построено на основе SELECT-запроса к таблице AUDITO-RIUM и содержать следующие столбцы: код, наименование аудитории. 
--Представление должно отображать только лекционные аудитории (в столбце AUDITO-RIUM_TYPE строка, начинающаяся с симво-лов ЛК). 

CREATE VIEW [Лекционные_аудитории] AS
  SELECT AUDITORIUM AS [Код], AUDITORIUM_NAME AS [Имя] FROM AUDITORIUM
    WHERE AUDITORIUM_TYPE LIKE 'ЛК%'

--5. Разработать представление с именем Дис-циплины. Представление должно быть по-строено на основе SELECT-запроса 
--к таблице SUBJECT, отображать все дисциплины в ал-фавитном порядке и содержать следующие столбцы: код,
--наименование дисциплины и код кафедры. Использовать TOP и ORDER BY.

CREATE VIEW [Дисциплины] AS
  SELECT TOP 5 SUBJECT AS [Код], SUBJECT_NAME AS [Наименование], PULPIT AS [Код кафедры] FROM SUBJECT
    ORDER BY SUBJECT_NAME -- всего 26 дисциплин

--6. Изменить представление Количе-ство_кафедр, созданное в задании 2 так, чтобы оно было привязано к базовым таблицам.
--Продемонстрировать свойство привязанно-сти представления к базовым таблицам. Использовать опцию SCHEMABINDING. 


ALTER VIEW [Количество кафедр] WITH SCHEMABINDING AS
  SELECT FACULTY.FACULTY_NAME AS [Факультет], COUNT(PULPIT.PULPIT) AS [Количество кафедр] 
    FROM dbo.PULPIT INNER JOIN dbo.FACULTY ON PULPIT.FACULTY = FACULTY.FACULTY
	GROUP BY FACULTY.FACULTY_NAME