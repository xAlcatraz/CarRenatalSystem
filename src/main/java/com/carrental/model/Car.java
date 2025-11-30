/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.carrental.model;

public class Car {
    private int id;
    private String brand;
    private String model;
    private String carType;
    private int capacity;
    private String fuelType;
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
    
    public String getCarType() {
        return carType;
    }
    
     public int getCapacity() {
        return capacity;
    }
     
    public String getFuelType() {
        return fuelType;
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
    
    public void setCarType(String carType) {
        this.carType = carType;
    }
    
     public void setCapacity(int capacity) {
        this.capacity = capacity;
    }
     
    public void setFuelType(String fuelType) {
        this.fuelType = fuelType;
    }
    
    // Helper method for display
    public String getFullName() {
        return brand + " " + model;
    }
}