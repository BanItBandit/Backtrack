<?php
require __DIR__ . '/includes/db.php';
require __DIR__ . '/includes/auth.php';

require_api_login();

$gameId = (int) ($_GET['id'] ?? 0);

// Any active game in the catalog, plus YOUR library status if you own it.
// (Games you already own still show even if an admin has deactivated them.)
$stmt = $pdo->prepare(
    'SELECT g.game_id, g.game_name, g.game_description, g.cover_image,
            p.platform_name, l.status
     FROM Games g
     JOIN Platforms p ON p.platform_id = g.platform_id
     LEFT JOIN UserLibraryEntries l
            ON l.game_id = g.game_id AND l.user_id = ?
     WHERE g.game_id = ?
       AND (g.is_active = 1 OR l.user_id IS NOT NULL)'
);
$stmt->execute([$_SESSION['user_id'], $gameId]);
$game = $stmt->fetch();

if (!$game) {
    json_error(404, 'Game not found');
}

$stmt = $pdo->prepare(
    'SELECT t.tag_name
     FROM GameTagAssignments a
     JOIN Tags t ON t.tag_id = a.tag_id
     WHERE a.game_id = ?
     ORDER BY t.category, t.tag_name'
);
$stmt->execute([$gameId]);
$game['tags'] = $stmt->fetchAll(PDO::FETCH_COLUMN);

echo json_encode($game);