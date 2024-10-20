-- ** port market segmentation analysis **

-- Question 1: Which home ports are being visited by defense vessels with the lowest fuel efficiency and decarbonisation efficiency?
SELECT 
    home_port_id,
    home_port,
    COUNT(*) AS vessel_count,
    propulsion_type_id, 
    description AS propulsion_type,
    ROUND(AVG(fuel_efficiency), 2) AS avg_fuel_efficiency,
    ROUND(AVG(decarbonisation_efficiency), 2) AS avg_decarbonisation_efficiency
FROM
    defense_vessels
WHERE
    engine_builder != 'Wärtsilä'
GROUP BY home_port_id , home_port , description, propulsion_type_id
ORDER BY avg_fuel_efficiency , avg_decarbonisation_efficiency
LIMIT 5;

-- Question 2: Which home ports are being visited by freighter vessels with the lowest fuel efficiency and decarbonisation efficiency?
SELECT 
    home_port_id,
    home_port,
    COUNT(*) AS vessel_count,
    propulsion_type_id, 
    description AS propulsion_type,
    ROUND(AVG(fuel_efficiency), 2) AS avg_fuel_efficiency,
    ROUND(AVG(decarbonisation_efficiency), 2) AS avg_decarbonisation_efficiency
FROM
    freighter_vessels
WHERE
    engine_builder != 'Wärtsilä'
GROUP BY home_port_id , home_port , description, propulsion_type_id
ORDER BY avg_fuel_efficiency , avg_decarbonisation_efficiency
LIMIT 5;

-- Question 3: Which home ports have the oldest average build years for defense vessels by propulsion type?
SELECT 
    home_port_id,
    home_port,
    COUNT(*) AS vessel_count,
    propulsion_type_id, 
    description AS propulsion_type,
    ROUND(AVG(year_built), 2) AS avg_build_year
FROM
    defense_vessels
WHERE
    engine_builder != 'Wärtsilä'
GROUP BY home_port_id, home_port, description, propulsion_type_id
ORDER BY avg_build_year ASC
LIMIT 5;

-- Question 4: Which home ports have the oldest average build years for freighter vessels by propulsion type?
SELECT 
    home_port_id,
    home_port,
    COUNT(*) AS vessel_count,
    description AS propulsion_type,
    propulsion_type_id, 
    ROUND(AVG(year_built), 2) AS avg_build_year
FROM
    freighter_vessels
WHERE
    engine_builder != 'Wärtsilä'
GROUP BY home_port_id , home_port , description, propulsion_type_id
ORDER BY avg_build_year ASC
LIMIT 5;

-- Question 5: Which home ports have the lowest average fuel efficiency for defense vessels for each propulsion type?
WITH avg_fuel_eff_by_prop AS (
    SELECT 
        home_port_id, 
        home_port, 
        propulsion_type_id, 
        description AS propulsion_type,
        ROUND(AVG(fuel_efficiency), 2) AS avg_fuel_efficiency,
        RANK() OVER (PARTITION BY description ORDER BY AVG(fuel_efficiency) ASC) AS avg_fuel_inefficiency_rank
    FROM defense_vessels
    GROUP BY    
        home_port_id, 
        home_port,
        propulsion_type_id, 
        description
)
SELECT 
    * 
FROM 
    avg_fuel_eff_by_prop
WHERE
    avg_fuel_inefficiency_rank <= 5;


-- Question 6: Which home ports have the lowest average fuel efficiency for freighter vessels for each propulsion type?
WITH avg_fuel_eff_by_prop AS (
    SELECT 
        home_port_id, 
        home_port, 
        propulsion_type_id, 
        description AS propulsion_type,
        ROUND(AVG(fuel_efficiency), 2) AS avg_fuel_efficiency,
        RANK() OVER (PARTITION BY description ORDER BY AVG(fuel_efficiency) ASC) AS avg_fuel_inefficiency_rank
    FROM freighter_vessels
    GROUP BY    
        home_port_id, 
        home_port,
        propulsion_type_id, 
        description
)
SELECT 
    * 
