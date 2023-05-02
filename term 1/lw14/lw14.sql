--1. Разработать скалярную функцию с именем COUNT_STUDENTS, которая вычисляет количество 
--студентов на факультете, код которого задается параметром типа varchar(20) с именем 
--@faculty. Использовать внутреннее соединение таблиц FACULTY, GROUPS, STUDENT.
--Опробовать работу функции. Внести изменения в текст функции с помощью оператора 
--ALTER с тем, чтобы функция принимала второй параметр @prof типа varchar(20), 
--обозначающий специальность студентов. Для параметров определить значения по 
--умолчанию NULL. Опробовать работу функции с помощью SELECT-запросов.

USE UNIVER;
go
CREATE FUNCTION COUNT_STUDENTS(@faculty varchar(20)) returns int
as
begin 
	declare @rc int = 0;
	set @rc = (select count(*) 
				from STUDENT
				Join GROUPS ON STUDENT.IDGROUP = GROUPS.IDGROUP
				Join FACULTY ON GROUPS.FACULTY = FACULTY.FACULTY
								where FACULTY.FACULTY = @faculty);
	return @rc;
end;
go
--------------------------------------------
declare @f int = [dbo].[COUNT_STUDENTS]('ИТ');
print 'Количество студентов на ФИТ: ' + cast(@f as varchar(4));
--------------------------------------------

go
ALTER FUNCTION [dbo].[COUNT_STUDENTS](@faculty varchar(20) = null, @prof varchar(20) = null) returns int
as
begin 
	declare @rc int = 0;
	set @rc = (select count(*) 
				from STUDENT
				Join GROUPS ON STUDENT.IDGROUP = GROUPS.IDGROUP
				Join FACULTY ON GROUPS.FACULTY = FACULTY.FACULTY
								where FACULTY.FACULTY = @faculty and GROUPS.PROFESSION = @prof);
	return @rc;
end;
go

declare @ress int = [dbo].[COUNT_STUDENTS]('ХТИТ', '1-36 07 01')
print 'Количество студентов на ХТИТе: ' + cast(@ress as varchar(2));

drop function COUNT_STUDENTS

--2. Разработать скалярную функцию с именем FSUBJECTS, принимающую параметр @p типа 
--varchar(20), значение которого задает код кафедры (столбец SUBJECT.PULPIT). 
--Функция должна возвращать строку типа varchar(300) с перечнем дисциплин в отчете. 
--Создать и выполнить сценарий, который создает отчет, аналогичный представленному ниже. 
--Использовать локальный статический курсор на основе SELECT-запроса к таблице SUBJECT.

USE UNIVER;
go
CREATE FUNCTION FSUBJECTS(@pulpit varchar(20)) returns varchar(300)
as
begin 
	declare @disc char(20);
	declare @line varchar(300) = 'Дисциплины: ';
	declare Subj CURSOR LOCAL
	for	select SUBJECT.SUBJECT from SUBJECT
									where SUBJECT.PULPIT = @pulpit;
	open Subj;
	fetch Subj into @disc;
	while @@FETCH_STATUS = 0
	begin
		set @line = @line + ', ' + rtrim(@disc);
		FETCH Subj into @disc;
	end;
	return @line;
	end;
go
------------------------------
select PULPIT, dbo.FSUBJECTS(PULPIT) [Дисциплины] from PULPIT

DROP FUNCTION FSUBJECTS;

--3. Разработать табличную функцию FFACPUL, результа-ты работы которой продемонстрированы 
--на рисунке ниже. Функция принимает два параметра, задающих код фа-культета (столбец FACULTY.FACULTY) 
--и код кафедры (столбец PULPIT.PULPIT). Использует SELECT-запрос c левым внешним соединением между 
--таблицами FACULTY и PULPIT. Если оба параметра функции равны NULL, то она воз-вращает список всех
--кафедр на всех факультетах. Если задан первый параметр (второй равен NULL), функ-ция возвращает 
--список всех кафедр заданного факультета. Если задан второй параметр (первый равен NULL), функция
--возвращает результирующий набор, содержащий стро-ку, соответствующую заданной кафедре.Если заданы
--два параметра, функция возвращает резуль-тирующий набор, содержащий строку, соответствующую 
--заданной кафедре на заданном факультете. Если по заданным значениям параметров невозможно 
--сформировать строки, функция возвращает пустой резуль-тирующий набор. 

-- табл ф-я приним-я два пар-а: код фак-а и кафедры
-- при null null - выводим все фак-ы и каф-ы
-- при str null - выводим все каф-ы ф-та str
-- при null str - выводим фак-т каф-ы str
USE UNIVER;
go
CREATE FUNCTION FFACPUL(@facultyCode varchar(20), @pulpitCode varchar(20)) returns table
as return
	select FACULTY.FACULTY, PULPIT.PULPIT	-- isnull - если первый пар-р равен null, то выведтся второй
											FROM FACULTY
											Left Outer Join PULPIT ON FACULTY.FACULTY = PULPIT.FACULTY
											where FACULTY.FACULTY = isnull(@facultyCode, FACULTY.FACULTY) 
												  and 
												  PULPIT.PULPIT = isnull(@pulpitCode, PULPIT.PULPIT)

