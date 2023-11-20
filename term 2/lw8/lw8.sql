--SET SERVEROUTPUT ON;
--TASK 1
BEGIN
    NULL;
end;

--TASK 2

BEGIN
  DBMS_OUTPUT.PUT_LINE('Hello World!');
END;
/ -- sqlplus

--TASK 3
DECLARE
  my_var NUMBER;
BEGIN
  my_var := 1 / 0;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
    DBMS_OUTPUT.PUT_LINE('Код ошибки: ' || SQLCODE);
END;

--TASK 4
DECLARE
  my_var NUMBER;
BEGIN
  BEGIN
    my_var := 1 / 0;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Внутренняя ошибка: ' || SQLERRM);
  END;

  my_var := 'abc';
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Внешняя ошибка: ' || SQLERRM);
END;

--TASK 5

-- ALL: Применяет квалификатор ко всем сообщениям с предупреждениями1.

-- SEVERE: Применяет квалификатор только к тем сообщениям с предупреждениями,
-- которые находятся в категории SEVERE (серьезные)1.

-- INFORMATIONAL: Применяет квалификатор только к тем сообщениям с предупреждениями,
-- которые находятся в категории INFORMATIONAL (информационные)1.

-- PERFORMANCE: Применяет квалификатор только к тем сообщениям с предупреждениями, которые
-- находятся в категории PERFORMANCE (производительность)1.

-- --TASK 6

BEGIN
  DBMS_OUTPUT.PUT_LINE('Специальные символы в PL/SQL включают:');
  DBMS_OUTPUT.PUT_LINE('+ - * /');
  DBMS_OUTPUT.PUT_LINE(':= . @ % ;');
  DBMS_OUTPUT.PUT_LINE('() [] {}');
  DBMS_OUTPUT.PUT_LINE('< > = <= >= <> !=');
  DBMS_OUTPUT.PUT_LINE('||');
  DBMS_OUTPUT.PUT_LINE('AND OR NOT');
END;
/


-- --TASK 7
-- --TASK 8
-- --TASK 9, 10, 11, 12, 13, 14, 15, 16, 17

DECLARE
  num1 NUMBER := 10;
  num2 NUMBER := 20;
  result NUMBER;

  fixed_num1 NUMBER(5,2) := 123.45; -- с фиксированной точкой
  fixed_num2 NUMBER(5,2) := 67.89;

  --  с фиксированной точкой и отрицательным масштабом
  neg_scale_num NUMBER(5,-2) := 12345;

  -- BINARY_FLOAT
  float_num BINARY_FLOAT := 123.45;

  -- BINARY_DOUBLE
  double_num BINARY_DOUBLE := 123.45;

  -- E
  e_num NUMBER := 1.23E-4;

  -- BOOLEAN
  bool_var BOOLEAN := TRUE;
BEGIN
  result := num1 + num2;
  DBMS_OUTPUT.PUT_LINE('Сумма: ' || result);

  result := num1 - num2;
  DBMS_OUTPUT.PUT_LINE('Разность: ' || result);

  result := num1 * num2;
  DBMS_OUTPUT.PUT_LINE('Произведение: ' || result);

  result := num1 / num2;
  DBMS_OUTPUT.PUT_LINE('Частное: ' || result);

  result := MOD(num1, num2);
  DBMS_OUTPUT.PUT_LINE('Остаток от деления: ' || result);
END;
/

--TASK 18
DECLARE
  CONST_VARCHAR2 CONSTANT VARCHAR2(100) := 'Hello, World!';
  CONST_CHAR CONSTANT CHAR(1) := 'A';
  CONST_NUMBER CONSTANT NUMBER := 123;

  -- Переменные для демонстрации операций
  var1 VARCHAR2(100);
  var2 NUMBER;
BEGIN
  -- Конкатенация строк
  var1 := CONST_VARCHAR2 || ' ' || CONST_CHAR;
  DBMS_OUTPUT.PUT_LINE('Конкатенация строк: ' || var1);

  -- Арифметические операции
  var2 := CONST_NUMBER * 2;
  DBMS_OUTPUT.PUT_LINE('Удвоенное значение CONST_NUMBER: ' || var2);
