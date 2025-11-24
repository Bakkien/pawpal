<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (!isset($_POST['name']) || !isset($_POST['email']) || !isset($_POST['password']) || !isset($_POST['phone'])) {
        $response = array("success" => "false", "message" => "Bad Request");
        sendJsonResponse($response);
        exit();
    }

    $name = $_POST['name'];
    $email = $_POST['email'];
    $password = $_POST['password'];
    $hashed_password = sha1($password);
    $phone = $_POST['phone'];

    // Check if email already exists
    $sqlcheckmail = "SELECT * FROM `tbl_users` WHERE `email` = '$email'";
    $result = $conn->query($sqlcheckmail);
    if ($result->num_rows > 0) {
        $response = array('success' => false, 'message' => 'Email already registered');
        sendJsonResponse($response);
        exit();
    }
    // Insert new user into database
    $sqlregister = "INSERT INTO `tbl_users`(`name`, `email`, `password`, `phone`) VALUES ('$name','$email','$hashed_password', '$phone')";
    try {
        if ($conn->query($sqlregister) === TRUE) {
            $response = array('success' => true, 'message' => 'Registration successful');
            sendJsonResponse($response);
        } else {
            $response = array('success' => false, 'message' => 'Registration failed');
            sendJsonResponse($response);
        }
    } catch (Exception $e) {
        $response = array('success' => false, 'message' => $e->getMessage());
        sendJsonResponse($response);
    }
} else {
    $response = array("success" => false, "message" => "Method Not Allowed");
    sendJsonResponse($response);
    exit();
}

//	function to send json response	
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
