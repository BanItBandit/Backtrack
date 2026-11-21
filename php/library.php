<?php
require __DIR__ . '/includes/db.php';
require __DIR__ . '/includes/auth.php';
require __DIR__ . '/includes/functions.php';
require_login();
$activeNav = 'library';

$f = read_game_filters($_GET);

$sortOptions = [
    'title'    => 'g.game_name',
    'platform' => 'p.platform_name',
    'status'   => 'l.status',      // ENUMs sort in their declared order
    'added'    => 'l.added_at',
];
[$sort, $dir] = read_sort($_GET, $sortOptions, 'title');

// The status filter only exists on the Library, so it stays here.
$allStatuses = ['Backlog', 'Playing', 'On Hold', 'Completed'];
$selStatuses = array_values(array_intersect($allStatuses, (array) ($_GET['status'] ?? [])));

$sql = 'SELECT g.game_id, g.game_name, g.cover_image, p.platform_name, l.status
        FROM UserLibraryEntries l
        JOIN Games g     ON g.game_id = l.game_id
        JOIN Platforms p ON p.platform_id = g.platform_id
        WHERE l.user_id = ?';
$params = [$_SESSION['user_id']];

if ($selStatuses) {
    $sql .= ' AND l.status IN (' . placeholders(count($selStatuses)) . ')';
    array_push($params, ...$selStatuses);
}

[$filterSql, $filterParams] = game_filter_sql($f);
$sql .= $filterSql;
$params = array_merge($params, $filterParams);

$sql .= ' ORDER BY ' . $sortOptions[$sort] . ' ' . strtoupper($dir) . ', g.game_name';

$stmt = $pdo->prepare($sql);
$stmt->execute($params);
$games = $stmt->fetchAll();

// Your markup uses these names, so keep them pointing at the same values.
$q            = $f['search'];
$selPlatforms = $f['platforms'];
$selTags      = $f['tags'];

$stmt = $pdo->prepare(
    'SELECT DISTINCT p.platform_id, p.platform_name
     FROM UserLibraryEntries l
     JOIN Games g     ON g.game_id = l.game_id
     JOIN Platforms p ON p.platform_id = g.platform_id
     WHERE l.user_id = ?
     ORDER BY p.platform_name'
);
$stmt->execute([$_SESSION['user_id']]);
$platformOptions = $stmt->fetchAll();

$tagsByCategory = load_tags_by_category($pdo);

$stmt = $pdo->prepare(
    "SELECT g.game_id, g.game_name, g.cover_image
     FROM UserLibraryEntries l
     JOIN Games g ON g.game_id = l.game_id
     WHERE l.user_id = ? AND l.status = 'Playing'
     ORDER BY l.updated_at DESC"
);
$stmt->execute([$_SESSION['user_id']]);
$playing = $stmt->fetchAll();

$stmt = $pdo->prepare(
    'SELECT status, COUNT(*) FROM UserLibraryEntries WHERE user_id = ? GROUP BY status'
);
$stmt->execute([$_SESSION['user_id']]);
$counts = array_merge(
    array_fill_keys(['Backlog', 'Playing', 'On Hold', 'Completed'], 0),
    $stmt->fetchAll(PDO::FETCH_KEY_PAIR)
);
$total = array_sum($counts);

$colors = [
    'Backlog'   => 'var(--muted)',
    'Playing'   => 'var(--violet)',
    'On Hold'   => 'var(--accent)',
    'Completed' => 'var(--sky)',
];

$stops = [];
$start = 0;
foreach ($counts as $status => $n) {
    if ($n === 0) {
        continue;
    }
    $end = $start + ($n / $total * 100);
    $stops[] = "{$colors[$status]} {$start}% {$end}%";
    $start = $end;
}
$pie = $total > 0
    ? 'conic-gradient(' . implode(', ', $stops) . ')'
    : 'var(--surface)';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Library</title>
    <link rel="icon" type="image/png" href="../images/flavicon.png">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <!-- fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500&family=Oxanium:wght@500&family=Space+Grotesk:wght@500;700&display=swap" rel="stylesheet">

    <!-- css -->
    <link rel="stylesheet" href="../css/base.css">
    <link rel="stylesheet" href="../css/library.css">

    <meta name="csrf-token" content="<?= htmlspecialchars(csrf_token()) ?>">
</head>

