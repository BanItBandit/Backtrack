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
<meta charset="UTF-8">
  <title><?php echo $user['username']; ?> - Backtrack</title>
  <link rel="stylesheet" href="../css/base.css">
  <link rel="stylesheet" href="../css/login.css">
</head>
<body>
  <?php require __DIR__ . '/includes/header.php'; ?>
  <h1>Settings</h1>
  <?php
    echo "Hello, " . $user['username'] . "! Welcome to your settings page.";
  ?>
</body>
</html>