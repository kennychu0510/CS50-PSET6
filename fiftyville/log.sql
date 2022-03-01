-- Keep a log of any SQL queries you execute as you solve the mystery.
--All you know is that the theft took place on July 28, 2021 and that it took place on Humphrey Street.

--Check what available information is in crime_scene_reports
.schema crime_scene_reports

--Check description of crimes occured on July 28, 2021 on Humphrey Street
SELECT description
FROM crim_scene_reports
WHERE month = 7 AND day = 8 AND year = 2021
AND street = "Humphyrey Street";
--Theft of the CS50 duck took place at 10:15am at the Humphrey Street bakery.
--Interviews were conducted today with three witnesses who were present at the time – each of their interview transcripts mentions the bakery.

--Check available information in interviews
.schema interviews

--Check interviewees and transcripts conducted on July 28, 2021
SELECT name, transcript
FROM interviews
WHERE month = 7 AND day = 28 AND year = 2021;
--witnesses: Ruth, Eugene, Raymond
--Ruth: Within ten moinutes of the theft, saw thief get into a car in teh bakery parking lot and drive away. Check security footage from the bakery parking lot
--Eugene: Someone he recognize, earlier before he arrived at Emma's bakery, thief was walking by the ATM on Leggett Street withdrawing some money
--Raymond: As the thief left the bakery, he called someone and talked for less than a minute. During the call, the thief said they were planning to take the earliest flight out of Fiftyville tomorrow (July 29) and asked the person to purchase the flight ticket

--Check available information in bakery_security_logs
.schema bakery_security_logs

--Check security footage from bakery parking lot on July 28, 2021
SELECT name, hour, minute, activity, bakery_security_logs.license_plate
FROM bakery_security_logs
JOIN people
ON people.license_plate = bakery_security_logs.license_plate
WHERE month = 7 AND day = 28 AND year = 2021 AND hour = 10 AND minute < 25 AND minute > 15 ORDER BY name;
--Possiple thief's license_plate:
--+---------+------+--------+----------+---------------+
--|  name   | hour | minute | activity | license_plate |
--+---------+------+--------+----------+---------------+
--| Barry   | 10   | 18     | exit     | 6P58WS2       |
--| Bruce   | 10   | 18     | exit     | 94KL13X       |
--| Diana   | 10   | 23     | exit     | 322W7JE       |
--| Iman    | 10   | 21     | exit     | L93JTIZ       |
--| Kelsey  | 10   | 23     | exit     | 0NTHK55       |
--| Luca    | 10   | 19     | exit     | 4328GD8       |
--| Sofia   | 10   | 20     | exit     | G412CB7       |
--| Vanessa | 10   | 16     | exit     | 5P2BI95       |
--+---------+------+--------+----------+---------------+

--Check available information in atm_transactions
.schema atm_transactions

--Check ATM withdrawal on July 28, 2021 in Leggett Street
SELECT name, atm_transactions.account_number, transaction_type, amount
FROM atm_transactions
JOIN bank_accounts
ON bank_accounts.account_number = atm_transactions.account_number
JOIN people
ON people.id = bank_accounts.person_id
WHERE month = 7 AND day = 28 AND year = 2021 AND atm_location = "Leggett Street" AND transaction_type = "withdraw"
ORDER BY name;
--Possible account_number of theif:
--+---------+----------------+------------------+--------+
--|  name   | account_number | transaction_type | amount |
--+---------+----------------+------------------+--------+
--| Benista | 81061156       | withdraw         | 30     |
--| Brooke  | 16153065       | withdraw         | 80     |
--| Bruce   | 49610011       | withdraw         | 50     |
--| Diana   | 26013199       | withdraw         | 35     |
--| Iman    | 25506511       | withdraw         | 20     |
--| Kenny   | 28296815       | withdraw         | 20     |
--| Luca    | 28500762       | withdraw         | 48     |
--| Taylor  | 76054385       | withdraw         | 60     |
--+---------+----------------+------------------+--------+

--Check available information in phone_calls
.schema phone_calls

