CREATE DATABASE globalrides;
use globalrides;

CREATE TABLE Employee 
(empId INT PRIMARY KEY,
DOB DATE,
startDate DATE,
dept varchar(30));

CREATE TABLE User
(userId INT PRIMARY KEY,
fName varchar(20) NOT NULL,
sName varchar(20),
tName varchar(20),
address varchar(100),
gender varchar(20),
dob DATE);

CREATE TABLE Rider
(userId INT PRIMARY KEY,
FOREIGN KEY(userId) REFERENCES User(userId));

CREATE TABLE Customer
(userId INT PRIMARY KEY,
FOREIGN KEY(userId) REFERENCES User(userId));

CREATE TABLE RestOwner
(userId INT PRIMARY KEY,
FOREIGN KEY(userId) REFERENCES User(userId));

CREATE TABLE SupportAgent
(empId INT PRIMARY KEY,
FOREIGN KEY(empId) REFERENCES Employee(empId));

CREATE TABLE PlatformManager
(empId INT PRIMARY KEY,
FOREIGN KEY(empId) REFERENCES Employee(empId));

CREATE TABLE DeliveryCoordinator
(empId INT PRIMARY KEY,
FOREIGN KEY(empId) REFERENCES Employee(empId));

CREATE TABLE Inquiry
(inquiryId INT PRIMARY KEY,
empId INT,
resolution_status varchar(30),
inquiryTime DATETIME,
userID INT,
FOREIGN KEY(userId) REFERENCES User(userId),
FOREIGN KEY(empId) REFERENCES SupportAgent(empId));

CREATE TABLE UserContact
(userId INT,
contactDetails varchar(30),
PRIMARY KEY(userId, contactDetails),
FOREIGN KEY(userId) REFERENCES User(userId));


CREATE TABLE Driver
(userId INT PRIMARY KEY,
driverId INT UNIQUE,
experience INT,
licenseDetails varchar(10) NOT NULL,
vehicleInfo varchar(10),
FOREIGN KEY(userId) REFERENCES User(userId));




CREATE TABLE Trainer
(trainerId INT PRIMARY KEY,
pmEmpId INT,
dcEmpId INT,
certId INT UNIQUE NOT NULL,
dateOfIssue DATE, 
FOREIGN KEY(pmEmpId) REFERENCES platformmanager(empId),
FOREIGN KEY(dcEmpId) REFERENCES deliverycoordinator(empId));

CREATE TABLE IsTrainedBy
(tEmpId INT,
saEmpId INT,
PRIMARY KEY(tEmpId, saEmpId),
FOREIGN KEY(tEmpId) REFERENCES Trainer(trainerId),
FOREIGN KEY(saEmpId) REFERENCES SupportAgent(empId));



CREATE TABLE Restaurant
(restId INT PRIMARY KEY,
cuisine varchar(15),
operatingHours varchar(20),
address varchar(100),
name varchar(20),
ownerDesc varchar(50));

CREATE TABLE Menu
(itemId INT PRIMARY KEY,
foodCategory varchar(20),
price INT,
description varchar(30),
name varchar(20),
restId INT,
FOREIGN KEY(restId) REFERENCES Restaurant(restId));



CREATE TABLE Manages
(userId INT,
restId INT,
PRIMARY KEY(userId, restId),
FOREIGN KEY(userId) REFERENCES User(userId),
FOREIGN KEY(restId) REFERENCES Restaurant(restId));

 -- added columns driverId, deliverytime, and changed ordate from DATE to DATETIME
CREATE TABLE FoodOrders 
(orderId INT PRIMARY KEY,
restId INT,
custId INT,
driverId INT,
totAmount INT,
orderDate DATETIME,
deliveryTime DATETIME,
paymentMethod varchar(20),
deliveryStatus varchar(10),
FOREIGN KEY(restId) REFERENCES Restaurant(restId),
FOREIGN KEY(custId) REFERENCES Customer(userId),
FOREIGN KEY (driverId) REFERENCES Driver(userId));


CREATE TABLE Promotions
(promoId INT PRIMARY KEY,
description varchar(30),
validityPeriod varchar(20));

CREATE TABLE Item
(itemId INT,
name varchar(30) NOT NULL,
price INT,
PRIMARY KEY(itemId, name),
FOREIGN KEY(itemId) REFERENCES Menu(itemId));

DROP TABLE IF EXISTS RunsPromotion;
CREATE TABLE RunsPromotion
(restId INT,
promoId INT,
itemId INT,
name varchar(30),
PRIMARY KEY(restId, promoId, itemId),
FOREIGN KEY(promoId) REFERENCES Promotions(promoId),
FOREIGN KEY(itemId,name) REFERENCES Item(itemId,name),
FOREIGN KEY(restId) REFERENCES Restaurant(restId));

CREATE TABLE Review
(reviewId INT PRIMARY KEY,
rating INT,
feedbackText varchar(20),
date DATE);

CREATE TABLE LeavesFoodReview
(reviewId INT,
userId INT,
orderId INT,
PRIMARY KEY(reviewId, userId, orderId),
FOREIGN KEY(reviewId) REFERENCES Review(reviewId),
FOREIGN KEY(userId) REFERENCES Customer(userId),
FOREIGN KEY(orderId) REFERENCES FoodOrders(orderId));

CREATE TABLE PlacesOrder
(orderId INT,
userId INT,
restId INT,
PRIMARY KEY(orderId,userId,restId),
FOREIGN KEY(orderId) REFERENCES FoodOrders(orderId),
FOREIGN KEY(userId) REFERENCES Customer(userId),
FOREIGN KEY(restId) REFERENCES Restaurant(restId));

CREATE TABLE FareLocation
(pickUpLocation varchar(30),
dropOffLocation varchar(30),
pickUpTime TIME,
rideFare INT,
PRIMARY KEY(pickUpLocation, dropOffLocation, pickUpTime));

CREATE TABLE Rides
(rideId INT PRIMARY KEY,
pickUpLocation varchar(30) NOT NULL,
dropOffLocation varchar(30) NOT NULL,
pickUpTime TIME NOT NULL,
paymentStatus varchar(20),
paymentMethod varchar (20),
FOREIGN KEY(pickUpLocation, dropOffLocation, pickUpTime) REFERENCES FareLocation(pickUpLocation, dropOffLocation, pickUpTime));



CREATE TABLE Assigned
(userId INT,
empId INT,
rideId INT,
PRIMARY KEY(userId, empId, rideId),
FOREIGN KEY(userId) REFERENCES Driver(userId),
FOREIGN KEY(empId) REFERENCES deliverycoordinator(empId),
FOREIGN KEY(rideId) REFERENCES Rides(rideId));

CREATE TABLE LeavesRiderReview
(reviewId INT,
userId INT,
rideId INT,
PRIMARY KEY(reviewId, userId, rideId),
FOREIGN KEY(reviewId) REFERENCES Review(reviewId),
FOREIGN KEY(userId) REFERENCES Rider(userId),
FOREIGN KEY(rideId) REFERENCES Rides(rideId));


/* Based on the assumptions that were made, these are the modifications which were added to account for tracability between the schema and the queries*/
CREATE TABLE OrderItems (
    orderId INT,
    itemId INT,
    quantity INT,
    PRIMARY KEY (orderId, itemId),
    FOREIGN KEY (orderId) REFERENCES FoodOrders(orderId),
    FOREIGN KEY (itemId) REFERENCES Menu(itemId)
);

-- Consolidated INSERT statement for Employee table
INSERT INTO Employee (empId, DOB, startDate, dept) VALUES 
(1001, '1980-05-15', '2023-06-12', 'Support Agent'),
(1002, '1985-11-23', '2023-09-01', 'Delivery Coordinator'),
(1003, '1978-02-10', '2023-05-15', 'Platform Manager'),
(1004, '1990-08-30', '2023-11-05', 'Support Agent'),
(1005, '1982-04-17', '2023-07-22', 'Delivery Coordinator'),
(1006, '1988-09-03', '2023-08-18', 'Platform Manager'),
(1007, '1975-12-12', '2023-10-09', 'Support Agent'),
(1008, '1992-06-25', '2024-02-11', 'Delivery Coordinator'),
(1009, '1983-01-07', '2023-12-30', 'Platform Manager'),
(1010, '1987-07-19', '2024-01-14', 'Support Agent'),
(1011, '1979-03-26', '2024-03-20', 'Delivery Coordinator'),
(1012, '1991-10-01', '2024-04-07', 'Platform Manager'),
(1013, '1984-08-05', '2024-03-28', 'Support Agent'),
(1014, '1989-02-14', '2024-05-05', 'Delivery Coordinator'),
(1015, '1976-05-31', '2024-07-11', 'Platform Manager'),
(1016, '1993-11-09', '2024-08-22', 'Support Agent'),
(1017, '1981-07-22', '2024-09-16', 'Delivery Coordinator'),
(1018, '1986-04-03', '2024-11-29', 'Platform Manager'),
(1019, '1977-09-18', '2025-01-04', 'Support Agent'),
(1020, '1994-01-27', '2025-02-10', 'Delivery Coordinator');

-- SupportAgent table
INSERT INTO SupportAgent (empId) VALUES 
(1001),
(1004),
(1007),
(1010),
(1013),
(1016),
(1019);

-- PlatformManager table
INSERT INTO PlatformManager (empId) VALUES 
(1003),
(1006),
(1009),
(1012),
(1015),
(1018);

-- DeliveryCoordinator table
INSERT INTO DeliveryCoordinator (empId) VALUES 
(1002),
(1005),
(1008),
(1011),
(1014),
(1017),
(1020);


-- Consolidated INSERT statement for User table
INSERT INTO User (userId, fName, sName, tName, address, gender, dob) VALUES 
(101, 'John', 'Michael', 'Smith', '123 Main St, Springfield, IL 62701', 'Male', '1985-04-12'),
(102, 'Emma', 'Rose', NULL, '456 Oak Ave, Chicago, IL 60601', 'Female', '1990-07-23'),
(103, 'David', NULL, 'Johnson', '789 Pine Rd, Austin, TX 78701', 'Male', '1978-11-05'),
(104, 'Sophia', 'Marie', 'Williams', '234 Elm Blvd, Denver, CO 80202', 'Female', '1992-02-17'),
(105, 'James', 'Robert', NULL, '567 Maple Dr, Seattle, WA 98101', 'Male', '1983-09-30'),
(106, 'Olivia', NULL, NULL, '890 Cedar Ln, Boston, MA 02108', 'Female', '1995-06-14'),
(107, 'William', 'Thomas', 'Brown', '345 Birch St, San Francisco, CA 94102', 'Male', '1980-12-08'),
(108, 'Ava', 'Elizabeth', 'Davis', '678 Walnut Ave, Miami, FL 33101', 'Female', '1988-03-21'),
(109, 'Michael', 'Joseph', NULL, '901 Cherry Rd, Atlanta, GA 30301', 'Male', '1975-08-11'),
(110, 'Isabella', NULL, 'Martinez', '432 Pineapple Blvd, Honolulu, HI 96801', 'Female', '1993-01-27'),
(111, 'Ethan', 'Christopher', 'Anderson', '765 Orange Dr, Las Vegas, NV 89101', 'Male', '1987-05-19'),
(112, 'Charlotte', 'Grace', NULL, '098 Lemon Ln, Portland, OR 97201', 'Female', '1991-10-03'),
(113, 'Daniel', NULL, 'Taylor', '543 Grape St, Nashville, TN 37201', 'Male', '1979-07-15'),
(114, 'Amelia', 'Nicole', 'Thomas', '876 Peach Ave, Philadelphia, PA 19101', 'Female', '1994-04-29'),
(115, 'Matthew', 'Andrew', NULL, '219 Apple Rd, Phoenix, AZ 85001', 'Male', '1982-11-12'),
(116, 'Mia', NULL, 'Wilson', '654 Kiwi Blvd, New Orleans, LA 70112', 'Female', '1989-08-07'),
(117, 'Alexander', 'James', 'Miller', '987 Banana Dr, Detroit, MI 48201', 'Male', '1976-03-24'),
(118, 'Harper', 'Madison', NULL, '321 Mango Ln, Salt Lake City, UT 84101', 'Female', '1997-12-18'),
(119, 'Benjamin', NULL, 'Jackson', '654 Papaya St, Minneapolis, MN 55401', 'Male', '1984-09-05'),
(120, 'Abigail', 'Sophia', 'Garcia', '789 Coconut Ave, Raleigh, NC 27601', 'Female', '1996-05-31');

