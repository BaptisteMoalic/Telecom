<?php

    //phpinfo();

    // User Data
    $username = "root";
    $password = "root";
        
        
    // Address and Port
    $addr = "192.168.43.172";
    $port = 8000;
    
    
    // DB data
    $dbhost = "127.0.0.1";
    $dbname = "points_of_interest";
    $dbuser = "root";
    $dbpassword = "pact_server2020";

    
    //Connexion à la BDD
    echo "Connecting to database...\n";
    try {
        $bdd = new PDO("mysql:host=$dbhost;dbname=$dbname;charset=utf8", "$dbuser", "$dbpassword", array(PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION));
    } catch(Exception $e) {
        echo "Error when connecting to the database\n";
        die("Error : ". $e->getMessage() ."\n");
    }
    echo "Successfully connected to database\n\n";
    $bdd->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_OBJ);

    
        
        
    // Creating a socket
    echo "Creating socket ...\n";
    if (!($sock = socket_create(AF_INET, SOCK_STREAM, IPPROTO_IP))){
        $error_code = socket_last_error();
        $error_msg = socket_strerror($error_code);
        
        echo "Couldn't create socket: [$error_code] $error_msg\n";
        exit;
    }
    echo "Socket succesfully created\n\n";
        
        
    // Binding socket
    echo "Binding socket ...\n";
    if (!(socket_bind($sock, $addr, $port))){
        $error_code = socket_last_error();
        $error_msg = socket_strerror($error_code);
        
        echo "Couldn't bind socket: [$error_code] $error_msg\n";
        exit;
    }
    echo "Socket succesfully binded\n\n";
        
        


    // Listening
    echo "Attempting to listening ...\n";
    if (!(socket_listen($sock, 10))){
        $error_code = socket_last_error();
        $error_msg = socket_strerror($error_code);
        
        echo "Couldn't listen on socket: [$error_code] $error_msg\n";
        exit;
    }
    echo "Successfully attempt successful\n";
    echo "Listening ...\n\n";
    
    
    
    
    
    // Server life-time
    while(true){

        // Wait for client
        $client = socket_accept($sock);
        echo "Client connected\n";
        
        // Connection life-time
        while (true){
            
            //Login or register
            socket_write($client, "Login (1) or register (2) ?\n");
            $login_or_register = socket_read($client, 16777216);
            if($login_or_register==2) {
                //Register
                echo "You're registering";
                socket_write($client, "Username: \n");
                $new_username = socket_read($client, 16777216);
                socket_write($client, "Email : \n");
                $new_email = socket_read($client, 16777216);
                socket_write($client, "Password : \n");
                $new_password = password_hash(socket_read($client, 16777216),PASSWORD_DEFAULT);
                //Ici, faudrait rajouter des vérifications sur l'email

                $response = $bdd->prepare('INSERT INTO users(users.name, users.password, email) VALUES(?,?,?)');
                $response->execute(array($new_username, $new_password, $new_email));
                $response->closeCursor();
                socket_write($client, "0\n");
                echo 'New user '.$new_username.' added to the database\n';

            }
            
            
            elseif($login_or_register==1) {
                // Login
                // Ask client for username
                socket_write($client, "Username:\n");
                $client_user = socket_read($client, 16777216);
                echo "Client Username: ". $client_user ."\n";
            
                // Check User & Password
                //Commencons par voir si un tel username existe dans la bdd
                //Ensuite, si un tel truc existe, on check les mdp
                //Penser à l'inscription après
                
                $response=$bdd->prepare("SELECT * FROM users WHERE users.name = ?");
                $response->execute(array($client_user));
                $data = $response->fetch(PDO::FETCH_ASSOC);
                if(!$data) {
                    echo 'No account found with the '.$client_user.' username\n';
                    socket_write($client, "QUIT\n");
                    echo "Client succesfully disconnected\n";
                    socket_close($client);
                    break;
                }
                else {

                    // Ask client for password
                    socket_write($client, "Password:\n");
                    $client_password = socket_read($client, 16777216);
                    echo "Client Password: ". $client_password ."\n";

                    //Check password
                    $db_password = $data['password'];
                    if(password_verify($client_password,$db_password)) {
                        echo "Client successfully logged in\n";
                        socket_write($client, "Successfully connected\n");
                    }
                    else {
                        echo 'Wrong password. Please try again.\n';
                        socket_write($client, "QUIT\n");
                        echo "Client succesfully disconnected\n";
                        socket_close($client);
                        break;
                    }
                }
            }
            
            
            else {
                echo 'Unknown value. Expected values are 1 or 2. Please try again.\n';
                socket_write($client, "QUIT\n");
                echo "Client succesfully disconnected\n";
                socket_close($client);
                break;
            }

            


            /*
            if ($username == $client_user && password_verify($password, password_hash($client_password, PASSWORD_DEFAULT))){
                echo "Client successfully logged in\n";
                socket_write($client, "Successfully connected\n");
            }
            else{
                echo "Client wrong username or password\n";
                socket_write($client, "QUIT\n");
                echo "Client succesfully disconnected\n";
                socket_close($client);
                break;
            }
            */
            
            
            $exit_code = -1;
            // Authentified Client Loop
            while (true){

                // Reading client input
                $input = socket_read($client, 16777216);
                echo "Client says: ". $input ."\n";
                
                // Check if client wants to disconnect
                if ($input == "quit"){
                    socket_write($client, "QUIT\n");
                    $exit_code = 0;
                    break;
                }
                // Check for disconnect
                if ($input == ""){
                    $exit_code = 1;
                    break;
                }
                
                
                /* DEJA UN CHECK POUR LE DISCONNECT
                if(count($request_code)==0) {
                    echo 'No request from the client.\n';
                }
                */

                
                // Treat Client request
                $request_code = explode("|", $input);
                
                switch($request_code[0]){

                    case 0: //LIRE POI/TRAJET SELON TYPE, variable $type
                        if(count($request_code)!=2) {
                            echo "Wrong number of arguments, the syntax should be : 'int' 'type'\n";
                            socket_write($client, "-1\n");
                            break;
                        }
                        
                        // POUR LES POI
                        $response=$bdd->prepare("SELECT * FROM poi WHERE poi.type = ?");
                        $response->execute(array($request_code[1]));
                        $data_sent=(array)array();
                        while($data = $response->fetch()) {
                            print_r($data);
                            array_push($data_sent,json_decode(json_encode($data),true));
                        }
                        $response->closeCursor();
                        echo "All ". $request_code[1] ." points of interest have been fetched\n";
                        
                        
                        // POUR LES TRAJETS
                        $response=$bdd->prepare("SELECT * FROM trips WHERE trips.type = ?");
                        $response->execute(array($request_code[1]));
                        while($data = $response->fetch()) {
                            print_r($data);
                            array_push($data_sent,json_decode(json_encode($data),true));
                        }
                        $data_sent = json_encode($data_sent,JSON_FORCE_OBJECT);
                        $response->closeCursor();
                        
                        socket_write($client,$data_sent ."\n");
                        echo "All ". $request_code[1] ." trips have been fetched\n";
                        break;

                        
                        
                        
                  
                        
                        

                        
                    case 1: //LIRE POI/TRAJET SELON REGION, variables $longitude_left, $longitude_right, $lat_left, $lat_right
                        if(count($request_code)!=5) {
                            echo "Wrong number of arguments, the syntax should be : 'int' 'longitude_left' 'longitude_right' 'lat_left' 'lat_right'\n";
                            socket_write($client, "-1\n");
                            break;
                        }
                        $response=$bdd->prepare("SELECT * FROM poi WHERE longitude BETWEEN ? AND ? AND lat BETWEEN ? AND ?");
                        // Y'a pas de lat et de long pour les trips, comment on choisit?
                        $response->execute(array($request_code[1], $request_code[2], $request_code[3], $request_code[4]));
                        $data_sent=(array)array();
                        while($data = $response->fetch()) {
                            print_r($data);
                            array_push($data_sent,json_decode(json_encode($data),true));
                        }
                        $data_sent = json_encode($data_sent,JSON_FORCE_OBJECT);
                        socket_write($client,$data_sent . "\n");
                        $response->closeCursor();
                        echo "All points of interest located in this region have been fetched\n";
                        break;

                        
                        
                        
                        
                        
                        
                        
                        
                        
                    case 2: //ECRIRE POI DANS BDD, variables $name, $longitude, $lat, $type, $comment, $date_of_creation, $user_added
                        if(count($request_code)!=8) {
                            echo "Wrong number of arguments, the syntax should be : 'int' 'name' 'longitude' 'lat' 'type' 'comment' 'date_of_creation' 'user_added'\n";
                            socket_write($client, "-1\n");
                            break;
                        }
                        $response=$bdd->prepare("INSERT INTO poi(poi.name,longitude,lat,poi.type,comment,date_of_creation,user_added) VALUES(?,?,?,?,?,?,?)");
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
                        socket_write($client, "0\n");
                        echo "Point of interest ". $request_code[1] . " successfully added\n";
                        break;

                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                    case 3: //ECRIRE TRAJET DANS BDD, variables $name, $trip_list, $type, $vehicle, $trip_duration, $comment, $date_of_creation, $user_added
                        if(count($request_code)!=9) {
                            echo "Wrong number of arguments, the syntax should be : 'int' 'name' 'trip_list' 'type' 'vehicle' 'trip_duration' 'comment' 'date_of_creation' 'user_added'\n";
                            socket_write($client, "-1\n");
                            break;
                        }
                        $response=$bdd->prepare("INSERT INTO trips(trips.name,trip_list,trips.type,vehicle,trip_duration,comment,date_of_creation,user_added) VALUES(:name, :trip_list, :type, :vehicle, :trip_duration, :comment, :date_of_creation, :user_added)");
                        $response->execute(array(
                            "name"=>$request_code[1],
                            "trip_list"=>$request_code[2],
                            "type"=>$request_code[3],
                            "vehicle"=>$request_code[4],
                            "trip_duration"=>$request_code[5],
                            "comment"=>$request_code[6],
                            "date_of_creation"=>$request_code[7],
                            "user_added"=>$request_code[8]));
                        $response->closeCursor();
                        socket_write($client, "0\n");
                        echo "Trip ". $request_code[1] ." successfully added\n";
                        break;

                        
                        
                        
                        
                        
                        
                        
                        
                        
                    case 4: //SUPPRIMER POI/TRAJET DE LA BDD
                        echo "Feature not implemented yet. Please try again later\n";
                        break;

                        
                        
                        
                        
                        
                        
                        
                        
                        
                    default:
                        echo "Unknown request. Please try again.\n";
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
            switch ($exit_code) {
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
