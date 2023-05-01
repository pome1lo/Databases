--1. ����������� ��������, �������-���� ������ ��������� �� ������� ����. 
--� ����� ������ ���� �������� ������� �������� ��������� �� �����-�� SUBJECT �
--���� ������ ����� ����-���. ������������ ���������� ������� RTRIM.

USE UNIVER;
DECLARE @discip char(20), @d char(300) ='';
DECLARE Discipline CURSOR
	for SELECT SUBJECT.SUBJECT 
		FROM SUBJECT 
		WHERE SUBJECT.PULPIT IN('����')

	OPEN Discipline;
	FETCH Discipline into @discip;
	print '���������� � ������� ����';
	while @@fetch_status = 0
		begin
			set @d = rtrim(@discip) + ', ' + @d;
			FETCH Discipline into @discip;
		end;
	print @d;
	CLOSE Discipline;
	DEALLOCATE Discipline

--2. ����������� ��������, ���������-������ ������� ����������� 
--������� �� ���������� �� ������� ���� ������ UNIVER.

USE UNIVER;
DECLARE Student CURSOR GLOBAL
				for SELECT STUDENT.NAME, PROGRESS.NOTE
					FROM PROGRESS Inner Join STUDENT
					ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
					WHERE PROGRESS.SUBJECT IN('����')
PRINT '<---������� ��������� �� ������� �� ����--->' 
DECLARE @stud char(50), @n int;
	OPEN Student;
	FETCH Student into @stud, @n;
	print '1.'+ @stud + cast(@n as varchar(3));
	go --����� ������

DECLARE @stud char(50), @n int;
	FETCH Student into @stud, @n;
	print '2.'+ @stud + cast(@n as varchar(3));
	go

	DROP CURSOR @st
--3. ����������� ��������, ���������-������ ������� ����������� 
--�������� �� ������������ �� ������� ���� ���-��� UNIVER. TEMPDB

SELECT PROGRESS.IDSTUDENT, PROGRESS.PDATE, PROGRESS.NOTE
					FROM PROGRESS
					WHERE PROGRESS.SUBJECT IN('����')
use UNIVER
DECLARE @sid char(25), @sdate char(25), @spr char(3)
DECLARE StudPr CURSOR DYNAMIC 
				for SELECT PROGRESS.IDSTUDENT, PROGRESS.PDATE, PROGRESS.NOTE
					FROM PROGRESS
					WHERE PROGRESS.SUBJECT IN('����')
	OPEN StudPr;
	print '���������� �����: ' + cast(@@CURSOR_ROWS as varchar(5));
	UPDATE PROGRESS set NOTE = 5 where IDSTUDENT = 1014
	DELETE PROGRESS where IDSTUDENT = 1016
	INSERT PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE)
			values('����', 1016, cast('2013-12-01' as date), 7);
	FETCH StudPr into @sid, @sdate, @spr;
	while @@FETCH_STATUS = 0
	begin
		print @sid + '' + @sdate + '' + @spr;
		fetch StudPr into @sid, @sdate, @spr;
	end;
	CLOSE StudPr;
	DEALLOCATE StudPr
go
---------------------------------------------------------------

--4. ����������� ��������, ���������-������ �������� ��������� � �������������� 
--������ ������� � ��������� SCROLL �� ������� ���� ������ UNIVER.
--������������ ��� ��������� �����-��� ����� � ��������� FETCH.

SELECT SUBJECT, PULPIT 
				FROM SUBJECT
				ORDER BY PULPIT

DECLARE @s char(10), @ps char(50), @p char(10);
set @ps = '����'

