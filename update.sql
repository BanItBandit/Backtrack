UPDATE Users
SET password_hash = '$2y$10$kcOWKpP10U7PqjJDeSOKfu4eWs5SRio7.Q7O4mZMc/q5wemOJh7Ie'
WHERE user_id = 1;

--After running, testuser can log in with the email test@example.com and the password password123
--Note: When we make this site go live this user must be destroyed or the password changed. This is just for testing purposes.