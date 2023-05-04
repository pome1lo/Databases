--1. ����������� �������� �������� XML-��������� � ������ 
--PATH �� ������� TEACHER ��� �������������� ������� ����. 

-- ��� ������������� ������ PATH ������ ������� ��������������� ���������� � ������� ���������� ����� �������.
USE UNIVER
go
select TEACHER.TEACHER[���_�������������], TEACHER.TEACHER_NAME[���_�������������],TEACHER.GENDER[���], TEACHER.PULPIT[�������] 
	from TEACHER 
		where  TEACHER.PULPIT = '����'
	for xml PATH('TEACHER'), root('�������������_�������_����'), elements; --RAW('TEACHER')
go

--2. ����������� �������� �������� XML-��������� � ������ 
--AUTO �� ������ SELECT-������� � �������� AUDITORIUM � 
--AUDI-TORIUM_TYPE, ������� �������� ������-��� �������: 
--������������ ���������, �����-������� ���� ��������� �
--�����������. ����� ������ ���������� ���������. 

-- ����������� ������ AUTO ����������� � �������������� ��������. � ���� ������ ����� AUTO ��������� ��������� XML-�������� � 
-- �����-������ ��������� ���������.
USE UNIVER
select a.AUDITORIUM_NAME, at.AUDITORIUM_TYPENAME, a.AUDITORIUM_CAPACITY
		from AUDITORIUM a 
		Inner Join AUDITORIUM_TYPE at on at.AUDITORIUM_TYPE=a.AUDITORIUM_TYPE
			where a.AUDITORIUM_TYPE='��' 
for xml auto, 
root('����������_���������'), -- �������� ���
elements;
go 


--3. ����������� XML-��������, ���������� ������ � ����
--����� ������� �����������, ������� ������� �������� 
--� ������� SUBJECT. ����������� ��������, ����������� 
--������ � ����������� �� XML-��������� � �������-���� 
--�� � ������� SUBJECT. ��� ���� ��������� ��������� 
--������� OPENXML � ����������� INSERT� SELECT. 

-- ����������� ������� ������� ��������� ������ �� xml ����

USE UNIVER;
begin tran
declare @h int = 0, 
      @xml varchar(2000) = '<?xml version="1.0" encoding="windows-1251" ?>	
							<SUBJECTS> 
								<SUBJECT SUBJECT="���" SUBJECT_NAME="���������� ����������� �������" PULPIT="����" /> 
								<SUBJECT SUBJECT="����" SUBJECT_NAME="���������� ��������� � �������" PULPIT="��" /> 
								<SUBJECT SUBJECT="����" SUBJECT_NAME="��������������� ��������� � �������" PULPIT="���"  />  
							</SUBJECTS>'

exec sp_xml_preparedocument @h output, @xml;	 -- ���������� ��������� 
select * from openxml(@h, '/SUBJECTS/SUBJECT', 0)	--����������, ��������� XPATH � ����� ������������� �����, ��������-���� ����� ������ �������.    	
	with(SUBJECT char(10), SUBJECT_NAME varchar(100), PULPIT char(20))  -- ��������� ��������� ������������ ���-�  

insert into SUBJECT select * from openxml(@h, '/SUBJECTS/SUBJECT', 0)
	with(SUBJECT char(10), SUBJECT_NAME varchar(100), PULPIT char(20)) 

select * from SUBJECT where SUBJECT LIKE '%��'

exec sp_xml_removedocument @h          

rollback 

select * from SUBJECT

--4. ��������� ������� STUDENT �������-���� XML-���������,
--���������� ���������� ������ ��������: ����� � ����� 
--��������, ���-��� �����, ���� ������ � ����� ��������. 
--����������� ��������, � ������� ������� �������� INSERT,
--����������� ������ � XML-��������.�������� � ���� �� 
--�������� �������� UP-DATE, ���������� ������� INFO � 
--����� ������ ������� STUDENT � �������� SELECT, �����������
--�������������� �����, ����������� ��������������� �� ��-�����. 
--� SELECT-������� ������������ ������ QUERY � VALUEXML-����.

-- ����������� select ������ � xml �����
USE UNIVER
create table Students
(
	STUDENT nvarchar(100) primary key ,
	PasportData xml
);
 
