## Задание. Международные перелеты

1) Создать БД `flight_repo` с таблицами:
   - **airport (аэропорт)**
      - code
      - country
      - city
   - **aircraft (самолет)**
     - id
     - model
   - **seat (место в самолете)**
     - aircraft_id
     - seat_no
   - **flight (рейс)**
     - id
     - flight_no
     - departure_date
     - departure_airport_code
     - arrival_date
     - arrival_airport_code
     - aircraft_id
     - status (cancelled, arrived, departed, boarding, scheduled)
   - **ticket (билет)**
     - id
     - passport_no
     - passenger_name
     - flight_id
     - seat_no (flight_id + seat_no - unique)
     - cost

2) Вставить информацию во все таблицы
   - https://github.com/AndreiBor/flights.git

3) Написать запросы:
   -  Кто летел рейсом Минск (MNK) - Лондон (LDN) 2020-07-28 на месте B1
   -  Какие 2 перелета были самые длительные за все время
   -  Какая максимальная и минимальная продолжительность перелетов между Минском и Лондоном и сколько было всего таких перелетов
   -  Сколько мест осталось незанятыми 2020-06-14 на рейсе MN3002
   -  Какие имена встречаются чаще всего и какую долю от числа всех пассажиров они составляют
   -  Вывести имена пассажиров и сколько билетов пассажир купил за все время(*)
   - Вывести стоимость всех маршрутов по убыванию(*)
   - Отобразить разницу в стоимости между текущим и ближайшими маршрутами в отсортированном списке
4) Прислать диаграмму базы и скрины с выполнением запросов

### Решение задачи
- [Демонстрация решения](https://github.com/r0ck17/sql-flights/blob/main/solution.md)
- [Запросы для создания БД](https://github.com/r0ck17/sql-flights/blob/main/create-database.sql)
- [Запросы по задачам](https://github.com/r0ck17/sql-flights/blob/main/queries.sql)