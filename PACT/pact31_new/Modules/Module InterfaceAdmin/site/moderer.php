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

if($_SERVER["REQUEST_METHOD"] == "POST") {
    $sql = "DELETE FROM poi WHERE poi_id = ?";
    $stmt = $mysqli->prepare($sql);
    $stmt->bind_param("s",$_POST["submitbutton"]);
    $stmt->execute();
    $_SESSION["deleted"]=true;

}

$result = $mysqli->query("SELECT poi_id, user_added, name, longitude, lat, date_of_creation FROM (SELECT * FROM poi ORDER BY date_of_creation DESC) AS PoiSorted LIMIT 10");
$tableau=$result->fetch_all();
?>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>Table - Brand</title>
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i">
    <link rel="stylesheet" href="assets/fonts/fontawesome-all.min.css">
    <link rel="stylesheet" href="assets/fonts/font-awesome.min.css">
    <link rel="stylesheet" href="assets/fonts/fontawesome5-overrides.min.css">
    <link rel="stylesheet" href="assets/css/styles.min.css">
</head>

<body id="page-top">
    <div id="wrapper">
        <nav class="navbar navbar-dark align-items-start sidebar sidebar-dark accordion bg-gradient-primary p-0">
            <div class="container-fluid d-flex flex-column p-0"><a class="navbar-brand d-flex justify-content-center align-items-center sidebar-brand m-0" href="#">
                    <div class="sidebar-brand-icon rotate-n-15"><img src="assets/img/logo.svg" style="width: 54px;filter: invert(100%);"></div>
                    <div class="sidebar-brand-text mx-3"><span>OnionWizz</span></div>
                </a>
                <hr class="sidebar-divider my-0">
                <ul class="navbar-nav text-light" id="accordionSidebar">
                    <li class="nav-item"><a class="nav-link" href="panneau.php"><i class="fas fa-tachometer-alt"></i><span>Panneau de contrôle</span></a></li>
                    <li class="nav-item"><a class="nav-link" href="ajouter.php"><i class="fa fa-plus"></i><span>Ajouter</span></a></li>
                    <li class="nav-item"><a class="nav-link active" href="moderer.php"><i class="fa fa-exclamation-triangle"></i><span>Modérer</span></a></li>
                    <li class="nav-item"><a class="nav-link" href="logout.php"><i class="fas fa-door-open"></i><span>Se déconnecter</span></a></li>
                </ul>
                <div class="text-center d-none d-md-inline"></div>
            </div>
        </nav>
        <div class="d-flex flex-column" id="content-wrapper">
            <div id="content">
                <nav class="navbar navbar-light navbar-expand bg-white shadow mb-4 topbar static-top">
                    <div class="container-fluid"><button class="btn btn-link d-md-none rounded-circle mr-3" id="sidebarToggleTop" type="button"><i class="fas fa-bars"></i></button>
                        <ul class="navbar-nav flex-nowrap ml-auto">
                            <li class="nav-item dropdown no-arrow"><span class="d-none d-lg-inline mr-2 text-gray-600 small"><?php echo $_SESSION["username"]; ?></span></li>
                        </ul>
                    </div>
                </nav>
                <div class="container-fluid">
                    <h3 class="text-dark mb-4">Modifications utilisateurs (points d'intérêt)</h3>
                    <div class="card shadow">
                        <div class="card-body">
                            <?php
                                if(isset($_SESSION["deleted"]) && $_SESSION["deleted"]) {
                                    echo "Le point d'intérêt a été supprimé !";
                                    $_SESSION["deleted"]=false;
                                }
                            ?>
                            <div class="table-responsive table mt-2" id="dataTable" role="grid" aria-describedby="dataTable_info">
                                <table class="table my-0" id="dataTable">
                                    <thead>
                                        <tr>
                                            <th>Utilisateur</th>
                                            <th>POI</th>
                                            <th>Longitude</th>
                                            <th>Latitude</th>
                                            <th>Date</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php foreach ($tableau as $ligne): ?>
                                        <tr>
                                            <?php foreach (array_slice($ligne, 1) as $element): ?>
                                            <td><?php echo $element;?></td><?php endforeach; ?>
                                            <?php
                                                echo "<td class=\"d-lg-flex align-items-lg-center\"><form action=moderer.php method=post><button class=\"btn btn-primary\" type=\"submit\" style=\"background: var(--red);\" name=\"submitbutton\"value=\"" . $ligne[0] . "\">Delete</button></form></td>"
                                            ?>
                                        </tr><?php endforeach; ?>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <td><strong>Utilisateur</strong></td>
                                            <td><strong>POI</strong></td>
                                            <td><strong>Longitude</strong></td>
                                            <td><strong>Latitude</strong></td>
                                            <td><strong>Date</strong></td>
                                            <td><strong>Action</strong></td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
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
