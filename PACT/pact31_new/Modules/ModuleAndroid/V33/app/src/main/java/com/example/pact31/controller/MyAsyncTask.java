package com.example.pact31.controller;

import android.os.AsyncTask;

import org.json.JSONObject;

import java.io.IOException;

public class MyAsyncTask extends AsyncTask<String, String, JSONObject> {

    public MyAsyncTask(){

    }

    @Override
    protected JSONObject doInBackground(String... strings) {
        if (TomTomNetwork.getMode() == "ROUTING") {
            try {
                return TomTomNetwork.getInstance().requestRoute();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return null;
    }


}
