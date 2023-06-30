package com.example.applicationandroid.controller;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;

import com.example.applicationandroid.R;

/* Class "parametres route" from "definir trajet" menu */

public class ParamrouteActivity extends AppCompatActivity {

    private Button mLargeButton;
    private Button mPetiteButton;
    private Button mFaiblePenteButton;
    private Button mRapideButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_paramroute);

        mLargeButton = (Button) findViewById(R.id.activity_paramroute_large_btn);
        mPetiteButton = (Button) findViewById(R.id.activity_paramroute_petite_btn);
        mFaiblePenteButton = (Button) findViewById(R.id.activity_paramroute_faiblepente_btn);
        mRapideButton = (Button) findViewById(R.id.activity_paramroute_rapide_btn);

        mLargeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // The user clicked on the Large route button
                ParamrouteActivity.this.finish();
            }
        });

        mPetiteButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // The user clicked on the Large route button
                ParamrouteActivity.this.finish();
            }
        });

        mFaiblePenteButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // The user clicked on the Large route button
                ParamrouteActivity.this.finish();
            }
        });

        mRapideButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // The user clicked on the Large route button
                ParamrouteActivity.this.finish();
            }
        });

    }
}