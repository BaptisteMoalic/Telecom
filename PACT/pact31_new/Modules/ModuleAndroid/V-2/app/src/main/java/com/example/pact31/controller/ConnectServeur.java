package com.example.pact31.controller;

import android.os.AsyncTask;

public class ConnectServeur extends AsyncTask<String, Void, Void> {

    private Client client;
    private String command;
    private String address;
    private int port;
    private String username;
    private String password;

    public ConnectServeur(String address, int port, String username, String password, String command) {
        this.address=address;
        this.port=port;
        this.username=username;
        this.password=password;
        this.command=command;
    }

    @Override
    protected Void doInBackground(String... strings) {

        client = new Client(address, port, username, password);

        /*System.out.println(address);
        System.out.println(port);
        System.out.println(username);
        System.out.println(password);
        System.out.println(command);*/

        client.connect();

        String[] cmd = command.split("\\|");
        /*System.out.println(cmd[0]);
        System.out.println(cmd[0]=="WRITEPOI");
        System.out.println(cmd[1]);
        System.out.println(cmd[2]);
        System.out.println(cmd[3]);
        System.out.println(cmd[4]);
        System.out.println(cmd[5]);
        System.out.println(cmd[6]);*/
        /*if(cmd[0]=="WRITEPOI") {*/
        if (true) {
            client.write_poi(cmd[1], Integer.parseInt(cmd[2]), Integer.parseInt(cmd[3]),
                    cmd[4], cmd[5], cmd[6]);
        }

        client.disconnect();
        return null;
    }

}
