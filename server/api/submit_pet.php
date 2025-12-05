<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
	http_response_code(405);
	echo json_encode(array('error' => 'Method Not Allowed'));
	exit();
}

if (!isset($_POST['userid']) || !isset($_POST['petname']) || !isset($_POST['pettype']) || !isset($_POST['category']) || !isset($_POST['description']) || !isset($_POST['latitude']) || !isset($_POST['longitude']) || !isset($_POST['images'])) {
	http_response_code(400);
	echo json_encode(array("success" => false, "message" => "Bad Request"));
	exit();
}

$userid = $_POST['userid'];
$petname = $_POST['petname'];
$pettype = $_POST['pettype'];
$category = $_POST['category'];
$description = $_POST['description'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$base64list = json_decode($_POST['images'], true);
$savedImages = [];

// Insert new pet into database
$sqlinsertpet = "INSERT INTO `tbl_pets`(`user_id`, `pet_name`, `pet_type`, `category`, `description`, `lat`, `lng`, `image_paths`) 
	VALUES ('$userid','$petname','$pettype','$category','$description','$latitude','$longitude','')";
try {
	if ($conn->query($sqlinsertpet) === TRUE) {
		$last_id = $conn->insert_id;
		
		for ($i = 0; $i < count($base64list); $i++) {
			$base64image = $base64list[$i];
			$decodedImage = base64_decode($base64image);
			$filename = "../uploads/pet_" . $last_id . "_" . ($i + 1) . ".png";
			file_put_contents($filename, $decodedImage);
			$savedImages[] = 'image'.($i+1).': '.$filename;
		}
		// save the image path in JSON format
		$imageJson = json_encode($savedImages);
		$updatesql = "UPDATE tbl_pets SET `image_paths` = '$imageJson' WHERE pet_id = '$last_id'";
		if ($conn->query($updatesql) == TRUE) {
			$response = array('success' => true, 'message' => 'Pet submitted successfully');
			sendJsonResponse($response);
		} else {
			$response = array('success' => false, 'message' => 'Pet failed to submit');
			sendJsonResponse($response);
		}
	} else {
		$response = array('success' => false, 'message' => 'Pet not added');
		sendJsonResponse($response);
	}
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
