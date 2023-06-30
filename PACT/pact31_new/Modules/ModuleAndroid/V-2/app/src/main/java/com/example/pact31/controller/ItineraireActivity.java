package com.example.pact31.controller;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

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
                if (!mTransportButton.getText().equals("MOYEN DE TRANSPORT")) {
                    System.out.println("salut");
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