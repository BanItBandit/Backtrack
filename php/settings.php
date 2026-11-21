<?php
require __DIR__ . '/includes/db.php';
require __DIR__ . '/includes/auth.php';
$activeNav = 'settings';


$stmt = $pdo->prepare('SELECT username FROM Users WHERE user_id = ?');
$stmt->execute([$_SESSION['user_id']]);
$user = $stmt->fetch();
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Settings - Backtrack</title>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500&family=Oxanium:wght@500&family=Space+Grotesk:wght@500;700&display=swap" rel="stylesheet">

  <link rel="stylesheet" href="../css/base.css">
  <link rel="stylesheet" href="../css/settings.css">
  <script src="../js/settings.js" defer></script>
</head>
<body>
  <?php require __DIR__ . '/includes/header.php'; ?>
  <div class="settings-page">

    <main class="settings-main">

      <section class="settings-card">

        <h1>Account Settings</h1>

        <button class="button logout" id="logout-button" onclick="window.location.href='logout.php'">
          Logout
        </button>

        <form id="account-form">

          <div class="field">
            <input type="text" id="username" name="username" placeholder="Username" aria-label="Username" autocomplete="username" required>
          </div>

          <div class="field">
            <input type="text" id="display-name" name="display-name" placeholder="Display Name" aria-label="Display Name" autocomplete="nickname" required>
          </div>

          <div class="field">
            <input type="email" id="email" name="email" placeholder="Email" aria-label="Email" autocomplete="email" required>
          </div>

          <p class="form-message" id="account-message" role="status"></p>

          <button type="submit" class="button save-account">
            Save Changes
          </button>

        </form>

        <form id="password-form">

          <h2>Password</h2>

          <div class="field">
            <input
              type="password"
              id="new-password"
              name="new-password"
              placeholder="New Password"
              aria-label="New Password"
              autocomplete="new-password"
              required>
          </div>

          <div class="field">
            <input
              type="password"
              id="confirm-password"
              name="confirm-password"
              placeholder="Retype New Password"
              aria-label="Retype New Password"
              autocomplete="new-password"
              required>
          </div>

          <p class="form-message" id="password-message" role="status"></p>

          <button type="submit" class="button save-password">
            Save New Password
          </button>

        </form>

      </section>

    </main>

  </div>

</body>
</html>
