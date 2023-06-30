package com.example.pact31.controller;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import com.example.pact31.R;

/* Class "moyen de transport" from "definir trajet" menu */

public class TransportActivity extends AppCompatActivity {

    private Button veloB;
    private Button pietonB;
    private Button voitureB;
    private Button deuxRoues;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_transport);

        veloB = (Button) findViewById(R.id.velo) ;
        pietonB = (Button) findViewById(R.id.pieton) ;
        voitureB = (Button) findViewById(R.id.voiture) ;
        deuxRoues = (Button) findViewById(R.id.deuxRoues) ;

        //we load information
        Bundle bundle = getIntent().getExtras();
        String depart = bundle.getString("depart");
        String arrivee = bundle.getString("arrivee");

        veloB.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {


                Intent transportChoice = new Intent(TransportActivity.this, ItineraireActivity.class);
                transportChoice.putExtra("transport", "VELO");
                startActivity(transportChoice);
            }
        });

        pietonB.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Intent transportChoice = new Intent(TransportActivity.this, ItineraireActivity.class);
                transportChoice.putExtra("transport", "PIETON");
                startActivity(transportChoice);
            }
        });

        voitureB.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Intent transportChoice = new Intent(TransportActivity.this, ItineraireActivity.class);
                transportChoice.putExtra("transport", "VOITURE");
                startActivity(transportChoice);
            }
        });

        deuxRoues.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Intent transportChoice = new Intent(TransportActivity.this, ItineraireActivity.class);
                transportChoice.putExtra("transport", "DEUX ROUES MOTORISES");
                startActivity(transportChoice);
            }
        });
    }
}