FROM 
    avg_fuel_eff_by_prop
WHERE
    avg_fuel_inefficiency_rank <= 5;
    
-- Question 7: Which home ports have the lowest average decarbonisation efficiency for defense vessels for each propulsion type?
WITH avg_decarb_eff_by_prop AS (
    SELECT 
        home_port_id, 
        home_port, 
        propulsion_type_id, 
        description AS propulsion_type,
        ROUND(AVG(decarbonisation_efficiency), 2) AS avg_decarbonisation_inefficiency,
        RANK() OVER (PARTITION BY description ORDER BY AVG(decarbonisation_efficiency) ASC) AS avg_decarbonisation_inefficiency_rank
    FROM defense_vessels
    GROUP BY    
        home_port_id, 
        home_port,
        propulsion_type_id, 
        description
)
SELECT 
    * 
FROM 
    avg_decarb_eff_by_prop
WHERE
    avg_decarbonisation_inefficiency_rank <= 5;
    
-- Question 8: Which home ports have the lowest average decarbonisation efficiency for freighter vessels for each propulsion type?
WITH avg_decarb_eff_by_prop AS (
    SELECT 
        home_port_id, 
        home_port, 
        propulsion_type_id, 
        description AS propulsion_type,
        ROUND(AVG(decarbonisation_efficiency), 2) AS avg_decarbonisation_inefficiency,
        RANK() OVER (PARTITION BY description ORDER BY AVG(decarbonisation_efficiency) ASC) AS avg_decarbonisation_inefficiency_rank
    FROM freighter_vessels
    GROUP BY    
        home_port_id, 
        home_port,
        propulsion_type_id, 
        description
)
SELECT 
    * 
FROM 
    avg_decarb_eff_by_prop
WHERE
    avg_decarbonisation_inefficiency_rank <= 5;

-- Question 9: Which destination ports are being visited by defense vessels with the lowest fuel efficiency and decarbonisation efficiency?
SELECT 
    destination_port_id,
    destination_port,
    COUNT(*) AS vessel_count,
    propulsion_type_id, 
    description AS propulsion_type,
    ROUND(AVG(fuel_efficiency), 2) AS avg_fuel_efficiency,
    ROUND(AVG(decarbonisation_efficiency), 2) AS avg_decarbonisation_efficiency
FROM
    defense_vessels
WHERE
    engine_builder != 'Wärtsilä'
GROUP BY destination_port_id , destination_port , description, propulsion_type_id
ORDER BY avg_fuel_efficiency , avg_decarbonisation_efficiency
LIMIT 5;

-- Question 10: Which destination ports are being visited by freighter vessels with the lowest fuel efficiency and decarbonisation efficiency?
SELECT 
    destination_port_id,
    destination_port,
    COUNT(*) AS vessel_count,
    propulsion_type_id, 
    description AS propulsion_type,
    ROUND(AVG(fuel_efficiency), 2) AS avg_fuel_efficiency,
    ROUND(AVG(decarbonisation_efficiency), 2) AS avg_decarbonisation_efficiency
FROM
    freighter_vessels
WHERE
    engine_builder != 'Wärtsilä'
GROUP BY destination_port_id , destination_port , description, propulsion_type_id
ORDER BY avg_fuel_efficiency , avg_decarbonisation_efficiency
LIMIT 5;

-- Question 11: Which destination ports have the oldest average build years for defense vessels by propulsion type?
SELECT 
    destination_port_id,
    destination_port,
    COUNT(*) AS vessel_count,
    propulsion_type_id, 
    description AS propulsion_type,
    ROUND(AVG(year_built), 2) AS avg_build_year
FROM
    defense_vessels
WHERE
    engine_builder != 'Wärtsilä'
GROUP BY destination_port_id , destination_port , description, propulsion_type_id
ORDER BY avg_build_year ASC
LIMIT 5;

