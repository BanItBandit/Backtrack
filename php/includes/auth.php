<?php
// Session handling and access checks. Include after db.php on protected pages.
//
//   require __DIR__ . '/includes/db.php';
//   require __DIR__ . '/includes/auth.php';
//   require_login();            // any logged-in user
//   require_admin($pdo);        // admins only

session_start();

function require_login(): void
{
    if (empty($_SESSION['user_id'])) {
        header('Location: login.php');
        exit;
    }
}

function require_admin(PDO $pdo): void
{
    require_login();

    $stmt = $pdo->prepare('SELECT is_admin FROM Users WHERE user_id = ?');
    $stmt->execute([$_SESSION['user_id']]);

    if (!$stmt->fetchColumn()) {
        http_response_code(403);
        exit('You do not have access to this page.');
    }
}