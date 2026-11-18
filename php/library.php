<?php
require __DIR__ . '/includes/db.php';
require __DIR__ . '/includes/auth.php';
require_login();
$activeNav = 'library';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Library</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <!-- fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500&family=Oxanium:wght@500&family=Space+Grotesk:wght@500;700&display=swap" rel="stylesheet">

    <!-- css -->
    <link rel="stylesheet" href="../css/library.css">
    <link rel="stylesheet" href="../css/base.css">
</head>

<body>
<?php require __DIR__ . '/includes/header.php'; ?>
<div class="library-page">

    <main class="library-content">

        <aside class="sidebar">

            <section class="stats-card">

                <h2>Your Stats</h2>

                <div class="pie-chart-placeholder">
                </div>

            </section>

            <section class="filters-card">

                <!-- <h2>Filters</h2> -->
                 <!-- removed as they are somewhat redundant. This also allows to center the actual filter titles and not feel off -->

                <div class="filter-group">
                    <h3>Status</h3>

                    <label><input type="checkbox"> Backlog</label>
                    <label><input type="checkbox"> Playing</label>
                    <label><input type="checkbox"> On Hold</label>
                    <label><input type="checkbox"> Completed</label>
                    <label><input type="checkbox"> DNF</label>

                </div>

                <div class="filter-group">
                    <h3>Platform</h3>

                    <label><input type="checkbox"> PC</label>
                    <label><input type="checkbox"> Nintendo Switch</label>
                    <label><input type="checkbox"> PlayStation</label>
                    <label><input type="checkbox"> Xbox</label>
                    <label><input type="checkbox"> Mobile</label>
                    <label><input type="checkbox"> Emulator</label>
                </div>

            </section>

        </aside>

        <section class="library-main">

            <section class="currently-playing">

                <h2>Games Being Played</h2>

                <div class="horizontal-games">

                    <div class="game-banner"></div>
                    <div class="game-banner"></div>
                    <div class="game-banner"></div>
                    <div class="game-banner"></div>
                    <div class="game-banner"></div>
                    <div class="game-banner"></div>
                    <div class="game-banner"></div>
                    <div class="game-banner"></div>

                </div>

            </section>

            <section class="toolbar">

                <input
                    type="text"
                    placeholder="Search"
                    class="search-input">

                <select class="sort-dropdown">
                    <option>Alphabetical</option>
                    <option>Release Date</option>
                    <option>Completion Status</option>
                    
                </select>

            </section>

            <section class="game-grid">
<!-- added a bunch of game cards to test the scroll feature of the game grid, not running yet, JS or CSS? -->
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <div class="game-card"></div>
                <!-- for each game in the library, create a card with the game title, image, and a button to add it to the wishlist. Use PHP to loop through the library items and generate the HTML for each game card dynamically. -->
            </section>

        </section>

    </main>

</div>
<div class="footer">
    <p>&copy; 2026 Backtrack. All rights reserved.</p>
</div>
</body>
</html>