-- Rider table (7 users)
INSERT INTO Rider (userId) VALUES 
(101),
(102),
(103),
(104),
(105),
(106),
(107),
(108);

-- Customer table (7 users)
INSERT INTO Customer (userId) VALUES 
(108),
(109),
(110),
(111),
(112),
(113),
(114),
(115);

-- RestOwner table (6 users)
INSERT INTO RestOwner (userId) VALUES 
(115),
(116),
(117),
(118),
(119),
(120);

-- Inquiry table (10 inserts)
INSERT INTO Inquiry (inquiryId, empId, resolution_status, inquiryTime, userID) VALUES 
(5001, 1001, 'Resolved', '2023-07-15 09:30:42', 108),
(5002, 1004, 'Pending', '2023-09-22 14:15:30', 103),
(5003, 1007, 'In Progress', '2023-11-05 11:22:18', 112),
(5004, 1010, 'Resolved', '2024-01-18 16:45:23', 120),
(5005, 1013, 'Escalated', '2024-02-27 10:05:57', 105),
(5006, 1016, 'Pending', '2024-04-09 13:37:40', 117),
(5007, 1019, 'Resolved', '2024-06-14 08:20:15', 110),
(5008, 1001, 'In Progress', '2024-08-23 15:10:33', 114),
(5009, 1004, 'Escalated', '2024-10-30 12:45:29', 101),
(5010, 1007, 'Resolved', '2025-01-07 17:30:22', 118);

-- Trainer table (4 inserts)
INSERT INTO Trainer (trainerId, pmEmpId, dcEmpId, certId, dateOfIssue) VALUES 
(3001, NULL, 1008, 70001, '2023-08-15'),
(3002, 1006, NULL, 70002, '2023-12-20'),
(3003, NULL, 1017, 70003, '2024-03-25'),
(3004, 1015, NULL, 70004, '2024-09-10');

-- IsTrainedBy table (7 inserts)
INSERT INTO IsTrainedBy (tEmpId, saEmpId) VALUES 
(3001, 1001),
(3001, 1004),
(3002, 1007),
(3002, 1010),
(3003, 1013),
(3003, 1016),
(3004, 1019);

-- Restaurant table (10 inserts)
INSERT INTO Restaurant (restId, cuisine, operatingHours, address, name, ownerDesc) VALUES 
(2001, 'Italian', '11:00-22:00', '123 Broadway St, New York, NY 10001', 'Bella Vista', 'Family-run since 1985'),
(2002, 'Chinese', '10:30-23:00', '456 Dragon Ave, San Francisco, CA 94102', 'Golden Dragon', 'Authentic Szechuan specialist'),
(2003, 'Mexican', '9:00-21:00', '789 Taco Blvd, Austin, TX 78701', 'El Sombrero', 'Traditional recipes from Oaxaca'),
(2004, 'Indian', '11:00-22:30', '234 Curry Lane, Chicago, IL 60601', 'Spice Palace', 'Award-winning North Indian cuisine'),
(2005, 'Japanese', '12:00-23:00', '567 Sushi St, Seattle, WA 98101', 'Sakura Zen', 'Master chef with 20 years experience'),
(2006, 'Thai', '10:00-21:30', '890 Pad Thai Rd, Miami, FL 33101', 'Bangkok Bites', 'Street food inspired menu'),
(2007, 'Mediterranean', '11:30-22:00', '345 Olive Dr, Boston, MA 02108', 'Blue Aegean', 'Fresh seafood daily'),
(2008, 'American', '7:00-23:00', '678 Burger Ave, Atlanta, GA 30301', 'Stars & Stripes', 'Classic American diner'),
(2009, 'French', '17:00-23:30', '901 Bistro Ln, New Orleans, LA 70112', 'Le Petit Jardin', 'Fine dining experience'),
(2010, 'Korean', '11:00-22:00', '432 Kimchi Way, Los Angeles, CA 90001', 'Seoul Kitchen', 'Modern Korean fusion');
-- Insert two new restaurants for testing
INSERT INTO Restaurant (restId, cuisine, operatingHours, address, name, ownerDesc) VALUES 
(2011, 'Vietnamese', '10:00-21:00', '123 Pho Street, Dallas, TX 75201', 'Saigon Corner', 'Never opened'),
(2012, 'Greek', '11:00-22:00', '456 Gyro Lane, Houston, TX 77001', 'Athens Taverna', 'Closed temporarily');


-- Menu table (30 inserts)
INSERT INTO Menu (itemId, foodCategory, price, description, name, restId) VALUES 
-- Bella Vista (Italian)
(4001, 'Appetizer', 12, 'Fresh tomatoes and basil', 'Bruschetta', 2001),
(4002, 'Main Course', 24, 'Homemade pasta with clams', 'Linguine Vongole', 2001),
(4003, 'Dessert', 9, 'Classic Italian dessert', 'Tiramisu', 2001),

-- Golden Dragon (Chinese)
(4004, 'Appetizer', 8, 'Crispy vegetable rolls', 'Spring Rolls', 2002),
(4005, 'Main Course', 18, 'Spicy chicken with onions', 'Chilli Chicken', 2002),
(4006, 'Main Course', 22, 'Wok-fried beef and broccoli', 'Mongolian Beef', 2002),

-- El Sombrero (Mexican)
(4007, 'Appetizer', 10, 'House-made chips and dips', 'Guacamole & Chips', 2003),
(4008, 'Main Course', 16, 'Three soft corn tortillas', 'Carnitas Tacos', 2003),
(4009, 'Main Course', 18, 'Grilled steak with rice', 'Carne Asada', 2003),

-- Spice Palace (Indian)
(4010, 'Appetizer', 9, 'Crispy pastry with filling', 'Vegetable Samosa', 2004),
(4011, 'Main Course', 20, 'Creamy tomato curry', 'Butter Chicken', 2004),
(4012, 'Bread', 4, 'Traditional tandoor bread', 'Garlic Naan', 2004),

-- Sakura Zen (Japanese)
(4013, 'Appetizer', 7, 'Steamed soybeans', 'Edamame', 2005),
(4014, 'Main Course', 28, 'Assorted fresh fish', 'Sashimi Platter', 2005),
(4015, 'Main Course', 15, 'Grilled chicken skewers', 'Teriyaki Don', 2005),

-- Bangkok Bites (Thai)
(4016, 'Soup', 12, 'Spicy shrimp soup', 'Tom Yum', 2006),
(4017, 'Main Course', 17, 'Stir-fried rice noodles', 'Pad Thai', 2006),
(4018, 'Main Course', 19, 'Thai green curry', 'Green Curry Chicken', 2006),

-- Blue Aegean (Mediterranean)
(4019, 'Appetizer', 14, 'Grilled octopus salad', 'Octopus Mezze', 2007),
(4020, 'Main Course', 26, 'Fresh catch of the day', 'Grilled Branzino', 2007),
(4021, 'Salad', 12, 'Traditional Greek salad', 'Horiatiki', 2007),

-- Stars & Stripes (American)
(4022, 'Appetizer', 11, 'Buffalo wings with ranch', 'Hot Wings', 2008),
(4023, 'Main Course', 16, 'Angus beef with fries', 'Classic Burger', 2008),
(4024, 'Dessert', 8, 'New York style cheesecake', 'Cheesecake', 2008),

-- Le Petit Jardin (French)
(4025, 'Appetizer', 16, 'Pan-seared duck liver', 'Foie Gras', 2009),
(4026, 'Main Course', 32, 'Beef tenderloin in wine', 'Beef Bourguignon', 2009),
(4027, 'Dessert', 12, 'Chocolate lava cake', 'Fondant au Chocolat', 2009),

-- Seoul Kitchen (Korean)
(4028, 'Appetizer', 8, 'Fermented cabbage', 'Kimchi Pancake', 2010),
(4029, 'Main Course', 18, 'Korean BBQ rice bowl', 'Bibimbap', 2010),
(4030, 'Main Course', 22, 'Marinated grilled beef', 'Galbi', 2010);


-- Manages table (10 inserts)
INSERT INTO Manages (userId, restId) VALUES 
(115, 2001),
(115, 2002),
(115, 2008),
(116, 2003),
(116, 2006),
(117, 2004),
(117, 2010),
(118, 2005),
(119, 2007),
(120, 2009);

-- Driver table (5 inserts)
INSERT INTO Driver (userId, driverId, experience, licenseDetails, vehicleInfo) VALUES 
(101, 8001, 3, 'DL789456', 'Honda CBR'),
(102, 8002, 5, 'DL234567', 'Tesla S'),
(115, 8003, 2, 'DL891234', 'Yamaha MT'),
(116, 8004, 4, 'DL567890', 'Honda Civ'),
(117, 8005, 6, 'DL345678', 'Suzuki GS');

-- new driver was added because query e)1 had to have a list of top 5, so this new one does not have any assigned orders to show up in that list
INSERT INTO Driver (userId, driverId, experience, licenseDetails, vehicleInfo) VALUES 
(103, 8006, 3, 'DL189496', 'Tesla S');


