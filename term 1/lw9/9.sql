--1. Разработать скрипт, в котором: 
-- объявить переменные типа char, varchar, datetime, time, int, smallint, tinint, numeric(12, 5); 
-- первые две переменные проинициа-лизировать в операторе объявления;
-- присвоить произвольные значения переменным с помощью операторов SET и SELECT; 
-- значения одних переменных выве-сти с помощью оператора SELECT, зна-чения других переменных распечатать с помощью оператора PRINT. 
--Проанализировать результаты.


DECLARE @var1 char = 's', 
		@var2 varchar = 'Q',
		@var3 datetime,
		@var4 time,
		@var5 int,
		@var6 smallint,
		@var7 tinyint,
		@var8 numeric(12,5),
		@var9 int;

SET @var5 = 5;

SELECT @var1 = 'q', @var2 = 's', @var5 = 5;
PRINT @var5;

--2. Разработать скрипт, в котором определяется общая вместимость ауди-торий.
--Если общая вместимость превышает 200, то вывести количество аудиторий, среднюю вместимость аудиторий, 
--коли-чество аудиторий, вместимость которых меньше средней, и процент таких ауди-торий. 
--Если общая вместимость аудиторий меньше 200, то вывести сообщение о размере общей вместимости.
USE UNIVER;

DECLARE @result int = (SELECT SUM(AUDITORIUM_CAPACITY) AS [Average]
	FROM AUDITORIUM)
IF @result > 400 
	begin
		DECLARE @quanity int = (SELECT COUNT(*) FROM AUDITORIUM);
		PRINT 'количество аудиторий: ' + convert(varchar, @quanity);
		DECLARE @avgCapacity int = (SELECT AVG(AUDITORIUM_CAPACITY) FROM AUDITORIUM)
		PRINT 'средняя вместимость аудиторий: ' + convert(varchar, @result);
		DECLARE @count int = 
		(
		SELECT COUNT(AUDITORIUM) FROM AUDITORIUM
			WHERE AUDITORIUM_CAPACITY < @avgCapacity
		)
		DECLARE @test int = @count * 100 / @quanity;
		PRINT 'процент: ' + convert(varchar, @test);
	end;
	begin
		PRINT 'общая вместимость аудиторий: ' + convert(varchar, @result);
	end;
--3.	Разработать T-SQL-скрипт, ко-торый выводит на печать глобальные переменные: 
-- @@ROWCOUNT (число обрабо-танных строк); 
-- @@VERSION (версия SQL Server);
-- @@SPID (возвращает системный идентификатор процесса, назначен-ный сервером текущему подключе-нию); 
-- @@ERROR (код последней ошибки); 
-- @@SERVERNAME (имя сервера); 
-- @@TRANCOUNT (возвращает уровень вложенности транзакции); 
-- @@FETCH_STATUS (проверка ре-зультата считывания строк результи-рующего набора); 
-- @@NESTLEVEL (уровень вложен-ности текущей процедуры).
--Проанализировать результат.
PRINT 'число обработанных строк ' + convert(varchar, @@ROWCOUNT);
PRINT 'версия SQL Server ' + convert(varchar, @@VERSION);
PRINT 'системный идентификатор процесса, назначен-ный сервером текущему подключе-нию ' + convert(varchar, @@SPID);
PRINT 'код последней ошибки ' + convert(varchar, @@ERROR);
PRINT 'имя сервера ' + convert(varchar, @@SERVERNAME);
PRINT 'уровень вложенности транзакции ' + convert(varchar, @@TRANCOUNT);
PRINT 'проверка результата считывания строк результи-рующего набора ' + convert(varchar, @@FETCH_STATUS);
PRINT 'уровень вложенности текущей процедуры ' + convert(varchar, @@NESTLEVEL);


--4. Разработать T-SQL-скрипты, вы-полняющие: 

-- рисунок 
--для различных значений исходных дан-ных;
-- преобразование полного ФИО сту-дента в сокращенное (например, Макей-чик Татьяна Леонидовна в Макейчик Т. Л.);
-- поиск студентов, у которых день рождения в следующем месяце, и опре-деление их возраста;
-- поиск дня недели, в который сту-денты некоторой группы сдавали экза-мен по БД.

-- вычисление значений переменной z 
DECLARE @t int = 2;
DECLARE @x int = 1;
DECLARE @z float = 1;

	 IF(@t > @x) SET @z = POWER(SIN(@t), 2);
ELSE IF(@t < @x) SET @z = 4 * (@t + @x);
ELSE IF(@t = @x) SET @z = 1 - EXP(@x - 2);

PRINT 'z= ' + cast(@z as varchar(10))


--преобразование полного ФИО сту-дента в сокращенное (например, Макей-чик Татьяна Леонидовна в Макейчик Т. Л.);
DECLARE @res nvarchar(20);
DECLARE @fullname TABLE 
			(
				surname nvarchar(10) default 'Макейчик',
				name nvarchar(10) default 'Татьяна',
				secondname nvarchar(10) default 'Леонидовна'
			);
