-- **engine market segmentation analysis**

-- Question 1: Which defense vessel engines have the lowest average fuel efficiency and decarbonisation efficiency? (exclude from dash)
SELECT 
	engine_id,
    engine_builder,
    engine_designation,
    COUNT(*) AS engine_count,
    ROUND(AVG(fuel_efficiency), 2) AS avg_fuel_efficiency,
    ROUND(AVG(decarbonisation_efficiency), 2) AS avg_decarbonisation_efficiency
FROM
    defense_vessels
WHERE
    engine_builder != 'WÃƒÂ¤rtsilÃƒÂ¤'
GROUP BY engine_designation, engine_id, engine_builder
ORDER BY avg_fuel_efficiency , avg_decarbonisation_efficiency
LIMIT 5;

-- Question 2: Which freighter vessel engines have the lowest average fuel efficiency and decarbonisation efficiency? (excldue from dash)
SELECT 
	engine_id,
    engine_builder,
    engine_designation,
    COUNT(*) AS engine_count,
    ROUND(AVG(fuel_efficiency), 2) AS avg_fuel_efficiency,
    ROUND(AVG(decarbonisation_efficiency), 2) AS avg_decarbonisation_efficiency
FROM
    freighter_vessels
WHERE
    engine_builder != 'Wärtsilä'
GROUP BY engine_designation, engine_id, engine_builder
ORDER BY avg_fuel_efficiency , avg_decarbonisation_efficiency
LIMIT 5;

-- Question 3: Which defense vessel engines have average mco_per_tonnage lower than that of Wartsilas engine averageS? 
WITH avg_mco_by_eng AS (
	SELECT 
		engine_id,
		engine_designation,
        engine_builder,
		COUNT(*) AS engine_count,
		ROUND(AVG(mco_per_tonnage), 3) AS avg_mco_per_tonnage
	FROM	
		defense_vessels 
	GROUP BY 
		engine_designation,
        engine_builder,
        engine_id
)

SELECT
	* 
FROM 
	avg_mco_by_eng
WHERE 
	engine_builder != 'WÃƒÂ¤rtsilÃƒÂ¤'
    AND avg_mco_per_tonnage < (SELECT 
									AVG(mco_per_tonnage) 
								FROM 
									defense_vessels
								WHERE 
									engine_builder = 'WÃƒÂ¤rtsilÃƒÂ¤')
ORDER BY avg_mco_per_tonnage;
                                
-- Question 4: Which freighter vessel engines have average mco_per_tonnage lower than that of Wartsilas engine averageS? 
WITH avg_mco_by_eng AS (
	SELECT 
		engine_id,
		engine_designation,
        engine_builder,
		COUNT(*) AS engine_count,
		ROUND(AVG(mco_per_tonnage), 3) AS avg_mco_per_tonnage
	FROM	
		freighter_vessels 
	GROUP BY 
		engine_designation,
        engine_builder,
        engine_id
)

SELECT
	* 
FROM 
	avg_mco_by_eng
WHERE 
	engine_builder != 'WÃƒÂ¤rtsilÃƒÂ¤'
    AND avg_mco_per_tonnage < (SELECT 
									AVG(mco_per_tonnage) 
								FROM 
									freighter_vessels
								WHERE 
									engine_builder = 'WÃƒÂ¤rtsilÃƒÂ¤')
ORDER BY avg_mco_per_tonnage;

-- Question 5: what are the top 5 defense vessel engines that may have been in service for longest?
SELECT 
	engine_id,
    engine_builder,
    engine_designation,
    COUNT(*) AS engine_count,
    ROUND(AVG(year_built), 2) AS avg_build_year
FROM
    defense_vessels
WHERE 
	engine_builder != 'WÃƒÂ¤rtsilÃƒÂ¤'
GROUP BY engine_builder , engine_designation, engine_id
ORDER BY avg_build_year
LIMIT 5;

-- Question 6: what are the top 5 freighter vessel engines that may have been in service for longest?
SELECT 
	engine_id,
    engine_builder,
    engine_designation,
    COUNT(*) AS engine_count,
    ROUND(AVG(year_built), 2) AS avg_build_year
FROM
    freighter_vessels
WHERE 
	engine_builder != 'WÃƒÂ¤rtsilÃƒÂ¤'
GROUP BY engine_builder , engine_designation, engine_id
ORDER BY avg_build_year
LIMIT 5;
    
