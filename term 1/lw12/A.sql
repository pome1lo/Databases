create table Transactions
(
	Counter int identity(1,1),
	Info nvarchar(20)
)
insert Transactions values ('—трока 1'),('—трока 2'),('—трока 3'),('—трока 4')

---------------------------- Task 4 A ----------------------------

--системна€ функци€ @@SPID возвращает системный идентификатор процесса, назначенный сервером текущему подключению
--Ќеподтвержденное чтение, Ќеповтор€ющеес€ чтение, ‘антомное чтение
-- uncomitted - поддерживает неподтвержденное чтение, т.е. запросы м/д t1 и t2 выполн€ютс€ даже без commit в B тран-ии
set transaction isolation level read uncommitted
begin tran
select * from Transactions
select count(*) from Transactions
--t1
select count(*) from Transactions
select * from Transactions
commit
--t2

---------------------------- Task 5 A ----------------------------
-- commited - запросы м/д t1 и t2 не будут работать пока мы не произведем commit в тран-и B
set transaction isolation level read committed
begin tran
select * from Transactions
select count(*) from Transactions
--t1
select * from Transactions
select count(*) from Transactions
commit
--t2
update Transactions set Info = '—трока 4' where Counter = 4
delete from Transactions where Info = '—трока 5'

---------------------------- Task 6 A ----------------------------
-- repeatable не допускает неподт и неповтор€ющегос€ чтени€ (если мы 
--измен€ем данные м/д двум€ операци€ми чтени€, то рез-т будет разным)
set transaction isolation level repeatable read
begin tran
select * from Transactions
select count(*) from Transactions
--t1
select * from Transactions
select count(*) from Transactions
commit
--
delete from Transactions where Info = '—трока 5'
--t2

---------------------------- Task 7 A ----------------------------
-- serializable не допускает фантомных зн-й, т.е. теперь при добавлении нового пол€ через тран B, оно не будет доб-с€ 
set transaction isolation level serializable
begin tran
select * from Transactions
select count(*) from Transactions
--t1
select * from Transactions
select count(*) from Transactions
commit
--t2