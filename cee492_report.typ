#align(center, [= Risk Prediction and Assessment in the Construction Industry])

#v(5em)

#align(center, [
  #grid(
    columns: 2,
    gutter: 1.5em,
    row-gutter: 1em,
    [
      **Zhixing Wang**  
      Department of Civil and Environmental Engineering  
      University of Illinois Urbana–Champaign  
      Urbana, IL, USA  
      *zw88\@illinois.edu*
    ],
    [
      **Zain Sitabkhan**  
      Department of Civil and Environmental Engineering  
      University of Illinois Urbana–Champaign  
      Urbana, IL, USA 
      *zsita\@illinois.edu*
    ],
    [
      **Deago Sirenden**  
      Department of Civil and Environmental Engineering  
      University of Illinois Urbana–Champaign  
      Urbana, IL, USA  
      *deagofs2\@illinois.edu*
    ],
    [
      **Zach Da**  
      Department of Civil and Environmental Engineering  
      University of Illinois Urbana–Champaign  
      Urbana, IL, USA  
      *zhihuid2\@illinois.edu*
    ],
  )
])

#v(8em)

= Abstract
This project focuses on risk prediction and assessment in the construction industry using incident and accident data from New York City. By applying regression-based models, the objective is to predict fatality and injury outcomes, as well as generate a weighted index to evaluate the severity of such events. The study contributes to understanding which attributes most strongly influence construction-related incidents and provides insights that may improve safety measures in the industry.

keywords:"Construction Safety", "Risk Prediction", "Accident Reports", "Regression Analysis"
#pagebreak()

= 1. Data Description(Project 1)
#v(2em)
== 1.1 File Content

The dataset consists of construction-related incidents and accidents at New York City in each of the five boroughs. It provides a large-scale CSV file suitable for predictive analysis.

== 1.2 Source
Department of Buildings (DOB) Incident Database

== 1.3 Format and Size
The dataset includes approximately 958 rows, each representing an accident or incident record, and 20 columns containing attribute fields of these records.
#v(2em)
= 2. Attributes
#v(2em)
#align(center, [Table 1. Attribute Definitions and Descriptions])
#table(
  columns: 3,
  align: (left, left, left),
  inset: 5pt,
  stroke: 0.5pt,

  [Attribute Name], [Unit/Type], [Description],
  [BIN], [Integer], [Building Identification Number (unique ID for each building)],
  [Accident Report ID], [Integer], [Unique identifier of each accident report],
  [Incident Date], [Date], [Date of the incident or accident],
  [Record Type Description], [Category (Text)], [Record type, distinguishing Incident from Accident],
  [Check2 Description], [Category (Text)], [Detailed category of the incident, e.g., Construction Related, Mechanical Equipment, Worker Fall],
  [Fatality], [Integer], [Number of fatalities],
  [Injury], [Integer], [Number of injuries],
  [House Number], [Text/Number], [House number of the incident location],
  [Street Name], [Text], [Street name of the incident location],
  [Borough], [Category], [Administrative borough (e.g., Manhattan, Bronx, Brooklyn)],
  [Block], [Integer], [Geographic block number],
  [Lot], [Integer], [Lot number within the block],
  [Postcode], [Integer], [Postal code of the location],
  [Latitude], [Float], [Latitude coordinate of the incident location],
  [Longitude], [Float], [Longitude coordinate of the incident location],
  [Community Board], [Integer], [Community board identifier],
  [Council District], [Integer], [City council district identifier],
  [BBL], [Integer], [Borough-Block-Lot unique cadastral identifier],
  [Census Tract (2020)], [Integer], [Census tract number from the 2020 census],
  [Neighborhood Tabulation Area (NTA) (2020)], [Text], [Neighborhood Tabulation Area (NTA) code from 2020],
)

Proposal for attribute usage will be made, focusing on those with predictive relevance.

= 3. Proposal

