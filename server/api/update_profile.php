<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method Not Allowed']);
    exit();
}

// get data
$userid       = $_POST['user_id'];
$name         = addslashes($_POST['user_name']);
$phone        = addslashes($_POST['user_phone']);
$avatar       = $_POST['user_avatar'];

// update query
$sqlupdateprofile = "
UPDATE tbl_users 
SET 
    name    = '$name',
    phone   = '$phone'
WHERE user_id = '$userid'
";

try {
    if ($conn->query($sqlupdateprofile) === TRUE) {
        if(!empty($avatar)){
            $encodedimage = base64_decode($avatar);
            $path = "../uploads/profile/user_".$userid.".png";
    		file_put_contents($path, $encodedimage);
    		$sqlupdateavatar = "UPDATE tbl_users SET `avatar` = '$path' WHERE user_id = '$userid'";
    		if ($conn->query($sqlupdateavatar) === TRUE){
    		    $reponse = array('success' => true, 'message' => 'Profile update successfully');
    		}else{
    		 $reponse = array('success' => false, 'message' => 'Avatar update failed');   
    		}
        }
        $reponse = array('success' => true, 'message' => 'Profile update successfully');
		
    } else {
        $reponse = array('success' => false, 'message' => 'Profile update failed');
    }
    sendJsonResponse($reponse);
} catch (Exception $e) {
    sendJsonResponse([
        'success' => false,
        'message' => $e->getMessage()
    ]);
}

function sendJsonResponse($sentArray)
{
    echo json_encode($sentArray);
}
?>