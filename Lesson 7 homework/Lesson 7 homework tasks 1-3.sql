-- Задание 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

use shop;

INSERT INTO orders(user_id) VALUES (6); 

INSERT INTO
orders(user_id)
VALUES (1), (3);

INSERT INTO
orders_products(order_id, product_id)
VALUES (1, 1);

INSERT INTO orders_products(order_id, product_id)
VALUES (1, 1), (1, 2);


INSERT INTO orders_products(order_id, product_id)
VALUES (2, 1), (2, 2);


INSERT INTO orders_products(order_id, product_id, total)
VALUES (4, 1, 1), (4, 4, 3), (4, 5, 2);

SELECT id, name FROM users WHERE users.id IN (SELECT user_id FROM orders);

-- Задание 2. Выведите список товаров products и разделов catalogs, который соответствует товару.
SELECT 
	p.name,
    p.price,
    c.name
FROM
	catalogs as c
RIGHT JOIN
	products as p
ON
	c.id = p.catalog_id;
    
-- Задание 3. Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label 
-- содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.

CREATE TABLE IF NOT EXISTS flights(
id SERIAL PRIMARY KEY,
`from` VARCHAR(50) NOT NULL COMMENT 'en', 
`to` VARCHAR(50) NOT NULL COMMENT 'en'
);

CREATE TABLE  IF NOT EXISTS cities(
label VARCHAR(50) PRIMARY KEY COMMENT 'en', 
name VARCHAR(50) COMMENT 'ru'
);

INSERT INTO cities VALUES
('Moscow', 'Москва'),
('Saint Petersburg', 'Санкт-Петербург'),
('Omsk', 'Омск'),
('Tomsk', 'Томск'),
('Astrakhan', 'Астрахань');

INSERT INTO flights VALUES
(1, 'Moscow', 'Saint Petersburg'),
(2, 'Saint Petersburg', 'Omsk'),
(3, 'Omsk', 'Tomsk'),
(4, 'Tomsk', 'Astrakhan'),
(5, 'Astrakhan', 'Moscow');

SELECT 
	id, cities_from.name, cities_to.name 
FROM flights
LEFT JOIN 
	cities AS cities_from ON flights.from = cities_from.label
LEFT JOIN 
	cities AS cities_to ON flights.to = cities_to.label;

