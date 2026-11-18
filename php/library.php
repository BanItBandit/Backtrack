<?php
require __DIR__ . '/includes/db.php';
require __DIR__ . '/includes/auth.php';
$activeNav = 'library';
?>
<!DOCTYPE html>
<html lang="en">
<meta charset="UTF-8">
  <title>Library - Backtrack</title>
  <link rel="stylesheet" href="../css/base.css">
  <link rel="stylesheet" href="../css/login.css">
</head>
<body>
  <?php require __DIR__ . '/includes/header.php'; ?>
  <h1>Library</h1>

  <?php
  $stmt = $pdo->prepare(
      'SELECT username, display_name FROM Users WHERE user_id = ?'
  );

  $stmt->execute([$_SESSION['user_id']]);

  $user = $stmt->fetch();

  echo "Logged in as: " . htmlspecialchars($user['username']);
  echo "User Display Name: " . htmlspecialchars($user['display_name']);
  ?>
  
</body>
</html>