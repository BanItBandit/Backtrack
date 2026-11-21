<?php
require __DIR__ . '/includes/db.php';
require __DIR__ . '/includes/auth.php';

require_api_post();

$gameId = (int) ($_POST['game_id'] ?? 0);
$status = $_POST['status'] ?? '';

$allowed = ['Backlog', 'Playing', 'On Hold', 'Completed'];
if (!in_array($status, $allowed, true)) {
    json_error(400, 'Invalid status');
}

// user_id in the WHERE clause means you can only change YOUR entries.
$stmt = $pdo->prepare(
    'UPDATE UserLibraryEntries
     SET status = ?, updated_at = NOW()
     WHERE user_id = ? AND game_id = ?'
);
$stmt->execute([$status, $_SESSION['user_id'], $gameId]);

echo json_encode(['ok' => true, 'status' => $status]);