== 3.1 Objectives
Our main objective is to analyze different types of construction incidents at New York City that happened within 1 or 2 years from now. For this project, we would mainly be examining the nature of construction related incidents and accidents as well as performing correlations with the data by examining the prevalence of each incident and accident at each of the five boroughs of New York City. We would want to see where each type of incident has the highest probability of occurring, and where specifically measures should be implemented to prevent these types of incidents. Finally, keeping track of when these incidents occurred will also be critical as the data could also be used to calculate the frequency of accidents over time.

== 3.2 Preprocessing
Filtering may be applied to eliminate less effective or redundant variables, such as postcode or latitude, to improve model performance. Tidying and cleaning the data is also necessary before analyzing and correlating the data. We would probably need to order our data in terms of when they happen as well as categorizing the incidents/accidents that happened at each borough.

== 3.3 Output
- Incident vs accident count over time (could be in spans of 1 month)  
- How many construction incidents and accidents happened at each month  
- Computed severity index at each borough (e.g., grade scale from 1 = less severe to 10 = highly severe)

== 3.4 Input
Date, record type, latitude, longitude, type of incident, and BIN (business effect case, combined with other data).

== 3.5 Significance
The purpose of the model is to help avoid incidents and accidents at New York City by identifying the dominant attributes influencing outcomes, thereby guiding proactive protection measures in construction management.

#v(2em)
= 4. Exploratory Data Analysis(Project 2)
#v(2em)
This section will mainly focus on introductory data analysis with some preliminary tables and plots describing critical aspects of the data. Visible patterns will be discussed with the data that has been formulated and the coming sections below will describe how we plan on applying and modelling this data.
== 4.1 Data Integration and Cohort
For the data integration and cohort definition, we first filtered the dataset. We then applied groupby operations to extract and aggregate key information. This aggregation was performed by 'borough (Area)', month, and 'postcode'. The 'postcode' attribute serves as a critical key, as it is directly used to link and integrate the Heat Vulnerability Index (HVI) data.

== 4.2 Borough × Month Aggregation
To explore trends over time, the data were aggregated by borough and month. The aggregation reveals that incidents tend to cluster during the spring and summer months, aligning with increased construction activity. 
#v(1em)
#align(center, [Table 2. Monthly Aggregation of Incidents by Borough and Postcode])
#table(
  columns: 6,
  align: (left, right, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,
  [Borough], [Postcode], [YearMonth], [IncidentCount], [Fatality], [Injury],
  [Bronx], [10451], [Feb-24], [1], [0], [1],
  [Bronx], [10451], [Mar-24], [1], [0], [1],
  [Bronx], [10451], [Apr-24], [1], [0], [1],
  [Bronx], [10451], [Jun-24], [3], [1], [2],
)
Excerpt shown above; full panel saved as `monthly_borough.csv`.
#align(center, [
== 4.3 Temperature, Precipitation, and HVI Added
我将HVI与postcode结合，并删除缺失值。合并气候变量后得到415条有效观测。
#align(center, [Table 3. Integrated Dataset with Climate and HVI Variables])
#table(
  columns: 9,
  align: (left, right, right, right, right, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,
  [Borough], [Postcode], [YearMonth], [IncidentCount], [Fatality], [Injury], [AvgTemp], [AvgPrecip], [HVI],
  [Bronx], [10451], [Jun-24], [3], [1], [2], [71.7], [4.4], [5],
)
Preliminary inspection indicates that higher-HVI areas (typically in the Bronx and parts of Brooklyn) correspond to marginally elevated injury counts, hinting at interactions between heat exposure and worker safety.

== 4.4 Injury & Fatality Plots

#figure(image("figures/borough_fatality_bar_zs.jpg", width: 80%), caption: [Average Fatalities at Each Borough])

#figure(image("figures/borough_injury_bar_zs.jpg", width: 80%), caption: [Average Injuries at Each Borough])

#figure(image("figures/district_fatality_bar_zs.jpg", width: 80%), caption: [Average Fatalities at Each District])

