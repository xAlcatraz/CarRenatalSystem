/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.carrental.model;
import java.sql.Date;
import java.sql.Time;

/**
 *
 * @author danim
 */
public class BookingInfo {
    private int id;
    private String brand;
    private String model;
    private String carType;
    private int capacity;
    private String fuelType;
    private Date startDate;
    private Time startTime;
    private Date endDate;
    private Time endTime;
    private double pricePerDay;
    private double totalPrice;
    private String status;
    
    public int getId() {
        return id; 
    }
    
    public void setId(int id) {
        this.id = id; 
    }

    public String getBrand() {
        return brand; 
    }
    
    public void setBrand(String brand) { 
        this.brand = brand;
    }

    public String getModel() {
        return model; 
    }
    
    public void setModel(String model) {
        this.model = model; 
    }

    public String getCarType() {
        return carType; 
    }
    
    public void setCarType(String carType) {
        this.carType = carType;
    }

    public int getCapacity() {
        return capacity;
    }
    
    public void setCapacity(int capacity) { 
        this.capacity = capacity; 
    }

    public String getFuelType() {
        return fuelType; 
    }
    
    public void setFuelType(String fuelType) { 
        this.fuelType = fuelType;
    }

    public Date getStartDate() { 
        return startDate;
    }
    
    public void setStartDate(Date startDate) {
        this.startDate = startDate; 
    }

    public Time getStartTime() { 
        return startTime;
    }
    
    public void setStartTime(Time startTime) {
        this.startTime = startTime;
    }

    public Date getEndDate() {
        return endDate; 
    }
    
    public void setEndDate(Date endDate) {
        this.endDate = endDate; 
    }

    public Time getEndTime() { 
        return endTime; 
    }
    
    public void setEndTime(Time endTime) { 
        this.endTime = endTime; 
    }

    public double getPricePerDay() { 
        return pricePerDay; 
    }
    
    public void setPricePerDay(double pricePerDay) { 
        this.pricePerDay = pricePerDay; 
    }

    public double getTotalPrice() { 
        return totalPrice; 
    }
    
    public void setTotalPrice(double totalPrice) { 
        this.totalPrice = totalPrice; 
    }

    public String getStatus() { 
        return status; 
    }
    
    public void setStatus(String status) { 
        this.status = status;
    }
}