DECLARE Dis CURSOR LOCAL DYNAMIC SCROLL
				FOR SELECT SUBJECT, PULPIT 
				FROM SUBJECT
				ORDER BY PULPIT
	OPEN Dis;
	FETCH Dis INTO @s, @p;
	WHILE @@FETCH_STATUS = 0
	begin
		PRINT @s+' '+@p
		FETCH Dis INTO @s, @p
	end
	
	PRINT '--last--'
	FETCH LAST FROM Dis into @s, @p
	PRINT @s+' '+@p

	PRINT '--first--'
	FETCH FIRST FROM Dis into @s, @p
	PRINT @s+' '+@p

	PRINT '--absolute 10--'
	FETCH ABSOLUTE 10 FROM Dis into @s, @p
	PRINT @s+' '+@p

	PRINT '--relative 5--'
	FETCH RELATIVE 5 FROM Dis into @s, @p
	PRINT @s+' '+@p

	PRINT '--relative -5--'
	FETCH RELATIVE -5 FROM Dis into @s, @p
	PRINT @s+' '+@p

	PRINT '--absolute -10--'
	FETCH ABSOLUTE -10 FROM Dis into @s, @p
	PRINT @s+' '+@p

--5. ������� ������, ������������-��� ���������� ����������� 
--CURRENT OF � ������ WHERE � ������-�������� ���������� UPDATE � DE-LETE.

set nocount on;

declare @Sub nvarchar(10), @Sub_Name nvarchar(30);
declare currentOf cursor global dynamic for select SUBJECT, SUBJECT_NAME from SUBJECT for update

open currentOf 
fetch currentOf into @Sub, @Sub_Name
while @@FETCH_STATUS = 0
  begin
    if @Sub like '��%' update SUBJECT set SUBJECT_NAME = '����������' where current of currentOf 
	-- ���� ��� ������� ������ ��������� � currentOf, �� ����� ���������
    print '' + @Sub + ' ' + @Sub_Name
    fetch currentOf into @Sub, @Sub_Name
  end
close currentOf
deallocate currentOf

select SUBJECT[�������], SUBJECT_NAME[������� �� ������] from SUBJECT
go

update SUBJECT set SUBJECT_NAME = '������ ��������� ����' where SUBJECT_NAME = '�������'

--6. ����������� SELECT-������, � ������� �������� �� ������� PRO-GRESS 
--��������� ������, ���������� ���������� � ���������, ���������� ������ 
--���� 4 (������������ ������-����� ������ PROGRESS, STUDENT, GROUPS). 

use UNIVER

declare @Note int, @Name nvarchar(50), @Faculty nvarchar(20);
declare myCurs cursor dynamic global for select PROGRESS.NOTE, STUDENT.NAME, GROUPS.FACULTY
                      from PROGRESS inner join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
                      inner join  GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP

open myCurs
fetch myCurs into @Note, @Name, @Faculty
while @@FETCH_STATUS = 0
  begin
    print '������ ' + cast(@Note as nvarchar(10)) + ' - ' + @Name + ' - ' + @Faculty
    fetch myCurs into @Note, @Name, @Faculty

    if @Note <4 delete PROGRESS where current of myCurs
    if @Note <4 delete STUDENT  where current of myCurs
    if @Note <4 delete GROUPS   where current of myCurs

  end
close myCurs
deallocate myCurs
go

--����������� SELECT-������, � ��-����� �������� � ������� PROGRESS ��� 
--�������� � ���������� ������� IDSTUDENT �������������� ������ (������������� �� �������).



declare @Subject nvarchar(10), @IDStudent int, @Note int
declare Task6 cursor global dynamic for select SUBJECT, IDSTUDENT, NOTE
                    from PROGRESS for update

open Task6
fetch Task6 into @Subject, @IDStudent, @Note
while @@FETCH_STATUS = 0
  begin
    print @Subject + ' ' +cast(@IDStudent as nvarchar(10)) + ' ' + cast(@Note as nvarchar(20))
    if @IDStudent = 1021 update PROGRESS set NOTE = NOTE + 1 where current of Task6
    fetch Task6 into @Subject, @IDStudent, @Note
  end
close Task6
deallocate Task6

select SUBJECT[�������], IDSTUDENT[Id ��������], NOTE[������] from PROGRESS
go

update PROGRESS set NOTE = 8 where IDSTUDENT = 1021