   <?php
   session_start();

   // TEMPORARY: pretend user 1 is logged in until real login exists.
   if (!isset($_SESSION['user_id'])) {
       $_SESSION['user_id'] = 1;
   }