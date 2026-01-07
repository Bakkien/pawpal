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
$adoptionid = $_POST['adoption_id'];
$petid = $_POST['pet_id'];
$status = $_POST['status'];

// update query
$sqlupdateadoption = "
    UPDATE tbl_adoptions 
    SET status = '$status' 
    WHERE adoption_id = '$adoptionid'
";

try {
    if ($conn->query($sqlupdateadoption) === TRUE) {
        if ($status === 'Approve'){
            $sqlupdatepet = "UPDATE tbl_pets SET is_adopted = 1 WHERE pet_id = $petid";
            $conn->query($sqlupdatepet);
        }
        $response = array('success' => true, 'message' => 'Adoption update successfully');
    } else {
        $response = array('success' => false, 'message' => 'Adoption update failed');
    }
    sendJsonResponse($response);
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