CREATE VIEW main_courses AS
SELECT c.title, c.price, c.photo, COUNT(uc.user_id) AS users_count 
FROM courses AS c
JOIN user_courses AS uc ON c.id = uc.course_id
GROUP BY uc.course_id
ORDER BY c.created_date DESC
LIMIT 6;

CREATE VIEW users_certificates AS
SELECT users.id, users.full_name,
(SELECT GROUP_CONCAT(DISTINCT courses.title ORDER BY certificates.issue_date DESC SEPARATOR '; ')) AS certificates
               
FROM users
JOIN certificates ON certificates.user_id = users.id
JOIN courses ON certificates.course_id = courses.id
WHERE users.is_active = true
GROUP BY users.id, users.full_name
ORDER BY users.full_name;