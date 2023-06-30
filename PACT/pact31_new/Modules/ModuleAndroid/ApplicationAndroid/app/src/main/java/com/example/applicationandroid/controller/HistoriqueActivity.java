package com.example.applicationandroid.controller;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.widget.Button;

import com.example.applicationandroid.R;

public class HistoriqueActivity extends AppCompatActivity {

    private Button mInteretButton;
    private Button mGuidageButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_historique);
    }
}