#figure(image("figures/district_injury_bar_zs.jpg", width: 80%), caption: [Average Injuries at Each District])

#figure(image("figures/monthly_fatality_bar_zs.jpg", width: 80%), caption: [Cumulative Fatalities Overtime])

#figure(image("figures/monthly_injury_bar_zs.jpg", width: 80%), caption: [Cumulative Injuries Overtime])

#figure(image("figures/cumul_fatality_zs.jpg", width: 80%), caption: [Fatalities Each Month])

#figure(image("figures/cumul_injury_zs.jpg", width: 80%), caption: [Fatalities Each Month])

== 4.5 Averaging the Data
#align(center, [Table 4. Average Incident and Injury Rates by Borough])
#table(
  columns: 6,
  align: (left, right, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,
  [Borough], [AvgFatality], [AvgInjury], [AvgIncident], [FatalityRate%], [InjuryRate%],
  [Bronx], [0.019], [1.10], [1.31], [1.47], [83.82],
)
On average, 83.8% of incidents resulted in at least one reported injury, whereas fatalities were rare (around 1.5% of all cases). The Bronx recorded the highest injury rate, followed closely by Brooklyn.
== 4.6 Overall Summary
This section synthesizes the primary findings from our exploratory data analysis. We aggregated the data to compute and examine key descriptive statistics. Specifically, we calculated the average number of fatalities, average number of injuries, and average incident counts for each of the five boroughs. From this, we also derived the fatality and injury rates (as percentages) per borough to better understand the proportional risk. Furthermore, our summary includes an analysis of temporal patterns. We investigated monthly trends by charting the frequency and cumulative totals of both fatalities and injuries over the study period. These initial summaries provide a foundational understanding of which areas are most affected and how incident severity fluctuates over time.

#v(2em)
= 5. Correlation Analysis
#v(2em)
== 5.1 Weighted HVI
Weighted averaging is used when different observations contribute unequally to an aggregate measure.

== 5.2 Global Correlation
A global correlation analysis was conducted among key variables: TotalIncidents, Fatality, Injury, AvgTemp, AvgPrecip, and HVI.
#align(center, [Table 5. Correlation Matrix of Incident, Climate, and Vulnerability Variables])
#table(
  columns: 6,
  align: (left, right, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,
  [ ], [TotalIncidents], [Fatality], [Injury], [AvgTemp], [AvgPrecip],
  [TotalIncidents], [1.000], [0.120], [0.958], [0.025], [0.023],
  [Fatality], [0.120], [1.000], [0.075], [-0.007], [-0.153],
)
We conducted a global correlation analysis to understand the initial linear relationships between the primary variables. The results, partially shown in the table1, reveal several key patterns.Most notably, there is a very strong positive correlation between TotalIncidents and Injury (Pearson $r = 0.958$), which is expected as most incidents involve injuries.In contrast, Fatality demonstrates a weak correlation with the other variables in the table. The correlation with TotalIncidents is low ($r = 0.120$), and it is even weaker with Injury ($r = 0.075$). The environmental variables, AvgTemp ($r = -0.007$) and AvgPrecip ($r = -0.153$), also show negligible linear relationships with fatalities.Furthermore, analysis of the Heat Vulnerability Index (HVI) indicated a moderate negative correlation with both incidents and injuries, with correlation coefficients (r) observed in the range of approximately -0.57 to -0.606. This suggests that areas with higher vulnerability scores may, counterintuitively, be associated with fewer reported incidents in this dataset, prompting the need for further, more nuanced analysis.
#v(2em)
== 5.3 Log-scaled Correlation
#figure(
  image("figures/log_scaled_correlation_heatmap.jpg", width: 80%),
  caption: [Correlation heatmap after log scaling],
)
#v(2em)
Results show a strong positive correlation between TotalIncidents and Injury (r ≈ 0.96) and a negative correlation between HVI and Fatality (r ≈ –0.57). Although counterintuitive at first glance, this may reflect underreporting or mitigation interventions in high-vulnerability areas.
These relationships were visualized using a log-scaled correlation heatmap, emphasizing nonlinear dependencies that justify the use of both Poisson and Negative Binomial regression models in the next section.
= 6. Regression Models and Results
Regression modeling was performed using Poisson, Negative Binomial, and Logistic regressions,
which are standard approaches for count and binary outcomes in risk and safety studies.
#v(2em)
== 6.1 Poisson Model (Injury)
#align(center, [Table 6. Poisson Regression Model Results for Injury Counts])
#table(
  columns: 7,
  align: (left, right, right, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,
  [Variable], [coef], [std err], [z], [P>|z|], [0.025], [0.975],
  [Intercept], [0.1547], [1.059], [0.146], [0.884], [-1.921], [2.230],
)
#figure(image("figures/poisson_injury_coefficients.jpg", width: 80%), caption: [Poisson injury model coefficients])

