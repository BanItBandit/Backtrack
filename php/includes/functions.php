<?php
// Shared helpers for pages that list games (Library, Catalog, Wishlist).
//
// The filter SQL assumes the page's query uses these aliases:
//   Games g, Platforms p

// "?,?,?" for a list of N values, for use inside IN (...)
function placeholders(int $n): string
{
    return implode(',', array_fill(0, $n, '?'));
}

// Reads the shared filters out of the URL (pass in $_GET), cleaned up.
function read_game_filters(array $get): array
{
    return [
        'search'    => trim($get['search'] ?? ''),
        'platforms' => array_map('intval', (array) ($get['platform'] ?? [])),
        'tags'      => array_values(array_unique(array_map('intval', (array) ($get['tag'] ?? [])))),
    ];
}

// Turns those filters into SQL to append to a WHERE clause.
// Returns [sql_text, params]. Append the text, then merge the params,
// in that order, AFTER anything the page already added.
function game_filter_sql(array $f): array
{
    $sql = '';
    $params = [];

    if ($f['search'] !== '') {
        $sql .= ' AND g.game_name LIKE ?';
        $params[] = '%' . $f['search'] . '%';
    }

    // Platforms: a game on ANY checked platform.
    if ($f['platforms']) {
        $sql .= ' AND g.platform_id IN (' . placeholders(count($f['platforms'])) . ')';
        array_push($params, ...$f['platforms']);
    }

    // Tags: a game must have ALL the checked tags.
    if ($f['tags']) {
        $sql .= ' AND g.game_id IN (
                     SELECT game_id
                     FROM GameTagAssignments
                     WHERE tag_id IN (' . placeholders(count($f['tags'])) . ')
                     GROUP BY game_id
                     HAVING COUNT(DISTINCT tag_id) = ?
                  )';
        array_push($params, ...$f['tags']);
        $params[] = count($f['tags']);
    }

    return [$sql, $params];
}

// Picks a valid sort key and direction from the URL.
// $options is the page's own whitelist: ['title' => 'g.game_name', ...]
// Returns [key, 'asc'|'desc'].
function read_sort(array $get, array $options, string $default): array
{
    $key = $get['sort'] ?? $default;
    if (!isset($options[$key])) {
        $key = $default;
    }
    $dir = ($get['dir'] ?? 'asc') === 'desc' ? 'desc' : 'asc';
    return [$key, $dir];
}

// All tags, grouped by category, in the display order we want.
function load_tags_by_category(PDO $pdo): array
{
    $order = ['Genre', 'Play Style', 'Mood', 'Theme', 'Narrative'];

    $rows = $pdo->query('SELECT tag_id, tag_name, category FROM Tags ORDER BY tag_name')->fetchAll();
    $grouped = [];
    foreach ($rows as $t) {
        $grouped[$t['category']][] = $t;
    }

    $sorted = [];
    foreach ($order as $cat) {
        if (!empty($grouped[$cat])) {
            $sorted[$cat] = $grouped[$cat];
        }
    }
    return $sorted;
}

// One cover tile. $class lets the Playing strip use 'game-banner'.
function render_game_card(array $g, string $class = 'game-card'): void
{
    ?>
    <div class="<?= htmlspecialchars($class) ?>" data-game-id="<?= (int) $g['game_id'] ?>">
        <?php if ($g['cover_image']): ?>
            <img src="../images/covers/<?= htmlspecialchars($g['cover_image']) ?>"
                 alt="<?= htmlspecialchars($g['game_name']) ?> cover">
        <?php else: ?>
            <span class="game-card-title"><?= htmlspecialchars($g['game_name']) ?></span>
        <?php endif; ?>
    </div>
    <?php
}