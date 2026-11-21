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

// ---- JSON endpoint helpers -------------------------------------------

function json_error(int $code, string $message): void
{
    http_response_code($code);
    header('Content-Type: application/json');
    exit(json_encode(['error' => $message]));
}

function csrf_token(): string
{
    if (empty($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf_token'];
}

function require_csrf(): void
{
    $sent = $_POST['csrf_token'] ?? '';
    if (!hash_equals(csrf_token(), $sent)) {
        json_error(403, 'Invalid request token');
    }
}

// For endpoints that only read data (GET).
function require_api_login(): void
{
    header('Content-Type: application/json');
    if (empty($_SESSION['user_id'])) {
        json_error(401, 'Not logged in');
    }
}

// For endpoints that change data: logged in, POST only, valid CSRF token.
function require_api_post(): void
{
    require_api_login();
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        json_error(405, 'POST required');
    }
    require_csrf();
}