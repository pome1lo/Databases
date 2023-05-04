-- 1. С помощью сценария, представленного на рисунке, создать таблицу TR_AUDIT.
--Таблица предназначена для добавления в нее строк триггерами. 
--В столбец STMT триггер должен поместить событие, на которое он среагировал, а 
--в стол-бец TRNAME  собственное имя. Разработать AFTER-триггер с именем 
--TR_TEACHER_INS для таблицы TEACHER, реагирующий на событие INSERT. Триггер
--должен записывать строки вводимых данных в таблицу TR_AUDIT. В столбец 
--СС помеща-ются значения столбцов вводимой строки.

-- делаем триггеры на события ВСТАВКИ, УДАЛЕНИЯ и ОБНОВЛЕНИЯ
drop table TR_AUDIT;
drop trigger TR_TEACHER_INS;
USE UNIVER
go

create table TR_AUDIT
(
	ID int identity,											--номер
	STMT varchar(20) check (STMT in('INS', 'DEL', 'UPD')),		--DML-оператор (событие на которое триггер среагировал)
	TRNAME varchar(50),											--имя триггера
	CC varchar(300)												--комментарий
)
--------------------------------------------------------------------------------------INSERT
go
create trigger TR_TEACHER_INS
on TEACHER after INSERT	-- означает что такой триггер будет выполняться после оператора insert у TEACHER
as 
declare @Id varchar(20), @Name varchar(50), @Gender varchar(1), @Pulpit varchar(15), @ins varchar(100);
print 'Операция вставки'
set @Id = (select TEACHER from INSERTED)	-- записываем в переменные те значения которые мы вставили (и ктр нах-ся в псевдотабл INSERTED)
set @Name = (select TEACHER_NAME from INSERTED)
set @Gender = (select GENDER from INSERTED)
set @Pulpit = (select PULPIT from INSERTED)

if (@Gender not in ('м', 'ж'))
begin
	raiserror('Неверно указан пол', 10, 1)
	rollback
end

set @ins = @Id + ' ' + @Name + ' ' + @Gender + ' ' + @Pulpit
insert into TR_AUDIT(STMT, TRNAME, CC) values ('INS', 'TR_TEACHER_INS', @ins);	-- CC (@ins) - значения столбцов вводимой строки
return;
go
----------------------------------------------------------------------------------------INSERT test
insert into TEACHER(TEACHER, TEACHER_NAME, GENDER, PULPIT)
	values('ПАА', 'Пузиков Алексей Алеексеевич', 'м', 'ПОИТ');

select * from TR_AUDIT

 
--1. Создать AFTER-триггер с именем TR_TEACHER_DEL для таблицы TEA-CHER, 
--реагирующий на событие DELETE. Триггер должен записывать строку данных 
--в таблицу TR_AUDIT для каждой удаляемой строки. В столбец СС помещаются 
--значения столбца TEACHER удаляемой строки.

