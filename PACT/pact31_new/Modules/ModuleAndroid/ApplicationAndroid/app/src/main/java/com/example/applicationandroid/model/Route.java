package com.example.applicationandroid.model;

public class Route {
    private String rType;
    private String[] rEscales;
    private String rTransport;

    public Route() {
        rType = "rapide";
        rEscales = [];
        rTransport = "voiture";
    }

    public String getType() {
        return rType;
    }

    public void setType(String rType) {
        this.rType = rType;
    }

    public String[] getEscales() {
        return rEscales;
    }

    public void setEscales(String[] rEscales) {
        this.rEscales = rEscales;
    }

    public String getTransport() {
        return rTransport;
    }

    public void setTransport(String rTransport) {
        this.rTransport = rTransport;
    }
}
