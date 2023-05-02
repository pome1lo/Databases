--1. ����������� ��������� ������� � ������ COUNT_STUDENTS, ������� ��������� ���������� 
--��������� �� ����������, ��� �������� �������� ���������� ���� varchar(20) � ������ 
--@faculty. ������������ ���������� ���������� ������ FACULTY, GROUPS, STUDENT.
--���������� ������ �������. ������ ��������� � ����� ������� � ������� ��������� 
--ALTER � ���, ����� ������� ��������� ������ �������� @prof ���� varchar(20), 
--������������ ������������� ���������. ��� ���������� ���������� �������� �� 
--��������� NULL. ���������� ������ ������� � ������� SELECT-��������.

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
declare @f int = [dbo].[COUNT_STUDENTS]('��');
print '���������� ��������� �� ���: ' + cast(@f as varchar(4));
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

declare @ress int = [dbo].[COUNT_STUDENTS]('����', '1-36 07 01')
print '���������� ��������� �� �����: ' + cast(@ress as varchar(2));

drop function COUNT_STUDENTS

--2. ����������� ��������� ������� � ������ FSUBJECTS, ����������� �������� @p ���� 
--varchar(20), �������� �������� ������ ��� ������� (������� SUBJECT.PULPIT). 
--������� ������ ���������� ������ ���� varchar(300) � �������� ��������� � ������. 
--������� � ��������� ��������, ������� ������� �����, ����������� ��������������� ����. 
--������������ ��������� ����������� ������ �� ������ SELECT-������� � ������� SUBJECT.

USE UNIVER;
go
CREATE FUNCTION FSUBJECTS(@pulpit varchar(20)) returns varchar(300)
as
begin 
	declare @disc char(20);
	declare @line varchar(300) = '����������: ';
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
select PULPIT, dbo.FSUBJECTS(PULPIT) [����������] from PULPIT

DROP FUNCTION FSUBJECTS;

--3. ����������� ��������� ������� FFACPUL, ��������-�� ������ ������� ������������������ 
--�� ������� ����. ������� ��������� ��� ���������, �������� ��� ��-�������� (������� FACULTY.FACULTY) 
--� ��� ������� (������� PULPIT.PULPIT). ���������� SELECT-������ c ����� ������� ����������� ����� 
--��������� FACULTY � PULPIT. ���� ��� ��������� ������� ����� NULL, �� ��� ���-������� ������ ����
--������ �� ���� �����������. ���� ����� ������ �������� (������ ����� NULL), ����-��� ���������� 
--������ ���� ������ ��������� ����������. ���� ����� ������ �������� (������ ����� NULL), �������
--���������� �������������� �����, ���������� ����-��, ��������������� �������� �������.���� ������
--��� ���������, ������� ���������� ������-�������� �����, ���������� ������, ��������������� 
--�������� ������� �� �������� ����������. ���� �� �������� ��������� ���������� ���������� 
--������������ ������, ������� ���������� ������ ������-�������� �����. 

-- ���� �-� ������-� ��� ���-�: ��� ���-� � �������
-- ��� null null - ������� ��� ���-� � ���-�
-- ��� str null - ������� ��� ���-� �-�� str
-- ��� null str - ������� ���-� ���-� str
USE UNIVER;
go
CREATE FUNCTION FFACPUL(@facultyCode varchar(20), @pulpitCode varchar(20)) returns table
as return
	select FACULTY.FACULTY, PULPIT.PULPIT	-- isnull - ���� ������ ���-� ����� null, �� �������� ������
											FROM FACULTY
											Left Outer Join PULPIT ON FACULTY.FACULTY = PULPIT.FACULTY
											where FACULTY.FACULTY = isnull(@facultyCode, FACULTY.FACULTY) 
												  and 
												  PULPIT.PULPIT = isnull(@pulpitCode, PULPIT.PULPIT)

go
------------------------------------------------------------------------------
select * from [dbo].[FFACPUL](NULL, NULL);

select * from [dbo].[FFACPUL]('��', NULL);

select * from [dbo].[FFACPUL](NULL, '�����');

select * from [dbo].[FFACPUL]('����', '�����');


drop function FFACPUL

--4. �� ������� ���� ������� ��������, ��������������� ������ ��������� ������� FCTEACHER. 
--������� �����-���� ���� ��������, �������� ��� �������. ������� ���-������� ����������
--�������������� �� �������� �������-��� �������. ���� �������� ����� NULL, �� ������������ 
--����� ���������� ��������������. ����������� ������� FCTEACHER. 

-- ��������� �-� ������� ��������� ���-�� ��������. �� �������
USE UNIVER;
go
CREATE FUNCTION FCTEACHER(@pulpitCode nvarchar(10)) returns int
as
begin
	declare @rc int = (select count(*) from TEACHER	 -- isnull - ���� ������ ���-� ����� null, �� �������� ������
										where TEACHER.PULPIT = isnull(@pulpitCode, TEACHER.PULPIT));
	return @rc;
end;
go

select PULPIT, dbo.FCTEACHER(PULPIT) [���������� ��������������] from PULPIT

-- ��� null ��������� ����� ���-�� ���� ��������.
select top 1 dbo.FCTEACHER(NULL) [����� ��������������] from PULPIT

drop function FCTEACHER
















--6 

go
create function FACULTY_REPORT(@c int) returns @fr table ( [���������] varchar(50), [���������� ������] int, [���������� �����]  int, [���������� ���������] int, [���������� ��������������] int )
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