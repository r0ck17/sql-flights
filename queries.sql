-- 1. Кто летел рейсом Минск (MNK) - Лондон (LDN) 2020-07-28 на месте B1
SELECT t.passport_no,
       t.passenger_name,
       f.flight_no,
       t.seat_no,
       f.departure_date,
       f.departure_airport_code,
       f.arrival_airport_code
FROM ticket t
         JOIN flight f ON f.id = t.flight_id
WHERE f.departure_airport_code = 'MNK'
  AND f.arrival_airport_code = 'LDN'
  AND f.departure_date BETWEEN '2020-07-28' AND '2020-07-29'
  AND t.seat_no = 'B1';

-- 2. Какие 2 перелета были самые длительные за все время
SELECT id,
       flight_no,
       departure_date,
       departure_airport_code,
       arrival_airport_code,
       extract(MINUTE FROM arrival_date - flight.departure_date) AS flight_time_minutes
FROM flight
ORDER BY flight_time_minutes DESC
LIMIT 2;

-- 3. Какая максимальная и минимальная продолжительность перелетов между Минском и Лондоном и сколько было всего таких перелетов
SELECT min(extract(MINUTE FROM arrival_date - flight.departure_date)) AS min_minutes,
       max(extract(MINUTE FROM arrival_date - flight.departure_date)) AS max_minutes,
       count(*)
FROM flight
WHERE departure_airport_code = 'MNK'
  AND arrival_airport_code = 'LDN'
GROUP BY departure_airport_code, arrival_airport_code;

-- 4. Сколько мест осталось незанятыми 2020-06-14 на рейсе MN3002
-- 4.1 Все занятые места на рейсе MN3002 2020-06-14
SELECT seat_no
FROM flight f
         JOIN ticket t ON f.id = t.flight_id
WHERE f.flight_no = 'MN3002'
  AND f.departure_date::date = '2020-06-14';

-- 4.2 Все потенциально возможные места которые могут быть на рейсе MN3002 2020-06-14
SELECT seat_no
FROM seat s
         JOIN aircraft a ON a.id = s.aircraft_id
         JOIN flight f ON a.id = f.aircraft_id
WHERE f.flight_no = 'MN3002'
  AND f.departure_date::date = '2020-06-14';

-- 4.3 Итоговый запрос, используя 4.2 и 4.1
SELECT count(seat_no)
FROM seat s
         JOIN aircraft a ON a.id = s.aircraft_id
         JOIN flight f ON a.id = f.aircraft_id
WHERE f.flight_no = 'MN3002'
  AND f.departure_date::date = '2020-06-14'
  AND seat_no NOT IN (SELECT seat_no
                      FROM flight f
                               JOIN ticket t ON f.id = t.flight_id
                      WHERE f.flight_no = 'MN3002'
                        AND f.departure_date::date = '2020-06-14');

-- 5. Какие имена встречаются чаще всего и какую долю от числа всех пассажиров они составляют
-- 5.1 Вариант решения 1
SELECT SPLIT_PART(passenger_name, ' ', 1)            AS name,
       round((count(*)::numeric / (SELECT COUNT(DISTINCT SPLIT_PART(passenger_name, ' ', 1))
                                   FROM ticket)), 2) AS part
FROM ticket t
GROUP BY name
ORDER BY name;

-- 5.2 Вариант решения 2
SELECT SPLIT_PART(passenger_name, ' ', 1) AS name, round(count(*)::numeric / t2.total_count, 2) AS part
FROM ticket t1
         CROSS JOIN (SELECT count(DISTINCT SPLIT_PART(passenger_name, ' ', 1)) AS total_count FROM ticket) t2
GROUP BY name, total_count
ORDER BY name;

-- 6. Вывести имена пассажиров и сколько билетов пассажир купил за все время(*)
SELECT passport_no, passenger_name, count(*) AS total_ticket_count
FROM ticket
GROUP BY passport_no, passenger_name
ORDER BY total_ticket_count DESC;

-- 7. Вывести стоимость всех маршрутов по убыванию(*)
-- Будем считать, что:
-- Маршрут - полёт самолета в одну сторону, то есть из города А в город Б, при этом полет из Б в А - это уже другой маршрут.
-- Стоимость маршрута - это стоимость всех купленных билетов каждого рейса по данному маршруту.
-- Например, если было два рейса Минск - Лондон, в первом рейсе было куплено 2 билета ценой по 100 усл. ед., а во втором маршруте
-- три билета, ценой по 150 усл. ед., то стоимость маршрута = 2 * 100 + 3 * 150 = 650 усл. ед.

SELECT departure_airport_code, arrival_airport_code, sum(cost) as total_price
FROM ticket t
         JOIN flight f ON t.flight_id = f.id
GROUP BY departure_airport_code, arrival_airport_code
ORDER BY total_price DESC;

-- 8. Отобразить разницу в стоимости между текущим и ближайшими маршрутами в отсортированном списке
-- 8.1 Находим стоимость определенного маршрута (Пусть это будет LDN - MNK)
SELECT departure_airport_code, arrival_airport_code, sum(cost) as total_price
FROM ticket t
         JOIN flight f ON t.flight_id = f.id
WHERE departure_airport_code = 'LDN'
  AND arrival_airport_code = 'MNK'
GROUP BY departure_airport_code, arrival_airport_code;

-- 8.2 Итоговый запрос
SELECT departure_airport_code,
       arrival_airport_code,
       (sum(cost) - (SELECT sum(cost) as total_price
                     FROM ticket t
                              JOIN flight f ON t.flight_id = f.id
                     WHERE departure_airport_code = 'LDN'
                       AND arrival_airport_code = 'MNK'
                     GROUP BY departure_airport_code, arrival_airport_code
                     ORDER BY total_price DESC)) as diff_price
FROM ticket t
         JOIN flight f
              ON t.flight_id = f.id
GROUP BY departure_airport_code, arrival_airport_code
ORDER BY diff_price DESC;