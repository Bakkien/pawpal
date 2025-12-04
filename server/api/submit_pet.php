<?php
	header("Access-Control-Allow-Origin: *");
	include 'dbconnect.php';

	if ($_SERVER['REQUEST_METHOD'] != 'POST') {
		http_response_code(405);
		echo json_encode(array('error' => 'Method Not Allowed'));
		exit();
	}

	$userid = $_POST['userid'];
	$petname = $_POST['petname'];
	$pettype = $_POST['pettype'];
	$category = $_POST['category'];
	$description = addslashes($_POST['description']);
	$latitude = $_POST['latitude'];
    $longitude = $_POST['longitude'];
	$imagepaths = $_POST['image'];
    //$base64image = json_decode($imagepaths);

	// Insert new pet into database
	$sqlinsertpet = "INSERT INTO `tbl_pets`(`user_id`, `pet_name`, `pet_type`, `category`, `description`, `lat`, `lng`, `image_paths`) 
	VALUES ('$userid','$petname','$pettype','$category','$description','$latitude','$longitude','$imagepaths')";
	try{
		if ($conn->query($sqlinsertpet) === TRUE){
			//$last_id = $conn->insert_id;
			//$path = "../assets/pet/pet_".$last_id.".png";
			//file_put_contents($path, $encodedimage);

			$response = array('status' => 'success', 'message' => 'Pet added successfully');
			sendJsonResponse($response);
		}else{
			$response = array('status' => 'failed', 'message' => 'Pet not added');
			sendJsonResponse($response);
		}
	}catch(Exception $e){
		$response = array('status' => 'failed', 'message' => $e->getMessage());
		sendJsonResponse($response);
	}


//	function to send json response	
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}


?>