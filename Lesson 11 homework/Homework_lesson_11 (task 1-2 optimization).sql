-- Оптимизация запросов

-- Задание 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs 
-- помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.

use shop;

CREATE TABLE logs (
  table_name VARCHAR(20) NOT NULL,
  pk_id INT UNSIGNED NOT NULL,
  name VARCHAR(255),
  created_at DATETIME DEFAULT NOW()
) ENGINE=ARCHIVE;

DROP TRIGGER IF EXISTS users_logs;
delimiter //
CREATE TRIGGER users_logs AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, pk_id, name)
	VALUES (NOW(), 'users', NEW.id, NEW.name);
END //
delimiter ;

-- пример вставки в таблицу users:
INSERT INTO users (name, birthday_at)
VALUES ('Васька Иванов', '1985-01-01');

DROP TRIGGER IF EXISTS catalogs_logs;
delimiter //
CREATE TRIGGER catalogs_logs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, pk_id, name)
	VALUES (NOW(), 'catalogs', NEW.id, NEW.name);
END //
delimiter ;

-- пример вставки в таблицу catalogs:
INSERT INTO catalogs (name)
VALUES ('Мониторы'), ('Клавиатуры');

DROP TRIGGER IF EXISTS products_logs;
delimiter //
CREATE TRIGGER products_logs AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, pk_id, name)
	VALUES (NOW(), 'products', NEW.id, NEW.name);
END //
delimiter ;

-- пример вставки в таблицу catalogs:
INSERT INTO products (name, description, price, catalog_id)
VALUES ('GE-FORCE-SUPER-PUPER', 'Лучшая материнская плата на свете', 47890, 2);

-- Задание 2. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.

DROP PROCEDURE IF EXISTS insert_into_users ;
delimiter //
CREATE PROCEDURE insert_into_users ()
BEGIN
	DECLARE m INT DEFAULT 1000000;
	WHILE m > 0 DO
		INSERT INTO users(name, birthday_at) VALUES (CONCAT('user_', m), NOW());
		SET m = m - 1;
	END WHILE;
END //
delimiter ;


-- для проверки

CALL insert_into_users();

SELECT name, birthday_at FROM users LIMIT 1000;


