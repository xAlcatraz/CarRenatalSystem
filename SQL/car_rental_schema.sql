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
  price_per_day DECIMAL(8,2) NOT NULL,
  available BOOLEAN DEFAULT TRUE
);

CREATE TABLE bookings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  car_id INT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  total_price DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_b_user FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_b_car  FOREIGN KEY (car_id)  REFERENCES cars(id)
);

INSERT INTO users (name,email,password_hash,role) VALUES
('Test User','user@example.com','demo-hash','user'),
('Admin','admin@example.com','demo-hash','admin');

INSERT INTO cars (brand,model,price_per_day,available) VALUES
('Toyota','Camry',55.00,TRUE),
('Honda','Civic',49.00,TRUE),
('Ford','Escape',62.00,TRUE);