-- FoodOrders table (30 inserts) with deliveryTime and driverId
INSERT INTO FoodOrders (orderId, restId, custId, driverId, totAmount, orderDate, deliveryTime, paymentMethod, deliveryStatus) VALUES 
(7001, 2001, 108, 101, 45, '2024-05-15 18:30:00', '2024-05-15 19:15:00', 'Credit Card', 'Delivered'),
(7002, 2003, 109, 102, 32, '2024-06-20 19:15:00', '2024-06-20 19:35:00', 'Debit Card', 'Delivered'),
(7003, 2005, 110, 116, 58, '2024-07-10 20:00:00', '2024-07-10 20:25:00', 'Cash', 'Delivered'),
(7004, 2002, 115, 116, 40, '2024-08-05 12:30:00', '2024-08-05 13:10:00', 'PayPal', 'Delivered'),
(7005, 2004, 112, 116, 35, '2024-09-12 19:45:00', '2024-09-12 20:30:00', 'Credit Card', 'Delivered'),
(7006, 2006, 113, 101, 48, '2024-10-18 18:00:00', '2024-10-18 18:10:00', 'Apple Pay', 'Delivered'),
(7007, 2008, 114, 116, 27, '2024-11-22 13:15:00', '2024-11-22 13:20:00', 'Google Pay', 'Delivered'),
(7008, 2007, 108, 116, 52, '2024-12-08 19:30:00', '2024-12-08 20:20:00', 'Credit Card', 'Delivered'),
(7009, 2009, 109, 116, 78, '2025-04-26 20:30:00', '2025-04-26 21:15:00', 'Debit Card', 'Delivered'),
(7010, 2010, 110, 117, 40, '2025-04-27 18:45:00', '2025-04-27 19:25:00', 'Cash', 'Delivered'),
(7011, 2001, 115, 101, 36, '2025-04-28 12:00:00', '2025-04-28 12:15:00', 'PayPal', 'Delivered'),
(7012, 2003, 112, 116, 44, '2025-04-29 19:00:00', '2025-04-29 19:20:00', 'Credit Card', 'Delivered'),
(7013, 2005, 113, 115, 65, '2025-04-30 20:15:00', '2025-04-30 21:00:00', 'Debit Card', 'Delivered'),
(7014, 2002, 114, 116, 55, '2025-05-01 18:30:00', '2025-05-01 19:15:00', 'Apple Pay', 'Delivered'),
(7015, 2004, 108, 116, 42, '2025-05-02 19:45:00', '2025-05-02 20:25:00', 'Google Pay', 'Delivered'),
(7016, 2006, 109, 116, 38, '2025-05-03 13:00:00', '2025-05-03 13:15:00', 'Credit Card', 'Delivered'),
(7017, 2008, 110, 102, 29, '2025-05-04 12:30:00', '2025-05-04 13:05:00', 'Cash', 'Delivered'),
(7018, 2007, 111, 116, 68, '2025-05-05 20:00:00', '2025-05-05 20:10:00', 'PayPal', 'Delivered'),
(7019, 2009, 112, 116, 92, '2025-05-06 19:30:00', '2025-05-06 19:45:00', 'Credit Card', 'Cancelled'),
(7020, 2010, 113, 116, 46, '2025-05-07 18:15:00', '2025-05-07 18:55:00', 'Debit Card', 'Delivered'),
(7021, 2001, 114, 101, 50, '2025-05-08 19:00:00', '2025-05-08 19:40:00', 'Apple Pay', 'Delivered'),
(7022, 2003, 108, 102, 34, '2025-05-09 18:45:00', '2025-05-09 18:55:00', 'Google Pay', 'Preparing'),
(7023, 2005, 109, 115, 72, '2025-05-09 20:30:00', '2025-05-09 21:15:00', 'Credit Card', 'Delivered'),
(7024, 2002, 110, 116, 48, '2025-05-10 12:15:00', '2025-05-10 12:55:00', 'Cash', 'Delivered'),
(7025, 2004, 111, 117, 56, '2025-05-10 13:45:00', '2025-05-10 14:25:00', 'PayPal', 'Preparing'),
(7026, 2006, 112, 101, 41, '2025-05-10 14:30:00', '2025-05-10 14:45:00', 'Debit Card', 'Pending'),
(7027, 2008, 113, 102, 35, '2025-05-10 15:00:00', '2025-05-10 15:30:00', 'Credit Card', 'Confirmed'),
(7028, 2007, 114, 116, 76, '2025-05-10 16:15:00', '2025-05-10 16:35:00', 'Apple Pay', 'Preparing'),
(7029, 2009, 108, 116, 85, '2025-05-10 17:30:00', '2025-05-10 17:40:00', 'Google Pay', 'Pending'),
(7030, 2010, 109, 117, 52, '2025-05-10 18:00:00', '2025-05-10 18:40:00', 'Credit Card', 'Confirmed'),
(7031, 2001, 111, 101, 145, '2024-05-20 19:00:00', '2024-05-20 19:40:00', 'Credit Card', 'Delivered'),
(7032, 2003, 111, 116, 138, '2024-06-20 18:30:00', '2024-06-20 19:10:00', 'PayPal', 'Delivered'),
(7033, 2005, 111, 116, 62, '2024-07-20 20:00:00', '2024-07-20 20:45:00', 'Debit Card', 'Delivered'),
(7034, 2002, 111, 115, 147, '2024-08-20 19:30:00', '2024-08-20 20:15:00', 'Cash', 'Delivered'),
(7035, 2004, 111, 115, 155, '2024-09-20 18:00:00', '2024-09-20 18:40:00', 'Google Pay', 'Delivered'),
(7036, 2006, 111, 116, 141, '2024-10-20 19:15:00', '2024-10-20 19:55:00', 'Apple Pay', 'Delivered'),
(7037, 2008, 111, 117, 133, '2024-11-20 20:30:00', '2024-11-20 21:10:00', 'Credit Card', 'Delivered'),
(7038, 2007, 111, 101, 68, '2024-12-20 19:00:00', '2024-12-20 19:50:00', 'PayPal', 'Delivered'),
(7039, 2009, 111, 102, 85, '2025-01-20 20:00:00', '2025-01-20 20:45:00', 'Debit Card', 'Delivered'),
(7040, 2010, 111, 115, 149, '2025-02-20 18:30:00', '2025-02-20 19:10:00', 'Credit Card', 'Delivered'),
(7041, 2001, 111, 115, 152, '2025-03-20 19:30:00', '2025-03-20 20:15:00', 'Cash', 'Delivered'),
(7042, 2003, 111, 116, 143, '2025-04-20 18:00:00', '2025-04-20 18:35:00', 'Google Pay', 'Delivered');
INSERT INTO FoodOrders (orderId, restId, custId, driverId, totAmount, orderDate, deliveryTime, paymentMethod, deliveryStatus) VALUES
(7043, 2001, 108, 116, 45, '2025-04-27 10:00:00', '2025-04-27 10:40:00', 'Credit Card', 'Delivered'),
(7044, 2002, 109, 116, 35, '2025-04-28 11:30:00', '2025-04-28 12:10:00', 'Cash', 'Delivered'),
(7045, 2003, 110, 116, 28, '2025-04-29 12:00:00', '2025-04-29 12:35:00', 'Debit Card', 'Delivered'),
(7046, 2004, 111, 116, 52, '2025-04-30 13:15:00', '2025-04-30 13:55:00', 'PayPal', 'Delivered'),
(7047, 2005, 112, 116, 65, '2025-05-01 14:30:00', '2025-05-01 15:10:00', 'Credit Card', 'Delivered'),
(7048, 2006, 113, 116, 41, '2025-05-02 15:45:00', '2025-05-02 16:25:00', 'Apple Pay', 'Delivered'),
(7049, 2007, 114, 116, 76, '2025-05-03 17:00:00', '2025-05-03 17:40:00', 'Google Pay', 'Delivered'),
(7050, 2008, 108, 116, 29, '2025-05-04 18:15:00', '2025-05-04 18:50:00', 'Cash', 'Delivered'),
(7051, 2009, 109, 116, 85, '2025-05-05 19:30:00', '2025-05-05 20:15:00', 'Credit Card', 'Delivered'),
(7052, 2010, 110, 116, 48, '2025-05-06 20:45:00', '2025-05-06 21:25:00', 'Debit Card', 'Delivered'),
(7053, 2001, 111, 116, 36, '2025-05-07 11:00:00', '2025-05-07 11:35:00', 'PayPal', 'Delivered'),
(7054, 2002, 112, 116, 44, '2025-05-08 12:15:00', '2025-05-08 12:55:00', 'Apple Pay', 'Delivered'),
(7055, 2003, 113, 116, 38, '2025-05-09 13:30:00', '2025-05-09 14:10:00', 'Google Pay', 'Delivered'),
(7056, 2004, 114, 116, 56, '2025-05-09 16:00:00', '2025-05-09 16:40:00', 'Credit Card', 'Delivered'),
(7057, 2005, 108, 116, 72, '2025-05-10 09:00:00', '2025-05-10 09:45:00', 'Cash', 'Delivered');
INSERT INTO FoodOrders (orderId, restId, custId, driverId, totAmount, orderDate, deliveryTime, paymentMethod, deliveryStatus) VALUES
(7058, 2001, 108, 116, 45, '2025-04-11 10:00:00', '2025-04-11 10:40:00', 'Credit Card', 'Delivered'),
(7059, 2001, 109, 116, 36, '2025-04-12 11:00:00', '2025-04-12 11:40:00', 'Cash', 'Delivered'),
(7060, 2001, 110, 116, 50, '2025-04-13 12:00:00', '2025-04-13 12:40:00', 'PayPal', 'Delivered'),
(7061, 2001, 111, 116, 42, '2025-04-14 13:00:00', '2025-04-14 13:40:00', 'Credit Card', 'Delivered'),
(7062, 2001, 112, 116, 38, '2025-04-15 14:00:00', '2025-04-15 14:40:00', 'Debit Card', 'Delivered'),
(7063, 2001, 113, 116, 45, '2025-04-16 15:00:00', '2025-04-16 15:40:00', 'Apple Pay', 'Delivered'),
(7064, 2001, 114, 116, 50, '2025-04-17 16:00:00', '2025-04-17 16:40:00', 'Google Pay', 'Delivered'),
(7065, 2001, 108, 116, 36, '2025-04-18 17:00:00', '2025-04-18 17:40:00', 'Credit Card', 'Delivered'),
(7066, 2001, 109, 116, 42, '2025-04-19 18:00:00', '2025-04-19 18:40:00', 'Cash', 'Delivered'),
(7067, 2001, 110, 116, 45, '2025-04-20 19:00:00', '2025-04-20 19:40:00', 'PayPal', 'Delivered'),
(7068, 2001, 111, 116, 38, '2025-04-21 20:00:00', '2025-04-21 20:40:00', 'Credit Card', 'Delivered'),
(7069, 2001, 112, 116, 50, '2025-04-22 10:30:00', '2025-04-22 11:10:00', 'Debit Card', 'Delivered'),
(7070, 2001, 113, 116, 36, '2025-04-23 11:30:00', '2025-04-23 12:10:00', 'Apple Pay', 'Delivered'),
(7071, 2001, 114, 116, 42, '2025-04-24 12:30:00', '2025-04-24 13:10:00', 'Google Pay', 'Delivered'),
(7072, 2001, 108, 116, 45, '2025-04-25 13:30:00', '2025-04-25 14:10:00', 'Credit Card', 'Delivered'),
-- Adding 14 orders for restaurant 2002
(7073, 2002, 109, 116, 40, '2025-04-11 09:00:00', '2025-04-11 09:40:00', 'Cash', 'Delivered'),
(7074, 2002, 110, 116, 55, '2025-04-12 10:00:00', '2025-04-12 10:40:00', 'PayPal', 'Delivered'),
(7075, 2002, 111, 116, 48, '2025-04-13 11:00:00', '2025-04-13 11:40:00', 'Credit Card', 'Delivered'),
(7076, 2002, 112, 116, 42, '2025-04-14 12:00:00', '2025-04-14 12:40:00', 'Debit Card', 'Delivered'),
(7077, 2002, 113, 116, 55, '2025-04-15 13:00:00', '2025-04-15 13:40:00', 'Apple Pay', 'Delivered'),
(7078, 2002, 114, 116, 40, '2025-04-16 14:00:00', '2025-04-16 14:40:00', 'Google Pay', 'Delivered'),
(7079, 2002, 108, 116, 48, '2025-04-17 15:00:00', '2025-04-17 15:40:00', 'Credit Card', 'Delivered'),
(7080, 2002, 109, 116, 55, '2025-04-18 16:00:00', '2025-04-18 16:40:00', 'Cash', 'Delivered'),
(7081, 2002, 110, 116, 42, '2025-04-19 17:00:00', '2025-04-19 17:40:00', 'PayPal', 'Delivered'),
(7082, 2002, 111, 116, 40, '2025-04-20 18:00:00', '2025-04-20 18:40:00', 'Credit Card', 'Delivered'),
(7083, 2002, 112, 116, 48, '2025-04-21 19:00:00', '2025-04-21 19:40:00', 'Debit Card', 'Delivered'),
(7084, 2002, 113, 116, 55, '2025-04-22 20:00:00', '2025-04-22 20:40:00', 'Apple Pay', 'Delivered'),
(7085, 2002, 114, 116, 42, '2025-04-23 10:00:00', '2025-04-23 10:40:00', 'Google Pay', 'Delivered'),
(7086, 2002, 108, 116, 40, '2025-04-24 11:00:00', '2025-04-24 11:40:00', 'Credit Card', 'Delivered'),
-- Adding 15 orders for restaurant 2008
(7087, 2008, 109, 116, 27, '2025-04-11 12:00:00', '2025-04-11 12:30:00', 'Cash', 'Delivered'),
(7088, 2008, 110, 116, 35, '2025-04-12 13:00:00', '2025-04-12 13:30:00', 'PayPal', 'Delivered'),
(7089, 2008, 111, 116, 29, '2025-04-13 14:00:00', '2025-04-13 14:30:00', 'Credit Card', 'Delivered'),
(7090, 2008, 112, 116, 35, '2025-04-14 15:00:00', '2025-04-14 15:30:00', 'Debit Card', 'Delivered'),
(7091, 2008, 113, 116, 27, '2025-04-15 16:00:00', '2025-04-15 16:30:00', 'Apple Pay', 'Delivered'),
(7092, 2008, 114, 116, 29, '2025-04-16 17:00:00', '2025-04-16 17:30:00', 'Google Pay', 'Delivered'),
(7093, 2008, 108, 116, 35, '2025-04-17 18:00:00', '2025-04-17 18:30:00', 'Credit Card', 'Delivered'),
(7094, 2008, 109, 116, 27, '2025-04-18 19:00:00', '2025-04-18 19:30:00', 'Cash', 'Delivered'),
(7095, 2008, 110, 116, 29, '2025-04-19 20:00:00', '2025-04-19 20:30:00', 'PayPal', 'Delivered'),
(7096, 2008, 111, 116, 35, '2025-04-20 09:00:00', '2025-04-20 09:30:00', 'Credit Card', 'Delivered'),
(7097, 2008, 112, 116, 27, '2025-04-21 10:00:00', '2025-04-21 10:30:00', 'Debit Card', 'Delivered'),
(7098, 2008, 113, 116, 29, '2025-04-22 11:00:00', '2025-04-22 11:30:00', 'Apple Pay', 'Delivered'),
(7099, 2008, 114, 116, 35, '2025-04-23 12:00:00', '2025-04-23 12:30:00', 'Google Pay', 'Delivered'),
(7100, 2008, 108, 116, 27, '2025-04-24 13:00:00', '2025-04-24 13:30:00', 'Credit Card', 'Delivered'),
(7101, 2008, 109, 116, 29, '2025-04-25 14:00:00', '2025-04-25 14:30:00', 'Cash', 'Delivered');
-- Insert an old order for restaurant 2012 (more than 2 months ago)
INSERT INTO FoodOrders (orderId, restId, custId, driverId, totAmount, orderDate, deliveryTime, paymentMethod, deliveryStatus) VALUES 
(7102, 2012, 108, 101, 45, '2025-01-05 18:30:00', '2025-01-05 19:15:00', 'Credit Card', 'Delivered');
-- Food orders for 31-60 day period with promotional items (but no promotions applied)
INSERT INTO FoodOrders (orderId, restId, custId, driverId, totAmount, orderDate, deliveryTime, paymentMethod, deliveryStatus) VALUES 
(7201, 2002, 109, 116, 48, '2025-03-15 19:00:00', '2025-03-15 19:40:00', 'Credit Card', 'Delivered'),
(7202, 2004, 111, 117, 44, '2025-03-18 18:30:00', '2025-03-18 19:10:00', 'PayPal', 'Delivered'),
(7203, 2006, 112, 101, 48, '2025-03-22 20:00:00', '2025-03-22 20:40:00', 'Cash', 'Delivered'),
(7204, 2008, 114, 102, 35, '2025-03-25 19:30:00', '2025-03-25 20:00:00', 'Apple Pay', 'Delivered'),
(7205, 2009, 108, 115, 96, '2025-03-28 19:00:00', '2025-03-28 19:45:00', 'Credit Card', 'Delivered'),
(7206, 2010, 110, 116, 48, '2025-03-30 18:30:00', '2025-03-30 19:10:00', 'Debit Card', 'Delivered'),
(7207, 2002, 113, 117, 40, '2025-04-02 19:15:00', '2025-04-02 19:55:00', 'Google Pay', 'Delivered'),
(7208, 2008, 109, 101, 27, '2025-04-05 12:30:00', '2025-04-05 13:00:00', 'Cash', 'Delivered'),
(7209, 2004, 111, 116, 33, '2025-04-07 20:00:00', '2025-04-07 20:40:00', 'Credit Card', 'Delivered'),
(7210, 2009, 115, 102, 64, '2025-04-09 19:30:00', '2025-04-09 20:15:00', 'PayPal', 'Delivered');
-- Now create 10 food orders for 31-60 day period WITHOUT promotions (9002, 9007, 9008)
INSERT INTO FoodOrders (orderId, restId, custId, driverId, totAmount, orderDate, deliveryTime, paymentMethod, deliveryStatus) VALUES 
(7231, 2005, 108, 116, 50, '2025-03-13 19:00:00', '2025-03-13 19:40:00', 'Credit Card', 'Delivered'),
(7232, 2007, 109, 117, 64, '2025-03-16 18:30:00', '2025-03-16 19:10:00', 'PayPal', 'Delivered'),
(7233, 2005, 111, 101, 43, '2025-03-19 20:00:00', '2025-03-19 20:40:00', 'Cash', 'Delivered'),
(7234, 2007, 113, 102, 78, '2025-03-22 19:30:00', '2025-03-22 20:15:00', 'Apple Pay', 'Delivered'),
(7235, 2005, 112, 115, 57, '2025-03-25 12:30:00', '2025-03-25 13:10:00', 'Debit Card', 'Delivered'),
(7236, 2007, 114, 116, 90, '2025-03-28 19:15:00', '2025-03-28 20:00:00', 'Google Pay', 'Delivered'),
(7237, 2005, 110, 117, 71, '2025-03-31 19:45:00', '2025-03-31 20:25:00', 'Credit Card', 'Delivered'),
(7238, 2007, 108, 101, 52, '2025-04-03 18:00:00', '2025-04-03 18:40:00', 'PayPal', 'Delivered'),
(7239, 2005, 115, 102, 36, '2025-04-06 13:00:00', '2025-04-06 13:30:00', 'Cash', 'Delivered'),
(7240, 2007, 109, 116, 86, '2025-04-09 20:00:00', '2025-04-09 20:45:00', 'Credit Card', 'Delivered');
-- Create 20 food orders with promotions 9002, 9007, 9008 in the last 30 days
INSERT INTO FoodOrders (orderId, restId, custId, driverId, totAmount, orderDate, deliveryTime, paymentMethod, deliveryStatus) VALUES 
-- Orders with promotion 9002 (Free Delivery Weekend - Teriyaki Don at Sakura Zen)
(7241, 2005, 108, 116, 43, '2025-05-10 19:00:00', '2025-05-10 19:40:00', 'Credit Card', 'Delivered'),
(7242, 2005, 109, 117, 57, '2025-05-10 18:30:00', '2025-05-10 19:10:00', 'PayPal', 'Delivered'),
(7243, 2005, 111, 101, 50, '2025-05-11 12:00:00', '2025-05-11 12:40:00', 'Cash', 'Delivered'),
(7244, 2005, 113, 102, 64, '2025-05-11 13:30:00', '2025-05-11 14:10:00', 'Apple Pay', 'Delivered'),
(7245, 2005, 112, 115, 71, '2025-05-10 20:00:00', '2025-05-10 20:40:00', 'Debit Card', 'Delivered'),
(7246, 2005, 114, 116, 36, '2025-05-11 14:00:00', '2025-05-11 14:40:00', 'Google Pay', 'Delivered'),
(7247, 2005, 110, 117, 85, '2025-05-10 19:45:00', '2025-05-10 20:25:00', 'Credit Card', 'Delivered'),
-- Orders with promotion 9007 (Summer Special - Grilled Branzino at Blue Aegean)  
(7248, 2007, 108, 101, 52, '2025-04-25 18:00:00', '2025-04-25 18:40:00', 'PayPal', 'Delivered'),
(7249, 2007, 115, 102, 78, '2025-04-28 19:00:00', '2025-04-28 19:40:00', 'Cash', 'Delivered'),
(7250, 2007, 109, 116, 90, '2025-05-03 20:00:00', '2025-05-03 20:45:00', 'Credit Card', 'Delivered'),
(7251, 2007, 111, 117, 64, '2025-05-06 19:30:00', '2025-05-06 20:10:00', 'Debit Card', 'Delivered'),
(7252, 2007, 113, 101, 86, '2025-05-08 18:30:00', '2025-05-08 19:10:00', 'Apple Pay', 'Delivered'),
(7253, 2007, 112, 102, 52, '2025-05-09 19:00:00', '2025-05-09 19:40:00', 'PayPal', 'Delivered'),
-- Orders with promotion 9008 (Free Drink with Meal - Edamame at Sakura Zen)
(7254, 2005, 114, 115, 43, '2025-04-20 19:15:00', '2025-04-20 19:55:00', 'Google Pay', 'Delivered'),
(7255, 2005, 110, 116, 57, '2025-04-26 19:45:00', '2025-04-26 20:25:00', 'Credit Card', 'Delivered'),
(7256, 2005, 108, 117, 36, '2025-05-02 12:30:00', '2025-05-02 13:00:00', 'Cash', 'Delivered'),
(7257, 2005, 109, 101, 50, '2025-05-05 13:00:00', '2025-05-05 13:30:00', 'PayPal', 'Delivered'),
(7258, 2005, 111, 102, 64, '2025-05-07 19:30:00', '2025-05-07 20:10:00', 'Credit Card', 'Delivered'),
(7259, 2005, 113, 115, 43, '2025-05-09 20:00:00', '2025-05-09 20:40:00', 'Debit Card', 'Delivered'),
(7260, 2005, 112, 116, 71, '2025-05-10 17:30:00', '2025-05-10 18:10:00', 'Apple Pay', 'Delivered');


