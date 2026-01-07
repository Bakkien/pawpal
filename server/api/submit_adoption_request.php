<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
	http_response_code(405);
	echo json_encode(array('error' => 'Method Not Allowed'));
	exit();
}

if (!isset($_POST['petid']) || !isset($_POST['userid']) || !isset($_POST['houseType']) || !isset($_POST['owned']) || !isset($_POST['reason']) || !isset($_POST['status'])) {
	http_response_code(400);
	echo json_encode(array("success" => false, "message" => "Bad Request"));
	exit();
}

$petid = $_POST['petid'];
$userid = $_POST['userid'];
$housetype = $_POST['houseType'];
$owned = $_POST['owned'];
$reason = $_POST['reason'];
$status = $_POST['status'];

// Insert adoption request into database
$sqlinsertadoption = "INSERT INTO `tbl_adoptions`(`pet_id`, `user_id`, `house_type`, `owned`, `reason`, `status`) 
	VALUES ('$petid','$userid','$housetype','$owned','$reason', '$status')";
try {
	if ($conn->query($sqlinsertadoption) === TRUE) {
	   $response = array('success' => true, 'message' => 'Adoption request successful');
	} else {
		$response = array('success' => false, 'message' => 'Adoption request failed');
	}
	sendJsonResponse($response);
} catch (Exception $e) {
	$response = array('success' => false, 'message' => $e->getMessage());
	sendJsonResponse($response);
}

//	function to send json response	
function sendJsonResponse($sentArray)
{
	header('Content-Type: application/json');
	echo json_encode($sentArray);
}