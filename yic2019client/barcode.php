<?php
session_start();
$visitid = $_SESSION['visitid'];
//echo $visitid;

?>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta http-equiv="X-UA-Compatible" content="ie=edge">
	<title>Document</title>
</head>
<link rel="stylesheet" href="barcode.css">
<body>

   <p>Here is your barcode, thanks for using our application	</p>
   <div style="width:300px;height:100px;border:1px solid #000;">barcode</div>  
	<p>Please bring along your Identity Card for your vertification</p>

</body>
</html>