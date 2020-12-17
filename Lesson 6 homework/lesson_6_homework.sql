-- Задание 2. Найти человека, который больше всех общался с нашим пользователем.
-- Возьмем, к примеру, пользователя '14	Eliane	Emard'

use lesson_7;

select from_user_id, to_user_id from messages where to_user_id = 14;

-- Задание 3. Подсчитать общее количество лайков, которое получили 10 самых молодых пользователей.
SELECT COUNT(id) FROM users_likes WHERE user_id IN (
  SELECT * FROM (
    SELECT id FROM users ORDER BY birthday DESC LIMIT 10
    ) as total_likes_qty
);

-- Задание 4. Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT distinct if(
	(SELECT COUNT(id) FROM users_likes WHERE user_id IN (
		SELECT id FROM users WHERE gender="m")
	) 
	> 
	(SELECT COUNT(id) FROM users_likes WHERE user_id IN (
		SELECT id FROM users WHERE gender="f")
	), 
   'Мужчины', 'Женщины') as won
   from users;

-- Задание 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

SELECT user_id, sum(activities) as activities from (
(SELECT user_id, quantity as activities
FROM users_likes)
UNION
SELECT initiator_user_id as user_id, COUNT(*) as activities
FROM friend_requests
UNION
SELECT user_id, quantity as activities
FROM photo_likes
UNION
SELECT user_id, quantity as activities
FROM photo_likes
UNION
SELECT user_id, quantity as activities
FROM posts_likes
UNION
SELECT from_user_id, is_read as activities
FROM messages
)
AS JOPA
GROUP BY user_id
ORDER BY activities
LIMIT 10;







