--Разработать хранимую процедуру без параметров с именем PSUBJECT. Процедура 
--формирует результи-рующий набор на основе таблицы SUBJECT, анало-гичный 
--набору, представленному на рисунке: Процедура должна возвращать количество
--строк, выведенных в результирующий набор.

USE UNIVER
DROP PROCEDURE PSUBJECT;
go
CREATE PROCEDURE PSUBJECT
as
begin
	declare @k int = (select count (*) from SUBJECT);
	select SUBJECT.SUBJECT [код], SUBJECT.SUBJECT_NAME [дисциплина], SUBJECT.PULPIT [кафедра] from SUBJECT;
	return @k;	--возвращает значение к точке вызова, равное общему количеству дисциплин 
end;
go

declare @k int = 0;
EXEC @k = PSUBJECT;
print 'кол-во дисциплин = ' + cast(@k as varchar(3));

--DROP PROCEDURE PSUBJECT

--2. Найти процедуру PSUBJECT с помощью обо-зревателя объектов (Object Explorer)
--и через кон-текстное меню создать сценарий на изменение проце-дуры оператором ALTER.
--Изменить процедуру PSUBJECT, созданную в за-дании 1, таким образом, чтобы она 
--принимала два па-раметра с именами @p и @c. Параметр @p является входным, 
--имеет тип varchar(20) и значение по умол-чанию NULL. Параметр @с является 
--выходным, име-ет тип INT. Процедура PSUBJECT должна формировать ре-зультирующий 
--набор, аналогичный набору, представ-ленному на рисунке выше, но при этом 
--содержать строки, соответствующие коду кафедры, заданному параметром @p. 
--Кроме того, процедура должна фор-мировать значение выходного параметра @с,
--равное количеству строк в результирующем наборе, а также возвращать значение 
--к точке вызова, равное общему количеству дисциплин (количеству строк в таблице SUBJECT). 

USE [UNIVER]
GO

