package com.example.pact31.controller;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import com.example.pact31.R;

/* Class main menu */

public class MainActivity extends AppCompatActivity {

    private Button mItineraireButton;
    //private Button mBraceletsButton;
    //private Button mHistoriqueButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mItineraireButton = (Button) findViewById(R.id.activity_main_itineraire_btn);
        mItineraireButton.setEnabled(true);
        //mBraceletsButton = (Button) findViewById(R.id.activity_main_bracelets_btn);
        //mBraceletsButton.setEnabled(true);
        //mHistoriqueButton = (Button) findViewById(R.id.activity_main_historique_btn);
        //mHistoriqueButton.setEnabled(true);

        mItineraireButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // The user clicked on the Itineraire button
                Intent itineraireActivity = new Intent(MainActivity.this, ItineraireActivity.class);
                startActivity(itineraireActivity);
            }
        });

        /*mBraceletsButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // The user clicked on the Parametrer bracelets button
                Intent braceletsActivity = new Intent(MainActivity.this, BraceletsActivity.class);
                startActivity(braceletsActivity);
            }
        });*/


    }
}