package com.example.pact31.controller;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import com.example.pact31.R;
import java.time.Clock;

public class PoiActivity extends AppCompatActivity {

    private Button mEnvoyerButton;
    private EditText mNomInput;
    private EditText mLongitudeInput;
    private EditText mLatitudeInput;
    private EditText mTypeInput;
    private EditText mCommentInput;

    public static String loadName;
    public static String loadLongitude;
    public static String loadLatitude;
    public static String loadType;
    public static String loadComment;

    private Client client;
    private ConnectServeur mConnectServeur;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_poi);

        mEnvoyerButton = (Button) findViewById(R.id.activity_poi_envoyer_btn);
        mNomInput = (EditText) findViewById(R.id.activity_poi_nompoi_input);
        mLongitudeInput = (EditText) findViewById(R.id.activity_poi_longitude_input);
        mLatitudeInput = (EditText) findViewById(R.id.activity_poi_latitude_input);
        mTypeInput = (EditText) findViewById(R.id.activity_poi_type_input);
        mCommentInput = (EditText) findViewById(R.id.activity_poi_commentaire_input);

        mNomInput.setText(loadName);
        mLongitudeInput.setText(loadLongitude);
        mLatitudeInput.setText(loadLatitude);
        mTypeInput.setText(loadType);
        mCommentInput.setText(loadComment);

        mEnvoyerButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                String command = "WRITEPOI|" + mNomInput.getText().toString() + "|" +
                        Integer.parseInt(mLongitudeInput.getText().toString()) + "|" +
                        Integer.parseInt(mLatitudeInput.getText().toString()) + "|" +
                        mTypeInput.getText().toString() + "|" + mCommentInput.getText().toString() +
                        "|" + "2021-04-12";

                mConnectServeur = new ConnectServeur("192.168.43.172", 8000,
                        "Quentin", "password", command);

                mConnectServeur.executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR);


            }
        });

    }
}