== 6.2 Negative Binomial Model (Fatality)
#align(center, [Table 7. Negative Binomial Regression Model Results for Fatalities])
#table(
  columns: 7,
  align: (left, right, right, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,
  [Variable], [coef], [std err], [z], [P>|z|], [0.025], [0.975],
  [Intercept], [-9.6771], [10.237], [-0.945], [0.345], [-29.742], [10.387],
)
#figure(image("figures/neg_bin_fatality_coefficients.jpg", width: 80%), caption: [Negative binomial fatality model coefficients])

== 6.3 Logistic Model
#align(center, [Table 8. Logistic Regression Results for Binary Fatality Events])
#table(
  columns: 7,
  align: (left, right, right, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,
  [Variable], [coef], [std err], [z], [P>|z|], [0.025], [0.975],
  [Intercept], [-8.1713], [8.01e+06], [-1e-06], [1.000], [-1.57e+07], [1.57e+07],
)

== 6.4 Visual Summaries
#figure(image("figures/coef_comparison.jpg", width: 80%), caption: [Coefficient comparison])
#figure(image("figures/pred_fatal_heatmap.jpg", width: 80%), caption: [Predicted fatality heatmap])
#figure(image("figures/pred_fatal_spatial.jpg", width: 80%), caption: [Spatial fatality prediction map])

= 7. Plan for Deliverable 3

This section will describe how we plan on creating more complex models pertaining to our data, such as predictive modelling. This aspect is necessary in terms of understanding important patterns and information that cannot be simply derived by just correlating two variables.

== 7.1 Objectives
Here are objectives we want to achieve if predictive modelling would be implemented:
1. Know when and where injuries and fatalities are the most severe around New York City 
2. Know the most prevalent underlying causes with injuries and fatalities through check descriptions
3. Thoroughly investigate each borough or districts if we want to take this further to thoroughly detect where these incidents are occuring
4. Figure out how much weather (e.g. precipitation, temperature) affects the prevalence of construction incidents
5. Know how create more complex models with this data

== 7.2 Models
Here are some examples of models we may implement:
1. Binary injury risk per event 
2. Count severity per borough-month (injury counts or SeverityIndex)
3. Poisson vs. Negative Binomial
4. Regularized logistic for rare events
5. Heatmap or spatial distribution (longitude and latitude) detailing fatalities or injuries around New York City (may need to include detail with which borough)

== 7.4 Interpretability & Fairness
This would include inspecting borough effects and error parity across high-HVI ZIPs.

== 7.5 Next Steps
Steps we could eventually take are adding exposure controls (permits, active sites), extending years, and considering hierarchical models if time allows.

= 8. References
[1] Hilbe, J. M. (2011). *Negative binomial regression* (2nd ed.). Cambridge University Press. \
[2] Cameron, A. C., & Trivedi, P. K. (2013). *Regression analysis of count data* (2nd ed.). Cambridge University Press. \
[3] Hosmer, D. W., Lemeshow, S., & Sturdivant, R. X. (2013). *Applied logistic regression* (3rd ed.). Wiley.