/****** Object:  StoredProcedure [dbo].[PSUBJECT]    Script Date: 19.05.2022 11:07:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- изм-ть процедуру таким образом чтобы она содержала входной и выходной параметр
--@p - код кафедры, @c - кол-во строк
ALTER PROCEDURE [dbo].[PSUBJECT] @p varchar(20) = null, @c int output -- принимает два входных параметра: p принимает знач по ум varchar, с - выходной параметр
as
begin
	declare @k int = (select count (*) from SUBJECT);
	set @c = (select count(*) from SUBJECT where SUBJECT.PULPIT = @p)
	select SUBJECT.SUBJECT [код], SUBJECT.SUBJECT_NAME [дисциплина], SUBJECT.PULPIT [кафедра] from SUBJECT
																				where SUBJECT.PULPIT = @p;
	return @k;		--возвращает значение к точке вызова, равное общему количеству дисциплин 
end;
GO

declare @k int, @rez int = 0
exec @k = PSUBJECT @p = 'ИСиТ', @c = @rez output
print @k
print @rez


--3. Создать временную локальную таблицу с именем #SUBJECT. Наименование
--и тип столбцов таблицы должны соответствовать столбцам результирующего 
--набора процедуры PSUBJECT, разработанной в задании 2. Изменить процедуру
--PSUBJECT таким образом, чтобы она не содержала выходного параметра.
--Применив конструкцию INSERT… EXECUTE с мо-дифицированной процедурой
--PSUBJECT, добавить строки в таблицу #SUBJECT. 

-- изм-ть так, чтобы у процедуры не было выходного параметра
USE UNIVER;
go
CREATE TABLE #SUBJECT
(
	SUBJECT char(10) primary key,
	SUBJECT_NAME varchar(100),
	PULPIT char(20)
)
--------------------------------------------------------
go
--@p - код кафедры, @c - кол-во строк
ALTER PROCEDURE [dbo].[PSUBJECT] @p varchar(20) = null
as
begin
	declare @k int = (select count (*) from SUBJECT);
	select SUBJECT.SUBJECT [код], SUBJECT.SUBJECT_NAME [дисциплина], SUBJECT.PULPIT [кафедра] from SUBJECT
																				where SUBJECT.PULPIT = @p;
end;
go
-------------------------------------------------------
INSERT #SUBJECT exec PSUBJECT @p = 'ИСиТ'
SELECT * FROM #SUBJECT
DROP TABLE #SUBJECT

--4. Разработать процедуру с именем PAUDITORI-UM_INSERT. Процедура принимает 
--четыре входных параметра: @a, @n, @c и @t. Параметр @a имеет тип CHAR(20), 
--параметр @n имеет тип VARCHAR(50), параметр @c имеет тип INT и значение по
--умолчанию 0, параметр @t имеет тип CHAR(10).Процедура добавляет строку в
--таблицу AUDITO-RIUM. Значения столбцов AUDITORIUM, AUDI-TORIUM_NAME, 
--AUDITORIUM_CAPACITY и AUDITORIUM_TYPE добавляемой строки задаются соответственно
--параметрами @a, @n, @c и @t. Процедура PAUDITORIUM_INSERT должна при-менять
--механизм TRY/CATCH для обработки ошибок. В случае возникновения ошибки,
--процедура должна формировать сообщение, содержащее код ошибки, уровень серьезности
--и текст сообщения в стандартный выходной поток. Процедура должна возвращать к
--точке вызова зна-чение -1 в том случае, если произошла ошибка и 1, ес-ли 
--выполнение успешно. Опробовать работу процедуры с различными значе-ниями исходных данных.

USE UNIVER
--DROP PROCEDURE PAUDITORIUM_INSERT

go
CREATE PROCEDURE PAUDITORIUM_INSERT @a char(20), @n varchar(50), @c int = 0, @t char(10)
as 
begin try
	insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE)
		values(@a, @n, @c, @t)
	return 1
end try
begin catch
	print 'номер ошибки: ' + cast (error_number() as varchar(6));
	print 'сообщение:    ' + error_message();
	print 'уровень:      ' + cast (error_severity() as varchar(6));
	print 'метка:        ' + cast (error_state() as varchar(8));
	print 'номер строки: ' + cast (error_line() as varchar(8));
	if ERROR_PROCEDURE() is not null
	print 'имя процедуры: ' + cast (error_procedure() as varchar(8)); 
		return -1
end catch
go

--- Test ---
declare @rez int;


begin tran

exec @rez = PAUDITORIUM_INSERT @a= '207-1', @n = '207-1', @c = 15, @t = 'ЛБ-К'
print @rez
if @rez = 1	-- если успешное выполнение
	select * from AUDITORIUM

rollback

--5. Разработать процедуру с именем SUB-JECT_REPORT, формирующую в стандартный 
--вы-ходной поток отчет со списком дисциплин на кон-кретной кафедре. В отчет 
--должны быть выведены краткие названия (поле SUBJECT) из таблицы SUBJECT в
--одну строку через запятую (использовать встроенную функцию RTRIM). Процедура
--имеет входной параметр с именем @p типа CHAR(10), кото-рый предназначен для
--указания кода кафедры. В том случае, если по заданному значению @p не-возможно 
--определить код кафедры, процедура должна генерировать ошибку с сообщением ошибка 
--в пара-метрах. Процедура SUBJECT_REPORT должна возвра-щать к точке вызова
--количество дисциплин, отобра-женных в отчете. 
--RAISERROR: текстовое сообщение об ошибке, уровень серьезности ошибки и метку. 

USE UNIVER
DROP PROCEDURE SUBJECT_REPORT

go
CREATE PROCEDURE SUBJECT_REPORT @p char(10)
as declare @rc int = 0
begin try
	declare @subjectName nvarchar(15), @subjectline nvarchar(150) = ''
	
	declare Subj CURSOR for
	select SUBJECT.SUBJECT from SUBJECT
									where SUBJECT.PULPIT = @p;
	
	if not exists(select SUBJECT.SUBJECT from SUBJECT
												where SUBJECT.PULPIT = @p)
		begin
			raiserror('Ошибка в параметрах', 11, 1)
			return 0
		end
	else
		open Subj;
		fetch Subj into @subjectName;
		print 'Дисциплины с конкретной кафедры';
		while @@FETCH_STATUS = 0
			begin
				set @subjectline = rtrim(@subjectName) + ', ' + @subjectline;
				set @rc = @rc + 1;
				fetch Subj into @subjectName;
			end;
			print @subjectline;
			close Subj;
			return @rc;
end try
begin catch
	print 'Ошибка в параметрах'
	if ERROR_PROCEDURE() is not null
		print 'имя процедуры: ' + cast (error_procedure() as varchar(20)); 
		return @rc;
end catch;
go
------------------------------------------------------------------------------

declare @rc int;
exec @rc = SUBJECT_REPORT @p = 'ИСиТ';
print 'количество дисциплин = ' + cast(@rc as varchar(3));

--6. Разработать процедуру с именем PAUDITORI-UM_INSERTX. Процедура принимает 
--пять входных параметров: @a, @n, @c, @t и @tn. Параметры @a, @n, @c, @t 
--аналогичны парамет-рам процедуры PAUDITORIUM_INSERT. Параметр @tn является 
--входным, имеет тип VARCHAR(50), предназначен для ввода значения в столбец 
--AUDITO-RIUM_TYPE.AUDITORIUM_TYPENAME.Процедура добавляет две строки. 
--Первая строка добавляется в таблицу AUDITORIUM_TYPE. Значе-ния столбцов 
--AUDITORIUM_TYPE и AUDITORI-UM_ TYPENAME задаются соответственно параметрами 
--@t и @tn. Вторая строка добавляется путем вы-зова процедуры PAUDITORIUM_INSERT.
--Добавление строки в таблицу AUDITORIUM_ TYPE и вызов процедуры PAUDITORIUM_INSERT
--должны выполняться в рамках одной транзакции с уровнем изолированности SERIALIZABLE. 
--В процедуре должна быть предусмотрена обработка ошибок с помощью механизма TRY/CATCH.
--Все ошибки должны быть обработаны с выдачей соответ-ствующего сообщения в стандартный
--выходной поток. Процедура PAUDITORIUM_INSERTX должна возвращать к точке вызова
--значение -1 в том случае, если произошла ошибка и 1, если выполнения проце-дуры
--завершилось успешно. 

USE UNIVER
----добавляем данные в таблицу AUDITORIUM и в AUDITORIUM_TYPENAME

DROP PROCEDURE PAUDITORIUM_INSERTX

go
CREATE PROCEDURE PAUDITORIUM_INSERTX @a char(20), 
									 @n varchar(50), 
									 @c int = 0, 
									 @t char(10), 
									 @tn varchar(50) --AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
as 
begin try
	declare @rc int = 1;
	set transaction isolation level SERIALIZABLE;
		begin tran
		insert into AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
			values (@t, @tn)
		exec @rc = PAUDITORIUM_INSERT @a, @n, @c, @t;	-- добавление второй строки, с такими же значениями
		commit tran;
	return @rc;
end try
begin catch
	print 'номер ошибки: ' + cast (error_number() as varchar(6));
	print 'сообщение:    ' + error_message();
	print 'уровень:      ' + cast (error_severity() as varchar(6));
	print 'метка:        ' + cast (error_state() as varchar(8));
	print 'номер строки: ' + cast (error_line() as varchar(8));
	if ERROR_PROCEDURE() is not null
	print 'имя процедуры: ' + cast (error_procedure() as varchar(8)); 
	if @@TRANCOUNT > 0 rollback tran;
	return -1;
end catch;
go
--------------------------------------------------

declare @rc int;

begin tran
exec @rc = PAUDITORIUM_INSERTX @a= '208-1', @n = '208-1', @c = 15, @t = 'ТУ2', @tn = 'Тип аудитории 2'
print @rc
if @rc = 1
	select * from AUDITORIUM
	select * from AUDITORIUM_TYPE
rollback
go 