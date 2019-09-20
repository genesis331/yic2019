
<?php
session_start();
$errorvisitid=false;

if(isset($_POST['btnlogin'])){
    if(empty($_POST['visitid'])){
        $errorvisitidMessage= "visitid is empty";
        $errorvisitid=true;
    }
    if (!empty($_POST['visitid'])){
        header("Location: barcode.php");
        $_SESSION['visitid']=$_POST['visitid'];
     }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Login</title>
</head>
<link rel="stylesheet" href="cilent.css">
<body>
    <h1>IntelliGuard</h1>
    <p>Welcome to IntelliGuard, please fill ur Visitid below:</p>
    <h2>Brings you to a pleasurable experience</h2>
    <div>
    <form method="POST">
    <input type="text" name="visitid" placeholder="visitid" required> 
    <i> =<?php if ($errorvisitid== true){echo $errorvisitidMessage;}?></I>
    <br><br>
    <input type ="submit" name="btnlogin" value="login">    
    </form>
</div>

    
</body>
</html>
