CREATE DATABASE IF NOT EXISTS car_rental
  DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE car_rental;

DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS cars;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(60) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('user','admin') DEFAULT 'user'
);

CREATE TABLE cars (
  id INT AUTO_INCREMENT PRIMARY KEY,
  brand VARCHAR(40) NOT NULL,
  model VARCHAR(60) NOT NULL,
  car_type VARCHAR(30),  
  capacity INT,          
  fuel_type VARCHAR(20), 
  price_per_day DECIMAL(8,2) NOT NULL,
  available BOOLEAN DEFAULT TRUE
);

CREATE TABLE bookings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  car_id INT NOT NULL,
  start_date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_date DATE NOT NULL,
  end_time TIME NOT NULL,
  total_price DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_b_user FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_b_car  FOREIGN KEY (car_id)  REFERENCES cars(id)
);

INSERT INTO users (name,email,password_hash,role) VALUES
('Test User','user@example.com','demo-hash','user'),
('Admin','admin@example.com','demo-hash','admin');

INSERT INTO cars (brand, model, car_type, capacity, fuel_type, price_per_day, available) VALUES
-- Original 3 cars
('Toyota','Camry','Sedan',5,'Gas',55.00,TRUE),
('Honda','Civic','Sedan',5,'Gas',49.00,TRUE),
('Ford','Escape','SUV',5,'Gas',62.00,TRUE),

-- 4 more Sedans (Gas)
('Nissan','Altima','Sedan',5,'Gas',52.00,TRUE),
('Chevrolet','Malibu','Sedan',5,'Gas',50.00,TRUE),
('Hyundai','Sonata','Sedan',5,'Gas',48.00,TRUE),
('Mazda','Mazda6','Sedan',5,'Gas',54.00,TRUE),

-- 4 more SUVs (Gas)
('Jeep','Grand Cherokee','SUV',5,'Gas',70.00,TRUE),
('Toyota','RAV4','SUV',5,'Gas',65.00,TRUE),
('Honda','CR-V','SUV',5,'Gas',63.00,TRUE),
('Nissan','Rogue','SUV',5,'Gas',61.00,TRUE),

-- 4 Trucks (Diesel)
('Ford','F-150','Truck',6,'Diesel',80.00,TRUE),
('Chevrolet','Silverado','Truck',6,'Diesel',82.00,TRUE),
('Ram','1500','Truck',6,'Diesel',85.00,TRUE),
('GMC','Sierra','Truck',6,'Diesel',83.00,TRUE),

-- 4 Electric cars
('Tesla','Model 3','Sedan',5,'Electric',90.00,TRUE),
('Tesla','Model Y','SUV',5,'Electric',95.00,TRUE),
('Chevrolet','Bolt EV','Sedan',5,'Electric',75.00,TRUE),
('Nissan','Leaf','Sedan',5,'Electric',70.00,TRUE),

-- 4 Hybrid cars
('Toyota','Prius','Sedan',5,'Hybrid',60.00,TRUE),
('Honda','Accord Hybrid','Sedan',5,'Hybrid',65.00,TRUE),
('Toyota','Camry Hybrid','Sedan',5,'Hybrid',62.00,TRUE),
('Hyundai','Ioniq Hybrid','Sedan',5,'Hybrid',58.00,TRUE);
