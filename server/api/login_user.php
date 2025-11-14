<?php
header('Access-Control-Allow-Origin: *');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (!isset($_POST['email']) || !isset($_POST['password'])) {
        $response = array("success" => "false", "message" => "Bad Request");
        sendJsonResponse($response);
        exit();
    }

    $email = $_POST['email'];
    $password = $_POST['password'];
    $hashed_password = sha1($password);

    include 'dbconnect.php';

    $sqllogin = "SELECT * FROM `tbl_users` WHERE `email` = '$email' AND `password` = '$hashed_password'";
    $result = $conn->query($sqllogin);

    if ($result->num_rows > 0) {
        $userData = array();
        while($row = $result->fetch_assoc()){
            $userData[] = $row;
        }
        $response = array("success" => "true", "message" => "Login successful", "data" => $userData);
    } else {
        $response = array("success" => "false", "message" => "Invalid email or password");
    }

    sendJsonResponse($response);
} else {
    $response = array("success" => "false", "message" => "Method Not Allowed");
    sendJsonResponse($response);
    exit();
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>