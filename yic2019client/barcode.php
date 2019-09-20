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
	<title>Barcode</title>
</head>
<link rel="stylesheet" href="barcode.css">
<body>

   <h1>Here is your barcode, thanks for your cooperation	</h1>
   <div class="center-container"><div style="width:300px;height:100px;border:1px solid #000;">barcode</div></div>
	<p>Please bring along your Identity Card for your vertification</p>
	<p>Please be punctual! </p>

</body>
</html>
