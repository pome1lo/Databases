-- 1. Разработать сценарий, де-монстрирующий работу в ре-жиме неявной транзакции.
--Проанализировать пример, приведенный справа, в котором создается таблица Х, и 
--создать сценарий для другой таблицы.

-- Неявная транзакция продолжается до тех пор, пока не будет выполнен
-- оператор фиксации (COMMIT) или оператор отката (ROLLBACK) транзакции.

SET nocount on

IF exists(SELECT * FROM SYS.OBJECTS	WHERE OBJECT_ID = object_id(N'DBO.NewT')) -- есть ли таблмца NewT
	DROP TABLE NewT;	-- если есть то удаляем ее



DECLARE @c int, @flag char = 'c';

SET IMPLICIT_TRANSACTIONS ON --включили режим неявной транзакции

CREATE TABLE NewT	-- начало транзакции
(
	K int
);

INSERT NewT values (1), (2), (3);

SET @c = (SELECT count(*) FROM NewT);

	PRINT 'Количество строк в таблице NewT: ' + cast(@c as varchar(2));
	IF  @flag = 'c' COMMIT;		-- завершение транзакции: фиксация 
	ELSE ROLLBACK;				-- завершение транзакции: откат  

SET IMPLICIT_TRANSACTIONS OFF --выключаем режим неявной транзакции

IF exists(SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = object_id(N'DBO.NewT'))
	PRINT 'Таблица NewT есть';
ELSE 
	PRINT 'Таблицы NewT нет'



	UPDATE TEACHER SET GENDER='м'; 


--2. Разработать сценарий, де-монстрирующий свойство ато-марности явной 
--транзакции на примере базы данных UNIVER. В блоке CATCH предусмотреть 
--выдачу соответствующих сообщений об ошибках. Опробовать работу сценария 
--при использовании различных операторов модификации таблиц.

-- в случае если в try заполнение не получится, код перейдет в catch, выдаст ошибку и выполнится откат через rollback
-- доказали что работает св-во атомарности

USE UNIVER
DECLARE @trcount int
BEGIN TRY -- начало блока try
	BEGIN TRAN -- Переключение в режим явной транзакции
		DELETE AUDITORIUM_TYPE WHERE AUDITORIUM_TYPENAME = 'Новая лекционная';
		--DELETE AUDITORIUM_TYPE WHERE AUDITORIUM_TYPENAME = 'Самая новая лекционная';
		INSERT AUDITORIUM_TYPE VALUES ('ЛК-Н', 'Новая лекционная');
		INSERT AUDITORIUM_TYPE VALUES ('ЛК-Н', 'Новая лекционная');
		INSERT AUDITORIUM_TYPE VALUES ('ЛК-С', 'Самая новая лекционная');
		COMMIT TRAN;
	END TRY
BEGIN CATCH 
		PRINT 'Ошибка: ' + case -- PATINDEX определяет в строке позицию первого символа под-строки, заданную шаблоном
							WHEN error_number() = 2627 and patindex('%AUDITORIUM_TYPE_PK%', error_message()) > 0 -- 2627 - Ошибка дубл поля
								THEN 'дублирование типа аудитории'
						   else 'неизвестная ошибка: ' + cast(error_number() as varchar(5)) + error_message()
						   end;
	SET @trcount = @@TRANCOUNT  -- возвращает уровень вложенности транзакции (если больше 0 то тран не закончена)
	PRINT @trcount
	IF @@TRANCOUNT > 0 ROLLBACK TRAN;
END CATCH;

-- в итоге получится что так как тран не заверш (@trancount будет = 1), то произойдет откат и изменен insert не вступят в силу
-- также мы не примере показали работу св-ва атомарности: опер-ы изм-я включе в тран-ю либо все выполня-я, либо нет.

--3. Разработать сценарий, де-монстрирующий применение оператора SAVE TRAN 
--на при-мере базы данных UNIVER. В блоке CATCH предусмот-реть выдачу 
--соответствующих сообщений об ошибках. Опробовать работу сценария при 
--использовании различных контрольных точек и различных операторов модификации таб-лиц.

USE UNIVER;
DECLARE @point varchar(32);
BEGIN TRY
	BEGIN TRAN				--начало явной транзакции
		DELETE AUDITORIUM_TYPE WHERE AUDITORIUM_TYPENAME = 'Новая лекционная';
		SET @point = 'p1'; SAVE TRAN @point;	-- формируем контрольную точку транзакции.
		
		INSERT AUDITORIUM_TYPE VALUES ('ЛК-Н', 'Новая лекционная');
		SET @point = 'p2'; SAVE TRAN @point;
		
		INSERT AUDITORIUM_TYPE VALUES ('ЛК-Н', 'Новая лекционная');
		--INSERT AUDITORIUM_TYPE VALUES ('ЛК-НН', 'НоваяНовая лекционная');
	COMMIT TRAN;	-- фиксируем тран после второй КТ (@point = p2)
END TRY
BEGIN CATCH 
		PRINT 'Ошибка: ' + CASE 
						   WHEN error_number() = 2627 and patindex('%AUDITORIUM_TYPE_PK%', error_message()) > 0
							THEN 'дублирование типа аудитории'
							ELSE 'неизвестная ошибка: ' + cast(error_number() as varchar(5)) + error_message()
						   end;
	IF @@TRANCOUNT > 0
		begin 
			print 'контрольная точка: ' + @point;
			rollback tran @point;		--откат к контрольной точке
			commit tran;				--фиксация изменений, выпоолненных до контрольной точки
		end
END CATCH


--4. Разработать два сценария A и B на примере базы данных UNIVER. 
--Сценарий A представляет со-бой явную транзакцию с уров-нем изолированности
--READ UNCOMMITED, сценарий B – явную транзакцию с уровнем изолированности READ
--COM-MITED (по умолчанию). Сценарий A должен демон-стрировать, что уровень
--READ UNCOMMITED допускает не-подтвержденное, неповторяю-щееся и фантомное чтение. 

--5
--6
--7

--8. Разработать сценарий, де-монстрирующий свойства вло-женных
--транзакций, на примере базы данных UNIVER. 

begin tran 
	create table #Task8 (Num int identity, Words nvarchar(20))
	insert #Task8 values ('Пузиков'), ('Алексей'), ('Алексеевич')

	begin tran 
		insert #Task8 values ('Чупапи')
	commit tran --rollback tran 

 if exists (select Words from #Task8 where Words = 'Чупапи')
 commit tran 
 else rollback tran 
 select Num[Id], Words[Строки] from #Task8
drop table #Task8



BEGIN TRAN				--начало явной транзакции
		IF TEA
			