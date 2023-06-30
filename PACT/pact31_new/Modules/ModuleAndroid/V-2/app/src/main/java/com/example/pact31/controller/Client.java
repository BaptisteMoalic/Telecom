package com.example.pact31.controller;

import java.io.PrintWriter;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.Socket;
// import java.util.Scanner;

public class Client {

    private String address;
    private int port;

    private String username;
    private String password;

    private int connected;
    private int authenticated;


    // Socket
    Socket sock;
    PrintWriter wOut;
    BufferedReader rOut;// = new BufferedReader(
    //   new InputStreamReader(soc.getInputStream())



    /*
        Address     (depends on how we connect devices)
        Port        8000
        username    root
        password    root
    */
    // Constructor
    public Client(String address, int port, String username, String password){
        // Initialise address and port
        this.address = address;
        this.port = port;

        // Initialise user data
        this.username = username;
        this.password = password;


    }


    // Connect to client
    public int connect(){
        // Connect to address and port

        try{
            sock = new Socket(address, port);
            wOut = new PrintWriter(sock.getOutputStream());
            rOut = new BufferedReader(new InputStreamReader(sock.getInputStream()));

            String msg;
            // Connect with user data

            // Read for login/register
            msg = rOut.readLine();
            System.out.println(msg);


            wOut.write("1");
            wOut.flush();

            msg = rOut.readLine();
            System.out.println(msg);


            wOut.write(username);
            wOut.flush();



            msg = rOut.readLine();
            System.out.println(msg);

            wOut.write(password);
            wOut.flush();

            // Make different case if password is correct or not
            msg = rOut.readLine();
            System.out.println(msg);

            if (msg == "Successfully connected"){
                return 0;
            }

        }catch(Exception e){
            System.out.println("BUG");
            e.printStackTrace();
        }
        return -1;


    }

    public void disconnect(){
        // Disconnect

        // Send message to server to quit
        String mess = "quit";
        wOut.write(mess);
        wOut.flush();

        System.out.println("Successfully disconnected");

        try{
            sock.close();
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public void read_poi_type(String type){
        // Put them into one string and print
        String mess = "0|" + type;
        wOut.write(mess);
        wOut.flush();

        try{
            String msg = rOut.readLine();
            System.out.println(msg);
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public void read_poi_area(int long_left, int long_right, int lat_left, int lat_right){
        // Put them into one string and print
        String mess = "1|" + long_left + "|" + long_right + "|" + lat_left + "|" + lat_right;
        wOut.write(mess);
        wOut.flush();

        try{
            String msg = rOut.readLine();
            System.out.println(msg);
        }catch(Exception e){
            e.printStackTrace();
        }
    }


    // Functionnalities
    public void write_poi(String name, int longitude, int latitude, String type, String comment, String date_created){
        // Put them into one string and print
        String mess = "2|" + name + "|" + longitude + "|" + latitude + "|" + type + "|" + comment + "|" + date_created + "|" + username;
        wOut.write(mess);
        wOut.flush();

        try{
            String msg = rOut.readLine();
            System.out.println(msg);
        } catch(Exception e){
            e.printStackTrace();
        }

    }

    public void write_trip(String name, String trip, String type, String vehicle, int duration, String comment, String date_created){
        // Put them into one string and print
        String mess = "3|" + name + "|" + trip + "|" + type + "|" + vehicle + "|" + duration + "|" + comment + "|" + date_created + "|" + username;
        //String mess = "Hello!";
        wOut.write(mess);
        wOut.flush();

        try{
            String msg = rOut.readLine();
            System.out.println(msg);
        }catch(Exception e){
            e.printStackTrace();
        }
    }


}