--Check 2 phone calls made on July 28, 2021: 1) a phone call made at around 10:15am that lasted for less than a minute. 2) a phone call made at around 9:45am that lasted around half an hour
SELECT caller_names.name, caller, receiver_names.name, receiver, duration
FROM phone_calls
JOIN people AS caller_names ON phone_calls.caller = caller_names.phone_number
JOIN people AS receiver_names ON phone_calls.receiver = receiver_names.phone_number
WHERE month = 7 AND day = 28 AND year = 2021 AND duration < 60 ORDER BY caller_names.name;
--Possible phone call by thief:
--+---------+----------------+------------+----------------+----------+
--|  name   |     caller     |    name    |    receiver    | duration |
--+---------+----------------+------------+----------------+----------+
--| Benista | (338) 555-6650 | Anna       | (704) 555-2131 | 54       |
--| Bruce   | (367) 555-5533 | Robin      | (375) 555-8161 | 45       |
--| Carina  | (031) 555-6622 | Jacqueline | (910) 555-3251 | 38       |
--| Diana   | (770) 555-1861 | Philip     | (725) 555-3243 | 49       |
--| Kelsey  | (499) 555-9472 | Larry      | (892) 555-8872 | 36       |
--| Kelsey  | (499) 555-9472 | Melissa    | (717) 555-1342 | 50       |
--| Kenny   | (826) 555-1652 | Doris      | (066) 555-9701 | 55       |
--| Sofia   | (130) 555-0289 | Jack       | (996) 555-8899 | 51       |
--| Taylor  | (286) 555-6063 | James      | (676) 555-6554 | 43       |
--+---------+----------------+------------+----------------+----------+

--Check availabe information from people
.schema people

--Check possible theif based on suspected list of phone number, license plate and suspect lists from ATM withdrawal evidence
SELECT name
FROM people
WHERE phone_number IN
    (SELECT caller
    FROM phone_calls
    WHERE month = 7 AND day = 28 AND year = 2021 AND duration < 60)
AND license_plate IN
    (SELECT license_plate
    FROM bakery_security_logs
    WHERE month = 7 AND day = 28 AND year = 2021 AND hour = 10 AND minute < 25 AND minute > 15)
AND name IN
    (SELECT name
    FROM people
    WHERE id IN
        (SELECT person_id
        FROM bank_accounts
        WHERE account_number IN
            (SELECT account_number
            FROM atm_transactions
            WHERE month = 7 AND day = 28 AND year = 2021 AND atm_location = "Leggett Street" AND transaction_type = "withdraw")));

--List of possible suspects:
--+-------+
--| name  |
--+-------+
--| Diana |
--| Bruce |
--+-------+

--Find available information in flights
.schema flights

--Find available information in airports
.schema airports

--Get airport ID of Fiftyville airport
SELECT id FROM airports WHERE city = "Fiftyville";
--ID = 8

--Get all flights_id leaving Fiftyville on July 29, 2021
SELECT airports_origin.city AS origin, airports_destination.city AS destination, hour, minute
FROM flights
JOIN airports AS airports_origin
ON airports_origin.id = flights.origin_airport_id
JOIN airports AS airports_destination
ON airports_destination.id = flights.destination_airport_id
WHERE origin_airport_id = (SELECT id FROM airports WHERE city = "Fiftyville")
AND month = 7 AND day = 29 AND year = 2021 ORDER BY hour;
--+------------+---------------+------+--------+
--|   origin   |  destination  | hour | minute |
--+------------+---------------+------+--------+
--| Fiftyville | New York City | 8    | 20     |
--| Fiftyville | Chicago       | 9    | 30     |
--| Fiftyville | San Francisco | 12   | 15     |
--| Fiftyville | Tokyo         | 15   | 20     |
--| Fiftyville | Boston        | 16   | 0      |
--+------------+---------------+------+--------+


--Find available information in passengers
.schema passengers

--Find list of people flying away from Fiftyville on July 29, 2021
SELECT name, airports_origin.city AS fly_from, airports_destination.city AS fly_to, hour, minute
FROM passengers
JOIN flights
ON flights.id = passengers.flight_id
JOIN airports AS airports_origin
ON airports_origin.id = flights.origin_airport_id
JOIN airports AS airports_destination
ON airports_destination.id = flights.destination_airport_id
JOIN people
ON people.passport_number = passengers.passport_number
WHERE flight_id IN
    (SELECT id
    FROM flights
    WHERE origin_airport_id = (SELECT id FROM airports WHERE city = "Fiftyville")
    AND month = 7 AND day = 29 AND year = 2021)