-- Question 12: Which destination ports have the oldest average build years for freighter vessels by propulsion type?
SELECT 
    destination_port_id,
    destination_port,
    COUNT(*) AS vessel_count,
    propulsion_type_id, 
    description AS propulsion_type,
    ROUND(AVG(year_built), 2) AS avg_build_year
FROM
    freighter_vessels
WHERE
    engine_builder != 'Wärtsilä'
GROUP BY destination_port_id , destination_port , description, propulsion_type_id
ORDER BY avg_build_year ASC
LIMIT 5;

-- Question 13: Which destination ports have the lowest average fuel efficiency for defense vessels for each propulsion type?
WITH avg_fuel_eff_by_prop AS (
    SELECT 
        destination_port_id, 
		destination_port, 
        propulsion_type_id, 
        description AS propulsion_type,
        ROUND(AVG(fuel_efficiency), 2) AS avg_fuel_efficiency,
        RANK() OVER (PARTITION BY description ORDER BY AVG(fuel_efficiency) ASC) AS avg_fuel_inefficiency_rank
    FROM defense_vessels
    GROUP BY    
        destination_port_id, 
		destination_port, 
        description,
        propulsion_type_id
)
SELECT 
    * 
FROM 
    avg_fuel_eff_by_prop
WHERE
    avg_fuel_inefficiency_rank <= 5;

-- Question 14: Which destination ports have the lowest average fuel efficiency for freighter vessels for each propulsion type?
WITH avg_fuel_eff_by_prop AS (
    SELECT 
        destination_port_id, 
		destination_port, 
        propulsion_type_id, 
        description AS propulsion_type,
        ROUND(AVG(fuel_efficiency), 2) AS avg_fuel_efficiency,
        RANK() OVER (PARTITION BY description ORDER BY AVG(fuel_efficiency) ASC) AS avg_fuel_inefficiency_rank
    FROM freighter_vessels
    GROUP BY    
        destination_port_id, 
		destination_port, 
        description,
        propulsion_type_id
)
SELECT 
    * 
FROM 
    avg_fuel_eff_by_prop
WHERE
    avg_fuel_inefficiency_rank <= 5;

-- Question 15: Which destination ports have the lowest average decarbonisation efficiency for defense vessels for each propulsion type?
WITH avg_decarb_eff_by_prop AS (
    SELECT 
        destination_port_id, 
		destination_port, 
        propulsion_type_id, 
        description AS propulsion_type,
        ROUND(AVG(decarbonisation_efficiency), 2) AS avg_decarbonisation_inefficiency,
        RANK() OVER (PARTITION BY description ORDER BY AVG(decarbonisation_efficiency) ASC) AS avg_decarbonisation_inefficiency_rank
    FROM defense_vessels
    GROUP BY    
        destination_port_id, 
		destination_port,
        description,
        propulsion_type_id
)
SELECT 
    * 
FROM 
    avg_decarb_eff_by_prop
WHERE
    avg_decarbonisation_inefficiency_rank <= 5;
    
-- Question 16: Which destination ports have the lowest average decarbonisation efficiency for freighter vessels for each propulsion type?
WITH avg_decarb_eff_by_prop AS (
    SELECT 
        destination_port_id, 
		destination_port, 
        propulsion_type_id, 
        description AS propulsion_type,
        ROUND(AVG(decarbonisation_efficiency), 2) AS avg_decarbonisation_inefficiency,
        RANK() OVER (PARTITION BY description ORDER BY AVG(decarbonisation_efficiency) ASC) AS avg_decarbonisation_inefficiency_rank
    FROM freighter_vessels
    GROUP BY    
        destination_port_id, 
		destination_port,
        description,
        propulsion_type_id
)
SELECT 
    * 
FROM 
    avg_decarb_eff_by_prop
WHERE
    avg_decarbonisation_inefficiency_rank <= 5;
    
