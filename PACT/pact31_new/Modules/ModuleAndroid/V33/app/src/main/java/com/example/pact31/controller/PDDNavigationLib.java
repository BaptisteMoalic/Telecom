package com.example.pact31.controller;

import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Hashtable;

public abstract class PDDNavigationLib
{
    private static final String TAG = "PDDNavigationLib";

    public static ArrayList[] treatResponse(JSONObject JSONResponse)
    {
        // implementation de notre tableau d'instructions
        Hashtable<String,Integer> instructionHash = new Hashtable<>(20);

        instructionHash.put("DEPART",0);

        instructionHash.put("BEAR_RIGHT",1);
        instructionHash.put("TURN_RIGHT",1);

        instructionHash.put("BEAR_LEFT",2);
        instructionHash.put("TURN_LEFT",2);

        instructionHash.put("SHARP_RIGHT",3);

        instructionHash.put("SHARP_LEFT",4);

        instructionHash.put("STRAIGHT",6);
        // instructionHash.put("SWITCH_MAIN_ROAD",5);

        instructionHash.put("ARRIVE",7);
        instructionHash.put("ARRIVE_LEFT",7);
        instructionHash.put("ARRIVE_RIGHT",7);

        instructionHash.put("KEEP_RIGHT",9);

        instructionHash.put("KEEP_LEFT",10);

        instructionHash.put("ROUNDABOUT_BACK",11);
        instructionHash.put("MAKE_UTURN",11);
        instructionHash.put("TRY_MAKE_UTURN",11);

        instructionHash.put("ROUNDABOUT_CROSS",12);
        instructionHash.put("ROUNDABOUT_RIGHT",12);
        instructionHash.put("ROUNDABOUT_LEFT",12);

        ArrayList<Point> pointList = new ArrayList<>();
        ArrayList<Integer[]> instructionList = new ArrayList<>();

        // traitement de la reponse
        Log.i(TAG, "starting treatment of data");
        try {
            if (JSONResponse==null)
            {
                Log.e(TAG,"response is still null after request");
            }
            JSONObject mainObject = JSONResponse;
            mainObject = mainObject.getJSONArray("routes").getJSONObject(0);
            JSONArray JSONPointList = mainObject.getJSONArray("legs").getJSONObject(0).getJSONArray("points");
            JSONArray JSONInstructionList = mainObject.getJSONObject("guidance").getJSONArray("instructions");

            // completion de la liste de coordonnees
            pointList.clear();
            int i = 0;
            while (i < JSONPointList.length()) {
                pointList.add(new Point(JSONPointList.getJSONObject(i).getDouble("latitude"),
                        JSONPointList.getJSONObject(i).getDouble("longitude")));
                i++;
            }

            // completion de la liste d'instructions
            instructionList.clear();
            i = 0;
            while (i < JSONInstructionList.length()) {
                JSONObject obj = JSONInstructionList.getJSONObject(i);
                Integer[] instruction = new Integer[3];

                instruction[0] = obj.getInt("pointIndex"); //coordonnees de declenchement
                instruction[1] = instructionHash.get(obj.getString("maneuver")); // entier designant une de nos instructions
                instruction[2] = null; // null dans tous les cas sauf celui d'un rond point (hors demi-tour)
                if (instruction[1] == null) // manoeuvre absente de la table, non prise en charge
                {
                    instruction[1] = 100;
                    Log.e(TAG, "Instruction non prise en charge :" + obj.getString("maneuver"));
                }
                if (instruction[1] == 12) // sortie de rond point à trouver
                {
                    instruction[2] = obj.getInt("roundaboutExitNumber");
                    instruction[1] = instruction[1] + (instruction[2] - 1);
                }

                instructionList.add(instruction);
                i++;
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return new ArrayList[]{pointList, instructionList};
    }

    public static Double [] nearestPointAndDistance(Point Loc, ArrayList<Point> pointList)
    {
        ArrayList<Double> distanceList = new ArrayList<>();
        distanceList.clear();
        for (int i = 0 ; i<pointList.size() ; i++)
        {
            distanceList.add(Loc.distanceTo(pointList.get(i)));
        }

        Double minDist = distanceList.get(0);
        int minPointIndex = 0;
        for (int j = 1; j<pointList.size() ; j++)
        {
            if (distanceList.get(j) < minDist)
            {
                minDist = distanceList.get(j);
                minPointIndex = j;
            }
        }
        return new Double[] {(double) minPointIndex,minDist};
    }

    private double angleBetweenLocations(Point A, Point B)
    {
        double PI = Math.PI;
        double latA = A.getLatitude() * PI / 180;
        double longA = A.getLongitude() * PI / 180;
        double latB = B.getLatitude() * PI / 180;
        double longB = B.getLongitude() * PI / 180;

        double dLon = (longB - longA);

        double x = Math.cos(latA) * Math.sin(latB) - Math.sin(latA)
                * Math.cos(latB) * Math.cos(dLon);
        double y = Math.sin(dLon) * Math.cos(latB);

        double angle = Math.atan2(y, x);

        angle = Math.toDegrees(angle);
        angle = (angle + 360) % 360;

        return angle;
    }


}

