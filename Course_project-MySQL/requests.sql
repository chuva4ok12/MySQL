use contract_supervision;

-- средний возраст персонала, оказывающего ШМУ
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday, NOW())), 0) AS AVG_Age FROM personnel;

-- топ 5 самых долгих по реализации проектов

SELECT project_number, ROUND(TIMESTAMPDIFF(month, started_at, completed_at), 0) AS period FROM projects order by period desc limit 5;

-- Выведем список сотрудников, занятых на проекте NU15003.
SELECT COUNT(*) as NU15003_persons FROM personnel WHERE project_id = 9;

-- Определим 5 самых затратных проектов с точки зрения расходов на проживание
SELECT 
	p.project_number,
    city_of_project,
    exp.habitation_costs
FROM 
	projects as p
JOIN
	expenditure as exp
ON
	p.id = exp.project_id
order by habitation_costs desc limit 5;
	
-- Выберем 5 сотрудников, оказывающих ШМУ, которые родились после 01.01.1984
select name, surname, birthday from personnel where birthday > '1984-01-01'; 

-- Посмотрим, у каких приборов истекает срок поверки только после 2022 года
SELECT name, calibration_date_before FROM equipment group by calibration_date_before having calibration_date_before > '2022-01-01';

-- Выберем работников, у которых затраты на проезд оказались выше средней величины этой статьи расходов
SELECT 
    employer_id,
    journey_costs
FROM expenditure
WHERE
	journey_costs > (SELECT AVG(journey_costs) FROM expenditure);

-- определяем суммарные затраты по каждому проекту
SELECT 
	p.id,
    p.project_number,
    (journey_costs + food + habitation_costs) as costs
FROM 
	projects as p
JOIN
	expenditure as exp
ON 
	p.id = exp.project_id;

-- На каких трех проектах монтажная организация задействовала больше всего персонала
SELECT 
	p.id,
    p.project_number,
    e_c.company_name,
    (workers_quantity + engineers_quantity) as workers_qty
FROM 
	projects as p
JOIN
	erection_company as e_c
ON 
	p.id = e_c.project_id
    order by workers_quantity desc limit 3;
    

-- Сделаем пару представлений
-- 1) Посмотрим, на каких проектах отзывы заказчика были превосходными
CREATE VIEW good_feedback as
SELECT project_id, quality, relationship, observance_of_a_treaty
FROM customer_feedback where quality = 'excellent' and relationship = 'excellent' and observance_of_a_treaty = 'excellent';

SELECT * from good_feedback;

-- 2) Посмотрим, кто из персонала в каких гостиницах жил
CREATE VIEW residence_detail as 
SELECT 
	CONCAT(name, ' ', surname) as employer,
    r_d.hotel_name,
    r_d.city_of_residence
FROM 
	personnel as p
JOIN
	residence_data as r_d
ON 
	p.id = r_d.employer_id;

SELECT * from residence_detail;


-- Создадим несколько триггеров

-- 1) Запретить добавление в таблицу equipment оборудования с истекшим сроком поверки

DROP TRIGGER IF EXISTS equipment_calibration;
delimiter //
CREATE TRIGGER equipment_calibration BEFORE INSERT ON equipment FOR EACH ROW
BEGIN
  IF NEW.calibration_date_before < NOW()
    THEN SIGNAL sqlstate '45000' SET message_text = "you are trying to insert item with expired date of calibration"; 
  END IF;
END //

-- запрос для проверки реализации триггера:
INSERT INTO equipment (employer_id, name, serial_number, calibration_date_before) VALUES
  ('3', 'Штангенциркуль 150 мм Калибр', '156757293', '2018-06-01');
  
  -- 2) Запрет на введение пустых данных об отзывах заказчика из таблицы customer_feedback
  
DROP TRIGGER IF EXISTS feedback_data;
delimiter //
CREATE TRIGGER feedback_data BEFORE INSERT ON customer_feedback FOR EACH ROW
BEGIN
  IF NEW.quality or NEW.relationship or NEW.observance_of_a_treaty IS NULL
    THEN SIGNAL sqlstate '45000' SET message_text = "don't add blank cells"; 
  END IF;
END //

-- запрос для проверки реализации триггера:
INSERT INTO customer_feedback (project_id, quality, relationship, observance_of_a_treaty) VALUES
	('1', 'excellent', 'satisfactory', NULL);

-- Создадим функцию, позволяющую узнать возраст персонала
DROP FUNCTION IF EXISTS AGE;
DELIMITER //
CREATE FUNCTION AGE (p_id INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE Y INT;
    SET Y = (SELECT timestampdiff(year, birthday, now()) FROM personnel where id = p_id);
	RETURN Y;  
END //

SELECT AGE(2);

-- Создадим процедуру, выводящую кто из персонала в каком городе жил
DROP PROCEDURE IF EXISTS resident;
DELIMITER //
CREATE PROCEDURE resident (in resident_id INT)
BEGIN
	SELECT 
		CONCAT(name, ' ', surname) as employer,
		r_d.hotel_name,
		r_d.city_of_residence
	FROM 
		personnel as p
	JOIN
		residence_data as r_d
	ON 
		p.id = r_d.employer_id
		where r_d.employer_id = resident_id;
END //

CALL resident (9);


