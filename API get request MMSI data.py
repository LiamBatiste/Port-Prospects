import pandas as pd
import requests
import os
import concurrent.futures
import time

# Step 0: Load the Kaggle dataset and apply filters for ship type and size
kaggle_dataset = pd.read_excel("Port Prospects.xlsx")

# Define ship types of interest and size thresholds
ship_types_of_interest = ['Military', 'SAR', 'Law enforcement', 'Cargo',
                          'Tanker']

# Filter the dataset for relevant ship types and large size
filtered_dataset = kaggle_dataset[
    (kaggle_dataset['shiptype'].isin(ship_types_of_interest)) ]

# Convert MMSI values to integers while filtering out invalid values
mmsis = [int(mmsi) for mmsi in filtered_dataset["mmsi"].dropna() if
         pd.notnull(mmsi)]

# Lists for data collection
vessels_data = []
engine_data_map = {}  # Maps IMO to engine data
specs_data_map = {}  # Maps UUID to vessel specs
error_count = 0


# Helper function to fetch vessel data with retry logic and avoid duplicates
def fetch_vessel_data(mmsi, max_retries=5):
    global error_count
    retries = 0
    backoff_time = 60  # Start with a 60-second backoff

    while retries < max_retries:
        try:
            response = requests.get(
                f"https://api.datalastic.com/api/v0/vessel?api-key={os.environ['API_KEY']}&mmsi={mmsi}")
            if response.status_code == 200:
                json_response = response.json()
                if 'data' in json_response:
                    vessel_data = json_response['data']
                    vessel_uuid = vessel_data['uuid']

                    # Check for duplicates before appending
                    if not any(v['uuid'] == vessel_uuid for v in vessels_data):
                        # Save the basic vessel info
                        vessels_data.append({
                            'uuid': vessel_uuid,
                            'mmsi': mmsi,
                            'imo': vessel_data['imo'],
                            'name': vessel_data['name'],
                            'country_iso': vessel_data['country_iso'],
                            'type': vessel_data['type'],
                            'type_specific': vessel_data['type_specific'],
                            'destination': vessel_data['destination']
                        })

                        # Fetch vessel specs and map by UUID
                        specs_response = requests.get(
                            f"https://api.datalastic.com/api/v0/vessel_info?api-key={os.environ['API_KEY']}&uuid={vessel_uuid}")
                        if specs_response.status_code == 200:
                            specs_data_map[
                                vessel_uuid] = specs_response.json().get('data',
                                                                         {})

                        # Fetch engine specs and map by IMO
                        engine_response = requests.get(
                            f"https://api.datalastic.com/api/maritime_reports/engine?api-key={os.environ['API_KEY']}&imo={vessel_data['imo']}")
                        if engine_response.status_code == 200:
                            engine_data_map[vessel_data[
                                'imo']] = engine_response.json().get('data', [])

                return  # Exit if successful

            elif response.status_code == 429:
                # Rate limit exceeded, wait and retry
                print(
                    f"Error 429: Rate limit exceeded for MMSI: {mmsi}. Retrying in {backoff_time} seconds.")
                time.sleep(backoff_time)
                retries += 1
                backoff_time = min(backoff_time * 2,
                                   600)  # Cap the backoff time at 600 seconds (10 minutes)

            elif response.status_code == 404:
                print(f"Error 404: Data not found for MMSI: {mmsi}. Skipping.")
                error_count += 1
                return  # Exit since there's no data to process

            else:
                print(f"Error {response.status_code} for MMSI: {mmsi}")
                error_count += 1
                return  # Exit on non-retryable error

        except Exception as e:
            print(f"Exception occurred for MMSI {mmsi}: {e}")
            error_count += 1
            return  # Exit on other exceptions


# Step 1: Fetch data in parallel using ThreadPoolExecutor
with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
    futures = [executor.submit(fetch_vessel_data, mmsi) for mmsi in mmsis]
    for index, future in enumerate(concurrent.futures.as_completed(futures),
                                   start=1):
        future.result()  # To raise any exceptions that might have occurred during execution

        # Log progress every 100 records
        if index % 100 == 0:
            print(
                f"Processed {index} vessels so far, with {error_count} errors.")
            # Save interim results every 100 records
            temp_df = pd.DataFrame(vessels_data)
            temp_df.to_csv('consolidated_vessel_data_temp.csv', index=False)
            print(
                f"Saved interim data to 'consolidated_vessel_data_temp.csv' after {index} records.")

# Step 2: Consolidate data
consolidated_data = []

for vessel in vessels_data:
    uuid = vessel['uuid']
    imo = vessel['imo']

    # Get corresponding specs and engine data
    vessel_specs = specs_data_map.get(uuid, {})
    vessel_engine_data = engine_data_map.get(imo, [{}])[
        0]  # Take the first engine record if multiple exist

    # Combine the data into a single dictionary
    combined_data = {
        'uuid': vessel['uuid'],
        'mmsi': vessel['mmsi'],
        'imo': vessel['imo'],
        'name': vessel['name'],
        'country_iso': vessel['country_iso'],
        'type': vessel['type'],
        'type_specific': vessel['type_specific'],
        'destination': vessel['destination'],
        'year_built': vessel_specs.get('year_built', 'N/A'),
        'gross_tonnage': vessel_specs.get('gross_tonnage', 'N/A'),
        'home_port': vessel_specs.get('home_port', 'N/A'),
        'propulsion_type_code': vessel_engine_data.get('propulsion_type_code',
                                                       'N/A'),
        'mco': vessel_engine_data.get('mco', 'N/A'),
        'mco_rpm': vessel_engine_data.get('mco_rpm', 'N/A'),
        'engine_designation': vessel_engine_data.get('engine_designation',
                                                     'N/A'),
        'engine_builder': vessel_engine_data.get('engine_builder', 'N/A'),
        'engine_designer': vessel_engine_data.get('engine_designer', 'N/A')
    }

    # Append to the consolidated data list
    consolidated_data.append(combined_data)

# Step 3: Convert to DataFrame and export to CSV
df = pd.DataFrame(consolidated_data)
df.to_csv('consolidated_vessel_data.csv', index=False)

print("Data has been consolidated and saved to 'consolidated_vessel_data.csv'.")
print(f"Total errors encountered during execution: {error_count}")