-- Promotions table (3 inserts)
INSERT INTO Promotions (promoId, description, validityPeriod) VALUES 
(9001, '20% Off First Order', '2025-05-01 to 05-31'),
(9002, 'Free Delivery Weekend', '2025-05-10 to 05-12'),
(9003, '$5 Off Orders Over $30', '2025-05-15 to 06-15'),  
(9004, 'Buy 1 Get 1 Free Desserts', '2025-05-20 to 05-27'),
(9005, '30% Off Asian Cuisine', '2025-06-01 to 06-07'),
(9006, 'Happy Hour 15% Off', '2025-05-15 to 07-15'),
(9007, 'Summer Special 25% Off', '2025-06-20 to 08-31'),
(9008, 'Free Drink with Meal', '2025-05-25 to 06-10');


-- Item table (8 inserts) 
INSERT INTO Item (itemId, name, price) VALUES 
(4003, 'Tiramisu', 7),              -- Original: 9 (for dessert promo 9001)
(4024, 'Cheesecake', 6),            -- Original: 8 (for dessert promo 9001)
(4005, 'Chilli Chicken', 13),     -- Original: 18 (for Asian cuisine promo 9005)
(4017, 'Pad Thai', 12),             -- Original: 17 (for Asian cuisine promo 9005)
(4029, 'Bibimbap', 13),             -- Original: 18 (for Asian cuisine promo 9005)
(4011, 'Butter Chicken', 15),       -- Original: 20 (for first order promo 9001)
(4023, 'Classic Burger', 12),       -- Original: 16 (for happy hour promo 9006)
(4026, 'Beef Bourguignon', 24),    -- Original: 32 (for $5 off promo 9003)
-- First, add items to promotions 9002, 9007, 9008 (these promotions currently have no items)
(4015, 'Teriyaki Don', 12),      -- Original: 15 (for Free Delivery Weekend promo 9002)
(4020, 'Grilled Branzino', 20),  -- Original: 26 (for Summer Special promo 9007)
(4013, 'Edamame', 5);            -- Original: 7 (for Free Drink with Meal promo 9008)


