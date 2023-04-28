--1 На основе таблиц AUDITORIUM_ TYPE и AUDITORIUM сформировать перечень кодов аудиторий и 
-- соответствующих им наименований типов аудиторий. Использовать соединение таблиц INNER JOIN. 
USE UNIVER;
SELECT AUDITORIUM_NAME AS [Name],, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME FROM AUDITORIUM INNER JOIN AUDITORIUM_TYPE 
	ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE;

--2 На основе таблиц AUDITORIUM_TYPE и AUDITORIUM сформировать перечень кодов аудиторий и соответствующих
-- им наименований типов аудиторий, выбрав только те аудитории, в наименовании которых присутствует 
-- подстрока компьютер. Использовать соединение таблиц INNER JOIN и предикат LIKE. 
USE UNIVER;
SELECT AUDITORIUM_TYPENAME, AUDITORIUM_TYPE.AUDITORIUM_TYPE FROM AUDITORIUM INNER JOIN AUDITORIUM_TYPE 
	ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
	WHERE AUDITORIUM_TYPENAME LIKE '%компьютер%';

--3 На основе таблиц PRORGESS, STUDENT, GROUPS, SUBJECT, PULPIT и FACULTY сформировать перечень студентов,
-- получивших экзаменационные оценки от 6 до 8. Результирующий набор должен содержать столбцы: Факультет, 
-- Кафедра, Специальность, Дисциплина, Имя Студента, Оценка. В столбце Оценка должны быть записаны экзаменационные
-- оценки прописью: шесть, семь, восемь. Результат отсортировать в порядке убывания по столбцу PROGRESS.NOTE.
-- Использовать соединение INNER JOIN, предикат BETWEEN и выражение CASE.
USE UNIVER
SELECT  FACULTY.FACULTY AS [Факультет], PULPIT.PULPIT[Кафедра], STUDENT.NAME[Имя студента], GROUPS.PROFESSION[Специальность], SUBJECT.SUBJECT[Дисциплина],
	CASE 
		WHEN NOTE = 6 THEN 'шесть'
		WHEN NOTE = 7 THEN 'семь'
		WHEN NOTE = 8 THEN 'восемь'
	END [Оценка]
		FROM PROGRESS 
		Inner Join STUDENT ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		Inner Join GROUPS ON STUDENT.IDGROUP = GROUPS.IDGROUP
		Inner Join SUBJECT ON PROGRESS.SUBJECT = SUBJECT.SUBJECT
		Inner Join FACULTY ON GROUPS.FACULTY = FACULTY.FACULTY
		Inner Join PULPIT ON SUBJECT.PULPIT = PULPIT.PULPIT
		WHERE Note BETWEEN 6 AND 8
		ORDER BY PROGRESS.NOTE desc, FACULTY.FACULTY, PULPIT.PULPIT, GROUPS.PROFESSION, STUDENT.NAME
	--?

--4 На основе таблиц PULPIT и TEACHER получить полный перечень кафедр и преподавателей на этих кафедрах. 
-- Результирующий набор должен содержать два столбца: Кафедра и Преподаватель. Если на кафедре нет 
-- преподавателей, то в столбце Преподаватель должна быть выведена строка ***. 
-- Примечание: использовать соединение таблиц LEFT OUTER JOIN и функцию isnull.
SELECT PULPIT.PULPIT_NAME,
	CASE
		WHEN(TEACHER.TEACHER_NAME IS NULL) then '***'
		ELSE TEACHER.TEACHER_NAME
		END [NAME]
	FROM PULPIT LEFT OUTER JOIN TEACHER
	ON PULPIT.PULPIT = TEACHER.PULPIT;

--5 Создав две таблицы показать на примере, что соединение FULL OUTER JOIN двух таблиц является коммутативной операцией.
-- Создать три новых запроса: запрос, результат которого содержит данные левой (в операции FULL OUTER JOIN) таблицы и не содержит данные правой; 
-- запрос, результат которого содержит данные правой таблицы и не содержащие данные левой; 
-- запрос, результат которого содержит данные правой таблицы и левой таблиц;
-- Использовать в запросах выражение IS NULL и IS NOT NULL.

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

-- запрос, результат которого содержит данные левой (в операции FULL OUTER JOIN) таблицы и не содержит данные правой; 
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

-- запрос, результат которого содержит данные правой таблицы и не содержащие данные левой; 
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

-- запрос, результат которого содержит данные правой таблицы и левой таблиц;
SELECT * FROM EXAMPLE_1 FULL OUTER JOIN EXAMPLE_2 
		ON EXAMPLE_2.EXAMPLE_FIELD = EXAMPLE_1.EXAMPLE_FIELD

--6 Разработать SELECT-запрос на основе CROSS JOIN-соединения таблиц AUDITORIUM_TYPE и 
--  AUDITORIUM, формирующего результат, аналогичный результату запроса в задании 1.
USE UNIVER;
SELECT AUDITORIUM_NAME, AUDITORIUM_TYPE.AUDITORIUM_TYPE FROM AUDITORIUM CROSS JOIN AUDITORIUM_TYPE 
	WHERE AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
	


--X_MyBase SCRIPTS
USE Puzikov_MyBase;
--1 Извлечь имена всех покупателей и их номера заказов
SELECT BUYER_.Name_ AS NAME, ORDERS_.OrderNumber AS ORDER_ID  FROM ORDERS_ INNER JOIN BUYER_ ON ORDERS_.Telephone = BUYER_.Telephone;

--2 Извлечь номера заказов и имена покупателей содержащих в имени букву о
SELECT BUYER_.Name_ AS NAME, ORDERS_.OrderNumber AS ORDER_ID FROM ORDERS_ INNER JOIN BUYER_ 
	ON ORDERS_.Telephone = BUYER_.Telephone AND BUYER_.Name_ LIKE '%o%';

--3 


--4 Результирующий набор должен содержать два столбца: ТЕлефон покупателя и Описание продукта. Если на кафедре null
--  то в столбце должна быть выведена строка ***. 
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