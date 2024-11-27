<?php
$servername = "localhost";
$username   = "root";
$password   = "82052103";
$dbname     = "memberlink_db";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>