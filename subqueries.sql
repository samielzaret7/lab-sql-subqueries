-- Write SQL queries to perform the following tasks using the Sakila database:

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

select *
from (select title,f.film_id,count(*)
  from film as f
  join inventory as i
  on f.film_id=i.film_id group by f.film_id) as `title_count`
where `title_count`.title = 'Hunchback Impossible';

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.

SELECT film_id, title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);

--  3. Use a subquery to display all actors who appear in the film "Alone Trip".

SELECT actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id
IN (SELECT film_actor.actor_id
    FROM film_actor
    JOIN film ON film_actor.film_id = film.film_id
    WHERE film.title = 'Alone Trip');
    
    
-- Bonus:

-- Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.

SELECT film.title
FROM film
WHERE film.film_id
IN (SELECT film_category.film_id
	FROM film_category
	JOIN category 
	ON film_category.category_id = category.category_id
    WHERE category.name="Family");
    
    
-- Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.

SELECT customer.first_name, customer.email
FROM customer
WHERE customer.address_id 
IN (
    SELECT address.address_id
    FROM customer
    JOIN address ON customer.address_id = address.address_id
    WHERE address.city_id IN (
        SELECT city.city_id
        FROM country
        JOIN city ON city.country_id = country.country_id
        WHERE country.country = 'Canada'));

-- Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. 
-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.

-- prolific actor
select * from film_actor;

select actor.actor_id, actor.first_name, actor.last_name
from actor
where actor.actor_id
in (select count(film_actor.film_id) as prolific
from film_actor
group by actor_id);

-- 
SELECT actor.actor_id, actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id = (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 1
);

SELECT
    actor_id,
    first_name,
    last_name,
    COUNT(fa.film_id) AS film_count
FROM
    actor
JOIN film_actor fa ON actor.actor_id = fa.actor_id
GROUP BY
    actor_id
ORDER BY
    film_count DESC
LIMIT 1;

-- Find the most prolific actor
SELECT
    actor_id,
    first_name,
    last_name,
    COUNT(fa.film_id) AS film_count
FROM
    actor
JOIN film_actor fa ON actor.actor_id = fa.actor_id
GROUP BY
    actor_id
ORDER BY
    film_count DESC
LIMIT 1;

-- Use the most prolific actor_id to find the films
SELECT
    film.film_id,
    film.title
FROM
    film
JOIN film_actor ON film.film_id = film_actor.film_id
WHERE
    film_actor.actor_id = (
        SELECT
            actor_id
        FROM
            actor
        JOIN film_actor fa ON actor.actor_id = fa.actor_id
        GROUP BY
            actor_id
        ORDER BY
            COUNT(fa.film_id) DESC
        LIMIT 1
    );