insert into Students 
values ('�������� ���� ������',
		'<Pasport>
			<Sereal>MP</Sereal>
				<Number>22223333</Number>
				<PersonalNumber>124124124</PersonalNumber>
				<Date>15/05/2015</Date>
				<Addres>��.������������, �.110</Addres>
		</Pasport>'),
	   ('�������� ���� ���������',
		'<Pasport>
			<Sereal>MP</Sereal>
			<Number>1234555</Number>
			<PersonalNumber>9412412</PersonalNumber>
			<Date>01/04/2014</Date>
			<Addres>��.���������, �.53</Addres>
		</Pasport>')
 select Students.STUDENT,
		PasportData.value('(/Pasport/Sereal)[1]','varchar(5)')[����� ��������],
		PasportData.value('(/Pasport/Number)[1]','int')[����� ��������],
		PasportData.value('(/Pasport/PersonalNumber)[1]','varchar(100)')[������ �����],
		PasportData.value('(/Pasport/Date)[1]','date')[���� ������],
		PasportData.value('(/Pasport/Addres)[1]','varchar(100)')[����� ��������],
		PasportData.query('/Pasport') [���������� ������]
			from Students;

update Students 
	  set PasportData = '<Pasport>
							<Sereal>MM</Sereal>
							<Number>55666777</Number>
							<PersonalNumber>123456</PersonalNumber>
							<Date>16/06/2015</Date>
							<Addres>��.���������, �.53</Addres>
						</Pasport>'
				where PasportData.value('(/Pasport/Number)[1]','int')=1234555
 go
  select Students.STUDENT[Name],
		PasportData.value('(/Pasport/Sereal)[1]','varchar(5)')[����� ��������],
		PasportData.value('(/Pasport/Number)[1]','int')[����� ��������],
		PasportData.query('/Pasport') [���������� ������]
			from Students;



drop table Students

--5. �������� (ALTER TABLE) ������� STU-DENT � ���� ������ 
--UNIVER ����� �������, ����� �������� ��������������� ������� 
--� ������ INFO ���������������� ���������� XML-���� (XML
--SCHEMACOLLECTION), �������������� � ������ �����. �����������
--��������, ��������������� ���� � ������������� ������ 
--(��������� IN-SERT � UPDATE) � ������� INFO ������� 
--STUDENT, ��� ���������� ������, ��� � ����������.
--����������� ������ XML-����� � �������� �� � ��������� 
--aXML-���� � �� UNIVER.

-- ������� ���� INFO ������� �������������a�� ���������� XML-����
USE UNIVER;
create xml schema collection Studentss as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
		elementFormDefault="qualified"
		xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xs:element name="�������">
	<xs:complexType><xs:sequence>
	<xs:element name="�������" maxOccurs="1" minOccurs="1">
	<xs:complexType>
    <xs:attribute name="�����" type="xs:string" use="required" />
    <xs:attribute name="�����" type="xs:unsignedInt" use="required"/>
    <xs:attribute name="����"  use="required"  >
	<xs:simpleType>  <xs:restriction base ="xs:string">
	<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
	</xs:restriction>	</xs:simpleType>
    </xs:attribute>	</xs:complexType>
	</xs:element>
	<xs:element maxOccurs="3" name="�������" type="xs:unsignedInt"/>
	<xs:element name="�����">   <xs:complexType><xs:sequence>
	<xs:element name="������" type="xs:string" />
    <xs:element name="�����" type="xs:string" />
    <xs:element name="�����" type="xs:string" />
    <xs:element name="���" type="xs:string" />
    <xs:element name="��������" type="xs:string" />
</xs:sequence></xs:complexType>  </xs:element>
</xs:sequence></xs:complexType>
</xs:element>
</xs:schema>';

go
create table STUDENTSS
( 
	IDSTUDENT integer  identity(1000,1) 
		 constraint STUDENTSS_PK  primary key,
   IDGROUP integer constraint STUDENTSS_GROUP_FK
		 foreign key  references GROUPS(IDGROUP),        
  NAME nvarchar(100), 
  BDAY  date,
  STAMP timestamp,
  INFO     xml(STUDENTSS),    -- �������������� ������� XML-����
  FOTO   varbinary
);
go 

insert into STUDENTSS(INFO)
	values (
	'
	<�������>
			<������� �����="string" �����="sdsd" ����="27.04.2023">
				
				
			</�������>
			<�������>3752970942</�������>
			<�����>
				<������>���</������>
				<�����>�����</�����>
				<�����>�������</�����>
				<���>�����������</���>
				<��������>69</��������>
			</�����>
		</�������>
	'
	)

-- � �������, ��� ��� ��������� �� ����� Pasport
insert into STUDENTSS(INFO)
	values (
	'
	<Pasport>
			<Sereal>MP</Sereal>
				<Number>22223333</Number>
				<PersonalNumber>124124124</PersonalNumber>
				<Date>15/05/2015</Date>
				<Addres>��.������������, �.110</Addres>
		</Pasport>
	'
	)


drop table STUDENTSS;
drop xml schema collection Studentss