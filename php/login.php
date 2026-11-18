<?php
require __DIR__ . '/includes/db.php';
session_start();

$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email    = trim($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';

    $stmt = $pdo->prepare('SELECT user_id, password_hash FROM Users WHERE email = ?');
    $stmt->execute([$email]);
    $user = $stmt->fetch();

    if ($user && password_verify($password, $user['password_hash'])) {
        session_regenerate_id(true);
        $_SESSION['user_id'] = (int) $user['user_id'];
        header('Location: library.php');
        exit;
    }

    $error = 'Incorrect email or password.';
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Log in - Backtrack</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500&family=Oxanium:wght@500&family=Space+Grotesk:wght@500;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="../css/base.css">
  <link rel="stylesheet" href="../css/login.css">
  <script src="../js/login.js" defer></script>
</head>
<body>

  <div class="login-page">

    <main class="login-main">
      <header>
        <p class="wordmark">Backtrack</p>
      </header>

      <section class="login-card">
        <h1>Welcome!</h1>
        <p class="login-intro">Please enter your email and password</p>

        <form class="login-form" action="login.php" method="post">
          <div class="field">
            <input type="email" id="email" name="email" autocomplete="email" required placeholder="Email">
          </div>

          <div class="field">
            <input type="password" id="password" name="password" autocomplete="current-password" required placeholder="Password">
          </div>

          <?php if ($error !== ''): ?>
            <p class="form-error" role="alert"><?= htmlspecialchars($error) ?></p>
          <?php endif; ?>

          <button type="submit" class="button login-button">Login</button>
        </form>

        <p class="forgot-password"><a href="forgot-password.html">Forgot Password</a></p><br>

        <p class="divider">or</p>

        <hr><br>

        <a class="button create-account" href="create.php">Create an account</a>
      </section>
    </main>

    <section class="blurb">
      <h2>All your games. One place.</h2>
      <p>
        Keep track of the games you own, the ones you're playing,
        the ones you've beaten, and the ones still on your wishlist.
        Your entire gaming backlog, organized in one convenient place.
      </p>
    </section>

    <!-- Control games carousel -->
    <div class="game-art" aria-hidden="true"></div>

  </div>

</body>
</html>