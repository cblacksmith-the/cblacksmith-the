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
    ADD COLUMN total_stats integer;
UPDATE stats SET total_stats = hp + attack + defense + special_attack + special_defense + speed;

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
ORDER BY generation asc;

