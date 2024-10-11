-- Create Database if it does not exist
CREATE DATABASE IF NOT EXISTS port_prospects;

-- Change column name to avoid issues with special characters
ALTER TABLE vessel_data 
CHANGE `mco/tonnage` mco_per_tonnage FLOAT;

-- Drop redundant columns
ALTER TABLE vessel_data
    DROP COLUMN engine_designer,
    DROP COLUMN engine_manufacturer;

-- Check the first 10 rows of the flat file
SELECT * FROM vessel_data
LIMIT 10;

-- ** Market Segmentation **

-- ** Port Analysis **

-- Top 5 home ports of defense vessels to help identify potential hotspots
SELECT 
    home_port, 
    COUNT(*) AS count 
FROM 
    vessel_data
WHERE 
    type IN ('Military', 'Warship', 'SAR')
GROUP BY 
    home_port
ORDER BY 
    count DESC
LIMIT 5;

-- Top 5 home ports ranked by count for defense vessels
WITH ranked_ports AS (
    SELECT 
        type, 
        home_port, 
        COUNT(*) AS count,
        ROW_NUMBER() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranks
    FROM 
        vessel_data
    WHERE 
        type IN ('Military', 'Warship', 'SAR')
    GROUP BY 
        type, 
        home_port
)
SELECT  
    * 
FROM 
    ranked_ports
WHERE 
    ranks <= 5
ORDER BY 
    ranks;

-- Top 5 destination ports of defense vessels
SELECT 
    destination, 
    COUNT(*) AS count 
FROM 
    vessel_data
WHERE 
    type IN ('Military', 'Warship', 'SAR')
GROUP BY 
    destination
ORDER BY 
    count DESC
LIMIT 5;

-- Top 5 destination ports ranked by count for defense vessels
WITH ranked_dest_ports AS (
    SELECT 
        type, 
        destination, 
        COUNT(*) AS count,
        ROW_NUMBER() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranks
    FROM 
        vessel_data
    WHERE 
        type IN ('Military', 'Warship', 'SAR')
    GROUP BY 
        type, 
        destination
)
SELECT  
    * 
FROM 
    ranked_dest_ports
WHERE 
    ranks <= 5
ORDER BY 
    ranks;

-- Top 5 home ports of tanker and cargo vessels
SELECT 
    home_port, 
    COUNT(*) AS count
FROM 
    vessel_data
WHERE 
    type IN ('Cargo', 'Tanker')
GROUP BY 
    home_port
ORDER BY 
    count DESC
LIMIT 5;

-- Top 5 home ports ranked by count for cargo and tanker vessels
WITH ranked_freighter_ports AS (
    SELECT 
        type, 
        home_port, 
        COUNT(*) AS count,
        ROW_NUMBER() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranks
    FROM 
        vessel_data
    WHERE 
        type IN ('Cargo', 'Tanker')
    GROUP BY 
        type, 
        home_port
)
SELECT  
    * 
FROM 
    ranked_freighter_ports
WHERE 
    ranks <= 5
ORDER BY 
    ranks;

-- Top 5 destination ports of tanker and cargo vessels
SELECT 
    destination, 
    COUNT(*) AS count 
FROM 
    vessel_data
WHERE 
    type IN ('Cargo', 'Tanker')
GROUP BY 
    destination
ORDER BY 
    count DESC
LIMIT 5;

-- Top 5 destination ports ranked by count for cargo and tanker vessels
WITH ranked_freighter_dest_ports AS (
    SELECT 
        type, 
        destination, 
        COUNT(*) AS count,
        ROW_NUMBER() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranks
    FROM 
        vessel_data
    WHERE 
        type IN ('Cargo', 'Tanker')
    GROUP BY 
        type, 
        destination
)
SELECT  
    * 
FROM 
    ranked_freighter_dest_ports
WHERE 
    ranks <= 5
ORDER BY 
    ranks;

-- ** Engine Data Analysis **

-- Military vessel counts using stealth-associated propulsion systems with mco/tonnage below average
SELECT 
    propulsion_type_code,  
    engine_designation, 
    engine_builder,
    COUNT(*) AS count
FROM 
    vessel_data
WHERE 
    type = 'Military'
    AND propulsion_type_code IN ('MO', 'HR')
GROUP BY 
    propulsion_type_code, 
    engine_designation,
    engine_builder
HAVING 
    AVG(mco_per_tonnage) < (SELECT AVG(mco_per_tonnage) 
                             FROM vessel_data 
                             WHERE type = 'Military' 
                             AND propulsion_type_code IN ('MO', 'HR'))
