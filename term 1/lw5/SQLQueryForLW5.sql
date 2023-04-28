-- 1. На основе таблиц FACULTY, PULPIT и PROFESSION сформировать список наименований кафедр, которые находятся 
-- на факультете, обеспечивающем подготовку по специальности, в наименовании которого содержится слово технология 
-- или технологии. Использовать в секции WHERE предикат IN c некоррелированным подзапросом к таблице PROFESSION. 
USE UNIVER;
SELECT PULPIT.PULPIT_NAME AS [Наименование кафедры], FACULTY.FACULTY_NAME AS [Наименование факультета] FROM PULPIT, FACULTY INNER JOIN PROFESSION 
ON FACULTY.FACULTY = PROFESSION.FACULTY
	WHERE PULPIT.FACULTY = FACULTY.FACULTY AND
		PROFESSION.PROFESSION_NAME in (SELECT PROFESSION.PROFESSION_NAME FROM PROFESSION
					WHERE (PROFESSION.PROFESSION_NAME LIKE '%технология%') OR 
						  (PROFESSION.PROFESSION_NAME LIKE '%технологии%'))

-- 2. Переписать запрос пункта 1 таким образом, чтобы тот же подзапрос был записан в конструкции INNER JOIN секции 
-- FROM внешнего запроса. При этом результат выполнения запроса должен быть аналогичным результату исходного запроса. 

USE UNIVER;
SELECT PULPIT.PULPIT_NAME AS [Наименование кафедры], FACULTY.FACULTY_NAME AS [Наименование факультета] 
  FROM FACULTY INNER JOIN PULPIT
	ON FACULTY.FACULTY = PULPIT.FACULTY
		INNER JOIN PROFESSION ON PROFESSION.FACULTY = FACULTY.FACULTY
					WHERE (PROFESSION.PROFESSION_NAME LIKE '%технология%') OR 
						  (PROFESSION.PROFESSION_NAME LIKE '%технологии%')



-- 3. Переписать запрос, реализующий 1 пункт без использования подзапроса. Примечание: использовать соединение INNER JOIN трех таблиц. 					

USE UNIVER;
SELECT PULPIT.PULPIT_NAME AS [Наименование кафедры], FACULTY.FACULTY_NAME AS [Наименование факультета] FROM PULPIT, FACULTY INNER JOIN PROFESSION 
ON FACULTY.FACULTY = PROFESSION.FACULTY
	WHERE PULPIT.FACULTY = FACULTY.FACULTY AND
		(PROFESSION.PROFESSION_NAME LIKE '%технология%' OR 
		PROFESSION.PROFESSION_NAME LIKE '%технологии%')


-- 4. На основе таблицы AUDITORIUM сформировать список аудиторий самых больших вместимостей для каждого типа аудитории. При этом
-- результат следует отсортировать в порядке убывания вместимости. Примечание: использовать коррелируемый подзапрос c секциями TOP и ORDER BY. 

USE UNIVER;
SELECT AUDITORIUM.AUDITORIUM_NAME AS [Название], AUDITORIUM.AUDITORIUM_CAPACITY AS [Вместимость], AUDITORIUM.AUDITORIUM_TYPE AS [Тип] FROM AUDITORIUM
	WHERE AUDITORIUM.AUDITORIUM_CAPACITY = (SELECT TOP(1) AUDITORIUM.AUDITORIUM_CAPACITY FROM AUDITORIUM
		WHERE AUDITORIUM.AUDITORIUM_CAPACITY = AUDITORIUM.AUDITORIUM_CAPACITY
		ORDER BY AUDITORIUM.AUDITORIUM_TYPE DESC)

-- 5. На основе таблиц FACULTY и PULPIT сформировать список наименований факультетов на котором нет ни одной кафедры (таблица PULPIT). 
-- Использовать предикат EXISTS и коррелированный подзапрос. 

USE UNIVER;
SELECT FACULTY.FACULTY_NAME AS [Наименование факультета] FROM FACULTY
	WHERE NOT EXISTS (SELECT * FROM PULPIT
		WHERE PULPIT.FACULTY = FACULTY.FACULTY) -- таких нет как я понял



-- 6. На основе таблицы PROGRESS сформировать строку, содержащую средние значения оценок (столбец NOTE) по дисциплинам,
-- имеющим следующие коды: ОАиП, БД и СУБД. Примечание: использовать три некоррелированных подзапроса в списке SELECT; 
-- в подзапросах применить агрегатные функции AVG. 

