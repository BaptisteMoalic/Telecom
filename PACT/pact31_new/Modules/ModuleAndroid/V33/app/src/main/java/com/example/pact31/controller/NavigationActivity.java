package com.example.pact31.controller;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;

import com.example.pact31.R;

import android.Manifest;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.provider.Settings;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.concurrent.ExecutionException;

public class NavigationActivity extends AppCompatActivity {
    private LocationManager locationManager;
    private Context mContext;
    private Location previousLoc = null;
    private final Double maxDistUntilAway = 30.; // distance avant laquelle on recalcul l'itineraire en m
    private Point destination;
    private int instructionIndex;
    private String vehicleHeading = "90";
    private ArrayList[] data;
    private ArrayList<Point> pointList;
    private ArrayList<Integer[]> instructionList;

    //Bundle test = getIntent().getBundleExtra("bundle");

    ImageView flecheHaute;
    ImageView flecheBasse;
    ImageView flecheDroite;
    ImageView flecheGauche;
    ImageView onionImage;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_navigation);

        flecheHaute = (ImageView) findViewById(R.id.fleche_haut);
        flecheBasse = (ImageView) findViewById(R.id.fleche_bas);
        flecheDroite = (ImageView) findViewById(R.id.fleche_droite);
        flecheGauche = (ImageView) findViewById(R.id.fleche_gauche);
        onionImage = (ImageView) findViewById(R.id.onion);

        mContext = this;
        locationManager = (LocationManager) mContext.getSystemService(Context.LOCATION_SERVICE);
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            isLocationEnabled();
            return;
        }
        locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER,
                3000,
                10, locationListenerGPS);
        //isLocationEnabled();

        Intent intent = getIntent();
        Bundle args = intent.getBundleExtra("bundle");

        ArrayList[] data;
        // a initialiser avec le trajet choisi sur l'autre activite
        pointList = (ArrayList<Point>) args.getSerializable("data0");
        instructionList = (ArrayList<Integer[]>) args.getSerializable("data1");

        int instructionIndex = 0; // peut etre 1 selon ce que je veux faire
        destination  = pointList.get(pointList.size()-1); // pas final car elle changera peut etre si on change de mode / va vers un PI
        String vehicleHeading;

        Integer n = pointList.size();
        Log.i("AFFICAHE", n.toString());
    }


    LocationListener locationListenerGPS=new LocationListener() {
        @Override
        public void onLocationChanged(android.location.Location location)
        {
            Integer n = pointList.size();
            Log.i("TEST", n.toString());
            if (previousLoc != null)
            {
                Float f = previousLoc.bearingTo(location);
                Integer angle = (Integer) 180+Math.round(f);
                vehicleHeading = angle.toString();
            }
            previousLoc = location;
            Point currentPoint = new Point(location);
            Double[] relativeLoc = PDDNavigationLib.nearestPointAndDistance(currentPoint,pointList);
            if (relativeLoc[1]>maxDistUntilAway) // recalcul
            {
                JSONObject tJSONResponse = null;
                TomTomNetwork.getInstance().buildRoutingURL(new Point(location),
                        destination,
                        "pedestrian",
                        vehicleHeading);
                Log.i("URLREQUETE", TomTomNetwork.getInstance().getRequestURL());
                try {
                    tJSONResponse = new MyAsyncTask().execute().get();
                } catch (ExecutionException e) {
                    e.printStackTrace();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }

                data = PDDNavigationLib.treatResponse(tJSONResponse);
                pointList = data[0];
                instructionList = data[1];
                instructionIndex = 0;
            }
            //} else { // r
                if (relativeLoc[0] >= instructionList.get(instructionIndex)[0] - 2) // -1 ou -2, a jauger pendant les tests
                {
                    // envoi de instructionList.get(instructionIndex)[1] (entier codant l'instruction)
                    // on incremente instructionIndex

                    setInvisible();

                    switch (instructionList.get(instructionIndex)[1]) {
                        case 1:
                        case 3:
                        case 9:
                            flecheDroite.setVisibility(View.VISIBLE);
                            break;
                        case 2:
                        case 4:
                        case 10:
                            flecheGauche.setVisibility(View.VISIBLE);
                            break;
                        case 6:
                            flecheHaute.setVisibility(View.VISIBLE);
                            break;
                        case 11:
                            flecheBasse.setVisibility(View.VISIBLE);
                            break;
                        default:
                            onionImage.setVisibility(View.VISIBLE);
                            break;

                    }
                    instructionIndex++;
                }
            }

/*
        @Override
        public void onStatusChanged(String provider, int status, Bundle extras) {

        }

        @Override
        public void onProviderEnabled(String provider) {

        }

        @Override
        public void onProviderDisabled(String provider) {

        }

 */
    };

    private void isLocationEnabled() {

        if(!locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)){
            AlertDialog.Builder alertDialog=new AlertDialog.Builder(mContext);
            alertDialog.setTitle("Enable Location");
            alertDialog.setMessage("Your locations setting is not enabled. Please enabled it in settings menu.");
            alertDialog.setPositiveButton("Location Settings", new DialogInterface.OnClickListener(){
                public void onClick(DialogInterface dialog, int which){
                    Intent intent=new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
                    startActivity(intent);
                }
            });
            alertDialog.setNegativeButton("Cancel", new DialogInterface.OnClickListener(){
                public void onClick(DialogInterface dialog, int which){
                    dialog.cancel();
                }
            });
            AlertDialog alert=alertDialog.create();
            alert.show();
        }
        else{
            AlertDialog.Builder alertDialog=new AlertDialog.Builder(mContext);
            alertDialog.setTitle("Confirm Location");
            alertDialog.setMessage("Your Location is enabled, please enjoy");
            alertDialog.setNegativeButton("Back to interface",new DialogInterface.OnClickListener(){
                public void onClick(DialogInterface dialog, int which){
                    dialog.cancel();
                }
            });
            AlertDialog alert=alertDialog.create();
            alert.show();
        }
    }
    public void setInvisible() {
        flecheDroite.setVisibility(View.INVISIBLE);
        flecheHaute.setVisibility(View.INVISIBLE);
        flecheBasse.setVisibility(View.INVISIBLE);
        flecheGauche.setVisibility(View.INVISIBLE);
        onionImage.setVisibility(View.INVISIBLE);
        return;
    }
}
