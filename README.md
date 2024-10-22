# Port Prospects
An analytical approach to identifying potential opportunities for marketing Wärtsilä’s advanced propulsion solutions tailored towards defence, tankers and cargo vessels through market segmentation, further bolstered by identifying target ports of interest. 

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
To enrich the Kaggle data set, additional data was aquired using the [Datalastic API](https://datalastic.com/) as it allows for _'All in one vessel API. Access historical and real-time AIS data about ships, cargo vessels, fishing boats, cruise liners, and more.'_

The main endpoints allowed for data to be called pertaining to [the Vessel Specs and Vessel Engine](https://datalastic.com/api-reference/).

This method of data aquisition was working as expected up until the account making the API requests hit the monthly call limit of 20,000 extremely quickly as I ran the programme multiples times due to performing the API call for different parameters in parallel using the ThreadPoolExecutor Class built into Python. 

# Schema and Normalisation
![image](https://github.com/user-attachments/assets/ac95e433-561d-4dd5-9fd6-14b16555860e)

# Visuals - Python
## Port Segmentation
![f d hport dvessels](https://github.com/user-attachments/assets/36684e4d-b488-434e-8c58-ad7fdc7959ea)

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
