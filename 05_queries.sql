-- Запрос, который выведет id, полные имена пользователей и количество курсов (courses_count) у каждого пользователя.

SELECT users.id, users.full_name, COUNT(user_courses.course_id) AS courses_count
FROM users

LEFT JOIN user_courses ON users.id = user_courses.user_id
WHERE users.is_active = TRUE
GROUP BY users.id
ORDER BY courses_count DESC, full_name;

-- Запрос, который выведет информацию об активных пользователях (поле is_active).

SELECT id, full_name, CASE
WHEN 
 (SELECT COUNT(*)
						FROM user_courses
                        WHERE users.id = user_courses.user_id					
                        )  >= 3 THEN 'Высокая активность'
WHEN (SELECT COUNT(*)
						FROM user_courses
                        WHERE users.id = user_courses.user_id					
                        )  = 2 THEN 'Средняя активность'
ELSE 'Низкая активность'
                        END AS activity_level     
                        
FROM users
WHERE is_active = TRUE
ORDER BY full_name;

/* Запрос к таблице certificatesn(ее отрывок приведен выше), который выведет количество полученных сертификатов (number_of_certificates)
 и перечисление id пройденных курсов (completed_courses), сгруппированных по id пользователей (user_id)*/

SELECT user_id, COUNT(course_id) AS number_of_certificates, GROUP_CONCAT(course_id ORDER BY issue_date  SEPARATOR '; ') AS completed_courses
FROM certificates
GROUP BY user_id
ORDER BY number_of_certificates DESC, user_id DESC
LIMIT 10;

--  Запрос, который к каждому отзыву на курс, будет показывать комментарий
SELECT course_id, text, CASE
						WHEN  course_reviews.comment_id IS NULL THEN 'Нет комментария'
                        ELSE (SELECT comments.text
							FROM comments
                            WHERE course_reviews.comment_id = comments.user_id)
                        END AS comment
FROM course_reviews;

--  Запрос, который выведет количество курсов, созданных в каждом месяце (по дате created_date)
SELECT 
    DATE_FORMAT(created_date, '%Y-%m') AS month_year,
    COUNT(id) AS course_count
FROM courses
GROUP BY month_year
ORDER BY month_year;

-- Запрос выведет имена пользователей и количество их сертификатов, но только тех, у кого сертификатов больше 3
SELECT u.full_name, COUNT(c.course_id) AS cert_count
FROM users AS u
JOIN certificates AS c ON u.id = c.user_id
GROUP BY c.user_id
HAVING cert_count >= 3
ORDER BY cert_count DESC;

-/*Запрос выведет имена пользователей и названия курсов, по которым они оставили отзыв (course_reviews),
 но при этом у них нет сертификата (certificates) по этому же курсу*/
 SELECT u.full_name, c.title
FROM users AS u
 JOIN course_reviews AS c_r ON c_r.user_id = u.id
 JOIN courses AS c ON c_r.course_id = c.id
WHERE NOT EXISTS (SELECT 1 FROM certificates AS cert 
				WHERE cert.user_id = u.id AND cert.course_id = c.id);
                
-- Запрос выведет пользователей с самым высоким рейтингом среди тех, у кого больше 2 сертификатов
SELECT u.full_name
FROM users AS u
JOIN certificates AS c ON c.user_id = u.id
GROUP BY c.user_id
HAVING COUNT(c.course_id) > 2ж




