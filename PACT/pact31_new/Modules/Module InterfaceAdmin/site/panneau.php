<!DOCTYPE html>
<html>
<?php
session_start();

if(!isset($_SESSION["loggedin"]) || $_SESSION["loggedin"] === false){
    header("location: login.php");
    exit;
}


define('DB_SERVER', 'localhost');
define('DB_NAME', 'points_of_interest');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', 'pact_server2020');

$mysqli = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);

if($mysqli === false){
    die("ERROR: Could not connect. " . $mysqli->error);
}

?>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>Dashboard - OnionWizz</title>
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i">
    <link rel="stylesheet" href="assets/fonts/fontawesome-all.min.css">
    <link rel="stylesheet" href="assets/fonts/font-awesome.min.css">
    <link rel="stylesheet" href="assets/fonts/fontawesome5-overrides.min.css">
    <link rel="stylesheet" href="assets/css/styles.min.css">
</head>

<body id="page-top">
    <div id="wrapper" style="height: max;">
        <nav class="navbar navbar-dark align-items-start sidebar sidebar-dark accordion bg-gradient-primary p-0">
            <div class="container-fluid d-flex flex-column p-0"><a class="navbar-brand d-flex justify-content-center align-items-center sidebar-brand m-0" href="#">
                    <div class="sidebar-brand-icon rotate-n-15"><img src="assets/img/logo.svg" style="width: 54px;filter: invert(100%);"></div>
                    <div class="sidebar-brand-text mx-3"><span>OnionWizz</span></div>
                </a>
                <hr class="sidebar-divider my-0">
                <ul class="navbar-nav text-light" id="accordionSidebar">
                    <li class="nav-item"><a class="nav-link active" href="panneau.php"><i class="fas fa-tachometer-alt"></i><span>Panneau de contrôle</span></a></li>
                    <li class="nav-item"><a class="nav-link" href="ajouter.php"><i class="fa fa-plus"></i><span>Ajouter</span></a></li>
                    <li class="nav-item"><a class="nav-link" href="moderer.php"><i class="fa fa-exclamation-triangle"></i><span>Modérer</span></a></li>
                    <li class="nav-item"><a class="nav-link" href="logout.php"><i class="fas fa-door-open"></i><span>Se déconnecter</span></a></li>
                </ul>
                <div class="text-center d-none d-md-inline"></div>
            </div>
        </nav>
        <div class="d-flex flex-column" id="content-wrapper" style="height: auto;">
            <div id="content">
                <nav class="navbar navbar-light navbar-expand bg-white shadow mb-4 topbar static-top">
                    <div class="container-fluid"><button class="btn btn-link d-md-none rounded-circle mr-3" id="sidebarToggleTop" type="button"><i class="fas fa-bars"></i></button>
                        <ul class="navbar-nav flex-nowrap ml-auto">
                            <li class="nav-item dropdown no-arrow"><span class="d-none d-lg-inline mr-2 text-gray-600 small"><?php echo $_SESSION["username"]; ?></span></li>
                        </ul>
                    </div>
                </nav>
                <div class="container-fluid">
                    <div class="d-sm-flex justify-content-between align-items-center mb-4">
                        <h3 class="text-dark mb-0">Panneau de contrôle</h3>
                    </div>
                </div>
                <div class="container" style="padding: 0px;margin-right: 608px;padding-left: 0px;margin-left: 18px;width: 50%;">
                    <div class="row" style="margin: 0px;border-style: solid;">
                        <div class="col" style="height: 71px;width: 103px;padding-right: 12px;max-width: 37px;"><i class="fa fa-user" style="margin-top: 27px;"></i></div>
                        <div class="col text-center d-flex d-sm-flex justify-content-center align-items-center align-self-center justify-content-sm-center align-items-sm-center" style="height: 70px;"><span class="d-md-flex justify-content-md-center align-items-md-center" style="margin: auto;"><?php
                            $result = $mysqli->query("SELECT COUNT(*) FROM users");
                            echo $result->fetch_array()[0];
                        ?></span></div>
                    </div>
                    <div class="row" style="margin: 0px;border-style: solid;">
                        <div class="col" style="height: 71px;width: 103px;padding-right: 12px;max-width: 37px;"><i class="fa fa-map-signs" style="margin-top: 27px;"></i></div>
                        <div class="col d-flex d-sm-flex justify-content-center align-items-center justify-content-sm-center align-items-sm-center" style="height: 70px;margin: 0px;"><span class="d-md-flex justify-content-md-center align-items-md-center" style="margin: auto;"><?php
                            $result = $mysqli->query("SELECT COUNT(*) FROM trips");
                            echo $result->fetch_array()[0];
                        ?></span></div>
                    </div>
                    <div class="row" style="margin: 0px;border-style: solid;">
                        <div class="col" style="height: 71px;width: 103px;padding-right: 12px;max-width: 37px;"><i class="fa fa-map-pin" style="margin-top: 27px;"></i></div>
                        <div class="col d-flex d-sm-flex justify-content-center align-items-center justify-content-sm-center align-items-sm-center" style="height: 70px;"><span class="d-md-flex justify-content-md-center align-items-md-center" style="margin: auto;"><?php
                            $result = $mysqli->query("SELECT COUNT(*) FROM poi");
                            echo $result->fetch_array()[0];
                        ?></span></div>
                    </div>
                </div>
            </div>
            <footer class="bg-white sticky-footer">
                <div class="container my-auto">
                    <div class="text-center my-auto copyright"><span>Copyright © OnionWizz 2021</span></div>
                </div>
            </footer>
        </div>
    </div>
    <script src="assets/js/jquery.min.js"></script>
    <script src="assets/bootstrap/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.4.1/jquery.easing.js"></script>
    <script src="assets/js/script.min.js"></script>
</body>

</html>
