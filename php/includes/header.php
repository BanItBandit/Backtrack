<?php
// Expects: $pdo and a started session (include db.php and auth.php first).
// Optional: $activeNav = 'library' | 'catalog' | 'wishlist' | 'picker' | 'settings' | 'admin'

$activeNav = $activeNav ?? '';

$stmt = $pdo->prepare('SELECT username, display_name, is_admin FROM Users WHERE user_id = ?');
$stmt->execute([$_SESSION['user_id']]);
$navUser = $stmt->fetch();

$navName  = $navUser['display_name'] ?: $navUser['username'];
$navAdmin = (bool) $navUser['is_admin'];

$links = [
    'library'  => ['library.php',  'Library'],
    'browse'  => ['browse.php',  'Browse'],
    'wishlist' => ['wishlist.php', 'Wishlist'],
    'picker'   => ['picker.php',   'Game Picker'],
];
?>
<header class="site-header">
  <a class="wordmark" href="library.php">Backtrack</a>

  <nav class="site-header-nav" aria-label="Main">
    <?php foreach ($links as $key => [$href, $label]): ?>
      <a href="<?= $href ?>"<?= $key === $activeNav ? ' aria-current="page"' : '' ?>><?= $label ?></a>
    <?php endforeach; ?>
    <a href="settings.php"<?= $activeNav === 'settings' ? ' aria-current="page"' : '' ?>><?= htmlspecialchars($navName) ?></a>
    <!-- <a href="logout.php">Log out</a> -->
  </nav>
</header>