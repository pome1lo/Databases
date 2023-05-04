--1. Разработать сценарий создания XML-документа в режиме 
--PATH из таблицы TEACHER для преподавателей кафедры ИСиТ. 

-- При использовании режима PATH каждый столбец конфигурируется независимо с помощью псевдонима этого столбца.
USE UNIVER
go
select TEACHER.TEACHER[Код_преподавателя], TEACHER.TEACHER_NAME[Имя_преподавателя],TEACHER.GENDER[Пол], TEACHER.PULPIT[Кафедра] 
	from TEACHER 
		where  TEACHER.PULPIT = 'ИСиТ'
	for xml PATH('TEACHER'), root('Преподаватели_кафедры_ИСиТ'), elements; --RAW('TEACHER')
go

--2. Разработать сценарий создания XML-документа в режиме 
--AUTO на основе SELECT-запроса к таблицам AUDITORIUM и 
--AUDI-TORIUM_TYPE, который содержит следую-щие столбцы: 
--наименование аудитории, наиме-нование типа аудитории и
--вместимость. Найти только лекционные аудитории. 

-- Особенность режима AUTO проявляется в многотабличных запросах. В этом случае режим AUTO позволяет построить XML-фрагмент с 
-- приме-нением вложенных элементов.
USE UNIVER
select a.AUDITORIUM_NAME, at.AUDITORIUM_TYPENAME, a.AUDITORIUM_CAPACITY
		from AUDITORIUM a 
		Inner Join AUDITORIUM_TYPE at on at.AUDITORIUM_TYPE=a.AUDITORIUM_TYPE
			where a.AUDITORIUM_TYPE='ЛК' 
for xml auto, 
root('Лекционные_аудитории'), -- корневой тег
elements;
go 


--3. Разработать XML-документ, содержащий данные о трех
--новых учебных дисциплинах, которые следует добавить 
--в таблицу SUBJECT. Разработать сценарий, извлекающий 
--данные о дисциплинах из XML-документа и добавля-ющий 
--их в таблицу SUBJECT. При этом применить системную 
--функцию OPENXML и конструкцию INSERT… SELECT. 

-- разработать запросы которые извлекают данные из xml дока

USE UNIVER;
begin tran
declare @h int = 0, 
      @xml varchar(2000) = '<?xml version="1.0" encoding="windows-1251" ?>	
							<SUBJECTS> 
								<SUBJECT SUBJECT="РПР" SUBJECT_NAME="Разработка программных роботов" PULPIT="ИСиТ" /> 
								<SUBJECT SUBJECT="ИГИГ" SUBJECT_NAME="Инженерная геометрия и графика" PULPIT="ТЛ" /> 
								<SUBJECT SUBJECT="ПГИГ" SUBJECT_NAME="Полиграфическая геометрия и графика" PULPIT="ТиП"  />  
							</SUBJECTS>'

exec sp_xml_preparedocument @h output, @xml;	 -- подготовка документа 
select * from openxml(@h, '/SUBJECTS/SUBJECT', 0)	--дескриптор, выражение XPATH и целое положительное число, определя-ющее режим работы функции.    	
	with(SUBJECT char(10), SUBJECT_NAME varchar(100), PULPIT char(20))  -- указываем структуру формируемого рез-а  

insert into SUBJECT select * from openxml(@h, '/SUBJECTS/SUBJECT', 0)
	with(SUBJECT char(10), SUBJECT_NAME varchar(100), PULPIT char(20)) 

select * from SUBJECT where SUBJECT LIKE '%ИГ'

exec sp_xml_removedocument @h          

rollback 

select * from SUBJECT

--4. Используя таблицу STUDENT разрабо-тать XML-структуру,
--содержащую паспортные данные студента: серию и номер 
--паспорта, лич-ный номер, дата выдачи и адрес прописки. 
--Разработать сценарий, в который включен оператор INSERT,
--добавляющий строку с XML-столбцом.Включить в этот же 
--сценарий оператор UP-DATE, изменяющий столбец INFO у 
--одной строки таблицы STUDENT и оператор SELECT, формирующий
--результирующий набор, аналогичный представленному на ри-сунке. 
--В SELECT-запросе использовать методы QUERY и VALUEXML-типа.

-- разработать select запрос с xml доком
USE UNIVER
create table Students
(
	STUDENT nvarchar(100) primary key ,
	PasportData xml
);
 
