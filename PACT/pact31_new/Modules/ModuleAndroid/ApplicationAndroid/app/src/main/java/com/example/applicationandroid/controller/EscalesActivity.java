package com.example.applicationandroid.controller;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;

import com.example.applicationandroid.R;

/* Class "escales" from the "definir trajet" menu */

public class EscalesActivity extends AppCompatActivity {

    private Button mEssenceButton;
    private Button mRestoButton;
    private Button mForetButton;
    private Button mVueButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_escales);

        mEssenceButton = (Button) findViewById(R.id.activity_escales_essence_btn);
        mRestoButton = (Button) findViewById(R.id.activity_escales_resto_btn);
        mForetButton = (Button) findViewById(R.id.activity_escales_foret_btn);
        mVueButton = (Button) findViewById(R.id.activity_escale_vue_btn);

        mEssenceButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // The user clicked on the Large route button
                EscalesActivity.this.finish();
            }
        });

        mRestoButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // The user clicked on the Large route button
                EscalesActivity.this.finish();
            }
        });

        mForetButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // The user clicked on the Large route button
                EscalesActivity.this.finish();
            }
        });

        mVueButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // The user clicked on the Large route button
                EscalesActivity.this.finish();
            }
        });

    }
}