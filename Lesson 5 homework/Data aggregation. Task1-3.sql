use trial1;

-- Задание 1

SELECT ROUND(AVG((TO_DAYS(NOW()) - TO_DAYS(birthday_at)) / 365.25), 0) AS AVG_Age FROM users;


-- Задание 2

SELECT
	DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W') AS day,
	COUNT(*) AS total
FROM
	users
GROUP BY
	day
ORDER BY
	total;

-- Задание 3

CREATE TABLE integers(
    value SERIAL PRIMARY KEY
);

INSERT INTO integers VALUES (1), (2), (3), (4), (5);

SELECT ROUND(exp(SUM(log(value))), 0) AS factorial FROM integers;
