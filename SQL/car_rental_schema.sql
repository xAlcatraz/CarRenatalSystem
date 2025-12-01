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
  available BOOLEAN DEFAULT TRUE,
  image_path VARCHAR(255) NULL
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

SET SQL_SAFE_UPDATES = 0;

UPDATE cars SET image_path = 'images/cars/toyota_camry.jpg' WHERE brand='Toyota' AND model='Camry';
UPDATE cars SET image_path = 'images/cars/honda_civic.jpg' WHERE brand='Honda' AND model='Civic';
UPDATE cars SET image_path = 'images/cars/ford_escape.jpg' WHERE brand='Ford' AND model='Escape';

UPDATE cars SET image_path = 'images/cars/nissan_altima.jpg' WHERE brand='Nissan' AND model='Altima';
UPDATE cars SET image_path = 'images/cars/chevy_malibu.jpg' WHERE brand='Chevrolet' AND model='Malibu';
UPDATE cars SET image_path = 'images/cars/hyundai_sonata.jpg' WHERE brand='Hyundai' AND model='Sonata';
UPDATE cars SET image_path = 'images/cars/mazda_mazda6.jpg' WHERE brand='Mazda' AND model='Mazda6';

UPDATE cars SET image_path = 'images/cars/jeep_cherokee.jpg' WHERE brand='Jeep' AND model='Grand Cherokee';
UPDATE cars SET image_path = 'images/cars/toyota_rav4.jpg' WHERE brand='Toyota' AND model='RAV4';
UPDATE cars SET image_path = 'images/cars/honda_crv.jpg' WHERE brand='Honda' AND model='CR-V';
UPDATE cars SET image_path = 'images/cars/nissan_rogue.jpg' WHERE brand='Nissan' AND model='Rogue';

UPDATE cars SET image_path = 'images/cars/ford_f-150.jpg' WHERE brand='Ford' AND model='F-150';
UPDATE cars SET image_path = 'images/cars/chevy_silverado.jpg' WHERE brand='Chevrolet' AND model='Silverado';
UPDATE cars SET image_path = 'images/cars/ram_1500.jpg' WHERE brand='Ram' AND model='1500';
UPDATE cars SET image_path = 'images/cars/gmc_sierra.jpg' WHERE brand='GMC' AND model='Sierra';

UPDATE cars SET image_path = 'images/cars/tesla_model3.jpg' WHERE brand='Tesla' AND model='Model 3';
UPDATE cars SET image_path = 'images/cars/testla_modely.jpg'  WHERE brand='Tesla' AND model='Model Y';
UPDATE cars SET image_path = 'images/cars/chevy_bolt.jpg' WHERE brand='Chevrolet' AND model='Bolt EV';
UPDATE cars SET image_path = 'images/cars/nissan_leaf.jpg' WHERE brand='Nissan' AND model='Leaf';

UPDATE cars SET image_path = 'images/cars/toyota_prius.jpg' WHERE brand='Toyota' AND model='Prius';
UPDATE cars SET image_path = 'images/cars/honda_accord.jpg' WHERE brand='Honda' AND model='Accord Hybrid';
UPDATE cars SET image_path = 'images/cars/toyota_camryhb.jpg' WHERE brand='Toyota' AND model='Camry Hybrid';
UPDATE cars SET image_path = 'images/cars/hyundai_ioniqhb.jpg' WHERE brand='Hyundai' AND model='Ioniq Hybrid';

SET SQL_SAFE_UPDATES = 1;

SELECT id, brand, model, image_path
FROM cars;