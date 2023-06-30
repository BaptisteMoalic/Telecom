package com.example.pact31.controller;

import android.location.Location;

import java.io.Serializable;

public class Point implements Serializable {
    private Double latitude;
    private Double longitude;

    public Point(double latitude, double longitude)
    {
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public Point(Location l)
    {
        this(l.getLatitude(),l.getLongitude());
    }

    public Double getLatitude()
    {
        return this.latitude;
    }

    public Double getLongitude()
    {
        return this.longitude;
    }

    public Double distanceTo(Point P)
    {
        // l'angle séparant les points sera toujours petit
        // on approxime la surface comme étant plane
        // le calcul donne un resultat en metre
        Double deltaLambda = (this.latitude - P.getLatitude())*Math.PI/360;
        Double deltaPhi = (this.longitude - P.getLongitude())*Math.PI/360;
        Integer radius = 6371000;
        return radius*Math.sqrt(Math.pow(deltaLambda,2) + Math.pow(deltaPhi,2));
    }

   @Override
    public String toString() {
        return "Point{" +
                "latitude=" + latitude +
                ", longitude=" + longitude +
                '}';
    }
}
