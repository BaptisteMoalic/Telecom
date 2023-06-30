<?php

    
    // User Data
    $username = "PACT_31";
    $password = "pact_31";
    
    
    
    // Address and Port
    $addr = "127.0.0.1";
    $port = 8000;
    
    
    
    
    
    
    
    
    
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
                
                switch($request_code[0]){
                    case 0:
                        (PI_ID)
                        break;
                    case 1:
                        break;
                }
                
                
                
                
                
                
                
                
                // Send to client
                $send_mess = "Server received message";
                socket_write($client, $send_mess);
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
    
    
    
?>
