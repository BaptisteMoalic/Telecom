<!DOCTYPE html>
<html>
<head>
	<title>password hash</title>
</head>
<body>
	<?php
	if ($_SERVER["REQUEST_METHOD"] == "POST") {
		echo "Password: " . $_POST["password"]. "<br />";
		echo "Hashed password: " . password_hash($_POST["password"], PASSWORD_DEFAULT);
	}
	
	?>
	<form action=password.php method=post>
		<input name=password type=password />
		<input type=submit />
	</form>
</body>
</html>