INSERT INTO RunsPromotion (restId, promoId, itemId, name) VALUES 
(2001, 9004, 4003, 'Tiramisu'),              -- Bella Vista runs dessert promo
(2008, 9001, 4024, 'Cheesecake'),            -- Stars & Stripes runs 20% off 
(2002, 9005, 4005, 'Chilli Chicken'),        -- Golden Dragon runs Asian cuisine promo
(2006, 9001, 4017, 'Pad Thai'),              -- Bangkok Bites runs Asian cuisine promo
(2010, 9001, 4029, 'Bibimbap'),              -- Seoul Kitchen runs Asian cuisine promo*
(2004, 9001, 4011, 'Butter Chicken'),        -- Spice Palace runs first order promo
(2008, 9006, 4023, 'Classic Burger'),        -- Stars & Stripes runs happy hour promo
(2009, 9003, 4026, 'Beef Bourguignon'),     -- Le Petit Jardin runs $5 off promo 
(2005, 9002, 4015, 'Teriyaki Don'),      	-- Sakura Zen runs Free Delivery Weekend
(2007, 9007, 4020, 'Grilled Branzino'),  	-- Blue Aegean runs Summer Special
(2005, 9008, 4013, 'Edamame');           	-- Sakura Zen runs Free Drink with Meal


-- Review table (10 inserts)
INSERT INTO Review (reviewId, rating, feedbackText, date) VALUES 
(6001, 5, 'Excellent service!', '2025-05-08'),
(6002, 4, 'Very good food', '2025-05-07'),
(6003, 3, 'Average experience', '2025-05-06'),
(6004, 5, 'Amazing taste!', '2025-05-05'),
(6005, 2, 'Slow delivery', '2025-05-04'),
(6006, 4, 'Great value', '2025-05-03'),
(6007, 5, 'Best pizza ever', '2025-05-02'),
(6008, 1, 'Order was wrong', '2025-05-01'),
(6009, 4, 'Fresh ingredients', '2025-04-30'),
(6010, 3, 'Decent portion size', '2025-04-29'),
(6011, 5, 'Smooth ride!', '2025-05-08'),
(6012, 4.6, 'Driver was polite', '2025-05-07'),
(6013, 4.6, 'Late arrival', '2025-05-06'),
(6014, 5, 'Clean car', '2025-05-05'),
(6015, 3, 'Wrong route taken', '2025-05-04'),
(6016, 4.5, 'Fair price', '2025-05-03'),
(6017, 5, 'Quick pickup', '2025-05-02'),
(6018, 2, 'Driver was rude', '2025-05-01'),
(6019, 4.9, 'Safe driving', '2025-04-30'),
(6020, 3, 'AC not working', '2025-04-29');


-- Corrected: Add 10 new reviews to the Review table
INSERT INTO Review (reviewId, rating, feedbackText, date) VALUES 
(6061, 4, 'Satisfying meal', '2025-03-19'),
(6062, 5, 'Excellent choice', '2025-03-18'),
(6063, 3, 'Average quality', '2025-03-17'),
(6064, 5, 'Superb taste', '2025-03-16'),
(6065, 2, 'Disappointing', '2025-03-15'),
(6066, 4, 'Good value', '2025-03-14'),
(6067, 5, 'Outstanding', '2025-03-13'),
(6068, 1, 'Poor service', '2025-03-12'),
(6069, 4, 'Decent food', '2025-03-11'),
(6070, 3, 'Nothing special', '2025-03-10');


-- LeavesFoodReview table (10 inserts)
INSERT INTO LeavesFoodReview (reviewId, userId, orderId) VALUES 
(6001, 114, 7021),  -- User 114's order from 2025-05-08
(6002, 113, 7020),  -- User 113's order from 2025-05-07
(6003, 112, 7019),  -- User 112's cancelled order from 2025-05-06
(6004, 111, 7018),  -- User 111's order from 2025-05-05
(6005, 110, 7017),  -- User 110's order from 2025-05-04
(6006, 109, 7016),  -- User 109's order from 2025-05-03
(6007, 108, 7015),  -- User 108's order from 2025-05-02
(6008, 114, 7014),  -- User 114's order from 2025-05-01
(6009, 113, 7013),  -- User 113's order from 2025-04-30
(6010, 112, 7012);  -- User 112's order from 2025-04-29
-- Link these reviews to customer 111's unlinked orders
INSERT INTO LeavesFoodReview (reviewId, userId, orderId) VALUES 
(6061, 111, 7042),  -- Unlinked order in range
(6062, 111, 7046),  -- Unlinked order in range
(6063, 111, 7053),  -- Unlinked order in range
(6064, 111, 7061),  -- Unlinked order in range
(6065, 111, 7068),  -- Unlinked order in range
(6066, 111, 7075),  -- Unlinked order in range
(6067, 111, 7082),  -- Unlinked order in range
(6068, 111, 7089),  -- Unlinked order in range
(6069, 111, 7096),  -- Unlinked order in range
(6070, 111, 7018);  -- First occurrence of customer 111's order


INSERT INTO PlacesOrder (orderId, userId, restId) VALUES 
-- Original orders (7001-7030)
(7001, 108, 2001),
(7002, 109, 2003),
(7003, 110, 2005),
(7004, 115, 2002),
(7005, 112, 2004),
(7006, 113, 2006),
(7007, 114, 2008),
(7008, 108, 2007),
(7009, 109, 2009),
(7010, 110, 2010),
(7011, 115, 2001),
(7012, 112, 2003),
(7013, 113, 2005),
(7014, 114, 2002),
(7015, 108, 2004),
(7016, 109, 2006),
(7017, 110, 2008),
(7018, 111, 2007),
(7019, 112, 2009),
(7020, 113, 2010),
(7021, 114, 2001),
(7022, 108, 2003),
(7023, 109, 2005),
(7024, 110, 2002),
(7025, 111, 2004),
(7026, 112, 2006),
(7027, 113, 2008),
(7028, 114, 2007),
(7029, 108, 2009),
(7030, 109, 2010),
-- Fixed orders for customer 111 (7031-7042)
(7031, 111, 2001),
(7032, 111, 2003),
(7033, 111, 2005),
(7034, 111, 2002),
(7035, 111, 2004),
(7036, 111, 2006),
(7037, 111, 2008),
(7038, 111, 2007),
(7039, 111, 2009),
(7040, 111, 2010),
(7041, 111, 2001),
(7042, 111, 2003),
-- Additional orders (7043-7057)
(7043, 108, 2001),
(7044, 109, 2002),
(7045, 110, 2003),
(7046, 111, 2004),
(7047, 112, 2005),
(7048, 113, 2006),
(7049, 114, 2007),
(7050, 108, 2008),
(7051, 109, 2009),
(7052, 110, 2010),
(7053, 111, 2001),
(7054, 112, 2002),
(7055, 113, 2003),
(7056, 114, 2004),
(7057, 108, 2005),
-- Restaurant 2001 orders (7058-7072)
(7058, 108, 2001),
(7059, 109, 2001),
(7060, 110, 2001),
(7061, 111, 2001),
(7062, 112, 2001),
(7063, 113, 2001),
(7064, 114, 2001),
(7065, 108, 2001),
(7066, 109, 2001),
(7067, 110, 2001),
(7068, 111, 2001),
(7069, 112, 2001),
(7070, 113, 2001),
(7071, 114, 2001),
(7072, 108, 2001),
-- Restaurant 2002 orders (7073-7086)
(7073, 109, 2002),
(7074, 110, 2002),
(7075, 111, 2002),
(7076, 112, 2002),
(7077, 113, 2002),
(7078, 114, 2002),
(7079, 108, 2002),
(7080, 109, 2002),
(7081, 110, 2002),
(7082, 111, 2002),
(7083, 112, 2002),
(7084, 113, 2002),
(7085, 114, 2002),
(7086, 108, 2002),
-- Restaurant 2008 orders (7087-7101)
(7087, 109, 2008),
(7088, 110, 2008),
(7089, 111, 2008),
(7090, 112, 2008),
(7091, 113, 2008),
(7092, 114, 2008),
(7093, 108, 2008),
(7094, 109, 2008),
(7095, 110, 2008),
(7096, 111, 2008),
(7097, 112, 2008),
(7098, 113, 2008),
(7099, 114, 2008),
(7100, 108, 2008),
(7101, 109, 2008);
-- Restaurant 2011 has NO orders at all
-- Restaurant 2012 has only an old order from January 5, 2025
INSERT INTO PlacesOrder (orderId, userId, restId) VALUES 
(7102, 108, 2012);
-- PlacesOrder entries
INSERT INTO PlacesOrder (orderId, userId, restId) VALUES 
(7201, 109, 2002),
(7202, 111, 2004),
(7203, 112, 2006),
(7204, 114, 2008),
(7205, 108, 2009),
(7206, 110, 2010),
(7207, 113, 2002),
(7208, 109, 2008),
(7209, 111, 2004),
(7210, 115, 2009);
-- PlacesOrder entries
INSERT INTO PlacesOrder (orderId, userId, restId) VALUES 
(7231, 108, 2005),
(7232, 109, 2007),
(7233, 111, 2005),
(7234, 113, 2007),
(7235, 112, 2005),
(7236, 114, 2007),
(7237, 110, 2005),
(7238, 108, 2007),
(7239, 115, 2005),
(7240, 109, 2007);
-- PlacesOrder entries
INSERT INTO PlacesOrder (orderId, userId, restId) VALUES 
(7241, 108, 2005), 
(7242, 109, 2005),
(7243, 111, 2005), 
(7244, 113, 2005),
(7245, 112, 2005), 
(7246, 114, 2005), 
(7247, 110, 2005), 
(7248, 108, 2007),
(7249, 115, 2007), 
(7250, 109, 2007), 
(7251, 111, 2007), 
(7252, 113, 2007),
(7253, 112, 2007), 
(7254, 114, 2005), 
(7255, 110, 2005), 
(7256, 108, 2005),
(7257, 109, 2005), 
(7258, 111, 2005), 
(7259, 113, 2005), 
(7260, 112, 2005);


INSERT INTO FareLocation (pickUpLocation, dropOffLocation, pickUpTime, rideFare) VALUES
('JFK Airport', 'Times Square', '06:00:00', 65),
('Times Square', 'JFK Airport', '08:30:00', 70),
('Central Station', 'Business District', '07:45:00', 25),
('Business District', 'Central Station', '17:30:00', 30),
('Madison Square Garden', 'Brooklyn Bridge', '12:00:00', 35),
('Brooklyn Bridge', 'Madison Square Garden', '14:15:00', 35),
('Broadway Theater', 'Lincoln Center', '19:30:00', 20),
('Lincoln Center', 'Broadway Theater', '22:00:00', 22),
('Grand Central Terminal', 'Upper East Side', '09:00:00', 18),
('Upper East Side', 'Grand Central Terminal', '10:30:00', 18),
('Wall Street', 'Central Park', '11:45:00', 32);


