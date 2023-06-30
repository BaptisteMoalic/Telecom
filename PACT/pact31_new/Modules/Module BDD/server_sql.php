<?php

    //phpinfo();

    // User Data
    $username = "root";
    $password = "root";
        
        
    // Address and Port
    $addr = "127.0.0.1";
    $port = 8000;
    
    
    //Connexion à la BDD
    
    $dbhost = "127.0.0.1";
    $dbname = "points_of_interest";
    $dbuser = "root";
    $dbpassword = "";


    echo "Connecting to database...\n";
    try {
        $bdd = new PDO("mysql:host=$dbhost;dbname=$dbname;charset=utf8", "$dbuser", "$dbpassword", array(PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION));
    } catch(Exception $e) {
        echo "Error when connecting to the database\n";
        die("Error : ".$e->getMessage());
    }
    $bdd->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_OBJ);

    
        
        
    // Creating a socket
    echo "Creating socket\n";
    if (!($sock = socket_create(AF_INET, SOCK_STREAM, IPPROTO_IP))){
        $error_code = socket_last_error();
        $error_msg = socket_strerror($error_code);
        
        echo "Couldn't create socket: [$error_code] $error_msg\n";
        exit;
    }
    echo "Socket succesfully created\n\n";
        
        
    // Binding socket
    echo "Binding socket\n";
    if (!(socket_bind($sock, $addr, $port))){
        $error_code = socket_last_error();
        $error_msg = socket_strerror($error_code);
        
        echo "Couldn't bind socket: [$error_code] $error_msg\n";
        exit;
    }
    echo "Socket succesfully binded\n\n";
        
        


    // Listening
    echo "Attempting to listening\n";
    if (!(socket_listen($sock, 10))){
        $error_code = socket_last_error();
        $error_msg = socket_strerror($error_code);
        
        echo "Couldn't listen on socket: [$error_code] $error_msg\n";
        exit;
    }
    echo "Listening ...\n\n";
    
    
    
    
    
    // Server life-time
    while(true){

        // Wait for client
        $client = socket_accept($sock);
        echo "Client connected\n";
        
        $connected = false;
        // Connection life-time
        while (true){
            
            // Login
            // Ask client for username
            $send_mess = "Username:";
            socket_write($client, $send_mess);
            $client_user = socket_read($client, 16777216);
            echo "Client Username: ". $client_user ."\n";
            
            // Ask client for username
            $send_mess = "Password:";
            socket_write($client, $send_mess);
            $client_password = socket_read($client, 16777216);
            echo "Client Password: ". $client_password ."\n";
            
            // Check User & Password
            if ($username == $client_user && password_verify($password, password_hash($client_password, PASSWORD_DEFAULT))){
                echo "Client successfully infiltrated\n";
                $send_mess = "Successfully connected";
                socket_write($client, $send_mess);
            }
            else{
                $send_mess = "Wrong username or password";
                socket_write($client, $send_mess);
                $send_mess = "QUIT";
                socket_write($client, $send_mess);
                socket_close($client);
                echo "Client wrong username or password\n";
                echo "Client succesfully disconnected\n";
                break;
            }
            
            
            
            $connected = true;
            $exit = -1;
            // Authentified Client Loop
            while ($connected){

                // Reading client input
                $input = socket_read($client, 16777216);
                echo "Client says: ". $input ."\n";
                
                // Check if client wants to disconnect
                if ($input == "quit"){
                    $send_mess = "QUIT";
                    socket_write($client, $send_mess);
                    $exit = 0;
                    break;
                }
                // Check for disconnect
                if ($input == ""){
                    $exit = 1;
                    break;
                }
                
                // Treat Client request
                $request_code = explode(" ", $input);
                
                /* DEJA UN CHECK POUR LE DISCONNECT
                if(count($request_code)==0) {
                    echo 'No request from the client.\n';
                }
                */

                switch($request_code[0]){

                    case 0: //LIRE POI/TRAJET SELON TYPE, variable $type
                        if(count($request_code)!=2) {
                            echo 'Wrong number of arguments, the syntax should be : \'int\' \'type\'\n';
                            break;
                        }
                        // POUR LES POI
                        $response=$bdd->prepare('SELECT * FROM poi WHERE poi.type = ?');
                        $response->execute(array($request_code[1]));
                        $data_sent=(array)array();
                        while($data = $response->fetch()) {
                            print_r($data);
                            array_push($data_sent,json_decode(json_encode($data),true));
                        }
                        $response->closeCursor();
                        echo 'All '.$request_code[1].' points of interest have been fetched\n';
                        // POUR LES TRAJETS
                        $response=$bdd->prepare('SELECT * FROM trips WHERE trips.type = ?');
                        $response->execute(array($request_code[1]));
                        while($data = $response->fetch()) {
                            print_r($data);
                            array_push($data_sent,json_decode(json_encode($data),true));
                        }
                        $data_sent = json_encode($data_sent,JSON_FORCE_OBJECT);
                        socket_write($client,$data_sent);
                        $response->closeCursor();
                        echo 'All '.$request_code[1].' trips have been fetched\n';
                        break;

                    case 1: //LIRE POI/TRAJET SELON REGION, variables $longitude_left, $longitude_right, $lat_left, $lat_right
                        if(count($request_code)!=5) {
                            echo 'Wrong number of arguments, the syntax should be : \'int\' \'longitude_left\' \'longitude_right\' \'lat_left\' \'lat_right\'\n';
                            break;
                        }
                        $response=$bdd->prepare('SELECT * FROM poi WHERE longitude BETWEEN ? AND ? AND lat BETWEEN ? AND ?');
                        // Y'a pas de lat et de long pour les trips, comment on choisit?
                        $response->execute(array($request_code[1], $request_code[2], $request_code[3], $request_code[4]));
                        $data_sent=(array)array();
                        while($data = $response->fetch()) {
                            print_r($data);
                            array_push($data_sent,json_decode(json_encode($data),true));
                        }
                        $data_sent = json_encode($data_sent,JSON_FORCE_OBJECT);
                        socket_write($client,$data_sent);
                        $response->closeCursor();
                        echo 'All points of interest located in this region have been fetched\n';
                        break;

                    case 2: //ECRIRE POI DANS BDD, variables $name, $longitude, $lat, $type, $comment, $date_of_creation, $user_added
                        if(count($request_code)!=8) {
                            echo 'Wrong number of arguments, the syntax should be : \'int\' \'name\' \'longitude\' \'lat\' \'type\' \'comment\' \'date_of_creation\' \'user_added\'\n';
                            break;
                        }
                        $response=$bdd->prepare('INSERT INTO poi(poi.name,longitude,lat,poi.type,comment,date_of_creation,user_added) VALUES(?,?,?,?,?,?,?)');
                        /*
                        $response=$bdd->prepare('INSERT INTO poi(name,longitude,lat,type,comment,date_of_creation,user_added) VALUES(:name, :trip_list, :type, :vehicle, :trip_duration, :comment, :date_of_creation, :user_added)');
                        $response->execute(array(
                            'name'=>$request_code[1],
                            'longitude'=>$request_code[2],
                            'lat'=>$request_code[3],
                            'type'=>$request_code[4],
                            'comment'=>$request_code[5],
                            'date_of_creation'=>$request_code[6],
                            'user_added'=>$request_code[7]));
                            */
                        $response->execute(array($request_code[1], $request_code[2], $request_code[3], $request_code[4], $request_code[5], $request_code[6], $request_code[7]));
                        $response->closeCursor();
                        echo 'Point of interest '.$request_code[1].' successfully added\n';
                        break;

                    case 3: //ECRIRE TRAJET DANS BDD, variables $name, $trip_list, $type, $vehicle, $trip_duration, $comment, $date_of_creation, $user_added
                        if(count($request_code)!=9) {
                            echo 'Wrong number of arguments, the syntax should be : \'int\' \'name\' \'trip_list\' \'type\' \'vehicle\' \'trip_duration\' \'comment\' \'date_of_creation\' \'user_added\'\n';
                            break;
                        }
                        $response=$bdd->prepare('INSERT INTO trips(trips.name,trip_list,trips.type,vehicle,trip_duration,comment,date_of_creation,user_added) VALUES(:name, :trip_list, :type, :vehicle, :trip_duration, :comment, :date_of_creation, :user_added)');
                        $response->execute(array(
                            'name'=>$request_code[1],
                            'trip_list'=>$request_code[2],
                            'type'=>$request_code[3],
                            'vehicle'=>$request_code[4],
                            'trip_duration'=>$request_code[5],
                            'comment'=>$request_code[6],
                            'date_of_creation'=>$request_code[7],
                            'user_added'=>$request_code[8]));
                        $response->closeCursor();
                        echo 'Trip '.$request_code[1].' successfully added\n';
                        break;

                    case 4: //SUPPRIMER POI/TRAJET DE LA BDD
                        echo 'Feature not implemented yet. Please try again later\n';
                        break;

                    default:
                        echo 'Unknown request. Please try again.\n';
                        break;
                }
                
                
                /* TOUJOURS AVOIR WRITE/READ/WRITE/READ ETC...
                // Send to client
                $send_mess = "Server received message";
                socket_write($client, $send_mess);
                */
            }
            
            
            
            
            
            
            // Disconnect Client with exit code
            socket_close($client);
            switch ($exit) {
                case 0:
                    echo "Client succesfully disconnected\n";
                    break;
                case 1:
                echo "Client forcefully disconnected\n";
                    break;
            }
            
            break;

            
            
        }
        
        
    }
    
    socket_close($sock);


    /*
    //Il faudra faire la différence entre si le gars veut insert, update, delete etc... ==> FAIRE UN SWITCH
    $operation = 
    //INSERT un trajet, variables $name, $trip_list, $type, $vehicle, $trip_duration, $comment, $date_of_creation, $user_added
    $response=$bdd->prepare('INSERT INTO trips(name,trip_list,type,vehicle,trip_duration,comment,date_of_creation,user_added) VALUES(:name, :trip_list, :type, :vehicle, :trip_duration, :comment, :date_of_creation, :user_added)');
    $response->execute(array(
        'name'=>$name,
        'trip_list'=>$trip_list,
        'type'=>$type,
        'vehicle'=>$vehicle,
        'trip_duration'=>$trip_duration,
        'comment'=>$comment,
        'date_of_creation'=>$date_of_creation,
        'user_added'=>$user_added));

    echo 'Trip '.$name.' successfully added';

    //INSERT un poi, variables $name, $longitude, $lat, $type, $comment, $date_of_creation, $user_added
    $response=$bdd->prepare('INSERT INTO poi(name,longitude,lat,type,comment,comment,date_of_creation,user_added) VALUES(:name, :trip_list, :type, :vehicle, :trip_duration, :comment, :date_of_creation, :user_added)');
    $response->execute(array(
        'name'=>$name,
        'trip_list'=>$trip_list,
        'type'=>$type,
        'vehicle'=>$vehicle,
        'trip_duration'=>$trip_duration,
        'comment'=>$comment,
        'date_of_creation'=>$date_of_creation,
        'user_added'=>$user_added));

    echo 'Point of interest '.$name.' successfully added';

    //RETIRER plusieurs trajets
    $quit=0
    while(!$quit) {

    }


    //LIRE avec un type, variable $type
    $response=$bdd->prepare('SELECT * FROM trips,poi WHERE type = ?');
    $response->execute(array($type));
    while($data = $response->fetch()) {
        echo $data;
    }


    //LIRE dans une région, variables $longitude_left, $longitude_right, $lat_left, $lat_right
    $response=$bdd->prepare('SELECT * FROM trips,poi WHERE longitude BETWEEN ? AND ? AND lat BETWEEN ? AND ?');
    $response->execute(array($longitude_left, $longitude_right, $lat_left, $lat_left));
    while($data = $response->fetch()) {
        echo $data;
    }  

    */

    
?>
