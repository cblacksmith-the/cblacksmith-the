-- Level 2: Calculated Columns and Aggregates

-- Show each Pokemon's name, with its height in meters and its weight in kilograms
SELECT name, ROUND((height_dm::numeric/10), 2) as height_meters, ROUND((weight_hg::numeric/10), 2)  as weight_kilograms
FROM stats
LIMIT 50;

/* ^^^ Needed to cast 'height_dm' and 'weight_hg' as numeric to avoid PostgreSQL from dividing an integer by an integer
   which would result in ROUND not cooperating.
 */

-- Add a 'total_stats' column that sums all six base stats (hp, attack, defense, special_attack, special_defense, speed)
ALTER TABLE stats
    ADD COLUMN total_stats integer
GENERATED ALWAYS AS (hp + attack + defense + special_attack + special_defense + speed) STORED;
/* ^^^ A generation makes sure that the new column does not remain static, in the case any of the individual attributes
happen to change */

-- Find which 10 Pokemon have the highest totals.
SELECT id, name, total_stats, generation
FROM stats
ORDER BY total_stats desc
LIMIT 10;

-- Find how many Pokemon are mythical
SELECT count(is_mythical) AS total_mythical_pokemon
FROM stats;

-- ^^^ Now how many are mythical from each generation?

SELECT generation, count(*) AS num_mythical
FROM stats
WHERE is_mythical = 'True' -- Important to note: datatype is text, and 'True' only works, not 'true'. Would make sense
GROUP BY generation         -- to transform into a boolean type, along with is_legendary
ORDER BY generation;

-- What are the average, minimum, and maximum hp?
SELECT ROUND(avg(hp)) AS average_hp, min(hp) AS minimum_hp, max(hp) AS maximum_hp
FROM stats;

-- Which Pokemon is the hardest to catch?
-- Switching the data type of capture_rate from text to numeric
ALTER TABLE stats
    ALTER Column capture_rate
    TYPE numeric
    USING capture_rate::numeric;

WITH capture_rankings AS ( -- Window function to include all Pokemon with the lowest capture rate.
    SELECT name, capture_rate,
           dense_rank() OVER (ORDER BY capture_rate) as ranking
    FROM stats
    )
SELECT name, capture_rate
FROM capture_rankings
WHERE ranking = 1;

-- How many Pokemon are missing a base_experience value?
SELECT count(*) AS missing_base_exp
FROM stats
WHERE base_experience ISNULL;