-- Sample INSERT statements for Rides table (referencing first 11 FareLocation tuples)
INSERT INTO Rides (rideId, pickUpLocation, dropOffLocation, pickUpTime, paymentStatus, paymentMethod)
VALUES 
(11001, 'JFK Airport', 'Times Square', '06:00:00', 'COMPLETED', 'CREDIT_CARD'),
(11002, 'Times Square', 'JFK Airport', '08:30:00', 'COMPLETED', 'CASH'),
(11003, 'Central Station', 'Business District', '07:45:00', 'PENDING', 'DEBIT_CARD'),
(11004, 'Business District', 'Central Station', '17:30:00', 'COMPLETED', 'MOBILE_PAY'),
(11005, 'Madison Square Garden', 'Brooklyn Bridge', '12:00:00', 'COMPLETED', 'CREDIT_CARD'),
(11006, 'Brooklyn Bridge', 'Madison Square Garden', '14:15:00', 'FAILED', 'CREDIT_CARD'),
(11007, 'Broadway Theater', 'Lincoln Center', '19:30:00', 'COMPLETED', 'CORPORATE_ACCOUNT'),
(11008, 'Lincoln Center', 'Broadway Theater', '22:00:00', 'PENDING', 'CASH'),
(11009, 'Grand Central Terminal', 'Upper East Side', '09:00:00', 'COMPLETED', 'DEBIT_CARD'),
(11010, 'Upper East Side', 'Grand Central Terminal', '10:30:00', 'COMPLETED', 'MOBILE_PAY'),
(11011, 'Wall Street', 'Central Park', '11:45:00', 'PROCESSING', 'CREDIT_CARD');


-- Sample INSERT statements for Assigned table
INSERT INTO Assigned (userId, empId, rideId)VALUES 
(101, 1002, 11001),
(102, 1005, 11002),
(115, 1008, 11003),
(116, 1011, 11004),
(117, 1014, 11005),
(101, 1017, 11006),
(102, 1020, 11007),
(115, 1002, 11008),
(116, 1005, 11009),
(117, 1008, 11010),
(101, 1011, 11011);


-- Sample INSERT statements for LeavesRiderReview table
INSERT INTO LeavesRiderReview (reviewId, userId, rideId) VALUES 
(6011, 101, 11001),  -- Review for completed JFK to Times Square ride
(6012, 102, 11002),  -- Review for completed Times Square to JFK ride
(6013, 103, 11004),  -- Review for completed Business District to Central Station ride
(6014, 104, 11005),  -- Review for completed Madison Square Garden to Brooklyn Bridge ride
(6015, 105, 11007),  -- Review for completed Broadway Theater to Lincoln Center ride
(6016, 106, 11009),  -- Review for completed Grand Central to Upper East Side ride
(6017, 107, 11010),  -- Review for completed Upper East Side to Grand Central ride
(6018, 108, 11001),  -- Second review for ride 11001 (different rider)
(6019, 101, 11011),  -- Review for processing Wall Street to Central Park ride
(6020, 102, 11003);  -- Review for pending Central Station to Business District ride


-- OrderItems table (matching orders with menu items)
INSERT INTO OrderItems (orderId, itemId, quantity) VALUES 
-- Order 7001 (Bella Vista, total $45)
(7001, 4001, 1),  -- Bruschetta ($12)
(7001, 4002, 1),  -- Linguine Vongole ($24)
(7001, 4003, 1),  -- Tiramisu ($9)
-- Order 7002 (El Sombrero, total $32)
(7002, 4007, 1),  -- Guacamole & Chips ($10)
(7002, 4008, 1),  -- Carnitas Tacos ($16)
-- Order 7003 (Sakura Zen, total $58)
(7003, 4013, 1),  -- Edamame ($7)
(7003, 4014, 1),  -- Sashimi Platter ($28)
(7003, 4015, 1),  -- Teriyaki Don ($15)
-- Order 7004 (Golden Dragon, total $40)
(7004, 4004, 1),  -- Spring Rolls ($8)
(7004, 4005, 1),  -- Chilli Chicken ($18)
(7004, 4006, 1),  -- Mongolian Beef ($22)
-- Order 7005 (Spice Palace, total $35)
(7005, 4010, 1),  -- Vegetable Samosa ($9)
(7005, 4011, 1),  -- Butter Chicken ($20)
(7005, 4012, 1),  -- Garlic Naan ($4)
-- Order 7006 (Bangkok Bites, total $48)
(7006, 4016, 1),  -- Tom Yum ($12)
(7006, 4017, 1),  -- Pad Thai ($17)
(7006, 4018, 1),  -- Green Curry Chicken ($19)
-- Order 7007 (Stars & Stripes, total $27)
(7007, 4022, 1),  -- Hot Wings ($11)
(7007, 4023, 1),  -- Classic Burger ($16)
-- Order 7008 (Blue Aegean, total $52)
(7008, 4019, 1),  -- Octopus Mezze ($14)
(7008, 4020, 1),  -- Grilled Branzino ($26)
(7008, 4021, 1),  -- Horiatiki ($12)
-- Order 7009 (Le Petit Jardin, total $78)
(7009, 4025, 1),  -- Foie Gras ($16)
(7009, 4026, 2),  -- Beef Bourguignon ($32 x 2)
-- Order 7010 (Seoul Kitchen, total $40)
(7010, 4028, 1),  -- Kimchi Pancake ($8)
(7010, 4029, 1),  -- Bibimbap ($18)
(7010, 4030, 1),  -- Galbi ($22)
-- Order 7011 (Bella Vista, total $36)
(7011, 4001, 1),  -- Bruschetta ($12)
(7011, 4002, 1),  -- Linguine Vongole ($24)
-- Order 7012 (El Sombrero, total $44)
(7012, 4007, 1),  -- Guacamole & Chips ($10)
(7012, 4008, 1),  -- Carnitas Tacos ($16)
(7012, 4009, 1),  -- Carne Asada ($18)
-- Order 7013 (Sakura Zen, total $65)
(7013, 4013, 2),  -- Edamame ($7 x 2)
(7013, 4014, 1),  -- Sashimi Platter ($28)
(7013, 4015, 1),  -- Teriyaki Don ($15)
-- Order 7014 (Golden Dragon, total $55)
(7014, 4004, 2),  -- Spring Rolls ($8 x 2)
(7014, 4005, 1),  -- Chilli Chicken ($18)
(7014, 4006, 1),  -- Mongolian Beef ($22)
-- Order 7015 (Spice Palace, total $42)
(7015, 4010, 2),  -- Vegetable Samosa ($9 x 2)
(7015, 4011, 1),  -- Butter Chicken ($20)
(7015, 4012, 1),  -- Garlic Naan ($4)
-- Order 7016 (Bangkok Bites, total $38)
(7016, 4016, 1),  -- Tom Yum ($12)
(7016, 4017, 1),  -- Pad Thai ($17)
-- Order 7017 (Stars & Stripes, total $29)
(7017, 4023, 1),  -- Classic Burger ($16)
(7017, 4024, 1),  -- Cheesecake ($8)
-- Order 7018 (Blue Aegean, total $68)
(7018, 4019, 1),  -- Octopus Mezze ($14)
(7018, 4020, 2),  -- Grilled Branzino ($26 x 2)
-- Order 7019 (Le Petit Jardin, total $92)
(7019, 4025, 1),  -- Foie Gras ($16)
(7019, 4026, 2),  -- Beef Bourguignon ($32 x 2)
(7019, 4027, 1),  -- Fondant au Chocolat ($12)
-- Order 7020 (Seoul Kitchen, total $46)
(7020, 4028, 1),  -- Kimchi Pancake ($8)
(7020, 4029, 1),  -- Bibimbap ($18)
(7020, 4030, 1),  -- Galbi ($22)
-- Order 7021 (Bella Vista, total $50)
(7021, 4001, 1),  -- Bruschetta ($12)
(7021, 4002, 1),  -- Linguine Vongole ($24)
(7021, 4003, 2),  -- Tiramisu ($9 x 2)
-- Order 7022 (El Sombrero, total $34)
(7022, 4007, 1),  -- Guacamole & Chips ($10)
(7022, 4008, 1),  -- Carnitas Tacos ($16)
-- Order 7023 (Sakura Zen, total $72)
(7023, 4013, 1),  -- Edamame ($7)
(7023, 4014, 2),  -- Sashimi Platter ($28 x 2)
-- Order 7024 (Golden Dragon, total $48)
(7024, 4004, 1),  -- Spring Rolls ($8)
(7024, 4005, 1),  -- Chilli Chicken ($18)
(7024, 4006, 1),  -- Mongolian Beef ($22)
-- Order 7025 (Spice Palace, total $56)
(7025, 4010, 1),  -- Vegetable Samosa ($9)
(7025, 4011, 2),  -- Butter Chicken ($20 x 2)
(7025, 4012, 2),  -- Garlic Naan ($4 x 2)
-- Order 7026 (Bangkok Bites, total $41)
(7026, 4016, 1),  -- Tom Yum ($12)
(7026, 4017, 1),  -- Pad Thai ($17)
-- Order 7027 (Stars & Stripes, total $35)
(7027, 4022, 1),  -- Hot Wings ($11)
(7027, 4023, 1),  -- Classic Burger ($16)
(7027, 4024, 1),  -- Cheesecake ($8)
-- Order 7028 (Blue Aegean, total $76)
(7028, 4019, 1),  -- Octopus Mezze ($14)
(7028, 4020, 2),  -- Grilled Branzino ($26 x 2)
(7028, 4021, 1),  -- Horiatiki ($12)
-- Order 7029 (Le Petit Jardin, total $85)
(7029, 4025, 1),  -- Foie Gras ($16)
(7029, 4026, 2),  -- Beef Bourguignon ($32 x 2)
-- Order 7030 (Seoul Kitchen, total $52)
(7030, 4028, 1),  -- Kimchi Pancake ($8)
(7030, 4029, 1),  -- Bibimbap ($18)
(7030, 4030, 1);   -- Galbi ($22)
INSERT INTO OrderItems (orderId, itemId, quantity) VALUES
-- Order 7031 (Bella Vista, total $145)
(7031, 4001, 3),  -- Bruschetta ($12 x 3 = $36)
(7031, 4002, 4),  -- Linguine Vongole ($24 x 4 = $96)
(7031, 4003, 1),  -- Tiramisu ($9 x 1 = $9)

-- Order 7032 (El Sombrero, total $138)
(7032, 4007, 5),  -- Guacamole & Chips ($10 x 5 = $50)
(7032, 4008, 4),  -- Carnitas Tacos ($16 x 4 = $64)
(7032, 4009, 1),  -- Carne Asada ($18 x 1 = $18)

-- Order 7033 (Sakura Zen, total $62)
(7033, 4013, 2),  -- Edamame ($7 x 2 = $14)
(7033, 4014, 1),  -- Sashimi Platter ($28 x 1 = $28)
(7033, 4015, 1),  -- Teriyaki Don ($15 x 1 = $15)

-- Order 7034 (Golden Dragon, total $147)
(7034, 4004, 4),  -- Spring Rolls ($8 x 4 = $32)
(7034, 4005, 4),  -- Chilli Chicken ($18 x 4 = $72)
(7034, 4006, 2),  -- Mongolian Beef ($22 x 2 = $44)

-- Order 7035 (Spice Palace, total $155)
(7035, 4010, 5),  -- Vegetable Samosa ($9 x 5 = $45)
(7035, 4011, 5),  -- Butter Chicken ($20 x 5 = $100)
(7035, 4012, 2),  -- Garlic Naan ($4 x 2 = $8)

-- Order 7036 (Bangkok Bites, total $141)
(7036, 4016, 4),  -- Tom Yum ($12 x 4 = $48)
(7036, 4017, 3),  -- Pad Thai ($17 x 3 = $51)
(7036, 4018, 2),  -- Green Curry Chicken ($19 x 2 = $38)

-- Order 7037 (Stars & Stripes, total $133)
(7037, 4022, 5),  -- Hot Wings ($11 x 5 = $55)
(7037, 4023, 4),  -- Classic Burger ($16 x 4 = $64)
(7037, 4024, 2),  -- Cheesecake ($8 x 2 = $16)

