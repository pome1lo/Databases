-- 1. ����������� ��������, ��-������������� ������ � ��-���� ������� ����������.
--���������������� ������, ����������� ������, � ������� ��������� ������� �, � 
--������� �������� ��� ������ �������.

-- ������� ���������� ������������ �� ��� ���, ���� �� ����� ��������
-- �������� �������� (COMMIT) ��� �������� ������ (ROLLBACK) ����������.

SET nocount on

IF exists(SELECT * FROM SYS.OBJECTS	WHERE OBJECT_ID = object_id(N'DBO.NewT')) -- ���� �� ������� NewT
	DROP TABLE NewT;	-- ���� ���� �� ������� ��



DECLARE @c int, @flag char = 'c';

SET IMPLICIT_TRANSACTIONS ON --�������� ����� ������� ����������

CREATE TABLE NewT	-- ������ ����������
(
	K int
);

INSERT NewT values (1), (2), (3);

SET @c = (SELECT count(*) FROM NewT);

	PRINT '���������� ����� � ������� NewT: ' + cast(@c as varchar(2));
	IF  @flag = 'c' COMMIT;		-- ���������� ����������: �������� 
	ELSE ROLLBACK;				-- ���������� ����������: �����  

SET IMPLICIT_TRANSACTIONS OFF --��������� ����� ������� ����������

IF exists(SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = object_id(N'DBO.NewT'))
	PRINT '������� NewT ����';
ELSE 
	PRINT '������� NewT ���'



	UPDATE TEACHER SET GENDER='�'; 


--2. ����������� ��������, ��-������������� �������� ���-�������� ����� 
--���������� �� ������� ���� ������ UNIVER. � ����� CATCH ������������� 
--������ ��������������� ��������� �� �������. ���������� ������ �������� 
--��� ������������� ��������� ���������� ����������� ������.

-- � ������ ���� � try ���������� �� ���������, ��� �������� � catch, ������ ������ � ���������� ����� ����� rollback
-- �������� ��� �������� ��-�� �����������

USE UNIVER
DECLARE @trcount int
BEGIN TRY -- ������ ����� try
	BEGIN TRAN -- ������������ � ����� ����� ����������
		DELETE AUDITORIUM_TYPE WHERE AUDITORIUM_TYPENAME = '����� ����������';
		--DELETE AUDITORIUM_TYPE WHERE AUDITORIUM_TYPENAME = '����� ����� ����������';
		INSERT AUDITORIUM_TYPE VALUES ('��-�', '����� ����������');
		INSERT AUDITORIUM_TYPE VALUES ('��-�', '����� ����������');
		INSERT AUDITORIUM_TYPE VALUES ('��-�', '����� ����� ����������');
		COMMIT TRAN;
	END TRY
BEGIN CATCH 
		PRINT '������: ' + case -- PATINDEX ���������� � ������ ������� ������� ������� ���-������, �������� ��������
							WHEN error_number() = 2627 and patindex('%AUDITORIUM_TYPE_PK%', error_message()) > 0 -- 2627 - ������ ���� ����
								THEN '������������ ���� ���������'
						   else '����������� ������: ' + cast(error_number() as varchar(5)) + error_message()
						   end;
	SET @trcount = @@TRANCOUNT  -- ���������� ������� ����������� ���������� (���� ������ 0 �� ���� �� ���������)
	PRINT @trcount
	IF @@TRANCOUNT > 0 ROLLBACK TRAN;
END CATCH;

-- � ����� ��������� ��� ��� ��� ���� �� ������ (@trancount ����� = 1), �� ���������� ����� � ������� insert �� ������� � ����
-- ����� �� �� ������� �������� ������ ��-�� �����������: ����-� ���-� ������ � ����-� ���� ��� �������-�, ���� ���.

--3. ����������� ��������, ��-������������� ���������� ��������� SAVE TRAN 
--�� ���-���� ���� ������ UNIVER. � ����� CATCH ���������-���� ������ 
--��������������� ��������� �� �������. ���������� ������ �������� ��� 
--������������� ��������� ����������� ����� � ��������� ���������� ����������� ���-���.

USE UNIVER;
DECLARE @point varchar(32);
BEGIN TRY
	BEGIN TRAN				--������ ����� ����������
		DELETE AUDITORIUM_TYPE WHERE AUDITORIUM_TYPENAME = '����� ����������';
		SET @point = 'p1'; SAVE TRAN @point;	-- ��������� ����������� ����� ����������.
		
		INSERT AUDITORIUM_TYPE VALUES ('��-�', '����� ����������');
		SET @point = 'p2'; SAVE TRAN @point;
		
		INSERT AUDITORIUM_TYPE VALUES ('��-�', '����� ����������');
		--INSERT AUDITORIUM_TYPE VALUES ('��-��', '���������� ����������');
	COMMIT TRAN;	-- ��������� ���� ����� ������ �� (@point = p2)
END TRY
BEGIN CATCH 
		PRINT '������: ' + CASE 
						   WHEN error_number() = 2627 and patindex('%AUDITORIUM_TYPE_PK%', error_message()) > 0
							THEN '������������ ���� ���������'
							ELSE '����������� ������: ' + cast(error_number() as varchar(5)) + error_message()
						   end;
	IF @@TRANCOUNT > 0
		begin 
			print '����������� �����: ' + @point;
			rollback tran @point;		--����� � ����������� �����
			commit tran;				--�������� ���������, ������������ �� ����������� �����
		end
END CATCH


--4. ����������� ��� �������� A � B �� ������� ���� ������ UNIVER. 
--�������� A ������������ ��-��� ����� ���������� � ����-��� ���������������
--READ UNCOMMITED, �������� B � ����� ���������� � ������� ��������������� READ
--COM-MITED (�� ���������). �������� A ������ �����-����������, ��� �������
--READ UNCOMMITED ��������� ��-��������������, ����������-����� � ��������� ������. 

--5
--6
--7

--8. ����������� ��������, ��-������������� �������� ���-������
--����������, �� ������� ���� ������ UNIVER. 

begin tran 
	create table #Task8 (Num int identity, Words nvarchar(20))
	insert #Task8 values ('�������'), ('�������'), ('����������')

	begin tran 
		insert #Task8 values ('������')
	commit tran --rollback tran 

 if exists (select Words from #Task8 where Words = '������')
 commit tran 
 else rollback tran 
 select Num[Id], Words[������] from #Task8
drop table #Task8



BEGIN TRAN				--������ ����� ����������
		IF TEA
			