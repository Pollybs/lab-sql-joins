## Challenge - Joining on multiple tables

/*Write SQL queries to perform the following tasks using the Sakila database:*/
use sakila;
--  List the number of films per category.
SELECT category.category_id, category.name, COUNT(film_category.film_id) AS film_count
FROM category
LEFT JOIN film_category ON category.category_id = film_category.category_id
GROUP BY category.category_id, category.name;

-- 2. Retrieve the store ID, city, and country for each store.

select store.store_id, city.city, country
from store
join address
on store.address_id = address.address_id
join city
on address.city_id = city.city_id
join country
on city.country_id = country.country_id ;

-- 3.  Calculate the total revenue generated by each store in dollars.

select store_id, sum(payment.amount) as total_amount_dollars
from payment
join staff
on staff.staff_id = payment.staff_id
group by staff.store_id;

-- 4.  Determine the average running time of films for each category.

SELECT category.name, COUNT(film_category.film_id) AS film_count, avg(length) as lenght
FROM category
LEFT JOIN film_category ON category.category_id = film_category.category_id
join film
on film_category.film_id = film.film_id
GROUP BY category.name;

-- Bonus:
-- Identify the film categories with the longest average running time.
select category.name, avg(length) 
from category
join film_category
on category.category_id = film_category.category_id
join film
on film_category.film_id = film.film_id
group by category.name;

-- Display the top 10 most frequently rented movies in descending order.
select title, count(rental_id)
from film
join inventory
on film.film_id = inventory.film_id
join rental
on inventory.inventory_id = rental.inventory_id
group by title
order by count(rental_id) desc
limit 10;

-- Determine if "Academy Dinosaur" can be rented from Store 1.

SELECT count(inventory_id) as "Academy Dinosaur available in Store 1"
FROM inventory
WHERE
store_id = 1
AND film_id = ( SELECT film_id FROM film WHERE title = "Academy Dinosaur");

-- Provide a list of all distinct film titles, along with their availability status in the inventory. Include a column indicating whether each title is 'Available' or 'NOT available.' Note that there are 42 titles that are not in the inventory, and this information can be obtained using a CASE statement combined with IFNULL."

select distinct film_id
from inventory;

select distinct title, inventory.film_id,
case 
	when inventory.film_id is NULL THEN "Not in the inventory"
	else "In the inventory"
	end as inventory_status
from film
left join inventory
on film.film_id = inventory.film_id
order by 3 desc;
