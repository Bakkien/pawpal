<?php
error_reporting(0);

$email = $_GET['email']; //email
$phone = $_GET['phone']; 
$name = $_GET['name']; 
$money = floatval($_GET['money']);
$userid = $_GET['userid'];

$api_key = '864359e6-9f24-4d13-875d-465d8153d9dd';
$collection_id = '99b7miej';
$host = 'https://www.billplz-sandbox.com/api/v3/bills';

$data = array(
          'collection_id' => $collection_id,
          'email' => $email,
          'mobile' => $phone,
          'name' => $name,
          'amount' => $money * 100, 
		  'description' => 'Payment for '.$userid,
          'callback_url' => "https://canorcannot.com/Bakkien/pawpal/server/api/return_url",
          'redirect_url' => "https://canorcannot.com/Bakkien/pawpal/server/api/payment_update.php?userid=$userid&email=$email&name=$name&phone=$phone&money=$money" 
);


$process = curl_init($host );
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);

echo "<pre>".print_r($bill, true)."</pre>";
header("Location: {$bill['url']}");
?>