INSERT @fullname default values;

SELECT * FROM @fullname;


-- функция LEFT извлекает подстроку из строки, начиная с самого левого символа.
SET @res = (SELECT (surname + ' ' + LEFT(name, 1) + '. ' + LEFT(secondname, 1) + '.') FROM @fullname); 

PRINT @res
SELECT @res result

-- 3
-- Вывести список студнтов, чей др в некст месяце
-- DATEDIFF( интервал, дата1, дата2 ) - Возвращает значение типа Variant (Long), 
-- указывающее на количество интервалов времени между двумя указанными датами
-- функция YEAR возвращает четырехзначный год (как число) с учетом значения даты
-- SYSDATETIME() - Возвращает значение типа datetime2(7), которое содержит дату и время компьютера, на котором запущен экземпляр SQL Server.
USE UNIVER;
SELECT STUDENT.NAME [Имя студента],
	   STUDENT.BDAY [День рождения],
	   DATEDIFF(YEAR, STUDENT.BDAY, SYSDATETIME()) AS [Количество полных лет]
FROM STUDENT 
-- функция MONTH возвращает месяц (число от 1 до 12) с учетом значения даты.
-- DATEADD( интервал (m - месяц), число, дата ) - Возвращает значение типа Variant (Date),
-- содержащее результат прибавления к дате указанного интервала времени
WHERE MONTH(STUDENT.BDAY) = MONTH(DATEADD(m, 1, SYSDATETIME())) --добавляем к нашему ПК месяцу единицу


-- 4
-- поиск дня недели, в который студенты некоторой группы сдавали экзамен по СУБД.
-- DatePart (интервал (w - week), дата ) - данные содержащее указанную часть заданной даты.
DECLARE @examday date
SET @examday = (SELECT PROGRESS.PDATE
				FROM PROGRESS Inner Join STUDENT ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
				WHERE PROGRESS.SUBJECT in('СУБД') and STUDENT.IDGROUP in('5')
				GROUP BY PROGRESS.PDATE)

PRINT 'День, в который студенты некоторой группы сдавали экзамен по СУБД: ' + cast(@examday as varchar(10))
PRINT 'День недели, в который студенты некоторой группы сдавали экзамен по СУБД: ' + CONVERT (varchar(12), DATEPART(w, @examday))


--5. Продемонстрировать конструкцию IF… ELSE на примере анализа данных таблиц базы данных Х_UNIVER.

USE UNIVER;
SELECT AUDITORIUM_CAPACITY, AUDITORIUM_NAME FROM AUDITORIUM

DECLARE @x int = (SELECT count(*) FROM AUDITORIUM);
IF @x > 30 
	begin
		PRINT 'колво аудиторий > 10';
	end;
	begin
		PRINT 'колво аудиторий < 10'
	end;
PRINT 'колво аудиторий = ' + convert(varchar, @x);


--6. Разработать сценарий, в котором с помощью CASE анализируются оценки,
-- полученные студентами некоторого фа-культета при сдаче экзаменов.
USE UNIVER
SELECT  FACULTY.FACULTY AS [Факультет],
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
		WHERE FACULTY.FACULTY in('ИТ') AND Note BETWEEN 6 AND 8
		ORDER BY PROGRESS.NOTE desc, FACULTY.FACULTY

--7. Создать временную локальную таблицу из трех столбцов и 10 строк,
--заполнить ее и вывести содержимое. Использовать оператор WHILE.
CREATE TABLE #example 
(
	COLUMN1 int,
	COLUMN2 int,
	COLUMN3 int 
);

DECLARE @i int = 0;
WHILE @i < 10
	begin
		INSERT #example(COLUMN1, COLUMN2, COLUMN3)
			values((100 * rand()), (100 * rand()), (100 * rand()));
		SET @i = @i + 1;
	end;

SELECT * FROM #example;

--8. Разработать скрипт, демонстриру-ющий использование оператора RE-TURN. 

DECLARE @ex int = 0;
	PRINT @ex + 1;
	PRINT @ex + 2;
	RETURN 
	PRINT @ex + 3;

--9. Разработать сценарий с ошибками, в котором используются для обработки ошибок блоки TRY и CATCH. 
--Применить функции ER-ROR_NUMBER (код последней ошиб-ки), ERROR_MESSAGE (сообщение об ошибке), 
--ERROR_LINE (номер строки с ошибкой), ERROR_PROCEDURE (имя процедуры или NULL), ER-ROR_SEVERITY
--(уровень серьезности ошибки), ERROR_STATE (метка ошиб-ки). Проанализировать результат.
begin TRY 
	UPDATE dbo.AUDITORIUM SET AUDITORIUM = 4
		WHERE AUDITORIUM = 5;
end TRY
begin CATCH 
	print ERROR_NUMBER()
	print ERROR_MESSAGE()
	print ERROR_LINE()
	print ERROR_PROCEDURE()
	print ERROR_SEVERITY()
	print ERROR_STATE()
end CATCH