insert into Students 
values ('Ивананов Иван Иваныч',
		'<Pasport>
			<Sereal>MP</Sereal>
				<Number>22223333</Number>
				<PersonalNumber>124124124</PersonalNumber>
				<Date>15/05/2015</Date>
				<Addres>ул.Первомайская, д.110</Addres>
		</Pasport>'),
	   ('Сырников Олег Яковлевич',
		'<Pasport>
			<Sereal>MP</Sereal>
			<Number>1234555</Number>
			<PersonalNumber>9412412</PersonalNumber>
			<Date>01/04/2014</Date>
			<Addres>ул.Свердлова, д.53</Addres>
		</Pasport>')
 select Students.STUDENT,
		PasportData.value('(/Pasport/Sereal)[1]','varchar(5)')[Серия паспорта],
		PasportData.value('(/Pasport/Number)[1]','int')[Номер паспорта],
		PasportData.value('(/Pasport/PersonalNumber)[1]','varchar(100)')[Личный номер],
		PasportData.value('(/Pasport/Date)[1]','date')[Дата выдачи],
		PasportData.value('(/Pasport/Addres)[1]','varchar(100)')[Адрес студента],
		PasportData.query('/Pasport') [Паспортные данные]
			from Students;

update Students 
	  set PasportData = '<Pasport>
							<Sereal>MM</Sereal>
							<Number>55666777</Number>
							<PersonalNumber>123456</PersonalNumber>
							<Date>16/06/2015</Date>
							<Addres>ул.Свердлова, д.53</Addres>
						</Pasport>'
				where PasportData.value('(/Pasport/Number)[1]','int')=1234555
 go
  select Students.STUDENT[Name],
		PasportData.value('(/Pasport/Sereal)[1]','varchar(5)')[Серия паспорта],
		PasportData.value('(/Pasport/Number)[1]','int')[Номер паспорта],
		PasportData.query('/Pasport') [Паспортные данные]
			from Students;



drop table Students

--5. Изменить (ALTER TABLE) таблицу STU-DENT в базе данных 
--UNIVER таким образом, чтобы значения типизированного столбца 
--с именем INFO контролировались коллекцией XML-схем (XML
--SCHEMACOLLECTION), представленной в правой части. Разработать
--сценарии, демонстрирующие ввод и корректировку данных 
--(операторы IN-SERT и UPDATE) в столбец INFO таблицы 
--STUDENT, как содержащие ошибки, так и правильные.
--Разработать другую XML-схему и добавить ее в коллекцию 
--aXML-схем в БД UNIVER.

-- сделать поле INFO таблицы контролировалaсь коллекцией XML-схем
USE UNIVER;
create xml schema collection Studentss as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
		elementFormDefault="qualified"
		xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xs:element name="студент">
	<xs:complexType><xs:sequence>
	<xs:element name="паспорт" maxOccurs="1" minOccurs="1">
	<xs:complexType>
    <xs:attribute name="серия" type="xs:string" use="required" />
    <xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
    <xs:attribute name="дата"  use="required"  >
	<xs:simpleType>  <xs:restriction base ="xs:string">
	<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
	</xs:restriction>	</xs:simpleType>
    </xs:attribute>	</xs:complexType>
	</xs:element>
	<xs:element maxOccurs="3" name="телефон" type="xs:unsignedInt"/>
	<xs:element name="адрес">   <xs:complexType><xs:sequence>
	<xs:element name="страна" type="xs:string" />
    <xs:element name="город" type="xs:string" />
    <xs:element name="улица" type="xs:string" />
    <xs:element name="дом" type="xs:string" />
    <xs:element name="квартира" type="xs:string" />
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
  INFO     xml(STUDENTSS),    -- типизированный столбец XML-типа
  FOTO   varbinary
);
go 

insert into STUDENTSS(INFO)
	values (
	'
	<студент>
			<паспорт серия="string" номер="sdsd" дата="27.04.2023">
				
				
			</паспорт>
			<телефон>3752970942</телефон>
			<адрес>
				<страна>США</страна>
				<город>Минск</город>
				<улица>Пушкина</улица>
				<дом>Калатушкина</дом>
				<квартира>69</квартира>
			</адрес>
		</студент>
	'
	)

-- с ошибкой, так как валидатор не видит Pasport
insert into STUDENTSS(INFO)
	values (
	'
	<Pasport>
			<Sereal>MP</Sereal>
				<Number>22223333</Number>
				<PersonalNumber>124124124</PersonalNumber>
				<Date>15/05/2015</Date>
				<Addres>ул.Первомайская, д.110</Addres>
		</Pasport>
	'
	)


drop table STUDENTSS;
drop xml schema collection Studentss