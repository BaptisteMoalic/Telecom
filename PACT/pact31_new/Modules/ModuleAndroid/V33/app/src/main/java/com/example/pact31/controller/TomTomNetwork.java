package com.example.pact31.controller;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;

import org.json.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;

public class TomTomNetwork {
    // On veut avoir une seule instance a partir de laquelle faire des requetes
    // On utilise donc une structure de singleton

    private static final String TAG = "TomTomNetwork";
    private static TomTomNetwork instance = null;
    private String rootURL;
    private String requestURL; // les urls seront crées ici
    private static String mode = null;
    private final String APIKey = "eLYRZY8NPBhzWfADw45cqvfzo9gIzarN"; // la clef api du compte PACT31

    private TomTomNetwork()
    {
        rootURL = "https://api.tomtom.com/";
    }

    public static TomTomNetwork getInstance()
    {
        if (null == instance)
            instance = new TomTomNetwork();
        return instance;
    }

    public static String getMode() { return mode; }

    public void buildRoutingURL(Point A, Point B, String travelMode, String vehicleHeading)
    {
        String version = "1";
        this.requestURL = rootURL + "routing/" + version + "/calculateRoute/"
                + A.getLatitude().toString() +"," + A.getLongitude().toString()
                + ":" + B.getLatitude().toString() +"," + B.getLongitude().toString()
                + "/json?"
                + "instructionsType=text"
                + "&language=en-US"
                + "&vehicleHeading=" + vehicleHeading
                + "&report=effectiveSettings"
                + "&travelMode=" + travelMode
                + "&key="+ this.APIKey;
        mode = "ROUTING";
    }

    public JSONObject requestRoute() throws IOException
    {
        if (!mode.equals("ROUTING")) { Log.e(TAG, "URL isn't correct for routing !"); }

        Log.i(TAG, "url : " + this.requestURL);
        String tStringResponse = "";
        URL oracle = new URL(this.requestURL);

        BufferedReader in = new BufferedReader(new InputStreamReader(oracle.openStream()));
        String inputLine;
        while ((inputLine = in.readLine()) != null) { tStringResponse = tStringResponse + inputLine; }
        in.close();

        JSONObject tJSONResponse = null;
        try {
            tJSONResponse = new JSONObject(tStringResponse);
        } catch (JSONException e) {
            Log.e(TAG, "couldn't create jsonobject from string");
            e.printStackTrace();
        }

        return tJSONResponse;
    }

    public String getRequestURL() { return this.requestURL; }

}
