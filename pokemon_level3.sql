-- Level 3: Group BY and Having

-- How many Pokemon are there for each type_1?
SELECT count(*), type_1
FROM stats
GROUP BY type_1;

-- Add-on Question: How many Pokemon are there for each type (type_1 and type_2)?
SELECT count(*), type_1, type_2
FROM stats
GROUP BY type_1, type_2
ORDER BY type_1, type_2;

-- What's the average attack for each generation?
SELECT round(avg(attack), 2) AS avg_attack, generation
FROM stats
GROUP BY generation
ORDER BY generation;
/* This ORDER BY exposes a problem that hadn't shown up before: The 'generation' column is a TEXT datatype, so when it
   is sorted via an ORDER BY, it is sorted alphabetically, rather than numerically (which is ideal to sort the
   generations 1-9). I'll approach that next...
 */

-- First, testing a CASE statement for the conversion
SELECT DISTINCT generation,  CASE lower(trim(split_part(trim(generation), '-', 2)))
        WHEN 'i' THEN 1
        WHEN 'ii' Then 2
        WHEN 'iii' THEN 3
        WHEN 'iv' THEN 4
        WHEN 'v' THEN 5
        WHEN 'vi' THEN 6
        WHEN 'vii' THEN 7
        WHEN 'viii' THEN 8
        WHEN 'ix' THEN 9
    END AS gen_int
FROM stats
ORDER BY gen_int;

-- Adding an alternate 'generation' column that is integer datatype.

ALTER TABLE stats ADD COLUMN gen_int integer;
UPDATE stats set gen_int =
    CASE lower(trim(split_part(trim(generation), '-', 2)))
        WHEN 'i' THEN 1
        WHEN 'ii' Then 2
        WHEN 'iii' THEN 3
        WHEN 'iv' THEN 4
        WHEN 'v' THEN 5
        WHEN 'vi' THEN 6
        WHEN 'vii' THEN 7
        WHEN 'viii' THEN 8
        WHEN 'ix' THEN 9
    END;

SELECT round(avg(attack), 2) AS avg_attack, gen_int -- back to the original question: What's the avg attack for each generation?
FROM stats
GROUP BY gen_int
ORDER BY gen_int;

-- Which color is the most common?

SELECT count(*) AS num_of_pokemon, color
FROM stats
GROUP BY color
ORDER BY 1 desc;

-- Which shapes have more than 100 Pokemon?

SELECT count(*) AS num_of_pokemon, shape
FROM stats
GROUP BY shape
HAVING count(*) > 100
ORDER BY 1 desc;

-- For each generation, how many legendary Pokemon and how many mythical Pokemon are there?

SELECT
    gen_int,
    SUM(CASE WHEN is_legendary = 'True' THEN 1 ELSE 0 END) AS legendary,
    SUM(CASE WHEN is_mythical = 'True' THEN 1 ELSE 0 END) AS mythical
FROM stats
GROUP BY gen_int
ORDER BY gen_int;