----------------------------------------------------------------------------------------3. DELETE
go
create trigger TR_TEACHER_DEL
on TEACHER after DELETE
as 
declare @Id varchar(20), @Name varchar(50), @Gender varchar(1), @Pulpit varchar(15), @del varchar(100);
print 'Операция удаления'
set @Id = (select TEACHER from DELETED)		-- как видим в этих запросах меняется только таблица из которой берем данные
set @Name = (select TEACHER_NAME from DELETED)
set @Gender = (select GENDER from DELETED)
set @Pulpit = (select PULPIT from DELETED)
set @del = @Id + ' ' + @Name + ' ' + @Gender + ' ' + @Pulpit
insert into TR_AUDIT(STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL', @del);
return;
go
----------------------------------------------------------------------------------------DELETE test
delete TEACHER where TEACHER in('ПАА');

select * from TR_AUDIT



----------------------------------------------------------------------------------------

drop trigger TR_TEACHER_INS
drop trigger TR_TEACHER_DEL
drop trigger TR_TEACHER_UPD

--3. Создать AFTER-триггер с именем TR_TEACHER_UPD для таблицы TEA-CHER, 
--реагирующий на событие UPDATE. Триггер должен записывать строку данных 
--в таблицу TR_AUDIT для каждой изменяемой строки. В столбец СС помещаются
--значения столбцов изменяемой строки до и после изме-нения.



go
create trigger TR_TEACHER_UPD
on TEACHER after UPDATE
as 
declare @Id varchar(20), @Name varchar(50), @Gender varchar(1), @Pulpit varchar(15), @upd varchar(150);
print 'Операция изменения'
set @Id = (select TEACHER from INSERTED)
set @Name = (select TEACHER_NAME from INSERTED)
set @Gender = (select GENDER from INSERTED)
set @Pulpit = (select PULPIT from INSERTED)

set @upd = @Id + ' ' + @Name + ' ' + @Gender + ' ' + @Pulpit

set @Id = (select TEACHER from DELETED)
set @Name = (select TEACHER_NAME from DELETED)
set @Gender = (select GENDER from DELETED)
set @Pulpit = (select PULPIT from DELETED)

set @upd = @Id + ' ' + @Name + ' ' + @Gender + ' ' + @Pulpit + ' / ' + @upd

insert into TR_AUDIT(STMT, TRNAME, CC) values ('UPD', 'TR_TEACHER_UPD', @upd);
return;
go
----------------------------------------------------------------------------------------UPDATE test
update TEACHER set PULPIT = 'ПОИТ' where TEACHER in('ПАА');

select * from TR_AUDIT



--4. Создать AFTER-триггер с именем TR_TEACHER для таблицы TEACHER, 
--реа-гирующий на события INSERT, DELETE, UPDATE. Триггер должен
--записывать строку данных в таблицу TR_AUDIT для каждой изменяемой
--строки. В коде триггера определить событие, активизировавшее триггер 
--и поместить в стол-бец СС соответствующую событию информа-цию. 
--Разработать сценарий, демонстрирующий работоспособность триггера. 

-- разработать запрос который определяет какое событие вызвало наш триггер

-----------------------------------------------------------------------------------------
go
create trigger TR_TEACHER
on TEACHER after INSERT, DELETE, UPDATE
as 
declare @Id varchar(20), @Name varchar(50), @Gender varchar(1), @Pulpit varchar(15), @in varchar(300);
declare @ins int = (select count(*) from INSERTED),
	    @del int = (select count(*) from DELETED);
if @ins > 0 and @del = 0	-- т.е. таблица INSERTED будет заполнена, а DELETED пуста
begin
	print 'Событие: INSERT'
	set @Id = (select TEACHER from INSERTED)
	set @Name = (select TEACHER_NAME from INSERTED)
	set @Gender = (select GENDER from INSERTED)
	set @Pulpit = (select PULPIT from INSERTED)
	set @in = @Id + ' ' + @Name + ' ' + @Gender + ' ' + @Pulpit;
	insert into TR_AUDIT(STMT, TRNAME, CC) values ('INS', 'TR_TEACHER', @in);
end;

else
if @ins = 0 and @del > 0	-- соотв. наоборот
begin
	print 'Событие: DELETE'
	set @Id = (select TEACHER from DELETED)
	set @Name = (select TEACHER_NAME from DELETED)
	set @Gender = (select GENDER from DELETED)
	set @Pulpit = (select PULPIT from DELETED)
	set @in = @Id + ' ' + @Name + ' ' + @Gender + ' ' + @Pulpit;
	insert into TR_AUDIT(STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER', @in);
end;
if @ins > 0 and @del > 0	-- будут обе заполнены
begin
	print 'Событие: UPDATE'
	set @Id = (select TEACHER from INSERTED)
	set @Name = (select TEACHER_NAME from INSERTED)
	set @Gender = (select GENDER from INSERTED)
	set @Pulpit = (select PULPIT from INSERTED)
	set @in = @Id + ' ' + @Name + ' ' + @Gender + ' ' + @Pulpit;
	set @Id = (select TEACHER from DELETED)
	set @Name = (select TEACHER_NAME from DELETED)
	set @Gender = (select GENDER from DELETED)
	set @Pulpit = (select PULPIT from DELETED)
	set @in = @Id + ' ' + @Name + ' ' + @Gender + ' ' + @Pulpit + ' / ' + @in;
	insert into TR_AUDIT(STMT, TRNAME, CC) values ('UPD', 'TR_TEACHER', @in);
end;
return;
go

------------------------------------------------------------------------------- test
-- тестируем с разными событиями
insert into TEACHER(TEACHER, TEACHER_NAME, GENDER, PULPIT)
	values('ПАА2', 'Пузиков2 Алексей2 Алексеевич2', 'м', 'ПОИТ');
update TEACHER set PULPIT = 'ПОИТ' where TEACHER in('ПАА2');
delete from TEACHER where TEACHER in('ПАА2');

select * from TR_AUDIT

----------------------------------------------------------------------------------
drop trigger TR_TEACHER

--5. Разработать сценарий, который демон-стрирует на примере базы данных
--UNIVER, что проверка ограничения целостности выпол-няется до срабатывания AFTER-триггера.

-- показываем что after триггеры не нарушают ограничение целостности, так как при возникновении ошибки, триггер просто не выполнится
go
create trigger TR_TEACHER_INS
on TEACHER after INSERT
as 
declare @Id varchar(20), @Name varchar(50), @Gender varchar(1), @Pulpit varchar(15), @ins varchar(100);
print 'Операция вставки'
set @Id = (select TEACHER from INSERTED)
set @Name = (select TEACHER_NAME from INSERTED)
set @Gender = (select GENDER from INSERTED)
set @Pulpit = (select PULPIT from INSERTED)

if (@Gender not in ('м', 'ж'))
begin
	raiserror('Неверно указан пол', 10, 1)
	rollback
end

set @ins = @Id + ' ' + @Name + ' ' + @Gender + ' ' + @Pulpit
insert into TR_AUDIT(STMT, TRNAME, CC) values ('INS', 'TR_TEACHER_INS', @ins);
return;
go
----------------------------------------------------------------------------------------INSERT test
insert into TEACHER(TEACHER, TEACHER_NAME, GENDER, PULPIT)
	values('ПАА', 'Пузиков Алексей Алексеевич', 'м', 'ПОИТ');					--если в бд уже есть, то выполнение оператора не допускается (как и выполнение триггера)
	--delete TEACHER where TEACHER in('ПАА');
select * from TR_AUDIT


----------------------------------------------------------------------------------------------------
drop table TR_AUDIT
drop trigger TR_TEACHER_INS

--6. Создать для таблицы TEACHER три AF-TER-триггера с именами: TR_TEACHER_ DEL1,
--TR_TEACHER_DEL2 и TR_TEA-CHER_ DEL3. Триггеры должны реагировать на событие
--DELETE и формировать соответ-ствующие строки в таблицу TR_AUDIT.  
--Получить список триггеров таблицы TEACHER. Упорядочить выполнение
--триггеров для таб-лицы TEACHER, реагирующих на событие DELETE следующим 
--образом: первым должен выполняться триггер с именем TR_TEA-CHER_DEL3, 
--последним – триггер TR_TEACHER_DEL2. Использовать системные представления 
--SYS.TRIGGERS и SYS.TRIGGERS_ EVENTS, а также системную процедуру SP_SETTRIGGERORDERS. 

-- создаем три триггера для таблицы реаг-ие на удаление
-- прописываем для них порядок действия
-- из результата видно, что для отдельных строк (СПИ или ААА) вып-ся сначала 3-й триггер, потом 1-й и только потом 2-й

go
create trigger TR_TEACHER_DEL1 
on TEACHER  after DELETE   
as 
declare @Id varchar(20), @Name varchar(50), @Gender varchar(1), @Pulpit varchar(15), @ins varchar(100);
print 'TR_TEACHER_DEL1'
	set @Id = (select TEACHER from DELETED)
	set @Name = (select TEACHER_NAME from DELETED)
	set @Gender = (select GENDER from DELETED)
	set @Pulpit = (select PULPIT from DELETED)
	set @ins = @Id + ' ' + @Name + ' ' + @Gender + ' ' + @Pulpit;
	insert into TR_AUDIT(STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL1', @ins);
go 
create trigger TR_TEACHER_DEL2 
on TEACHER  after DELETE   
as 
declare @Id varchar(20), @Name varchar(50), @Gender varchar(1), @Pulpit varchar(15), @ins varchar(100);
print 'TR_TEACHER_DEL2'
	set @Id = (select TEACHER from DELETED)
	set @Name = (select TEACHER_NAME from DELETED)
	set @Gender = (select GENDER from DELETED)
	set @Pulpit = (select PULPIT from DELETED)
	set @ins = @Id + ' ' + @Name + ' ' + @Gender + ' ' + @Pulpit;
	insert into TR_AUDIT(STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL2', @ins);
go 
create trigger TR_TEACHER_DEL3
on TEACHER  after DELETE   
as 
declare @Id varchar(20), @Name varchar(50), @Gender varchar(1), @Pulpit varchar(15), @ins varchar(100);
print 'TR_TEACHER_DEL3'
	set @Id = (select TEACHER from DELETED)
	set @Name = (select TEACHER_NAME from DELETED)
	set @Gender = (select GENDER from DELETED)
	set @Pulpit = (select PULPIT from DELETED)
	set @ins = @Id + ' ' + @Name + ' ' + @Gender + ' ' + @Pulpit;
	insert into TR_AUDIT(STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL3', @ins);
go 

-- блок показа всех триггеров табоицы
select t.name, e.type_desc 
         from sys.triggers  t 
		 join  sys.trigger_events e  on t.object_id = e.object_id  
								where OBJECT_NAME(t.parent_id) = 'TEACHER' and e.type_desc = 'DELETE';  

-- Изменение порядка выполнения триггеров выполняется с помощью си-стемных процедур
exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL3', 
	                        @order = 'First', @stmttype = 'DELETE';

exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL2', 
	                        @order = 'Last', @stmttype = 'DELETE';


insert into TEACHER values ('СПИ', 'Серджи Петя Иванович', 'м', 'ИСиТ')
insert into TEACHER values ('ААА', 'Антонио Антон Антонович', 'м', 'ИСиТ')
insert into TEACHER values ('ЕЖЖ', 'Евгеший Жека Женский', 'м', 'ИСиТ')

delete from TEACHER where TEACHER = 'СПИ'
delete from TEACHER where TEACHER = 'ААА'
delete from TEACHER where TEACHER = 'ЕЖЖ'

select * from TR_AUDIT

----------------------------------------------------------------------------------------------
drop trigger TR_TEACHER_DEL1
drop trigger TR_TEACHER_DEL2
drop trigger TR_TEACHER_DEL3

--7. Разработать сценарий, демонстрирующий на примере базы данных UNIVER
--утверждение: AFTER-триггер является частью транзакции, в рамках которого
--выполняется оператор, акти-визировавший триггер.

-- док-ть что after триггер явл-ся часть транз-ии в рамках которого вып-ся оператор активиз-й триггер
USE UNIVER
go

--drop trigger TR_TEACHER_INS;
create table TR_AUDIT
(
	ID int identity,
	STMT varchar(20) check (STMT in('INS', 'DEL', 'UPD')),
	TRNAME varchar(50),
	CC varchar(300)
)
------------------------------------------------------------------------------------------
go
create trigger TR_TEACHER_INS
on TEACHER after INSERT
as 
declare @Id varchar(20), @Name varchar(50), @Gender varchar(1), @Pulpit varchar(15), @ins varchar(100);
print 'Операция вставки'
set @Id = (select TEACHER from INSERTED)
set @Name = (select TEACHER_NAME from INSERTED)
set @Gender = (select GENDER from INSERTED)
set @Pulpit = (select PULPIT from INSERTED)

if (@Gender in ('м'))					--транзакция
begin
	raiserror('дефицит женщин', 10, 1);
	rollback;
end

set @ins = @Id + ' ' + @Name + ' ' + @Gender + ' ' + @Pulpit
insert into TR_AUDIT(STMT, TRNAME, CC) values ('INS', 'TR_TEACHER_INS', @ins);
return;
go
----------------------------------------------------------------------------------------
insert into TEACHER(TEACHER, TEACHER_NAME, GENDER, PULPIT)
	values('ИВНВ', 'Иванов Иван Иванович', 'м', 'ИСиТ');

select * from TR_AUDIT
----------------------------------------------------------------------------------------
drop trigger TR_TEACHER_INS

--8.  Для таблицы FACULTY создать IN-STEAD OF-триггер, запрещающий удаление строк в таблице. 
--Разработать сценарий, который демонстри-рует на примере базы данных UNIVER, 
--что проверка ограничения целостности выполнена, если есть INSTEAD OF-триггер.
--С помощью оператора DROP удалить все DML-триггеры, созданные в этой лабораторной работе.

-- разработать instead of триггер который заменяет удаление в AUDITORIUM_TYPE на сооб-е Удаление данных запрещено!
USE UNIVER;
go
create trigger TR_UNIVER_DELETE
on AUDITORIUM_TYPE instead of DELETE
as
	raiserror (N'Удаление данных запрещено!', 10, 1);
	return;
go

-------------------------------------
select * from AUDITORIUM_TYPE
delete from AUDITORIUM_TYPE where AUDITORIUM_TYPE = 'ЛК';
select * from AUDITORIUM_TYPE

--------------------------------------
drop trigger TR_UNIVER_DELETE


--9. Создать DDL-триггер, реагирующий на все DDL-события в БД UNIVER. 
--Триггер должен запрещать создавать новые таблицы и удалять 
--существующие. Свое вы-полнение триггер должен сопровождать сооб-щением,
--которое содержит: тип события, имя и тип объекта, а также пояснительный текст,
--в случае запрещения выполнения оператора. 
--Разработать сценарий, демонстрирующий работу триггера. 

-- показываем что создаем DDL триггер который запрещает удаление и создание таблиц
USE UNIVER;

go
create trigger DDL_UNIVER on database 
	for DDL_DATABASE_LEVEL_EVENTS  
as  
declare @t varchar(50)= EVENTDATA().value ('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)');
declare @t1 varchar(50)=EVENTDATA().value ('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)');
declare @t2 varchar(50)=EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)'); 
if @t1 = 'AUDITORIUM' 
begin
	print 'Тип события: '+@t;
	print 'Имя объекта: '+@t1;
	print 'Тип объекта: '+@t2;
	raiserror( N'операции с таблицами запрещены', 16, 1);  
	rollback;    
end;
--create table a(c int);
--alter table AUDITORIUM drop column AUDITORIUM;


DISABLE TRIGGER DDL_UNIVER ON DATABASE;
DROP TRIGGER DDL_UNIVER ON DATABASE;