END;
/

--TASK 19
DECLARE
  -- Объявление переменных с использованием %TYPE
  v_faculty FACULTY.FACULTY%TYPE;
  v_faculty_name FACULTY.FACULTY_NAME%TYPE;
  v_pulpit PULPIT.PULPIT%TYPE;
  v_pulpit_name PULPIT.PULPIT_NAME%TYPE;
  v_teacher TEACHER.TEACHER%TYPE;
  v_teacher_name TEACHER.TEACHER_NAME%TYPE;
BEGIN
  -- Предположим, что мы выбираем данные из таблиц
  SELECT FACULTY, FACULTY_NAME INTO v_faculty, v_faculty_name FROM FACULTY WHERE ROWNUM = 1;
  SELECT PULPIT, PULPIT_NAME INTO v_pulpit, v_pulpit_name FROM PULPIT WHERE ROWNUM = 1;
  SELECT TEACHER, TEACHER_NAME INTO v_teacher, v_teacher_name FROM TEACHER WHERE ROWNUM = 1;

  -- Вывод результатов
  DBMS_OUTPUT.PUT_LINE('FACULTY: ' || v_faculty || ', FACULTY_NAME: ' || v_faculty_name);
  DBMS_OUTPUT.PUT_LINE('PULPIT: ' || v_pulpit || ', PULPIT_NAME: ' || v_pulpit_name);
  DBMS_OUTPUT.PUT_LINE('TEACHER: ' || v_teacher || ', TEACHER_NAME: ' || v_teacher_name);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Нет данных.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Произошла ошибка: ' || SQLERRM);
END;
/

--TASK 20
DECLARE
  rec FACULTY%ROWTYPE;
BEGIN
  SELECT * INTO rec FROM FACULTY WHERE FACULTY = 'ТОВ';
  DBMS_OUTPUT.PUT_LINE('FACULTY: ' || rec.FACULTY);
  DBMS_OUTPUT.PUT_LINE('FACULTY_NAME: ' || rec.FACULTY_NAME);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Нет данных.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Произошла ошибка: ' || SQLERRM);
END;
/

--TASK 21

DECLARE
  num NUMBER := 10;
BEGIN
  -- IF-THEN
  IF num > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Число положительное.');
  END IF;

  -- IF-THEN-ELSE
  IF num > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Число положительное.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Число не положительное.');
  END IF;

  -- IF-THEN-ELSIF
  IF num > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Число положительное.');
  ELSIF num < 0 THEN
    DBMS_OUTPUT.PUT_LINE('Число отрицательное.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Число равно нулю.');
  END IF;
END;
/

--TASK 22
DECLARE
  num NUMBER := 10;
  result VARCHAR2(50);
BEGIN
  CASE
    WHEN num > 0 THEN result := 'Число положительное.';
    WHEN num < 0 THEN result := 'Число отрицательное.';
    ELSE result := 'Число равно нулю.';
  END CASE;
  DBMS_OUTPUT.PUT_LINE(result);
END;
/

--TASK 23
DECLARE
  num NUMBER := 1;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE('Итерация: ' || num);
    num := num + 1;
    EXIT WHEN num > 5;
  END LOOP;
END;
/

--TASK 24
DECLARE
  num NUMBER := 1;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE('Итерация: ' || num);
    num := num + 1;
    EXIT WHEN num > 5;
  END LOOP;
END;
/


--TASK 25
DECLARE
  num NUMBER := 1;
BEGIN
  WHILE num <= 5 LOOP
    DBMS_OUTPUT.PUT_LINE('Итерация: ' || num);
    num := num + 1;
  END LOOP;
END;
/

--TASK 26

BEGIN
  FOR num IN 1..5 LOOP
    DBMS_OUTPUT.PUT_LINE('Итерация: ' || num);
  END LOOP;
END;
/