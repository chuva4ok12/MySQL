-- Задание 3

create table storehouses_products (
	id SERIAL PRIMARY KEY,
    storehouse_id INT unsigned,
    product_id INT unsigned,
    value INT unsigned,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO
    storehouses_products (storehouse_id, product_id, value)
VALUES
    (1, 1, 0),
    (1, 3, 2500),
    (1, 5, 0),
    (1, 7, 30),
    (1, 6, 500),
    (1, 8, 1);

SELECT 
    value
FROM
    storehouses_products ORDER BY CASE WHEN value = 0 then 1 else 0 end, value;