USE UNIVER;
SELECT TOP 1 
	(SELECT AVG(NOTE) FROM PROGRESS
		WHERE PROGRESS.SUBJECT LIKE 'ОАиП')[ОАиП],
	(SELECT AVG(NOTE) FROM PROGRESS
		WHERE PROGRESS.SUBJECT LIKE 'БД')[БД],
	(SELECT AVG(NOTE) FROM PROGRESS
		WHERE PROGRESS.SUBJECT LIKE 'СУБД')[СУБД]
FROM PROGRESS



-- 7. Разработать SELECT-запрос, демонстрирующий способ применения ALL совместно с подзапросом
USE UNIVER;
SELECT PROGRESS.NOTE, PROGRESS.SUBJECT FROM PROGRESS 
	WHERE NOTE >=ALL(SELECT PROGRESS.NOTE FROM PROGRESS
		WHERE PROGRESS.SUBJECT LIKE 'ОАиП')



-- 8. Разработать SELECT-запрос, демонстрирующий принцип применения ANY совместно с подзапросом.

-- Определить наименования товаров, цены продажи которых превышают хотя бы одно значение 
-- цены продажи товаров, наименования которых начинаются на букву ‘с’:
USE Puzikov_MyBase;
SELECT PRODUCT_.ProductName, PRODUCT_.Price FROM PRODUCT_
	WHERE PRODUCT_.Price >=ANY (SELECT	PRODUCT_.Price FROM PRODUCT_
		WHERE PRODUCT_.ProductName LIKE 'M%'); 







































		-- PAA_MyBase
-- 1 На основе таблиц ORDERS , BUYER , PRODUCT сформировать список наименований товаров, которые находятся указаны в заказе,
-- у покупателей которых в имене встречается Alex
USE Puzikov_MyBase;
SELECT PRODUCT_.ProductName AS [Наименование товара], BUYER_.Name_ AS [Имя покупателя] FROM PRODUCT_, BUYER_ INNER JOIN ORDERS_ 
ON ORDERS_.Telephone = BUYER_.Telephone
	WHERE PRODUCT_.ProductName = ORDERS_.ProductName AND
		BUYER_.Name_ in (SELECT BUYER_.Name_ FROM BUYER_
					WHERE (BUYER_.Name_ LIKE '%Alex%'))

-- PAA_MyBase
-- 2 Тоже самое только с INNER JOIN секции FROM внешнего запроса
USE Puzikov_MyBase;
SELECT PRODUCT_.ProductName AS [Наименование товара], BUYER_.Name_ AS [Имя покупателя] 
	FROM PRODUCT_ INNER JOIN ORDERS_
	ON PRODUCT_.ProductName = ORDERS_.ProductName
		INNER JOIN BUYER_ 
		ON ORDERS_.Telephone = BUYER_.Telephone
			WHERE PRODUCT_.ProductName = ORDERS_.ProductName AND BUYER_.Name_ in (SELECT BUYER_.Name_ FROM BUYER_
					WHERE (BUYER_.Name_ LIKE '%Alex%'))


					-- PAA_MyBase
-- На основе таблиц ORDERS и PRODUCT сформировать список номер заказов на те продуткы у которых нет описания.

USE Puzikov_MyBase;
SELECT ORDERS_.OrderNumber AS [Номер заказа] FROM ORDERS_ -------- ??????????????????????????????//////
	WHERE NOT EXISTS (SELECT * FROM PRODUCT_
		WHERE PRODUCT_.ProductName = ORDERS_.ProductName)



		--PAA_MyBase
-- Получить общее колиество заказов для дат в мае и июне

USE Puzikov_MyBase;
SELECT TOP 1 
	(SELECT COUNT(ORDERS_.OrderNumber) FROM ORDERS_ 
		WHERE DateOfTheTransaction LIKE '%2022-05%')[2022-05],
	(SELECT COUNT(ORDERS_.OrderNumber) FROM ORDERS_ 
		WHERE DateOfTheTransaction LIKE '%2022-06%')[2022-02]
FROM ORDERS_


-- наименования товаров, цены продажи которых превышают или равны значениям цен товаров, 
-- наименования которых начинаются на букву ‘с’:
USE Puzikov_MyBase;
SELECT PRODUCT_.ProductName, PRODUCT_.Price FROM PRODUCT_
	WHERE PRODUCT_.Price >=ALL (SELECT	PRODUCT_.Price FROM PRODUCT_
		WHERE PRODUCT_.ProductName LIKE 'C%');