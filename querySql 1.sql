use globalrides;

/*VIEWS*/
/*1. LoyalCustomers: Which customers have placed orders consistently every month for the past year?*/
CREATE VIEW LoyalCustomers AS 
SELECT u.userId, u.fName, u.sName, u.tName 
FROM User u 
JOIN Customer c ON u.userId = c.userId 
JOIN FoodOrders fo ON fo.custId = c.userId 
WHERE fo.orderDate >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH) 
GROUP BY u.userId, u.fName, u.sName, u.tName 
-- HAVING COUNT(DISTINCT DATE_FORMAT(fo.orderDate, '%Y-%m')) = 12;
HAVING COUNT(DISTINCT DATE_FORMAT(fo.orderDate, '%Y-%m')) >= 12;

/*2. TopRatedRestaurants: Which restaurants have an average review rating of 4.5 or higher over the past six months?*/
CREATE VIEW TopRatedRestaurants AS	
SELECT r.restId, r.name, AVG(rv.rating) AS avgRating
FROM Review rv
JOIN LeavesFoodReview lfr ON rv.reviewId = lfr.reviewId
JOIN FoodOrders fo ON lfr.orderId = fo.orderId
JOIN Restaurant r ON fo.restId = r.restId
WHERE rv.date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY r.restId, r.name
HAVING AVG(rv.rating) >= 4.5;

/*3.ActiveDrivers: Which delivery drivers have completed at least 20 deliveries within
the last two weeks?*/

CREATE VIEW ActiveDrivers AS
SELECT d.userId, COUNT(*) AS deliveryCount
FROM FoodOrders fo
JOIN Driver d ON fo.driverId = d.userId
WHERE fo.orderDate >= DATE_SUB(CURDATE(), INTERVAL 14 DAY)
AND fo.driverId IS NOT NULL
GROUP BY d.userId
HAVING COUNT(*) >= 20;

/*4.PopularMenuItems: What are the top 10 most frequently ordered menu items
across all restaurants in the past three months?
	
[Modification : ]
CREATE TABLE OrderItems (
    orderId INT,
    itemId INT,
    quantity INT DEFAULT 1,
    PRIMARY KEY(orderId, itemId),
    FOREIGN KEY(orderId) REFERENCES FoodOrders(orderId),
    FOREIGN KEY(itemId) REFERENCES Menu(itemId)
);
*/

CREATE VIEW PopularMenuItems AS 
SELECT 	m.itemId, 
		m.name, 
        COUNT(po.orderId) AS orderCount
FROM Menu m
JOIN FoodOrders fo ON fo.restId = m.restId
JOIN PlacesOrder po ON po.orderId = fo.orderId
WHERE fo.orderDate >= CURDATE() - INTERVAL 3 MONTH
GROUP BY m.itemId, m.name
ORDER BY orderCount DESC
LIMIT 10;

/*5.ProminentOwners: Which restaurant owners manage multiple restaurants with a
combined total of at least 50 orders in the past month?*/

CREATE VIEW ProminentOwners AS 
SELECT ro.userId AS ownerId,
       COUNT(DISTINCT m.restId) AS restaurantsManaged,
       COUNT(fo.orderId) AS totalOrders
FROM RestOwner ro
JOIN Manages m ON ro.userId = m.userId
JOIN Restaurant r ON m.restId = r.restId
JOIN FoodOrders fo ON m.restId = fo.restId
WHERE fo.orderDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY ro.userId
HAVING restaurantsManaged > 1 AND totalOrders >= 50;
 

/* SQL QUERY ANSWERS*/
/* 1. TopEarningDrivers: List the names and total earnings of the top five drivers.*/
 
SELECT u.userId,
       u.fName,
	   u.sName,
	   u.tName,
	   SUM(fl.rideFare) AS totalEarnings
FROM User u
JOIN Driver d ON u.userId = d.userId
JOIN Assigned a ON a.userId = d.userId
JOIN Rides r ON r.rideId = a.rideId
JOIN FareLocation fl ON fl.pickUpLocation = r.pickUpLocation AND
                                                        fl.pickUpTime = r.pickUpTime AND
                                                        fl.dropOffLocation = r.dropOffLocation
GROUP BY u.userId, u.fName, u.sName, u.tName
ORDER BY totalEarnings DESC
LIMIT 5;

/*2. HighSpendingCustomers: Identify customers who have spent more than $1,000 and list their total expenditure.*/

SELECT 	u.userId, 
		u.fName,
		u.sName, 
		u.tName, 
		SUM(fo.totAmount) AS totalExpenditure
FROM User u
JOIN Customer c ON u.userId = c.userId
JOIN PlacesOrder po ON po.userId = c.userId
JOIN FoodOrders fo ON fo.orderId = po.orderId
GROUP BY u.userId, u.fName, u.sName, u.tName
HAVING totalExpenditure > 1000;

