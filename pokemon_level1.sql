
-- List every Pokémon's name, typing (1), and their health.
SELECT name, type_1, hp
    FROM stats
limit 10;

-- Show all Pokemon who are a Dragon type
SELECT name, type_1
       FROM stats
WHERE type_1 = 'dragon'
limit 10;

-- Find all the Legendary Pokemon
SELECT id, name, type_1
    FROM stats
WHERE is_legendary = 'True';

-- Find which Pokemon have a speed of 130 or higher,
-- listed by fastest first
SELECT id, name, speed
    FROM stats
WHERE speed >= 130
ORDER BY speed desc;

-- List the 10 Heaviest Pokemon in Kilograms
SELECT id, name, (weight_hg/10) as weight_kg
FROM stats
ORDER BY 2 desc;

-- Find the Count of Pokemon with only one type
SELECT count(*)
FROM stats
WHERE type_2 ISNULL;

-- Show all the pink Pokemon from Gen 1
SELECT id, name, type_1, type_2
FROM stats
WHERE
    generation = 'generation-i'
    AND color = 'pink';

-- Show all the pink Pokemon from Gen 1, but excluding alternate forms (Mega Evolutions, Regional Forms, etc.)
-- Sort results first by type_1, then by type_2 (if available)

SELECT id, name, type_1, type_2
FROM stats
WHERE
    generation = 'generation-i'
    AND color = 'pink'
    AND id <= 151
GROUP BY type_1, type_2, id, name
ORDER BY type_1 desc;

-- Find every Pokemon whose name ends with 'saur'
SELECT id, name
FROM stats
WHERE name LIKE '%saur';

-- List all the alternate-form Pokemon
SELECT id, name, type_1, type_2
FROM stats
WHERE id >= 10000;

-- ^ Or another option if you didn't know alternate forms were greater than 10,000, and just wanted Mega forms:
SELECT id, name, type_1, type_2
FROM stats
WHERE name LIKE '%-mega%';