# Backtrack

Backtrack is a responsive website that helps video game players organize their collections, track their progress, manage a wishlist, and decide what to play next. It is built for people with games across multiple consoles and PC, especially those with large backlogs.

A team capstone project for the CVTC IT Software Development program.

**Live site:** https://backtrack.site.je

## Features

- **Accounts:** register, log in, and log out.
- **My Library:** your own games with search, filters (status, platform, tags), sorting, and progress tracking (Backlog, Playing, On Hold, Completed).
- **Shared Catalog:** a searchable catalog of games. Each platform-specific release is its own entry. Add entries to your library or wishlist.
- **Wishlist:** games you want but haven't added to your library.
- **Game Picker:** suggests a game from your library based on selected tags and an optional platform. Completed games are excluded unless you include them.
- **Settings:** display name and email. The username is read-only.
- **Admin tools (inside Settings, admins only):** add and edit catalog entries and review game requests. Games are deactivated, never permanently deleted.

## Tech stack

- **Back end:** PHP 8 (PDO) and MySQL
- **Front end:** HTML, CSS, vanilla JavaScript
- **Local development:** MAMP or XAMPP (Apache + PHP + MySQL)
- **Hosting:** InfinityFree

## Project structure

```
schema.sql              database structure (run first)
seed.sql                sample data: platforms, tags, games, test user
css/
  base.css              variables, reset, shared styles (load first on every page)
  login.css             login and create-account pages only
js/
  login.js              animated game-cover background
images/covers/          game cover art (.jpeg)
php/
  login.php             login page
  create.php            create-account page
  logout.php            ends the session
  includes/
    config.example.php  copy to config.php and fill in (config.php is NOT committed)
    db.php              opens the PDO connection ($pdo)
    auth.php            session handling and login checks
    header.php          shared top navigation bar
```

## Local setup

1. **Install MAMP or XAMPP** and start Apache and MySQL.
2. **Clone the repo** into the web server's folder (`htdocs`), or point the server's document root at the repo folder.
3. **Open phpMyAdmin** and import `schema.sql`, then `seed.sql`. Importing `schema.sql` creates the `backtrack` database.
4. **Create your config:** copy `php/includes/config.example.php` to `php/includes/config.php` and fill in your own values. This file is in `.gitignore`. Never commit it.
5. **Open the site** at `http://localhost:<port>/php/login.php`. Pages must be served through Apache. Opening a `.php` file straight from disk (`file://`) will not run PHP.

Typical settings (check your own tool's port settings, they vary):

| Tool | Apache port | MySQL port | MySQL user | MySQL password |
|---|---|---|---|---|
| MAMP (Mac) | 8888 | 8889 | root | root |
| MAMP (Windows) | 80 | 3306 | root | root |
| XAMPP | 80 | 3306 | root | (empty) |

Use `127.0.0.1` for `db_host`.

### Test account (local only)

After importing `seed.sql`:

- Email: `test@example.com`
- Password: `password123`

This is an **admin** account with a known password. It exists for local testing only. Never import it into the hosted database.

If you imported an older `seed.sql` before this account had a real password, run this once in phpMyAdmin (SQL tab) instead of re-importing:

```sql
UPDATE Users
SET password_hash = '$2y$10$kcOWKpP10U7PqjJDeSOKfu4eWs5SRio7.Q7O4mZMc/q5wemOJh7Ie'
WHERE user_id = 1;
```

## Database

| Table | Purpose |
|---|---|
| Users | accounts (unique username and email, hashed password, `is_admin`) |
| Platforms | lookup list of platforms |
| Games | the shared catalog, one row per platform-specific release (`is_active` instead of deleting) |
| Tags | preset tags in five categories: Genre, Play Style, Mood, Theme, Narrative |
| GameTagAssignments | links games to tags |
| UserLibraryEntries | a user's games and their status |
| WishlistEntries | a user's wishlist |
| GameRequests | requests for games missing from the catalog |

Rules to remember:
- Tags are a fixed preset list that users cannot edit.
- Filtering by several tags uses **all** (a game must have every selected tag). Filtering by platform uses **any**.
- Moving a game from the wishlist to the library means inserting a library row **and** deleting the wishlist row. The database will not do it automatically.
- If a user's `display_name` is empty (NULL), show their username.
- A game with no `cover_image` needs a placeholder in the UI.

## Starting a new page

```php
<?php
require __DIR__ . '/includes/db.php';
require __DIR__ . '/includes/auth.php';
require_login();              // admin-only pages: require_admin($pdo);
$activeNav = 'library';       // which nav link to highlight
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Library - Backtrack</title>
  <link rel="stylesheet" href="../css/base.css">
</head>
<body>
  <?php require __DIR__ . '/includes/header.php'; ?>
  <main>
    <!-- page content -->
  </main>
</body>
</html>
```

## Conventions

- **Prepared statements for every query that includes user input** (`prepare`, `execute`, `fetch`). Never build SQL by joining strings.
- **Escape user-supplied text** with `htmlspecialchars()` when printing it.
- **Passwords:** `password_hash()` to store, `password_verify()` to check. Never store or log the real password.
- **Hiding a link is not access control.** Every protected page calls `require_login()` or `require_admin($pdo)` at the top.
- **Use relative paths.** Never write `localhost:8888` in code.
- **Match file name capitalization exactly.** The hosted server is case-sensitive: `Doom.jpeg` and `doom.jpeg` are different files, and so are `Platforms` and `platforms`.
- **Change the database structure in `schema.sql`**, not only in phpMyAdmin. Tell the team when it changes.
- Do not commit `config.php`, `.DS_Store`, `Thumbs.db`, or `.vscode/`.

## Deploying to the hosted site

1. Upload everything except your local `config.php`. Create a separate `config.php` on the server with the host's database settings (host name, full database name, user, and password, all as shown in the hosting control panel, with port 3306).
2. Import `schema.sql` into the hosted database **with the first two statements removed** (`CREATE DATABASE ...` and `USE backtrack;`), because shared hosting does not allow them.
3. Import `seed.sql` **without the `testuser` line**.
4. Delete test files such as `test-db.php`.
5. Make sure `db.php` prints only the generic "Database connection failed." message, never the raw error.

## Status

- [x] Database schema and seed data
- [x] Registration, login, and logout
- [x] Shared header and base styles
- [x] Hosting and database connection
- [ ] Route guards (`require_login()` / `require_admin()`)
- [ ] My Library
- [ ] Catalog
- [ ] Wishlist
- [ ] Game Picker
- [ ] Settings and admin tools
- [ ] Responsive pass and testing
- [ ] User documentation and presentation

## Team

Alex Ingalls - Team Leader and Project Architect
Carrie Andersen - Record Keeper
Michael Onstad - Quality Control
Ethan Sippy - Quality Control