go
------------------------------------------------------------------------------
select * from [dbo].[FFACPUL](NULL, NULL);

select * from [dbo].[FFACPUL]('ИТ', NULL);

select * from [dbo].[FFACPUL](NULL, 'ЛМиЛЗ');

select * from [dbo].[FFACPUL]('ТТЛП', 'ЛМиЛЗ');


drop function FFACPUL

--4. На рисунке ниже показан сценарий, демонстрирующий работу скалярной функции FCTEACHER. 
--Функция прини-мает один параметр, задающий код кафедры. Функция воз-вращает количество
--преподавателей на заданной парамет-ром кафедре. Если параметр равен NULL, то возвращается 
--общее количество преподавателей. Разработать функцию FCTEACHER. 

-- скалярная ф-я которая возвращет кол-во преподов. на кафедре
USE UNIVER;
go
CREATE FUNCTION FCTEACHER(@pulpitCode nvarchar(10)) returns int
as
begin
	declare @rc int = (select count(*) from TEACHER	 -- isnull - если первый пар-р равен null, то выведтся второй
										where TEACHER.PULPIT = isnull(@pulpitCode, TEACHER.PULPIT));
	return @rc;
end;
go

select PULPIT, dbo.FCTEACHER(PULPIT) [Количество преподавателей] from PULPIT

-- при null выводится общее кол-во всех преподов.
select top 1 dbo.FCTEACHER(NULL) [Всего преподавателей] from PULPIT

drop function FCTEACHER
















--6 

go
create function FACULTY_REPORT(@c int) returns @fr table ( [Факультет] varchar(50), [Количество кафедр] int, [Количество групп]  int, [Количество студентов] int, [Количество специальностей] int )
	as begin 
           declare cc CURSOR static for 
	       select FACULTY from FACULTY 
                             where dbo.COUNT_STUDENTS(FACULTY, default) > @c; 
	       declare @f varchar(30);
	       open cc;  
           fetch cc into @f;
	       while @@fetch_status = 0
	       begin
	            insert @fr values( @f,  (select count(PULPIT) from PULPIT where FACULTY = @f),
	            (select count(IDGROUP) from GROUPS where FACULTY = @f),   dbo.COUNT_STUDENTS(@f, default),
	            (select count(PROFESSION) from PROFESSION where FACULTY = @f)   ); 
	            fetch cc into @f;  
	       end;   
                 return; 
	end;
go
-------------------------------------
go
create function PulpitCount(@faculty varchar(50)) returns int
as
begin
	 declare @pulpitCount int = 0
	 set @pulpitCount = (select count(*)
							from PULPIT
								where PULPIT.FACULTY = @faculty)
	return @pulpitCount
end
go
go
create function GroupCount(@faculty varchar(50)) returns int
as
begin
	 declare @groupCount int = 0
	 set @groupCount = (select count(*)
							from GROUPS
								where GROUPS.FACULTY = @faculty)
	return @groupCount
end
go
go
create function StudentCount(@faculty varchar(50)) returns int
as
begin
	declare @studentCount int = 0
	set @studentCount = (select count(*) 
							from STUDENT 
							Inner Join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
							Inner Join FACULTY on GROUPS.FACULTY = FACULTY.FACULTY
								where FACULTY.FACULTY = @faculty)
	return @studentCount
end
go
go
create function ProfessionCount(@faculty varchar(50)) returns int
as
begin
	 declare @professionCount int = 0
	 set @professionCount = (select count(*)
							from PROFESSION
								where PROFESSION.FACULTY = @faculty)
	return @professionCount
end
go

go
create function FacultyReport(@studentCount int) returns  @result table
																(
																	faculty varchar(50),
																	pulpitCount int, 
																	groupCount int, 
																	professionCount int
																)
as
begin
	declare FacultyCursor cursor local for
		select FACULTY from FACULTY where dbo.StudentCount(FACULTY) > @studentCount
	declare @faculty varchar(50)
	open FacultyCursor
		fetch FacultyCursor into @faculty
		while @@FETCH_STATUS = 0
		begin
			insert into @result values
			(@faculty, dbo.PulpitCount(@faculty), dbo.GroupCount(@faculty), dbo.ProfessionCount(@faculty))

			fetch FacultyCursor into @faculty
		end

	close FacultyCursor
	return
end
go

select FACULTY, dbo.StudentCount(FACULTY)[student count] from FACULTY
select * from dbo.FacultyReport(14)