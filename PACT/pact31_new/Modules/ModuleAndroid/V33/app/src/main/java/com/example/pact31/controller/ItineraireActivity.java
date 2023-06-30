package com.example.pact31.controller;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import org.json.JSONObject;

import java.io.Serializable;
import java.util.concurrent.ExecutionException;


import java.util.ArrayList;


import com.example.pact31.R;

/* Class "definir trajet" */

public class ItineraireActivity extends AppCompatActivity {

    private Button mTransportButton;
    private Button goButton;
    //private Button mEscalesButton;
    //private Button mParamrouteButton;
    private EditText mDepartInput;
    private EditText mArriveeInput;
    public static String loadDepart;
    public static String loadArrivee;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_itineraire);

        mTransportButton = (Button) findViewById(R.id.activity_itineraire_transport_btn);
        goButton         = (Button) findViewById(R.id.go);
       // mEscalesButton = (Button) findViewById(R.id.activity_itineraire_escales_btn);
       // mParamrouteButton = (Button) findViewById(R.id.activity_itineraire_parametres_btn);
        mDepartInput = (EditText) findViewById(R.id.activity_itineraire_depart_input);
        mArriveeInput = (EditText) findViewById(R.id.activity_itineraire_arrivee_input);

        mDepartInput.setText(loadDepart);
        mArriveeInput.setText(loadArrivee);

        //we load information
        Bundle bundle = getIntent().getExtras();
        String transport = "MOYEN DE TRANSPORT";
       if (bundle != null)
           transport = bundle.getString("transport");

            mTransportButton.setText(transport);

        mTransportButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                loadArrivee = mArriveeInput.getText().toString();
                loadDepart  = mDepartInput.getText().toString();

                // User clicked on the moyen de transport button
                Intent transportActivity = new Intent(ItineraireActivity.this, TransportActivity.class);
                transportActivity.putExtra("depart", mDepartInput.getText().toString());
                transportActivity.putExtra("arrivee", mArriveeInput.getText().toString());
                startActivity(transportActivity);
            }
        });


        goButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mTransportButton.getText().equals("MOYEN DE TRANSPORT")) {
                    Toast selectTransport = Toast.makeText(getApplicationContext(), "Selectionner un moyen de transport", Toast.LENGTH_SHORT);
                    selectTransport.show();
                }
                else {

                    String[] departSplit = mDepartInput.getText().toString().split(":", 2);
                    String[] arriveeSplit = mArriveeInput.getText().toString().split(":", 2);

                    JSONObject tJSONResponse = null;
                    TomTomNetwork.getInstance().buildRoutingURL(new Point(Float.parseFloat(departSplit[0]), Float.parseFloat(departSplit[1])),
                            new Point(Float.parseFloat(arriveeSplit[0]), Float.parseFloat(arriveeSplit[1])),
                            "pedestrian",
                            "90");
                    try {
                        tJSONResponse = new MyAsyncTask().execute().get();
                    } catch (ExecutionException e) {
                        e.printStackTrace();
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }

                    ArrayList[] data = PDDNavigationLib.treatResponse(tJSONResponse);

                    Intent informations = new Intent(ItineraireActivity.this, NavigationActivity.class);
                    Bundle args = new Bundle();
                    informations.putExtra("depart", mDepartInput.getText().toString());
                    informations.putExtra("arrivee", mArriveeInput.getText().toString());
                    informations.putExtra("transport", mTransportButton.getText());

                    args.putSerializable("data0", (Serializable) data[0]);
                    args.putSerializable("data1", (Serializable) data[1]);

                    informations.putExtra("bundle", args);
                    startActivity(informations);

                }
            }
        });
      /*  mEscalesButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                loadArrivee = mArriveeInput.getText().toString();
                loadDepart  = mDepartInput.getText().toString();
                // User clicked on the escales button
                Intent escaleActivity = new Intent(ItineraireActivity.this, EscalesActivity.class);
                startActivity(escaleActivity);
            }
        });

        mParamrouteButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                loadArrivee = mArriveeInput.getText().toString();
                loadDepart  = mDepartInput.getText().toString();
                // User clicked on the paramètre routes button
                Intent paramrouteActivity = new Intent(ItineraireActivity.this, ParamrouteActivity.class);
                startActivity(paramrouteActivity);
            }
        });*/
    }
}