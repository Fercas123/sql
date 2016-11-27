#first query
SELECT title, rental_rate FROM film WHERE rental_rate = .99;

#brainbuster 1
SELECT first_name, last_name, email FROM customer WHERE store_id = 2;

#count
SELECT count(title) FROM film WHERE rental_rate = .99;

#groupby
SELECT title, rental_rate FROM film GROUP BY rental_rate;

#films by rating
SELECT rating, count(film_id) FROM film GROUP BY rating;

#films by rating and rental rate
SELECT rating, rental_rate, count(film_id) as num
FROM film GROUP BY rating, rental_rate;

SELECT customer.customer_id, customer.first_name, customer.last_name, address.address
FROM customer, address WHERE customer.address_id = address.address_id;


SELECT count(inventory.film_id), film.rating, inventory.store_id
FROM inventory, film  WHERE film.film_id = inventory.film_id
GROUP BY rating, store_id;

#name, category and language
SELECT film.title, category.name, language.name
FROM film F, language L, film_category FC, category C
WHERE F.film_id = FC.film_id
    and FC.category_id = C.category_id
    and F.language_id = L.language_id;


#id, name, how many times has it been rented
SELECT F.film_id, F.title, count(R.rental_id)
FROM film F, inventory I, rental R
WHERE F.film_id = I.film_id and R.inventory_id = I.inventory_id
GROUP BY F.title;


#last one with revenue
SELECT F.film_id, F.title as "film title", count(r.rental_id), f.rental_rate, count(R.rental_id) * f.rental_rate as revenue
FROM film F, inventory I, rental R
WHERE F.film_id = I.film_id and R.inventory_id = I.inventory_id
group by F.title;

#the name of the person and how much money they´ve spend on us
SELECT C.first_name, SUM(P.amount) as money
FROM payment P, customer C
WHERE C.customer_id = P.customer_id
GROUP BY P.customer_id
ORDER BY money desc;

#last with id instead of name
SELECT p.customer_id, SUM(p.amount) as sum
FROM payment p
GROUP BY 1
ORDER BY sum desc;

# what store has historically brought the most revenue?
SELECT C.store_id, SUM(P.amount) as money
FROM payment P, customer C
WHERE C.customer_id = P.customer_id
GROUP BY C.store_id
ORDER BY money desc;

#the same thing but using staff table
SELECT S.store_id, SUM(P.amount) as sum
FROM payment, staff
WHERE P.staff_id = S.staff_id
GROUP BY S.store_id
ORDER BY sum desc;

# the same with inventory, payment and rental //seems like the best way of the 3
SELECT i.store_id as "Store ID", sum(p.amount) as revenue
FROM inventory i, payment p, rental r
WHERE p.rental_id = r.rental_id and r.inventory_id = i.inventory_id
GROUP BY 1
ORDER BY 2 desc;

#How many rentals we had each month?
SELECT left(R.rental_date, 7), count(r.rental_id)
FROM rental R
GROUP BY 1
ORDER BY 2 desc;

#movie and first and last time it was rented
SELECT F.title, left(max(r.rental_date),7) as "Last Rental", left(min(r.rental_date),7) as "First Rental"
FROM rental R, inventory I, film F
WHERE R.inventory_id = I.inventory_id and I.film_id = F.film_id
GROUP BY F.film_id;

#every customer last rental
SELECT C.customer_id, left(max(r.rental_date),7) as "Last Rental"
FROM rental R, inventory I, film F, customer C
WHERE R.inventory_id = I.inventory_id and I.film_id = F.film_id and C.customer_id = R.customer_id
GROUP BY C.customer_id;

#revenue by month
SELECT left(P.payment_date, 7), sum(p.amount)
FROM payment P
GROUP BY 1;


#how many distinct custumers per month
SELECT left(R.rental_date,7) as month, count(R.rental_id) as total_rentals, count(distinct R.customer_id) as unique_renters, count(R.rental_id)/count(distinct R.customer_id) as avg_rental_per_renter
FROM rental R
GROUP BY 1;

#the number of distinct films rented each month (??)
SELECT left(R.rental_date,7) as month,
count(distinct R.inventory_id) as films_rented,
count(distinct I.film_id) as unique_movies,
count(R.rental_id)/count(distinct I.film_id) as rental_per_film
FROM rental R, inventory I
WHERE I.inventory_id = R.inventory_id
GROUP BY month;

#number or rental in certain categories (comedy, sports and family)
SELECT C.name as category, count(R.rental_id) as num_rentals
FROM rental R, inventory I, film F, film_category FC, category C
WHERE R.inventory_id = I.inventory_id and I.film_id = F.film_id and F.film_id = FC.film_id and FC.category_id = C.category_id
and C.name in ("Comedy","Sports","Family")
GROUP BY 1;

#users who have rented at least 36 times
SELECT R.customer_id, count(R.rental_id) as rentals
FROM rental R
GROUP BY 1
HAVING rentals >= '36';

#how much revenue has one single store made over pg-13 and r-rate films
SELECT I.store_id, F.rating, sum(P.amount)
FROM film F, inventory I, rental R, payment P
WHERE F.film_id = I.film_id and  I.inventory_id = R.inventory_id and R.rental_id = P.rental_id and F.rating in ("PG-13", "R")
GROUP BY 1,2;

#same but with a date condition and only one store
SELECT I.store_id, F.rating, sum(P.amount)
FROM film F, inventory I, rental R, payment P
WHERE F.film_id = I.film_id and  I.inventory_id = R.inventory_id and R.rental_id = P.rental_id and F.rating in ("PG-13", "R")
and store_id  =1 and R.rental_date between '2005-06-08' and '2005-07-19'
GROUP BY 1,2;