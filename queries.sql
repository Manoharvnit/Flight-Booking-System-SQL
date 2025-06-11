
-- Easy Queries

-- 1. What are the different nationalities of passengers?
SELECT DISTINCT nationality FROM Passengers;

-- 2. What are the 5 most recent bookings?
SELECT * FROM Bookings ORDER BY booking_date DESC LIMIT 5;

-- 3. Which flights depart after July 15, 2025?
SELECT * FROM Flights WHERE departure_time > '2025-07-15 00:00:00';



-- Medium Queries

-- 4. What are the most popular routes based on flight count?
SELECT origin_id, destination_id, COUNT(*) AS flight_count
FROM Flights
GROUP BY origin_id, destination_id
ORDER BY flight_count DESC;

-- 5. Which passengers have made more than 2 bookings?
SELECT P.passenger_id, P.first_name, P.last_name, COUNT(*) AS booking_count
FROM Passengers P
JOIN Bookings B ON P.passenger_id = B.passenger_id
GROUP BY
P.passenger_id, P.first_name, P.last_name
HAVING booking_count > 2;

-- 6. What are the top 3 airlines by total revenue?
SELECT F.airline, SUM(B.fare) AS total_revenue
FROM Flights F
JOIN Bookings B ON F.flight_id = B.flight_id
GROUP BY F.airline
ORDER BY total_revenue DESC
LIMIT 3;

-- 7. Which flights have more than 120 bookings?
SELECT flight_id, COUNT(*) AS total_seats
FROM Bookings
GROUP BY flight_id
HAVING total_seats >= 120;

-- 8. What is the average fare paid by passengers of each nationality?
SELECT P.nationality, AVG(B.fare) AS avg_fare
FROM Passengers P
JOIN Bookings B ON P.passenger_id = B.passenger_id
GROUP BY P.nationality
ORDER BY avg_fare DESC;

-- 9. When is the first and last flight for each airline?
SELECT airline, MIN(departure_time) AS first_flight, MAX(departure_time) AS last_flight
FROM Flights
GROUP BY airline;

-- 10. Which passengers have visited more than one destination city?
SELECT P.passenger_id, P.first_name, P.last_name, COUNT(DISTINCT A.city) AS unique_destinations
FROM Passengers P
JOIN Bookings B ON P.passenger_id = B.passenger_id
JOIN Flights F ON B.flight_id = F.flight_id
JOIN Airports A ON F.destination_id = A.airport_id
GROUP BY P.passenger_id
HAVING unique_destinations > 1;



-- Advanced Queries

-- 11. What is the most profitable route (based on fare)?
SELECT A1.city AS origin, A2.city AS destination, SUM(B.fare) AS total_fare
FROM Bookings B
JOIN Flights F ON B.flight_id = F.flight_id
JOIN Airports A1 ON F.origin_id = A1.airport_id
JOIN Airports A2 ON F.destination_id = A2.airport_id
GROUP BY origin, destination
ORDER BY total_fare DESC
LIMIT 1;

-- 12. What was the last flight each passenger took, and where did it go?
SELECT P.passenger_id, P.first_name, P.last_name, F.flight_id, A.city AS destination, F.departure_time
FROM Passengers P
JOIN Bookings B ON P.passenger_id = B.passenger_id
JOIN Flights F ON B.flight_id = F.flight_id
JOIN Airports A ON F.destination_id = A.airport_id
WHERE (P.passenger_id, F.departure_time) IN (
    SELECT P2.passenger_id, MAX(F2.departure_time)
    FROM Passengers P2
    JOIN Bookings B2 ON P2.passenger_id = B2.passenger_id
    JOIN Flights F2 ON B2.flight_id = F2.flight_id
    GROUP BY P2.passenger_id
);

-- 13. Who are the top 5 spenders?
SELECT P.passenger_id, P.first_name, P.last_name, SUM(B.fare) AS total_spent
FROM Passengers P
JOIN Bookings B ON P.passenger_id = B.passenger_id
GROUP BY  
P.passenger_id, P.first_name, P.last_name
ORDER BY total_spent DESC
LIMIT 5;