/*3. FrequentReviewers: Find customers who have left at least 10 reviews and their average review rating.*/

SELECT 	u.userId, 
		u.fName, 
		u.sName, 
		u.tName, 
		COUNT(lfr.reviewId) AS reviewCount,
		AVG(r.rating) AS averageRating 
FROM User u
JOIN Customer c ON c.userId = u.userId
JOIN LeavesFoodReview lfr ON lfr.userId = c.userId
JOIN Review r ON lfr.reviewId = r.reviewId
GROUP BY u.userId, u.fName, u.sName, u.tName
HAVING reviewCount >= 10;

/*4. InactiveRestaurants: List restaurants that have not received any orders in the past months.*/

/*SELECT r.restId, 
	   r.name, 
	   fo.orderDate 
FROM Restaurant r 
JOIN FoodOrders fo ON fo.restId = r.restId
GROUP BY r.restId, r.name
HAVING MAX(fo.orderDate) < (CURDATE() - INTERVAL 2 MONTH);*/

SELECT r.restId, 
       r.name, 
       MAX(fo.orderDate) as lastOrderDate
FROM Restaurant r 
LEFT JOIN FoodOrders fo ON fo.restId = r.restId
GROUP BY r.restId, r.name
HAVING MAX(fo.orderDate) < (CURDATE() - INTERVAL 2 MONTH) 
    OR MAX(fo.orderDate) IS NULL;

/*5. PeakOrderDay: Identify the day of the week with the highest number of orders in the past month.*/
		
SELECT DAYNAME(fo.orderDate) AS dayOfWeek,
       COUNT(*) AS orderCount
FROM FoodOrders fo
WHERE (fo.orderDate) >= (CURDATE() - INTERVAL 1 MONTH)
GROUP BY DAYNAME(fo.orderDate)
ORDER BY orderCount DESC
LIMIT 1;

/*6. HighEarningRestaurants: Find the top three restaurants with the highest total revenue in the past year.*/

SELECT r.restId,
	   r.name,
	   SUM(fo.totAmount) AS totalRevenue
FROM Restaurant r
JOIN FoodOrders fo ON fo.restId = r.restId
WHERE (fo.orderDate) >= (CURDATE() - INTERVAL 1 YEAR)
GROUP BY r.restId, r.name
ORDER BY totalRevenue DESC
LIMIT 3;
 
/*7. PopularCuisineType: Identify the most frequently ordered cuisine type in the past six months.*/

SELECT r.cuisine,
       COUNT(*) AS cuisineCount
FROM Restaurant r 
JOIN FoodOrders fo ON fo.restId = r.restId
WHERE (fo.orderDate) >= (CURDATE() - INTERVAL 6 MONTH)
GROUP BY r.cuisine		
ORDER BY cuisineCount DESC
LIMIT 1;

/*8. LongestRideRoutes: Identify the top five ride routes with the longest travel distances.
[Assumption: Assume higher rideFare would cover longer distances]*/
	
SELECT pickUpLocation, dropOffLocation, rideFare
FROM FareLocation
ORDER BY rideFare DESC 
LIMIT 5;

/*9. DriverRideCounts: Display the total number of rides delivered by each driver in the past three months.*/
 	
SELECT u.userId, 
       u.fName, 
       u.sName, 
       u.tName, 
       COUNT(r.rideId) AS totRides
FROM User u 
JOIN Driver d ON d.userId = u.userId
JOIN Assigned a ON a.userId = d.userId
JOIN Rides r ON r.rideId = a.rideId
WHERE r.pickUpTime >= (CURDATE() - INTERVAL 3 MONTH)
GROUP BY u.userId, u.fName, u.sName, u.tName;

/*10. UndeliveredOrders: Find all orders that were not delivered within the promised time window and their delay durations.
[Assumption: the promised delivery time is between 30 - 40 mins after the orderDate]*/

SELECT orderId,
       orderDate,
       deliveryTime,
       (TIMESTAMPDIFF(MINUTE, orderDate, deliveryTime) -40 )AS delayMinutes
FROM FoodOrders
WHERE deliveryTime IS NOT NULL 
      AND TIMESTAMPDIFF(MINUTE, orderDate, deliveryTime) > 40
      AND deliveryStatus = "Delivered";

/*11. MostCommonPaymentMethods: Identify the most frequently used payment method on the platform for both rides and food orders.
[Assumption: paymentStatus also contains the payment information for rides]*/

SELECT method, SUM(count) AS totalUsage
FROM (
    SELECT paymentMethod AS method, 
           COUNT(*) AS count
    FROM FoodOrders
    GROUP BY paymentMethod
    UNION ALL
    SELECT paymentStatus AS method, 
           COUNT(*) AS count
    FROM Rides
    GROUP BY paymentStatus
) AS combinedMethods
GROUP BY method
ORDER BY totalUsage DESC;
	