ORDER BY hour;
--+-----------+------------+---------------+------+--------+
--|   name    |  fly_from  |    fly_to     | hour | minute |
--+-----------+------------+---------------+------+--------+
--| Edward    | Fiftyville | New York City | 8    | 20     |
--| Sofia     | Fiftyville | New York City | 8    | 20     |
--| Taylor    | Fiftyville | New York City | 8    | 20     |
--| Bruce     | Fiftyville | New York City | 8    | 20     |
--| Doris     | Fiftyville | New York City | 8    | 20     |
--| Kelsey    | Fiftyville | New York City | 8    | 20     |
--| Luca      | Fiftyville | New York City | 8    | 20     |
--| Kenny     | Fiftyville | New York City | 8    | 20     |
--| Sophia    | Fiftyville | Chicago       | 9    | 30     |
--| Heather   | Fiftyville | Chicago       | 9    | 30     |
--| Carol     | Fiftyville | Chicago       | 9    | 30     |
--| Rebecca   | Fiftyville | Chicago       | 9    | 30     |
--| Marilyn   | Fiftyville | Chicago       | 9    | 30     |
--| Daniel    | Fiftyville | Chicago       | 9    | 30     |
--| Douglas   | Fiftyville | San Francisco | 12   | 15     |
--| Dennis    | Fiftyville | San Francisco | 12   | 15     |
--| Matthew   | Fiftyville | San Francisco | 12   | 15     |
--| Emily     | Fiftyville | San Francisco | 12   | 15     |
--| Jennifer  | Fiftyville | San Francisco | 12   | 15     |
--| Brandon   | Fiftyville | San Francisco | 12   | 15     |
--| Jordan    | Fiftyville | San Francisco | 12   | 15     |
--| Jose      | Fiftyville | San Francisco | 12   | 15     |
--| Pamela    | Fiftyville | Tokyo         | 15   | 20     |
--| Steven    | Fiftyville | Tokyo         | 15   | 20     |
--| Larry     | Fiftyville | Tokyo         | 15   | 20     |
--| Brooke    | Fiftyville | Tokyo         | 15   | 20     |
--| Thomas    | Fiftyville | Tokyo         | 15   | 20     |
--| Melissa   | Fiftyville | Tokyo         | 15   | 20     |
--| Richard   | Fiftyville | Tokyo         | 15   | 20     |
--| John      | Fiftyville | Tokyo         | 15   | 20     |
--| Christian | Fiftyville | Boston        | 16   | 0      |
--| Gloria    | Fiftyville | Boston        | 16   | 0      |
--| Ethan     | Fiftyville | Boston        | 16   | 0      |
--| Douglas   | Fiftyville | Boston        | 16   | 0      |
--| Diana     | Fiftyville | Boston        | 16   | 0      |
--| Charles   | Fiftyville | Boston        | 16   | 0      |
--| Michael   | Fiftyville | Boston        | 16   | 0      |
--| Kristina  | Fiftyville | Boston        | 16   | 0      |
--+-----------+------------+---------------+------+--------+

--Find the flight that Bruce and Diana took on July 29, 2021
SELECT name, airports_origin.city AS fly_from, airports_destination.city AS fly_to, hour, minute
FROM passengers
JOIN flights
ON flights.id = passengers.flight_id
JOIN airports AS airports_origin
ON airports_origin.id = flights.origin_airport_id
JOIN airports AS airports_destination
ON airports_destination.id = flights.destination_airport_id
JOIN people
ON people.passport_number = passengers.passport_number
WHERE flight_id IN
    (SELECT id
    FROM flights
    WHERE origin_airport_id = (SELECT id FROM airports WHERE city = "Fiftyville")
    AND month = 7 AND day = 29 AND year = 2021)
AND name IN ("Bruce", "Diana")
ORDER BY hour;

--+-------+------------+---------------+------+--------+
--| name  |  fly_from  |    fly_to     | hour | minute |
--+-------+------------+---------------+------+--------+
--| Bruce | Fiftyville | New York City | 8    | 20     |
--| Diana | Fiftyville | Boston        | 16   | 0      |
--+-------+------------+---------------+------+--------+

--It appears Bruce should be the thief as he took the earliest flight on July 29 at 8:20am to New York City

--Bruce took the flight to New York City
--Bruce accomplice is the person who received the call
--Bruce called (375) 555-8161
--Check the name of the receiver
SELECT name
FROM people
WHERE phone_number = "(375) 555-8161";
--Accomplice is Robin