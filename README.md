# Port Prospects
### An analytical approach to identifying potential opportunities for marketing Wärtsilä’s advanced propulsion solutions tailored towards defence, tankers and cargo vessels through market segmentation, further bolstered by identifying target ports of interest. 
![image](https://github.com/user-attachments/assets/89ff50bc-46ca-4c2e-be78-15536cef7e68)


This approach focuses on leveraging Wärtsilä's unique strengths in propulsion technology, including fuel efficiency and decarbonisation, to identify vessels that would benefit most from these solutions.

The vessel segmentation was selected because both freighter and defense vessel types are consistently highlighted as vessels of interest on their website. This approach also enables a more granular analysis, providing more targeted leads for other Wärtsilä stakeholders to follow up on regarding their efforts and resource allocation. 
# Kaggle Dataset 
The Initial <a href="https://www.kaggle.com/datasets/eminserkanerdonmez/ais-dataset/data" target="_blank">open source dataset</a> was chosen from Kaggle and contains data relating to ships transiting the Kattegat Strait between January 1st and March 10th, 2022.

The data card was as follows:

**Static Information :**
- The ship's IMO number
- The ship's MMSI number
- The ship's Call Sign
- The ship's name
- The ship's type
- What type of destination this message was received from (like Class A / Class B)
- Width of ship
- Length of ship
- Draft of ship
- Type of GPS device
- Length from GPS to bow (Length A)
- Length from GPS to stern (Size B)
- Length from GPS to starboard (Size C)
- Length from GPS to port side (Dimension D)

**Dynamic Data:**
- Time information (31/12/2015 in 23:59:59 format)
- Latitude
- Longitude
- Navigational status (For example: 'Fishing', Anchored, etc.)
- Rate of Turn (ROT)
- Speed Over Ground (SOG)
- Course Over Ground (COG)
- Heading
- Type of cargo
- Port of Destination
- Estimated Time of Arrival (ETA)
- Data source type, eg. AIS
<br></br>
The data set was streamlined by reducing the number of columns, optimising SQL query performance and improving the efficiency of subsequent analyses **(see snippet below).**

![image](https://github.com/user-attachments/assets/8d9f0f12-9a24-4afa-afc7-062859b1be46)

# Data Aquisition
To enrich the Kaggle data set, additional data was aquired using the [Datalastic API](https://datalastic.com/) as it allows for - 

_'All in one vessel API. Access historical and real-time AIS data about ships, cargo vessels, fishing boats, cruise liners, and more'._

The main endpoints allowed for data retrieval related to [the Vessel Specs and Vessel Engine](https://datalastic.com/api-reference/) by using each ship's MMSI from the Kaggle dataset. The MMSI was passed as a parameter to uniquely identify each vessel and return its respective data.

This method of data acquisition was functioning as expected until the account making the API requests reached the monthly call limit of 20,000. This occurred due to earlier testing conducted to ensure the Python script was working as intended, along with the program performing API calls for different parameters in parallel using Python's built-in ThreadPoolExecutor class. 

Therefore, given that API limit was reached (and upgrading the account subscription making the API calls would be very expensive) after acquring aproximately 1,000 complete records, it was decided that this data would be used to prompt the creation of a larger 10,000 record synthetic data set using [Mostly AI](https://mostly.ai/). This decision was made to enhance the dataset's size, thereby:

**- Improving statistical power**
<br>
**- Uncovering more representative patterns**
<br>
**- Enabling more reliable vessel segmentation.**

Additionally, some feature columns were created to further enrich the data such as **'mco/tonnage'  (MCO (Maximum Continuous Output) to tonnage ratio)** as it could be used as a good indicator of both engine efficiency (particularly for freighters due to the cargo load impact).

Snippet of Synthetic flatfile Dataset:
![image](https://github.com/user-attachments/assets/de02e130-609b-4665-89eb-a8a27aa936b8)

_It should be noted that the synthetic dataset did not contain missing values, duplicates, or other typical data quality issues, and therefore is not fully representative of a real-world dataset prior to data cleansing_
# Data Normalisation and Schema
Given that the data set was currently in a flatfile format. It was decided performing data normlisation would be beneficial for both query speeds by creating a star schema, especially if the data was to be scaled upwards through continuous data ingestion (as querying speeds may otherwise suffer).

Further to this, adddiional columns were added to dimension tables such as the **country name** for the **countries table**, a **fuel and decarbonisation efficiency** rating (1 through 5 as part of a likert scale) for the **engines table** and **description of the propulsion type** utilised by vessels in the **proulsion types table.**
![image](https://github.com/user-attachments/assets/ac95e433-561d-4dd5-9fd6-14b16555860e)

These changes were made to enrich the data and allow for a deeper level of analysis with respect to the engine efficiency (or lack of for that matter) and therefore where to focus efforts when identifying potential opportunities for marketing Wärtsilä’s advanced propulsion solutions. 

It should also be mentioned that the fuel efficiency and decarbonisation efficiency were calculated a product of both the engine builder and engine designation. 

# SQL Insights 

The fact table and dimensions tables (as seen above) were created within SQL, along with their respective relationships. The data was then brought in using the SQL import wizard. 

## views 
Views to allow for segmentation of defense vessels and freighter vessels were created as they appear to be key segments of interest for Wärtsilä:

<br>

**Defense Vessel View**

![image](https://github.com/user-attachments/assets/dbe8942c-8400-4ac6-9a1a-cad1809d78bc)

<br>

**Freighter Vessel View**

![image](https://github.com/user-attachments/assets/3b75de43-51b2-46fe-b782-73d77c587c19)

<br>

## Queries
The Queries that were chosen were broken up into two key areas: 

**1.) Port Segmentation of defense and freighter vessels**

**2.) Engine Segmenation of defense and freighter vessels**

The following questions were then proposed to gain insight into key areas of interest such as:

**Port Segmenation:**

- Which home ports are being visited by defense vessels and freighter vessels with the lowest fuel efficiency and decarbonisation efficiency?
- Which home ports have the oldest average build years for defense and freighter vessels by propulsion type?
- Which home ports have the lowest average fuel efficiency for defense and freighter vessels for each propulsion type?
- Which home ports have the lowest average decarbonisation efficiency for defense and freighter vessels for each propulsion type?
- Which destination ports are being visited by defense and freighter vessels with the lowest fuel efficiency and decarbonisation efficiency?
- Which destination ports have the oldest average build years for defense and freighter vessels by propulsion type?
- Which destination ports have the lowest average fuel efficiency for defense and freighter vessels for each propulsion type?
- Which destination ports have the lowest average decarbonisation efficiency for defense and freighter vessels for each propulsion type?

**Engine Segmentation:**

-  Which defense and freighter vessel engines have the lowest average fuel efficiency and decarbonisation efficiency?
-  Which defense and freighter vessel engines have the lowest average maximum continous output per tonnage?
-  What are the top 5 defense and freighter vessel engines that may have been in service for longest?
-  Which propulsion types have the lowest average fuel efficiency for defense and freighter vessels?
-  Which propulsion types have the lowest average decarbonisation efficiency for defense and freighter vessels?
-  Which propulsion types are most commonly found across different countries for defense and freighter vessels?
-  Which propulsion types have the lowest average fuel and decarbonisation efficiency for defense and freighter vessels?

# Visuals - Python
## Port Segmentation

To visualise these queries, Jupyter Notebooks were chosen as they allow for creating straightforward visuals that effectively convey patterns and trends. The queries were executed using from sqlalchemy and then brought in as a dataframe using pandas. This then allowed the most 'suitable' visualisation for the dataframe to be chosen and to confirm the data being brought in was correct. 

The below visualisations were created using both the seaborn and matplotlib libraries:

![f d hport dvessels](https://github.com/user-attachments/assets/36684e4d-b488-434e-8c58-ad7fdc7959ea)

... Explain the purpose of each visual and the impact it will provide!

![f d hport fvessels](https://github.com/user-attachments/assets/05d1fea9-1216-4e87-b974-4771fac0f495)

![avg build year hport dvessels](https://github.com/user-attachments/assets/e645d47e-5332-4fdb-8227-02d3a2a7c4e5)

![avg build year hport fvessels](https://github.com/user-attachments/assets/7983a0de-1538-4968-a58a-9399870e4aca)

![f d dport dvessels](https://github.com/user-attachments/assets/9685ad96-c933-42f4-83dd-5ae54119e07a)

![f d dport fvessels](https://github.com/user-attachments/assets/7b58a423-4bc2-42df-b7f0-9c04e121da04)

![avg build year dport dvessels](https://github.com/user-attachments/assets/d6866c2e-6008-40ba-b836-741d88de9e71)

![avg build year dport fvessels](https://github.com/user-attachments/assets/dcf4e9db-4d0e-4b6d-ae7d-f113072c7c26)

## Engine Segmentation
![dvessel avg mco tonnage below wartsila](https://github.com/user-attachments/assets/e7020c70-4cda-4921-8503-d7b2462e6b2b)

![fvessel avg mco tonnage below wartsila](https://github.com/user-attachments/assets/c4e70fe1-4d69-4183-98a2-d234520cd24d)

![dvessel engines possible longest service](https://github.com/user-attachments/assets/331005fa-0e12-4974-b6b1-434200bd291f)

![fvessel engines possible longest service](https://github.com/user-attachments/assets/933ae10e-90b7-44a4-a76a-456ed2dfcc99)

![dvessel prop type avg f d](https://github.com/user-attachments/assets/06c91f83-6e1a-41e0-9778-2fd94e1dbd61)

![fvessel prop type avg f d](https://github.com/user-attachments/assets/8f8eb008-78d8-47bf-aa03-63fc6906d696)

![prop type percentage by country for dvessels](https://github.com/user-attachments/assets/a29541bc-b36a-4817-85b2-8798e01ecce6)

![prop type percentage by country for fvessels](https://github.com/user-attachments/assets/aa81afd6-47aa-44d1-bd5e-ee7138520253)

### Areas for Potential Enhancement:

**Operational Efficiency Analysis:**  
Beyond just identifying the lowest performers, it could be beneficial to evaluate operational metrics such as fuel efficiency, maintenance costs, and lifecycle costs for different engine types. This can help articulate the value proposition of Wärtsilä's solutions more effectively.

**Competitor Analysis:**  
While my focus was on identifying opportunities for Wärtsilä, understanding the competitive landscape—who the main competitors are in these segments and what they offer—could provide valuable context towards these findings.

**Customer Segmentation:**  
Analysing potential customers based on the identified vessel data (e.g., government contracts, shipping companies) could refine the marketing strategies and allow for a greater focus on specific target markets.

**Integration of External Data:**  
If feasible, I should consider integrating external datasets, such as industry reports or economic indicators, to enrich your analysis and support your findings.

**Direct querying data that updates live Vessel Data**
The use of direct querying along with scehdules refreshes for data that updates in real time such as vessel positions or status may also futher enrich the data and oppotunities for analysis.
