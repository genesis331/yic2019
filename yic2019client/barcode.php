<?php
session_start();
$visitid = $_SESSION['visitid'];
?>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta http-equiv="X-UA-Compatible" content="ie=edge">
	<title>Barcode</title>
	<script src="https://cdn.jsdelivr.net/jsbarcode/3.6.0/JsBarcode.all.min.js"></script>
</head>
<link rel="stylesheet" href="barcode.css">
<body>

   <h1>Here is your barcode, thanks for your cooperation	</h1>
   <div class="center-container"><div style="width:300px;height:100px;border:1px solid #000;">
   <img id="barcode"/>
   </div></div>
	<p>Please bring along your Identity Card for your vertification</p>
	<p>Please be punctual! </p>
<script>
	JsBarcode("#barcode", $visitid, {
      format: "pharmacode",
      lineColor: "#000000",
      displayValue: false
    });
	</script>
</body>
</html>
