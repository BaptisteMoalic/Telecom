<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>Login - OnionWizz</title>
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i">
    <link rel="stylesheet" href="assets/fonts/fontawesome-all.min.css">
    <link rel="stylesheet" href="assets/fonts/font-awesome.min.css">
    <link rel="stylesheet" href="assets/fonts/fontawesome5-overrides.min.css">
    <link rel="stylesheet" href="assets/css/styles.min.css">
</head>

<body class="bg-gradient-primary">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-9 col-lg-12 col-xl-10">
                <div class="card shadow-lg o-hidden border-0 my-5">
                    <div class="card-body p-0">
                        <div class="p-5">
                            <div class="text-center">
                                <h4 class="text-dark mb-4">OnionWizz</h4>
                            </div>
                            <form class="user" action=login.php method=post>
                                <?php
                                session_start();

                                    // Check if the user is already logged in, if yes then redirect him to welcome page
                                    
                                    if(isset($_SESSION["loggedin"]) && $_SESSION["loggedin"] === true){
                                        header("location: panneau.php");
                                        exit;
                                    }

                                    define('DB_SERVER', 'localhost');
                                    define('DB_USERNAME', 'root');
                                    define('DB_PASSWORD', 'pact_server2020');
                                    define('DB_NAME', 'points_of_interest');

                                    $link = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);

                                    if($link === false){
                                        die("ERROR: Could not connect. " . mysqli_connect_error());
                                    }

                                    $username = $password = "";
                                    $username_err = $password_err = $login_err = "";

                                    if($_SERVER["REQUEST_METHOD"] == "POST"){

                                        // Check if username is empty
                                        if(empty(trim($_POST["username"]))){
                                            $username_err = "Please enter username.";
                                        } else{
                                            $username = trim($_POST["username"]);
                                        }
                                        
                                        // Check if password is empty
                                        if(empty(trim($_POST["password"]))){
                                            $password_err = "Please enter your password.";
                                        } else{
                                            $password = trim($_POST["password"]);
                                        }
                                        
                                        // Validate credentials
                                        if(empty($username_err) && empty($password_err)) {
                                            // Prepare a select statement
                                            $sql = "SELECT id, username, password FROM admin_user WHERE username = ?";
                                            
                                            if($stmt = mysqli_prepare($link, $sql)){
                                                // Bind variables to the prepared statement as parameters
                                                if(mysqli_stmt_bind_param($stmt, "s", $param_username)) {

                                                // Set parameters
                                                    $param_username = $username;

                                                // Attempt to execute the prepared statement
                                                    if(mysqli_stmt_execute($stmt)){
                                                    // Store result
                                                        mysqli_stmt_store_result($stmt);

                                                    // Check if username exists, if yes then verify password
                                                        if(mysqli_stmt_num_rows($stmt) == 1){                    
                                                        // Bind result variables
                                                            mysqli_stmt_bind_result($stmt, $id, $username, $hashed_password);
                                                            if(mysqli_stmt_fetch($stmt)){
                                                                if(password_verify($password, $hashed_password)){
                                                                // Password is correct, so start a new session
                                                                    session_start();

                                                                // Store data in session variables
                                                                    $_SESSION["loggedin"] = true;
                                                                    $_SESSION["id"] = $id;
                                                                    $_SESSION["username"] = $username;                            

                                                                // Redirect user to welcome page
                                                                    header("location: panneau.php");
                                                                } else {
                                                                // Password is not valid, display a generic error message
                                                                    $login_err = "Invalid username or password.";
                                                                    echo $login_err;
                                                                }
                                                            } else {
                                                                echo mysqli_error($link);
                                                            }
                                                        } else{
                                                        // Username doesn't exist, display a generic error message
                                                            $login_err = "Invalid username or password.";
                                                            echo $login_err;
                                                        }
                                                    } else{
                                                        echo mysqli_error($link);
                                                    }

                                                // Close statement
                                                    mysqli_stmt_close($stmt); } 
                                                    else {
                                                        echo mysqli_error($link);
                                                    }
                                                } else {
                                                    echo mysqli_error($link);
                                                }
                                            } else {
                                                echo $username_err . " " . $password_err;
                                            }

                                        // Close connection
                                            mysqli_close($link);
                                        }

                                        ?>
                                <div class="form-group"><input class="form-control form-control-user" type="text" placeholder="Username" name="username"></div>
                                <div class="form-group"><input class="form-control form-control-user" type="password" id="exampleInputPassword" placeholder="Password" name="password"></div><button class="btn btn-primary btn-block text-white btn-user" type="submit">Login</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="assets/js/jquery.min.js"></script>
    <script src="assets/bootstrap/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.4.1/jquery.easing.js"></script>
    <script src="assets/js/script.min.js"></script>
</body>

</html>
