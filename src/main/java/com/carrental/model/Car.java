/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.carrental.model;

public class Car {
    private int id;
    private String brand;
    private String model;
    private double pricePerDay;
    private boolean available;
    
    // Default constructor
    public Car() {}
    
    // Constructor with all fields
    public Car(int id, String brand, String model, double pricePerDay, boolean available) {
        this.id = id;
        this.brand = brand;
        this.model = model;
        this.pricePerDay = pricePerDay;
        this.available = available;
    }
    
    // Getters
    public int getId() {
        return id;
    }
    
    public String getBrand() {
        return brand;
    }
    
    public String getModel() {
        return model;
    }
    
    public double getPricePerDay() {
        return pricePerDay;
    }
    
    public boolean isAvailable() {
        return available;
    }
    
    // Setters
    public void setId(int id) {
        this.id = id;
    }
    
    public void setBrand(String brand) {
        this.brand = brand;
    }
    
    public void setModel(String model) {
        this.model = model;
    }
    
    public void setPricePerDay(double pricePerDay) {
        this.pricePerDay = pricePerDay;
    }
    
    public void setAvailable(boolean available) {
        this.available = available;
    }
    
    // Helper method for display
    public String getFullName() {
        return brand + " " + model;
    }
}