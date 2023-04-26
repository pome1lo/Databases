SELECT Наименование FROM ТОВАРЫ
	WHERE (Цена > 1 AND Цена < 2)

SELECT НаименованиеТовара FROM ЗАКАЗЫ
	WHERE (ДатаДоставки = CONVERT(DATETIME, '2023-01-15 00:00:00', 102))

SELECT Заказчик FROM ЗАКАЗЫ
	WHERE (НаименованиеТовара = N'Молоко')

SELECT НомерЗаказа FROM ЗАКАЗЫ
	WHERE (Заказчик = N'Евпроопт')
	ORDER BY ДатаДоставки