/*12. TrainingCount: List the number of Support Agents trained by each Trainer and their respective certification dates.*/

SELECT t.trainerId,
       t.certId,
       t.dateOfIssue, 
       COUNT(sa.empId) AS totSaTrained
FROM Trainer t
JOIN IsTrainedBy itb ON itb.tEmpId = t.trainerId
JOIN SupportAgent sa ON sa.empId = itb.saEmpId
GROUP BY t.trainerId, t.certId, t.dateOfIssue;
		   
/*13. MultiRoleUsers: Identify users who simultaneously serve as both Drivers and Restaurant Owners, along with their details.*/

SELECT u.userId, 
       u.fName, 
       u.sName, 
       u.tName
FROM User u 
JOIN Driver d ON u.userId = d.userId
JOIN RestOwner ro ON ro.userId = d.userId;

/*14. DriverVehicleTypes: Display the distribution of drivers by vehicle type (Sedan, SUV, and etc.), including the total number for each type.*/

SELECT vehicleInfo, 
       COUNT(userId) AS totalDrivers
FROM Driver
GROUP BY vehicleInfo;

/*15. HighlyRatedDrivers: Find drivers who have an average customer review rating of at least 4.8 and the number of rides they've completed*/
	
SELECT d.driverId,
       COUNT(r.rideId) AS numRides,
       AVG(rv.rating) AS avgRating
FROM Driver d
JOIN LeavesRiderReview lrr ON d.userId = lrr.userId
JOIN Rides r ON lrr.rideId = r.rideId
JOIN Review rv ON lrr.reviewId = rv.reviewId
GROUP BY d.driverId
HAVING AVG(rv.rating) >= 4.8;

/*16. TopPerformingPromotions: Identify the top five promotions that resulted in the highest percentage increase in order volume during this month compared to the last month without the promotion, and display the percentage increase along with the promotion details.*/
-- Modification : FoodOrders will reference Promotions table whenever there is a promotion applied. Otherwise this value will be null.
WITH PromoOrders AS (
    SELECT rp.promoId,
           fo.orderId,
           fo.orderDate
    FROM RunsPromotion rp
    JOIN OrderItems oi ON rp.itemId = oi.itemId
    JOIN FoodOrders fo ON oi.orderId = fo.orderId),
MonthlyCounts AS (
    SELECT promoId,
        CASE
            WHEN MONTH(orderDate) = MONTH(CURDATE()) THEN 'thisMonth'
            WHEN MONTH(orderDate) = MONTH(DATE_SUB(CURDATE(), INTERVAL 1 MONTH)) THEN 'lastMonth'
            ELSE NULL
        END AS monthCategory,
        COUNT(DISTINCT orderId) AS orderCount
    FROM PromoOrders
    WHERE orderDate >= DATE_SUB(CURDATE(), INTERVAL 2 MONTH)
    GROUP BY promoId, monthCategory
),
PivotCounts AS (
    SELECT promoId,
           MAX(CASE WHEN monthCategory = 'thisMonth' THEN orderCount ELSE 0 END) AS thisMonthCount,
           MAX(CASE WHEN monthCategory = 'lastMonth' THEN orderCount ELSE 0 END) AS lastMonthCount
    FROM MonthlyCounts
    GROUP BY promoId
),
WithPercentageIncrease AS (
    SELECT
        pc.promoId,
        p.description,
        p.validityPeriod,
        thisMonthCount,
        lastMonthCount,
        CASE 
            WHEN lastMonthCount = 0 THEN 100.0
            ELSE ROUND(((thisMonthCount - lastMonthCount) / lastMonthCount) * 100, 2)
        END AS percentageIncrease
    FROM PivotCounts pc
    JOIN Promotions p ON pc.promoId = p.promoId
)

SELECT *
FROM WithPercentageIncrease
ORDER BY percentageIncrease DESC
LIMIT 5;

/*17. OrderTimeAnalysis: Identify the average order delivery time for each restaurant in the past month and list those with an average time exceeding 30 minutes.
[Assumptions: In FoodOrders table, the orderDate includes the time that the order was placed as well.
Modification: In FoodOrders, we added an attribute deliveryTime]*/

SELECT fo.restId,
       r.name AS restaurantName,
       ROUND(AVG(TIMESTAMPDIFF(MINUTE, fo.orderDate, fo.deliveryTime)), 2) AS avgDeliveryTimeMins
FROM FoodOrders fo
JOIN Restaurant r ON fo.restId = r.restId
WHERE fo.deliveryTime IS NOT NULL
      AND fo.orderDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY fo.restId, r.name
HAVING avgDeliveryTimeMins > 30;


