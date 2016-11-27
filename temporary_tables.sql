#first, drop the table if exist and then create the table
drop temporary table if exists rentals_per_customer;
create temporary table rentals_per_customer
#rental per User
SELECT R.customer_id, count(R.rental_id) as num_rentals, sum(P.amount) as customer_revenue
FROM rental R, payment P
WHERE R.rental_id = P.rental_id
GROUP BY 1;
#Revenue by Users Who rented X number of videos
SELECT RPC.num_rentals, sum(RPC.customer_revenue) as total_revenue, count(RPC.customer_id) as num_customers
FROM rentals_per_customer RPC
GROUP BY 1;

#revenue by actor name, amount of revenue they produced (my solution)
drop temporary table if exists rentals_per_actor;
create temporary table rentals_per_actor
SELECT A.actor_id, A.first_name as actor_name, Sum(P.amount) as revenue_per_actor
FROM actor A, film_actor FA, inventory I, rental R, Payment P
WHERE A.actor_id = FA.actor_id and FA.film_id = I.film_id and I.inventory_id = R.inventory_id and R.rental_id = P.rental_id
GROUP BY 1;


#revenue per film
drop temporary table if exists rev_per_film;
create temporary table rev_per_film
SELECT F.film_id as film_id, f.rental_rate*count(r.rental_id) as film_revenue
FROM rental R, inventory I, film F
WHERE R.inventory_id = I.inventory_id and I.film_id = F.film_id
GROUP BY 1;

#connecting actor to film revenue
SELECT A.actor_id, concat(A.first_name," ", A.last_name), sum(RPF.film_revenue)
FROM rev_per_film RPF, actor A, film_actor FA
WHERE A.actor_id = FA.actor_id and FA.film_id = RPF.film_id
GROUP BY 1;