-- Question 7: Which propulsion types have the lowest average fuel efficiency for defense vessels?
SELECT 
	propulsion_type_id,
    description AS propulsion_type,
    COUNT(*) AS propulsion_type_count,
    ROUND(AVG(fuel_efficiency), 2) AS avg_fuel_efficiency
FROM
    defense_vessels
GROUP BY propulsion_type, propulsion_type_id
ORDER BY avg_fuel_efficiency;

-- Question 8: Which propulsion types have the lowest average fuel efficiency for freighter vessels?
SELECT 
	propulsion_type_id,
    description AS propulsion_type,
    COUNT(*) AS propulsion_type_count,
    ROUND(AVG(fuel_efficiency), 2) AS avg_fuel_efficiency
FROM
    freighter_vessels
GROUP BY propulsion_type, propulsion_type_id
ORDER BY avg_fuel_efficiency;
	
-- Question 9: Which propulsion types have the lowest average decarbonisation efficiency for defense vessels?
SELECT 
	propulsion_type_id,
    description AS propulsion_type,
    COUNT(*) AS propulsion_type_count,
    ROUND(AVG(decarbonisation_efficiency), 2) AS avg_decarbonisation_efficiency
FROM
    defense_vessels
GROUP BY propulsion_type, propulsion_type_id
ORDER BY avg_decarbonisation_efficiency;
    
-- Question 10: Which propulsion types have the lowest average decarbonisation efficiency for freighter vessels?
SELECT 
	propulsion_type_id,
    description AS propulsion_type,
    COUNT(*) AS propulsion_type_count,
    ROUND(AVG(decarbonisation_efficiency), 2) AS avg_decarbonisation_efficiency
FROM
    freighter_vessels
GROUP BY propulsion_type, propulsion_type_id
ORDER BY avg_decarbonisation_efficiency;

-- Question 12: Which propulsion types are most commonly found across different countries for defense vessels?
SELECT 
    description AS propulsion_type,
    country,
    COUNT(*) AS propulsion_count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY country) AS propulsion_percentage
FROM
    defense_vessels
GROUP BY propulsion_type, country
ORDER BY country, propulsion_percentage DESC;

-- Question 12: Which propulsion types are most commonly found across different countries for freight vessels?
SELECT 
    description AS propulsion_type,
    country,
    COUNT(*) AS propulsion_count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY country) AS propulsion_percentage
FROM
    freighter_vessels
GROUP BY propulsion_type, country
ORDER BY country, propulsion_percentage DESC;


-- Question 13: Which propulsion types have the lowest average fuel and decarbonisation efficiency for defense vessels?
SELECT 
    description AS propulsion_type,
    COUNT(*) AS propulsion_type_count,
    ROUND(AVG(fuel_efficiency), 2) AS avg_fuel_efficiency,
    ROUND(AVG(decarbonisation_efficiency), 2) AS avg_decarbonisation_efficiency
FROM
    defense_vessels
WHERE
    engine_builder = 'WÃƒÂ¤rtsilÃƒÂ¤'
GROUP BY propulsion_type
ORDER BY avg_fuel_efficiency , avg_decarbonisation_efficiency;

-- Question 14: Which propulsion types have the lowest average fuel and decarbonisation efficiency for freighter vessels?
SELECT 
    description AS propulsion_type,
    COUNT(*) AS propulsion_type_count,
    ROUND(AVG(fuel_efficiency), 2) AS avg_fuel_efficiency,
    ROUND(AVG(decarbonisation_efficiency), 2) AS avg_decarbonisation_efficiency
FROM
    freighter_vessels
WHERE
    engine_builder != 'WÃƒÂ¤rtsilÃƒÂ¤'
GROUP BY propulsion_type
ORDER BY avg_fuel_efficiency , avg_decarbonisation_efficiency;

-- Notes from consulting with Environmental Expert:
# emmissions - majoirty standard diesel engines (what are the emmissions of carbon / kwh through total emissions) to determine which engines to phase out first
# which ones do they retire first (least efficient) 
# carbon emissions for their fleet - what type of diesels have they got? 
# not called decarbonisation efficiency - carbon emmissions/GHGs
# ammonia as an emmission much stronger and also health risk 
# low sulphur (heavy fueal oil vessels must comply) as can cause acid rain
# particulates for diesel 
