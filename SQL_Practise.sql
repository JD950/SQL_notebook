
 -- Shows all the actors & actresses: 
 
SELECT * FROM actor;

-- Shows actors that have a first name "John":

SELECT * FROM actor WHERE first_name= 'John' ;

-- Shows actors that have a last name "Neeson":

SELECT * FROM actor WHERE last_name= 'Neeson';

-- Shows actors with Id numbers divisible by 10:

SELECT * FROM actor WHERE (actor_id % 10)=0;

-- Shows the description of the movie with ID of 100:

SELECT description FROM film WHERE film_id=100;

-- Shows movies with a rating of "R":

SELECT * FROM film WHERE rating="R";

-- Shows all the movies apart from those with a rating of R:

SELECT * FROM film WHERE rating!="R";

-- Shows the shortest movies:

SELECT * FROM film_list ORDER BY length LIMIT 10;

-- Shows only the film titles:

SELECT title FROM film_list;

-- Shows movies with deleted scenes: 

SELECT * FROM film WHERE special_features="Deleted Scenes";

-- Shows all the last names that are NOT repeated / duplicated: 

SELECT last_name FROM actor GROUP BY last_name HAVING COUNT(actor_id)=1;

-- Shows all the last names that ARE repeated / duplicated: 

SELECT last_name FROM actor GROUP BY last_name HAVING COUNT(last_name) >1;

-- Shows which actor (ID) has appeated in the most films: 

SELECT COUNT(f.actor_id) FROM actor a JOIN film_actor f ON a.actor_id=f.actor_id GROUP BY a.actor_id ORDER BY COUNT(f.actor_id) 
DESC LIMIT 1;

-- Shows if "Academy Dinosaur" can be rented from store 1: 

SELECT * FROM inventory i JOIN film f ON i.film_id=f.film_id WHERE i.store_id=1 AND f.title="Academy Dinosaur";

-- Shows when "Academy Dinosaur" is due:

SELECT return_date FROM rental r JOIN inventory i ON i.inventory_id=r.inventory_id WHERE i.film_id=1 
AND r.return_date IS NOT NULL ORDER BY return_date LIMIT 1;

-- Shows the average running time of all the films in the database: 

SELECT AVG(length) FROM film;
SELECT AVG(length) FROM film f JOIN film_category fc ON f.film_id=fc.film_id GROUP BY fc.category_id;

-- Shows all the movies that have Robots in them:

SELECT title FROM film WHERE description LIKE "%Robot%";

-- Shows the longest movies:

SELECT length, title FROM film WHERE length=(SELECT MAX(length) FROM film);

-- Shows how many movies were released in 2010:

SELECT COUNT(film_id) FROM film WHERE release_year=2010;

-- Shows horror titles - movies 

SELECT title FROM film_list WHERE category="Horror";

-- Shows the full name of the staff member with ID = 1:

SELECT CONCAT(first_name, " ", last_name) AS full_name FROM staff WHERE staff_id=1;

-- Shows movies that Fred Costner has has appeared in:

SELECT fa.actor_id, f.title FROM film_actor fa JOIN film f ON fa.film_id=f.film_id 
WHERE actor_id=(SELECT actor_id FROM actor WHERE first_name="Fred" AND last_name="Costner");

-- Shows which location has the most copies of BUCKET BROTHERHOOD:

SELECT COUNT(film_id), store_id FROM inventory WHERE film_id=(SELECT film_id FROM film WHERE title="Bucket Brotherhood") GROUP BY store_id;

-- Shows how many unique countries there are (actor nationalities):

SELECT DISTINCT COUNT(country) FROM country;


-- Shows the full names of actors with "son" in their last name -- ordered by their first name:
 
SELECT first_name, last_name FROM actor WHERE last_name LIKE "%son%" ORDER BY last_name;

-- Shows a list of categories and the number of films for each category:

SELECT c.name, COUNT(f.FID) FROM film_list f JOIN category c ON f.category=c.name GROUP BY c.name;

-- Shows a list of actors and the number of movies by each actor:

SELECT a.first_name, a.last_name, COUNT(f.film_id) FROM film_actor f JOIN actor a ON a.actor_id=f.actor_id GROUP BY f.actor_id;

-- Shows actor/actress has appeared in the most movies:

SELECT a.first_name, a.last_name, COUNT(f.film_id) FROM film_actor f JOIN actor a ON a.actor_id=f.actor_id GROUP BY f.actor_id ORDER BY COUNT(f.film_id) DESC LIMIT 1;
