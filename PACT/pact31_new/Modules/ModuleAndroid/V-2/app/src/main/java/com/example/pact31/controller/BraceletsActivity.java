package com.example.pact31.controller;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.SeekBar;
import android.widget.TextView;

import com.example.pact31.R;

/* Class "parametrer bracelets" */

public class BraceletsActivity extends AppCompatActivity {

    private SeekBar seekBarColor;
    private TextView textViewColor;
    private Button  pColor;
    private Button  mColor;

    private SeekBar seekBarLum;
    private TextView textViewLum;
    private Button   pLum;
    private Button   mLum;

    private SeekBar seekBarDuree;
    private TextView textViewDuree;
    private Button   pDuree;
    private Button   mDuree;

    @SuppressLint("SetTextI18n")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bracelets);

        // Instanciation (connexion de tous les boutons, textes et seekbars)

        this.seekBarColor  = (SeekBar) findViewById(R.id.activity_bracelets_couleur_seekbar);
        this.textViewColor = (TextView) findViewById(R.id.activity_bracelets_couleur_text);
        this.pColor        = (Button) findViewById(R.id.activity_bracelets_inclumiere_btn);
        this.mColor        = (Button) findViewById(R.id.activity_bracelets_declumiere_btn);

        this.seekBarColor.setMax(10);
        this.seekBarColor.setProgress(1);

        this.textViewColor.setText("Progress: " + seekBarColor.getProgress() + "/" +
                seekBarColor.getMax());

        this.seekBarLum = (SeekBar) findViewById(R.id.activity_bracelets_lumiere_seekbar);
        this.textViewLum = (TextView) findViewById(R.id.activity_bracelets_lumiere_text);

        this.seekBarLum.setMax(10);
        this.seekBarLum.setProgress(1);

        this.textViewLum.setText("Progress: " + seekBarLum.getProgress() + "/" +
                seekBarLum.getMax());

        this.seekBarDuree = (SeekBar) findViewById(R.id.activity_bracelets_duree_seekbar);
        this.textViewDuree = (TextView) findViewById(R.id.activity_bracelets_duree_text);

        this.seekBarDuree.setMax(4);
        this.seekBarDuree.setProgress(1);

        this.textViewDuree.setText("Progress: " + seekBarDuree.getProgress() + "/" +
                seekBarDuree.getMax());

        // Methodes pour faire evoluer l'etat de la seekbar via les boutons

        mColor.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (seekBarColor.getProgress() > 1) {
                    seekBarColor.setProgress(seekBarColor.getProgress()-1);
                }
                return;
            }
        });
        // Lumiere
        this.seekBarLum.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            int progress = 0;

            // When Progress value changed
            @Override
            public void onProgressChanged(SeekBar seekBar, int progressValue, boolean fromUser) {
                progress = progressValue;
                textViewLum.setText("Progress: " + progressValue + "/" + seekBar.getMax());
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
            }
        });

        // Couleur
        this.seekBarColor.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            int progress = 0;

            // When Progress value changed
            @Override
            public void onProgressChanged(SeekBar seekBar, int progressValue, boolean fromUser) {
                progress = progressValue;
                textViewColor.setText("Progress: " + progressValue + "/" + seekBar.getMax());
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
            }
        });

        // Duree vibrations
        this.seekBarDuree.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            int progress = 0;

            // When Progress value changed
            @Override
            public void onProgressChanged(SeekBar seekBar, int progressValue, boolean fromUser) {
                progress = progressValue;
                textViewDuree.setText("Progress: " + progressValue + "/" + seekBar.getMax());
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
            }
        });

    }
}