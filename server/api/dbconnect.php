<?php
    $servername = "localhost";
    $username = "canortxw_pawpal_admin";
    $password = "%J%cFzi(lPcu";
    $dbname = "canortxw_pawpal_db";
    
    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);
    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
?>