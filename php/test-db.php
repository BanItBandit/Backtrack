<?php

require __DIR__ . '/includes/db.php';
require __DIR__ . '/includes/auth.php';

$stmt = $pdo->prepare(
    'SELECT username, display_name FROM Users WHERE user_id = ?'
);

$stmt->execute([$_SESSION['user_id']]);

$user = $stmt->fetch();

echo "Logged in as: " . htmlspecialchars($user['username']);
echo "User Display Name: " . htmlspecialchars($user['display_name']);