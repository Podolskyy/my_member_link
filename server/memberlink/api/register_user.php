<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");

$email = $_POST['email'];
$password = sha1($_POST['password']);
$name = $_POST['name']; // New field for name
$phoneNumber = $_POST['phoneNumber']; // New field for phone number

// Check if the email already exists in the database
$sqlCheckEmail = "SELECT `email` FROM `tbl_users` WHERE `email` = '$email'";
$resultEmail = $conn->query($sqlCheckEmail);

if ($resultEmail->num_rows > 0) {
    // Email already exists
    $response = array('status' => 'failed', 'data' => 'Email already registered');
    sendJsonResponse($response);
} else {
    // Insert the data into the tbl_users table
    $sqlinsert = "INSERT INTO `tbl_users`(`name`, `phoneNumber`, `email`, `pass`) VALUES ('$name', '$phoneNumber', '$email', '$password')";
    
    if ($conn->query($sqlinsert) === TRUE) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