-- Order 7038 (Blue Aegean, total $68)
(7038, 4019, 1),  -- Octopus Mezze ($14 x 1 = $14)
(7038, 4020, 2),  -- Grilled Branzino ($26 x 2 = $52)

-- Order 7039 (Le Petit Jardin, total $85)
(7039, 4025, 1),  -- Foie Gras ($16 x 1 = $16)
(7039, 4026, 2),  -- Beef Bourguignon ($32 x 2 = $64)

-- Order 7040 (Seoul Kitchen, total $149)
(7040, 4028, 5),  -- Kimchi Pancake ($8 x 5 = $40)
(7040, 4029, 4),  -- Bibimbap ($18 x 4 = $72)
(7040, 4030, 1),  -- Galbi ($22 x 1 = $22)

-- Order 7041 (Bella Vista, total $152)
(7041, 4001, 4),  -- Bruschetta ($12 x 4 = $48)
(7041, 4002, 4),  -- Linguine Vongole ($24 x 4 = $96)
(7041, 4003, 1),  -- Tiramisu ($9 x 1 = $9)

-- Order 7042 (El Sombrero, total $143)
(7042, 4007, 5),  -- Guacamole & Chips ($10 x 5 = $50)
(7042, 4008, 4),  -- Carnitas Tacos ($16 x 4 = $64)
(7042, 4009, 1);  -- Carne Asada ($18 x 1 = $18)

INSERT INTO OrderItems (orderId, itemId, quantity) VALUES
-- Order 7043 (Bella Vista, total $45)
(7043, 4001, 1),  -- Bruschetta ($12)
(7043, 4002, 1),  -- Linguine Vongole ($24)
(7043, 4003, 1),  -- Tiramisu ($9)

-- Order 7044 (Golden Dragon, total $35)
(7044, 4004, 1),  -- Spring Rolls ($8)
(7044, 4005, 1),  -- Chilli Chicken ($18)
(7044, 4003, 1),  -- Extra item to reach $35

-- Order 7045 (El Sombrero, total $28)
(7045, 4007, 1),  -- Guacamole & Chips ($10)
(7045, 4008, 1),  -- Carnitas Tacos ($16)

-- Order 7046 (Spice Palace, total $52)
(7046, 4010, 1),  -- Vegetable Samosa ($9)
(7046, 4011, 2),  -- Butter Chicken ($20 x 2 = $40)
(7046, 4012, 1),  -- Garlic Naan ($4)

-- Order 7047 (Sakura Zen, total $65)
(7047, 4013, 1),  -- Edamame ($7)
(7047, 4014, 2),  -- Sashimi Platter ($28 x 2 = $56)

-- Order 7048 (Bangkok Bites, total $41)
(7048, 4016, 1),  -- Tom Yum ($12)
(7048, 4017, 1),  -- Pad Thai ($17)
(7048, 4018, 1),  -- Green Curry Chicken ($19 -> adjusted)

-- Order 7049 (Blue Aegean, total $76)
(7049, 4019, 1),  -- Octopus Mezze ($14)
(7049, 4020, 2),  -- Grilled Branzino ($26 x 2 = $52)
(7049, 4021, 1),  -- Horiatiki ($12)

-- Order 7050 (Stars & Stripes, total $29)
(7050, 4022, 1),  -- Hot Wings ($11)
(7050, 4023, 1),  -- Classic Burger ($16)

-- Order 7051 (Le Petit Jardin, total $85)
(7051, 4025, 1),  -- Foie Gras ($16)
(7051, 4026, 2),  -- Beef Bourguignon ($32 x 2 = $64)

-- Order 7052 (Seoul Kitchen, total $48)
(7052, 4028, 1),  -- Kimchi Pancake ($8)
(7052, 4029, 1),  -- Bibimbap ($18)
(7052, 4030, 1),  -- Galbi ($22)

-- Order 7053 (Bella Vista, total $36)
(7053, 4001, 1),  -- Bruschetta ($12)
(7053, 4002, 1),  -- Linguine Vongole ($24)

-- Order 7054 (Golden Dragon, total $44)
(7054, 4004, 1),  -- Spring Rolls ($8)
(7054, 4005, 1),  -- Chilli Chicken ($18)
(7054, 4006, 1),  -- Mongolian Beef ($22 -> adjusted)

-- Order 7055 (El Sombrero, total $38)
(7055, 4007, 1),  -- Guacamole & Chips ($10)
(7055, 4008, 1),  -- Carnitas Tacos ($16)
(7055, 4009, 1),  -- Carne Asada ($18 -> adjusted)

-- Order 7056 (Spice Palace, total $56)
(7056, 4010, 1),  -- Vegetable Samosa ($9)
(7056, 4011, 2),  -- Butter Chicken ($20 x 2 = $40)
(7056, 4012, 2),  -- Garlic Naan ($4 x 2 = $8)

-- Order 7057 (Sakura Zen, total $72)
(7057, 4013, 1),  -- Edamame ($7)
(7057, 4014, 2),  -- Sashimi Platter ($28 x 2 = $56)
(7057, 4015, 1);  -- Teriyaki Don ($15)

-- Restaurant 2001 orders (Italian - items 4001, 4002, 4003)
INSERT INTO OrderItems (orderId, itemId, quantity) VALUES
-- Order 7058 (total $45)
(7058, 4001, 1),  -- Bruschetta ($12)
(7058, 4002, 1),  -- Linguine Vongole ($24)
(7058, 4003, 1),  -- Tiramisu ($9)

-- Order 7059 (total $36)
(7059, 4001, 1),  -- Bruschetta ($12)
(7059, 4002, 1),  -- Linguine Vongole ($24)

-- Order 7060 (total $50)
(7060, 4002, 2),  -- Linguine Vongole ($24 x 2 = $48)

-- Order 7061 (total $42)
(7061, 4001, 1),  -- Bruschetta ($12)
(7061, 4003, 3),  -- Tiramisu ($9 x 3 = $27)

-- Order 7062 (total $38)
(7062, 4001, 1),  -- Bruschetta ($12)
(7062, 4002, 1),  -- Linguine Vongole ($24)

-- Order 7063 (total $45)
(7063, 4001, 1),  -- Bruschetta ($12)
(7063, 4002, 1),  -- Linguine Vongole ($24)
(7063, 4003, 1),  -- Tiramisu ($9)

-- Order 7064 (total $50)
(7064, 4002, 2),  -- Linguine Vongole ($24 x 2 = $48)

-- Order 7065 (total $36)
(7065, 4001, 1),  -- Bruschetta ($12)
(7065, 4002, 1),  -- Linguine Vongole ($24)

-- Order 7066 (total $42)
(7066, 4003, 4),  -- Tiramisu ($9 x 4 = $36)

-- Order 7067 (total $45)
(7067, 4001, 1),  -- Bruschetta ($12)
(7067, 4002, 1),  -- Linguine Vongole ($24)
(7067, 4003, 1),  -- Tiramisu ($9)

-- Order 7068 (total $38)
(7068, 4001, 1),  -- Bruschetta ($12)
(7068, 4002, 1),  -- Linguine Vongole ($24)

-- Order 7069 (total $50)
(7069, 4002, 2),  -- Linguine Vongole ($24 x 2 = $48)

-- Order 7070 (total $36)
(7070, 4001, 1),  -- Bruschetta ($12)
(7070, 4002, 1),  -- Linguine Vongole ($24)

-- Order 7071 (total $42)
(7071, 4003, 4),  -- Tiramisu ($9 x 4 = $36)

-- Order 7072 (total $45)
(7072, 4001, 1),  -- Bruschetta ($12)
(7072, 4002, 1),  -- Linguine Vongole ($24)
(7072, 4003, 1),  -- Tiramisu ($9)

-- Restaurant 2002 orders (Chinese - items 4004, 4005, 4006)
-- Order 7073 (total $40)
(7073, 4004, 1),  -- Spring Rolls ($8)
(7073, 4005, 1),  -- Chilli Chicken ($18)
(7073, 4006, 1),  -- Mongolian Beef ($22) - adjusted

-- Order 7074 (total $55)
(7074, 4004, 1),  -- Spring Rolls ($8)
(7074, 4005, 1),  -- Chilli Chicken ($18)
(7074, 4006, 1),  -- Mongolian Beef ($22)

-- Order 7075 (total $48)
(7075, 4004, 1),  -- Spring Rolls ($8)
(7075, 4005, 1),  -- Chilli Chicken ($18)
(7075, 4006, 1),  -- Mongolian Beef ($22)

-- Order 7076 (total $42)
(7076, 4004, 2),  -- Spring Rolls ($8 x 2 = $16)
(7076, 4005, 1),  -- Chilli Chicken ($18)

-- Order 7077 (total $55)
(7077, 4004, 1),  -- Spring Rolls ($8)
(7077, 4005, 1),  -- Chilli Chicken ($18)
(7077, 4006, 1),  -- Mongolian Beef ($22)

-- Order 7078 (total $40)
(7078, 4004, 1),  -- Spring Rolls ($8)
(7078, 4005, 1),  -- Chilli Chicken ($18)
(7078, 4006, 1),  -- Mongolian Beef ($22) - adjusted

-- Order 7079 (total $48)
(7079, 4004, 1),  -- Spring Rolls ($8)
(7079, 4005, 1),  -- Chilli Chicken ($18)
(7079, 4006, 1),  -- Mongolian Beef ($22)

-- Order 7080 (total $55)
(7080, 4004, 1),  -- Spring Rolls ($8)
(7080, 4005, 1),  -- Chilli Chicken ($18)
(7080, 4006, 1),  -- Mongolian Beef ($22)

-- Order 7081 (total $42)
(7081, 4004, 2),  -- Spring Rolls ($8 x 2 = $16)
(7081, 4005, 1),  -- Chilli Chicken ($18)

-- Order 7082 (total $40)
(7082, 4004, 1),  -- Spring Rolls ($8)
(7082, 4005, 1),  -- Chilli Chicken ($18)

-- Order 7083 (total $48)
(7083, 4004, 1),  -- Spring Rolls ($8)
(7083, 4005, 1),  -- Chilli Chicken ($18)
(7083, 4006, 1),  -- Mongolian Beef ($22)

-- Order 7084 (total $55)
(7084, 4004, 1),  -- Spring Rolls ($8)
(7084, 4005, 1),  -- Chilli Chicken ($18)
(7084, 4006, 1),  -- Mongolian Beef ($22)

-- Order 7085 (total $42)
(7085, 4004, 2),  -- Spring Rolls ($8 x 2 = $16)
(7085, 4005, 1),  -- Chilli Chicken ($18)

-- Order 7086 (total $40)
(7086, 4004, 1),  -- Spring Rolls ($8)
(7086, 4005, 1),  -- Chilli Chicken ($18)

-- Restaurant 2008 orders (American - items 4022, 4023, 4024)
-- Order 7087 (total $27)
(7087, 4022, 1),  -- Hot Wings ($11)
(7087, 4023, 1),  -- Classic Burger ($16)

-- Order 7088 (total $35)
(7088, 4022, 1),  -- Hot Wings ($11)
(7088, 4023, 1),  -- Classic Burger ($16)
(7088, 4024, 1),  -- Cheesecake ($8)

-- Order 7089 (total $29)
(7089, 4022, 1),  -- Hot Wings ($11)
(7089, 4023, 1),  -- Classic Burger ($16)

-- Order 7090 (total $35)
(7090, 4022, 1),  -- Hot Wings ($11)
(7090, 4023, 1),  -- Classic Burger ($16)
(7090, 4024, 1),  -- Cheesecake ($8)

