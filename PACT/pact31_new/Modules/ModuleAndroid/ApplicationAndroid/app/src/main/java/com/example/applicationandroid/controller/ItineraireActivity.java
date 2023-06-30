package com.example.applicationandroid.controller;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.example.applicationandroid.R;

/* Class "definir trajet" */

public class ItineraireActivity extends AppCompatActivity {

    private Button mTransportButton;
    private Button mEscalesButton;
    private Button mParamrouteButton;
    private EditText mDepartInput;
    private EditText mArriveeInput;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_itineraire);

        mTransportButton = (Button) findViewById(R.id.activity_itineraire_transport_btn);
        mEscalesButton = (Button) findViewById(R.id.activity_itineraire_escales_btn);
        mParamrouteButton = (Button) findViewById(R.id.activity_itineraire_parametres_btn);
        mDepartInput = (EditText) findViewById(R.id.activity_itineraire_depart_input);
        mArriveeInput = (EditText) findViewById(R.id.activity_itineraire_arrivee_input);

        mTransportButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // User clicked on the moyen de transport button
                Intent transportActivity = new Intent(ItineraireActivity.this, TransportActivity.class);
                startActivity(transportActivity);
            }
        });

        mEscalesButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // User clicked on the escales button
                Intent escaleActivity = new Intent(ItineraireActivity.this, EscalesActivity.class);
                startActivity(escaleActivity);
            }
        });

        mParamrouteButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // User clicked on the paramètre routes button
                Intent paramrouteActivity = new Intent(ItineraireActivity.this, ParamrouteActivity.class);
                startActivity(paramrouteActivity);
            }
        });
    }
}