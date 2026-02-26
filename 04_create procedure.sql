DELIMITER //

CREATE PROCEDURE get_user_social_info(
IN user_id INT
)

BEGIN

SELECT social_providers.name, user_social_providers.connect_url
FROM user_social_providers
JOIN users ON user_social_providers.user_id = users.id
JOIN social_providers ON user_social_providers.social_provider_id = social_providers.id
WHERE users.id = user_id
ORDER BY social_providers.name;

END //

DELIMITER ;