ORDER BY 
    count DESC
LIMIT 5;

-- Tanker and cargo ships' engine-designation and engine builder with lower than average mco
WITH mco_by_prop_type AS (
    SELECT 
        propulsion_type_code,
        engine_designation,
        engine_builder,
        mco,
        AVG(mco) OVER(PARTITION BY propulsion_type_code) AS avg_mco
    FROM 
        vessel_data
    WHERE 
        type IN ('cargo', 'tanker')
        AND propulsion_type_code IN ('GT', 'ME') 
        AND engine_builder != 'Wärtsilä'  -- Ensure proper encoding
) 
SELECT 
    * 
FROM 
    mco_by_prop_type
WHERE 
    mco < avg_mco
ORDER BY 
    propulsion_type_code, mco;

-- Opportunities for cargo and tanker vessels older than the average age
WITH mco_by_old_vessels AS (
    SELECT 
        type,
        type_specific, 
        propulsion_type_code,
        engine_designation,
        engine_builder,
        mco,
        AVG(mco) OVER(PARTITION BY propulsion_type_code) AS avg_mco
    FROM 
        vessel_data
    WHERE 
        type IN ('cargo', 'tanker')
        AND propulsion_type_code IN ('GT', 'ME') 
        AND engine_builder != 'Wärtsilä'
        AND year_built < (SELECT AVG(year_built) FROM vessel_data)
) 
SELECT 
    * 
FROM 
    mco_by_old_vessels
WHERE 
    mco < avg_mco
ORDER BY 
    propulsion_type_code, mco;

-- ** Geographical Analysis **

-- Count of defense vessel types that have less than average mco
WITH defense_vessel_counts AS (
    SELECT 
        type, 
        COUNT(*) AS count
    FROM 
        vessel_data
    WHERE 
        type IN ('Military', 'Warship', 'SAR')
    GROUP BY 
        type
)
SELECT 
    * 
FROM 
    defense_vessel_counts
WHERE 
    count < (SELECT AVG(count) FROM defense_vessel_counts);

-- Bottom 5 engine_designations for mco_per_tonnage based on propulsion type for cargo and tanker vessels
WITH mco_tonnage_rank AS (
    SELECT 
        type,
        propulsion_type_code,
        engine_designation, 
        engine_builder,
        mco_per_tonnage,
        DENSE_RANK() OVER(PARTITION BY type, propulsion_type_code ORDER BY mco_per_tonnage) AS mco_tonnage_ranks
    FROM 
        vessel_data
    WHERE 
        type IN ('Cargo', 'Tanker')
)
SELECT 
    type,
    propulsion_type_code,
    engine_designation, 
    engine_builder,
    mco_per_tonnage,
    mco_tonnage_ranks
FROM 
    mco_tonnage_rank
WHERE 
    mco_tonnage_ranks <= 5
ORDER BY 
    type, 
    propulsion_type_code, 
    mco_per_tonnage;

-- Bottom 5 engine_designations for mco_per_tonnage based on propulsion type for defense vessels
WITH mco_tonnage_rank_defense AS (
    SELECT 
        type,
        propulsion_type_code,
        engine_designation, 
        engine_builder,
        mco_per_tonnage,
        DENSE_RANK() OVER(PARTITION BY type, propulsion_type_code ORDER BY mco_per_tonnage) AS mco_tonnage_ranks
    FROM 
        vessel_data
    WHERE 
        type IN ('Military', 'Warship', 'SAR')
)
SELECT 
    type,
    propulsion_type_code,
    engine_designation, 
    engine_builder,
    mco_per_tonnage,
    mco_tonnage_ranks
FROM 
    mco_tonnage_rank_defense
WHERE 
    mco_tonnage_ranks <= 5
ORDER BY 
    type, 
    propulsion_type_code, 
    mco_per_tonnage;

-- ** Vessel Age Analysis **

-- The 5 countries with the oldest average build year
SELECT 
    country_iso, 
    AVG(year_built) AS avg_build_year
FROM 
    vessel_data
GROUP BY 
    country_iso
ORDER BY 
    avg_build_year
LIMIT 5;

-- The 5 countries with the highest average vessel gross tonnage
SELECT 
    country_iso, 
    AVG(gross_tonnage) AS avg_gross_tonnage
FROM 
    vessel_data
GROUP BY 
    country_iso
ORDER BY 
    avg_gross_tonnage DESC
LIMIT 5;