-- creating star schema

-- Table: consolidated_vessel_data
CREATE TABLE IF NOT EXISTS consolidated_vessel_data (
    uuid VARCHAR(36) PRIMARY KEY,  -- Unique identifier for each vessel
    mmsi INT,  -- Maritime Mobile Service Identity
    imo INT,  -- International Maritime Organization number
    name VARCHAR(255),  -- Vessel name
    country_id INT,  -- Foreign key to countries table
    home_port_id INT,  -- Foreign key to ports table (home port)
    destination_port_id INT,  -- Foreign key to ports table (destination port)
    vessel_type_id INT,  -- Foreign key to vessel_types table
    year_built INT,  -- Year the vessel was built
    gross_tonnage INT,  -- Vessel's gross tonnage
    propulsion_type_id INT,  -- Foreign key to propulsion_types table
    maximum_continuous_output INT,  -- Maximum continuous output (engine power)
    mco_per_tonnage FLOAT,  -- Maximum continuous output per tonnage
    mco_rpm INT,  -- Maximum continuous output in RPM
    engine_id INT  -- Foreign key to engines table
);

-- Table: countries
CREATE TABLE IF NOT EXISTS countries (
    country_id INT PRIMARY KEY,  -- Unique identifier for each country
    country_iso VARCHAR(10),  -- ISO country code
    country VARCHAR(255)  -- Country name
);

-- Table: ports
CREATE TABLE IF NOT EXISTS ports (
    port_id INT PRIMARY KEY,  -- Unique identifier for each port
    port VARCHAR(255)  -- Port name
);

-- Table: vessel_types
CREATE TABLE IF NOT EXISTS vessel_types (
    vessel_type_id INT PRIMARY KEY,  -- Unique identifier for each vessel type
    type VARCHAR(255),  -- General vessel type (e.g., Cargo, Tanker)
    type_specific VARCHAR(255)  -- Specific vessel subtype
);

-- Table: propulsion_types
CREATE TABLE IF NOT EXISTS propulsion_types (
    propulsion_type_id INT PRIMARY KEY,  -- Unique identifier for each propulsion type
    propulsion_type_code VARCHAR(10),  -- Propulsion type code (e.g., GT for Gas Turbine)
    description VARCHAR(255)  -- Description of the propulsion system
);

-- Table: engines
CREATE TABLE IF NOT EXISTS engines (
    engine_id INT PRIMARY KEY,  -- Unique identifier for each engine
    engine_builder VARCHAR(255),  -- Name of the engine builder
    engine_designation VARCHAR(255),  -- Designation or model of the engine
    fuel_efficiency FLOAT,  -- Fuel efficiency rating (e.g., liters per kWh)
    decarbonisation_efficiency FLOAT  -- Decarbonization efficiency rating
);

-- Relationships (Foreign Key Constraints)

-- Relationship between consolidated_vessel_data and countries
ALTER TABLE consolidated_vessel_data
ADD CONSTRAINT fk_country
FOREIGN KEY (country_id) REFERENCES countries(country_id);

-- Relationship between consolidated_vessel_data and ports (home port)
ALTER TABLE consolidated_vessel_data
ADD CONSTRAINT fk_home_port
FOREIGN KEY (home_port_id) REFERENCES ports(port_id);

-- Relationship between consolidated_vessel_data and ports (destination port)
ALTER TABLE consolidated_vessel_data
ADD CONSTRAINT fk_destination_port
FOREIGN KEY (destination_port_id) REFERENCES ports(port_id);

-- Relationship between consolidated_vessel_data and vessel_types
ALTER TABLE consolidated_vessel_data
ADD CONSTRAINT fk_vessel_type
FOREIGN KEY (vessel_type_id) REFERENCES vessel_types(vessel_type_id);

-- Relationship between consolidated_vessel_data and propulsion_types
ALTER TABLE consolidated_vessel_data
ADD CONSTRAINT fk_propulsion_type
FOREIGN KEY (propulsion_type_id) REFERENCES propulsion_types(propulsion_type_id);

-- Relationship between consolidated_vessel_data and engines
ALTER TABLE consolidated_vessel_data
ADD CONSTRAINT fk_engine
FOREIGN KEY (engine_id) REFERENCES engines(engine_id);

-- create view for defense vessels
CREATE VIEW defense_vessels AS
SELECT 
	v.uuid, 
	v.country_id, 
	c.country_iso, 
	c.country,
	v.home_port_id,
	p_home.port AS home_port,
	v.destination_port_id, 
	p_destination.port AS destination_port,
	v.vessel_type_id,
	vt.type,
	vt.type_specific, 
	v.year_built, 
	v.gross_tonnage,
	v.propulsion_type_id, 
	pt.propulsion_type_code, 
	pt.description,
	v.maximum_continuous_output, 
	v.mco_per_tonnage,
	v.mco_rpm, 
	v.engine_id, 
	e.engine_builder, 
	e.engine_designation, 
	e.fuel_efficiency, 
	e.decarbonisation_efficiency
FROM consolidated_vessel_data v
JOIN countries c ON v.country_id = c.country_id
JOIN ports p_home ON v.home_port_id = p_home.port_id
JOIN ports p_destination ON v.destination_port_id = p_destination.port_id
JOIN vessel_types vt ON v.vessel_type_id = vt.vessel_type_id
JOIN propulsion_types pt ON v.propulsion_type_id = pt.propulsion_type_id
JOIN engines e ON v.engine_id = e.engine_id
WHERE type IN ('Military', 'Warship', 'SAR');

-- create view for freighter vessels
CREATE VIEW freighter_vessels AS
SELECT 
	v.uuid, 
	v.country_id, 
	c.country_iso, 
	c.country,
	v.home_port_id,
	p_home.port AS home_port,
	v.destination_port_id, 
	p_destination.port AS destination_port,
	v.vessel_type_id,
	vt.type,
	vt.type_specific, 
	v.year_built, 
	v.gross_tonnage,
	v.propulsion_type_id, 
	pt.propulsion_type_code, 
	pt.description,
	v.maximum_continuous_output, 
	v.mco_per_tonnage,
	v.mco_rpm, 
	v.engine_id, 
	e.engine_builder, 
	e.engine_designation, 
	e.fuel_efficiency, 
	e.decarbonisation_efficiency
FROM consolidated_vessel_data v
JOIN countries c ON v.country_id = c.country_id
JOIN ports p_home ON v.home_port_id = p_home.port_id
JOIN ports p_destination ON v.destination_port_id = p_destination.port_id
JOIN vessel_types vt ON v.vessel_type_id = vt.vessel_type_id
JOIN propulsion_types pt ON v.propulsion_type_id = pt.propulsion_type_id
JOIN engines e ON v.engine_id = e.engine_id
WHERE type IN ('Tanker', 'Bulk Carrier', 'Cargo');