-- Order 7091 (total $27)
(7091, 4022, 1),  -- Hot Wings ($11)
(7091, 4023, 1),  -- Classic Burger ($16)

-- Order 7092 (total $29)
(7092, 4022, 1),  -- Hot Wings ($11)
(7092, 4023, 1),  -- Classic Burger ($16)

-- Order 7093 (total $35)
(7093, 4022, 1),  -- Hot Wings ($11)
(7093, 4023, 1),  -- Classic Burger ($16)
(7093, 4024, 1),  -- Cheesecake ($8)

-- Order 7094 (total $27)
(7094, 4022, 1),  -- Hot Wings ($11)
(7094, 4023, 1),  -- Classic Burger ($16)

-- Order 7095 (total $29)
(7095, 4022, 1),  -- Hot Wings ($11)
(7095, 4023, 1),  -- Classic Burger ($16)

-- Order 7096 (total $35)
(7096, 4022, 1),  -- Hot Wings ($11)
(7096, 4023, 1),  -- Classic Burger ($16)
(7096, 4024, 1),  -- Cheesecake ($8)

-- Order 7097 (total $27)
(7097, 4022, 1),  -- Hot Wings ($11)
(7097, 4023, 1),  -- Classic Burger ($16)

-- Order 7098 (total $29)
(7098, 4022, 1),  -- Hot Wings ($11)
(7098, 4023, 1),  -- Classic Burger ($16)

-- Order 7099 (total $35)
(7099, 4022, 1),  -- Hot Wings ($11)
(7099, 4023, 1),  -- Classic Burger ($16)
(7099, 4024, 1),  -- Cheesecake ($8)

-- Order 7100 (total $27)
(7100, 4022, 1),  -- Hot Wings ($11)
(7100, 4023, 1),  -- Classic Burger ($16)

-- Order 7101 (total $29)
(7101, 4022, 1),  -- Hot Wings ($11)
(7101, 4023, 1);  -- Classic Burger ($16)

-- OrderItems entries (including promotional items WITHOUT promotions)
INSERT INTO OrderItems (orderId, itemId, quantity) VALUES
-- Order 7201 (Golden Dragon - includes Chilli Chicken)
(7201, 4004, 1),  -- Spring Rolls ($8)
(7201, 4005, 1),  -- Chilli Chicken ($18) - NO PROMO
(7201, 4006, 1),  -- Mongolian Beef ($22)

-- Order 7202 (Spice Palace - includes Butter Chicken)  
(7202, 4010, 1),  -- Vegetable Samosa ($9)
(7202, 4011, 1),  -- Butter Chicken ($20) - NO PROMO
(7202, 4012, 4),  -- Garlic Naan ($4 x 4 = $16)

-- Order 7203 (Bangkok Bites - includes Pad Thai)
(7203, 4016, 1),  -- Tom Yum ($12)
(7203, 4017, 2),  -- Pad Thai ($17 x 2 = $34) - NO PROMO

-- Order 7204 (Stars & Stripes - includes Classic Burger and Cheesecake)
(7204, 4023, 1),  -- Classic Burger ($16) - NO PROMO
(7204, 4024, 1),  -- Cheesecake ($8) - NO PROMO
(7204, 4022, 1),  -- Hot Wings ($11)

-- Order 7205 (Le Petit Jardin - includes Beef Bourguignon)
(7205, 4026, 2),  -- Beef Bourguignon ($32 x 2 = $64) - NO PROMO
(7205, 4025, 1),  -- Foie Gras ($16)
(7205, 4027, 1),  -- Fondant au Chocolat ($12)

-- Order 7206 (Seoul Kitchen - includes Bibimbap)
(7206, 4028, 1),  -- Kimchi Pancake ($8)
(7206, 4029, 1),  -- Bibimbap ($18) - NO PROMO
(7206, 4030, 1),  -- Galbi ($22)

-- Order 7207 (Golden Dragon - includes Chilli Chicken again)
(7207, 4005, 1),  -- Chilli Chicken ($18) - NO PROMO
(7207, 4006, 1),  -- Mongolian Beef ($22)

-- Order 7208 (Stars & Stripes - just has Classic Burger)
(7208, 4023, 1),  -- Classic Burger ($16) - NO PROMO
(7208, 4022, 1),  -- Hot Wings ($11)

-- Order 7209 (Spice Palace - includes Butter Chicken)
(7209, 4010, 1),  -- Vegetable Samosa ($9)
(7209, 4011, 1),  -- Butter Chicken ($20) - NO PROMO
(7209, 4012, 1),  -- Garlic Naan ($4)

-- Order 7210 (Le Petit Jardin - includes Beef Bourguignon)
(7210, 4026, 2);  -- Beef Bourguignon ($32 x 2 = $64) - NO PROMO

-- OrderItems entries (including the newly promoted items WITHOUT promotions)
INSERT INTO OrderItems (orderId, itemId, quantity) VALUES
-- Order 7231 (Sakura Zen - includes Teriyaki Don and Edamame)
(7231, 4013, 1),  -- Edamame ($7) - NO PROMO  
(7231, 4015, 1),  -- Teriyaki Don ($15) - NO PROMO
(7231, 4014, 1),  -- Sashimi Platter ($28)

-- Order 7232 (Blue Aegean - includes Grilled Branzino)
(7232, 4019, 1),  -- Octopus Mezze ($14)
(7232, 4020, 2),  -- Grilled Branzino ($26 x 2 = $52) - NO PROMO

-- Order 7233 (Sakura Zen - includes Teriyaki Don and Edamame)
(7233, 4013, 2),  -- Edamame ($7 x 2 = $14) - NO PROMO
(7233, 4015, 2),  -- Teriyaki Don ($15 x 2 = $30) - NO PROMO

-- Order 7234 (Blue Aegean - includes Grilled Branzino)
(7234, 4020, 1),  -- Grilled Branzino ($26) - NO PROMO
(7234, 4021, 1),  -- Horiatiki ($12)
(7234, 4019, 3),  -- Octopus Mezze ($14 x 3 = $42)

-- Order 7235 (Sakura Zen - multiple items)
(7235, 4013, 1),  -- Edamame ($7) - NO PROMO
(7235, 4014, 1),  -- Sashimi Platter ($28)
(7235, 4015, 1),  -- Teriyaki Don ($15) - NO PROMO

-- Order 7236 (Blue Aegean - big order)
(7236, 4019, 1),  -- Octopus Mezze ($14)
(7236, 4020, 3),  -- Grilled Branzino ($26 x 3 = $78) - NO PROMO

-- Order 7237 (Sakura Zen - includes all items)
(7237, 4013, 2),  -- Edamame ($7 x 2 = $14) - NO PROMO
(7237, 4014, 1),  -- Sashimi Platter ($28)
(7237, 4015, 2),  -- Teriyaki Don ($15 x 2 = $30) - NO PROMO

-- Order 7238 (Blue Aegean - includes Grilled Branzino)
(7238, 4019, 1),  -- Octopus Mezze ($14)
(7238, 4020, 1),  -- Grilled Branzino ($26) - NO PROMO
(7238, 4021, 1),  -- Horiatiki ($12)

-- Order 7239 (Sakura Zen - simple order)
(7239, 4013, 1),  -- Edamame ($7) - NO PROMO
(7239, 4015, 2),  -- Teriyaki Don ($15 x 2 = $30) - NO PROMO

-- Order 7240 (Blue Aegean - large order)
(7240, 4019, 2),  -- Octopus Mezze ($14 x 2 = $28)
(7240, 4020, 2),  -- Grilled Branzino ($26 x 2 = $52) - NO PROMO
(7240, 4021, 1);  -- Horiatiki ($12)

-- OrderItems entries (with promotions applied)
INSERT INTO OrderItems (orderId, itemId, quantity) VALUES
-- Orders 7241-7247 (Promo 9002 - Teriyaki Don)
(7241, 4015, 2),  -- Teriyaki Don ($15 x 2 = $30, with promo: $12 x 2 = $24)
(7241, 4013, 1),  -- Edamame ($7)
(7242, 4015, 3),  -- Teriyaki Don ($15 x 3 = $45, with promo: $12 x 3 = $36)
(7242, 4014, 1),  -- Sashimi Platter ($28)
(7243, 4015, 2),  -- Teriyaki Don ($15 x 2 = $30, with promo: $12 x 2 = $24)
(7243, 4013, 2),  -- Edamame ($7 x 2 = $14)
(7244, 4015, 4),  -- Teriyaki Don ($15 x 4 = $60, with promo: $12 x 4 = $48)
(7244, 4013, 1),  -- Edamame ($7)
(7245, 4015, 3),  -- Teriyaki Don ($15 x 3 = $45, with promo: $12 x 3 = $36)
(7245, 4014, 1),  -- Sashimi Platter ($28)
(7246, 4015, 2),  -- Teriyaki Don ($15 x 2 = $30, with promo: $12 x 2 = $24)
(7246, 4013, 1),  -- Edamame ($7)
(7247, 4015, 5),  -- Teriyaki Don ($15 x 5 = $75, with promo: $12 x 5 = $60)
(7247, 4013, 2),  -- Edamame ($7 x 2 = $14)

-- Orders 7248-7253 (Promo 9007 - Grilled Branzino)
(7248, 4020, 2),  -- Grilled Branzino ($26 x 2 = $52, with promo: $20 x 2 = $40)
(7248, 4021, 1),  -- Horiatiki ($12)
(7249, 4020, 3),  -- Grilled Branzino ($26 x 3 = $78, with promo: $20 x 3 = $60)
(7249, 4019, 1),  -- Octopus Mezze ($14)
(7250, 4020, 4),  -- Grilled Branzino ($26 x 4 = $104, with promo: $20 x 4 = $80)
(7250, 4021, 1),  -- Horiatiki ($12)
(7251, 4020, 2),  -- Grilled Branzino ($26 x 2 = $52, with promo: $20 x 2 = $40)
(7251, 4019, 1),  -- Octopus Mezze ($14)
(7252, 4020, 3),  -- Grilled Branzino ($26 x 3 = $78, with promo: $20 x 3 = $60)
(7252, 4021, 2),  -- Horiatiki ($12 x 2 = $24)
(7253, 4020, 2),  -- Grilled Branzino ($26 x 2 = $52, with promo: $20 x 2 = $40)
(7253, 4019, 1),  -- Octopus Mezze ($14)

-- Orders 7254-7260 (Promo 9008 - Edamame)
(7254, 4013, 5),  -- Edamame ($7 x 5 = $35, with promo: $5 x 5 = $25)
(7254, 4015, 1),  -- Teriyaki Don ($15)
(7255, 4013, 6),  -- Edamame ($7 x 6 = $42, with promo: $5 x 6 = $30)
(7255, 4014, 1),  -- Sashimi Platter ($28)
(7256, 4013, 4),  -- Edamame ($7 x 4 = $28, with promo: $5 x 4 = $20)
(7256, 4015, 1),  -- Teriyaki Don ($15)
(7257, 4013, 5),  -- Edamame ($7 x 5 = $35, with promo: $5 x 5 = $25)
(7257, 4014, 1),  -- Sashimi Platter ($28)
(7258, 4013, 7),  -- Edamame ($7 x 7 = $49, with promo: $5 x 7 = $35)
(7258, 4015, 1),  -- Teriyaki Don ($15)
(7259, 4013, 4),  -- Edamame ($7 x 4 = $28, with promo: $5 x 4 = $20)
(7259, 4014, 1),  -- Sashimi Platter ($28)
(7260, 4013, 8),  -- Edamame ($7 x 8 = $56, with promo: $5 x 8 = $40)
(7260, 4015, 1);  -- Teriyaki Don ($15)