<body id="top">
<?php require __DIR__ . '/includes/header.php'; ?>
<div class="library-page">

    <main class="library-content">
        <form method="get" class="library-form">
            <aside class="sidebar">

                <section class="stats-card">
                    <div class="stats-grid">
                        <div class="stats-list-container">
                            <h2>Your Stats</h2>
                            <ul class="stats-list">
                                <?php foreach ($counts as $status => $n): ?>
                                    <li>
                                        <span class="dot" style="background: <?= $colors[$status] ?>"></span>
                                        <span><?= htmlspecialchars($status) ?>:</span>
                                        <strong><?= $n ?></strong>
                                    </li>
                                <?php endforeach; ?>
                            </ul>
                            <hr class="stats-divider">
                            <p class="stats-total">Total: <?= $total ?></p>
                        </div>

                        <div class="pie" style="background: <?= $pie ?>" role="img" aria-label="Library breakdown by status"></div>
                    </div>
                </section>



                <section class="filters-card">
                    <div class="filters-scroll">

                        <div class="filter-group">
                            <h2>Status</h2>
                            <?php foreach ($allStatuses as $s): ?>
                                <label>
                                    <input type="checkbox" name="status[]" value="<?= htmlspecialchars($s) ?>"
                                        <?= in_array($s, $selStatuses, true) ? 'checked' : '' ?>>
                                    <?= htmlspecialchars($s) ?>
                                </label>
                            <?php endforeach; ?>
                        </div>

                        <div class="filter-group">
                            <h2 id="platform">Platform</h2>
                            <?php foreach ($platformOptions as $p): ?>
                                <label>
                                    <input type="checkbox" name="platform[]" value="<?= (int) $p['platform_id'] ?>"
                                        <?= in_array((int) $p['platform_id'], $selPlatforms, true) ? 'checked' : '' ?>>
                                    <?= htmlspecialchars($p['platform_name']) ?>
                                </label>
                            <?php endforeach; ?>
                        </div>

                        <?php require __DIR__ . '/includes/filter-tags.php'; ?>

                        <a href="library.php" class="clear-filters">Clear all</a>

                    </div>
                </section>

                

            </aside>

            <section class="library-main">

                <section class="currently-playing">

                    <h2>Games Being Played</h2>

                    <div class="horizontal-games">
                        <?php if (!$playing): ?>
                            <p>Nothing in progress yet. Set a game to Playing to see it here.</p>
                        <?php endif; ?>

                        <?php foreach ($playing as $g): ?>
                            <?php render_game_card($g, 'game-banner'); ?>
                        <?php endforeach; ?>
                    </div>

                </section>

                <section class="toolbar">

                    <div class="field">
                        <input type="search" id="search" name="search" autocomplete="off"
                            placeholder="Search" value="<?= htmlspecialchars($q) ?>">
                    </div>

                    <select class="sort-dropdown" name="sort">
                        <option value="title"    <?= $sort === 'title'    ? 'selected' : '' ?>>Alphabetical</option>
                        <option value="platform" <?= $sort === 'platform' ? 'selected' : '' ?>>Platform</option>
                        <option value="status"   <?= $sort === 'status'   ? 'selected' : '' ?>>Status</option>
                        <option value="added"    <?= $sort === 'added'    ? 'selected' : '' ?>>Date Added</option>
                    </select>

                    <input type="hidden" name="dir" id="sort-dir" value="<?= $dir ?>">
                    <button type="button" id="sort-by" class="sort-by-button"
                            aria-label="Reverse sort direction"><?= $dir === 'asc' ? '↑' : '↓' ?></button>

                </section>

                <section class="game-grid">
                    <?php if (!$games): ?>
                        <?php if ($total === 0): ?>
                            <p>Your library is empty. <a href="catalog.php">Browse the catalog</a> to add games.</p>
                        <?php else: ?>
                            <p>No games match.</p>
                        <?php endif; ?>
                    <?php endif; ?>
                    <?php foreach ($games as $g): ?>
                        <?php render_game_card($g); ?>
                    <?php endforeach; ?>
                </section>

            </section>
        </form>
    </main>

</div>

<dialog id="game-dialog" class="game-dialog">
  <button type="button" class="dialog-close" aria-label="Close">&times;</button>
  <img id="dialog-cover" class="dialog-cover" src="" alt="">
  <div class="dialog-body">
    <h2 id="dialog-title"></h2>
    <p id="dialog-platform" class="dialog-meta"></p>
    <p id="dialog-description"></p>
    <ul id="dialog-tags" class="tag-list"></ul>
    <div class="status-control" role="radiogroup" aria-label="Play status">
        <label><input type="radio" name="status" value="Backlog"><span>Backlog</span></label>
        <label><input type="radio" name="status" value="Playing"><span>Playing</span></label>
        <label><input type="radio" name="status" value="On Hold"><span>On Hold</span></label>
        <label><input type="radio" name="status" value="Completed"><span>Completed</span></label>
    </div>
    <button type="button" id="remove-button" class="remove-button">Remove from library</button>
  </div>
</dialog>

<button type="button" id="back-to-top" class="back-to-top-button" aria-label="Back to top">↑</button>

<script src="../js/library.js"></script>
</body>
</html>
