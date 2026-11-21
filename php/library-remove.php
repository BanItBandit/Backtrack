<?php
require __DIR__ . '/includes/db.php';
require __DIR__ . '/includes/auth.php';

require_api_post();

$gameId = (int) ($_POST['game_id'] ?? 0);

// user_id in the WHERE clause means you can only remove YOUR entries.
$stmt = $pdo->prepare(
    'DELETE FROM UserLibraryEntries WHERE user_id = ? AND game_id = ?'
);
$stmt->execute([$_SESSION['user_id'], $gameId]);

echo json_encode(['ok' => true]);