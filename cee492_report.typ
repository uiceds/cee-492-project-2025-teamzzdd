#import "@preview/charged-ieee:0.1.4": ieee

#show: ieee.with(
  title: [Risk Prediction and Assessment in the Construction Industry],
  abstract: [
    This project focuses on risk prediction and assessment in the construction industry using incident and accident data from New York City. By applying regression-based models, the objective is to predict fatality and injury outcomes, as well as generate a weighted index to evaluate the severity of such events. The study contributes to understanding which attributes most strongly influence construction-related incidents and provides insights that may improve safety measures in the industry.
  ],
  authors: (
    (
      name: "Zhixing Wang",
      department: [Civil and Environmental Engineering],
      organization: [University of Illinois Urbana-Champaign],
      location: [Urbana, IL, USA],
      email: "zw88@illinois.edu",
    ),
    (
      name: "Zain Sitabkhan",
      department: [Civil and Environmental Engineering],
      organization: [University of Illinois Urbana-Champaign],
      location: [Urbana, IL, USA],
      email: "zsita@illinois.edu",
    ),
    (
      name: "Deago Sirenden",
      department: [Civil and Environmental Engineering],
      organization: [University of Illinois Urbana-Champaign],
      location: [Urbana, IL, USA],
      email: "deagofs2@illinois.edu",
    ),
    (
      name: "Zach Da",
      department: [Civil and Environmental Engineering],
      organization: [University of Illinois Urbana-Champaign],
      location: [Urbana, IL, USA],
      email: "zhihuid2@illinois.edu",
    ),
  ),
  index-terms: ("Construction Safety", "Risk Prediction", "Accident Reports", "Regression Analysis"),
  bibliography: bibliography("refs.bib"),
)  // ← 这一行结束 ieee.with


= Data Description

== File Content
The dataset consists of construction-related incidents and accidents at New York City in each of the five boroughs. It provides a large-scale CSV file suitable for predictive analysis.

== Source
Department of Buildings (DOB) Incident Database

== Format and Size
The dataset includes approximately 958 rows, each representing an accident or incident record, and 20 columns containing attribute fields of these records.

= Attributes
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

= Proposal

== Objectives
Our main objective is to analyze different types of construction incidents at New York City that happened within 1 or 2 years from now. For this project, we would mainly be examining the nature of construction related incidents and accidents as well as performing correlations with the data by examining the prevalence of each incident and accident at each of the five boroughs of New York City. We would want to see where each type of incident has the highest probability of occurring, and where specifically measures should be implemented to prevent these types of incidents. Finally, keeping track of when these incidents occurred will also be critical as the data could also be used to calculate the frequency of accidents over time.

== Preprocessing
Filtering may be applied to eliminate less effective or redundant variables, such as postcode or latitude, to improve model performance. Tidying and cleaning the data is also necessary before analyzing and correlating the data. We would probably need to order our data in terms of when they happen as well as categorizing the incidents/accidents that happened at each borough.

== Output
- Incident vs accident count over time (could be in spans of 1 month)
- How many construction incidents and accidents happened at each month 
- Computed severity index at each borough (e.g., grade scale from 1 = less severe to 10 = highly severe)

== Input
Date, record type, latitude, longitude, type of incident, and BIN (business effect case, combined with other data).

== Significance
The purpose of the model is to help avoid incidents and accidents at New York City by identifying the dominant attributes influencing outcomes, thereby guiding proactive protection measures in construction management.


= Exploratory Data Analysis
A narrative description and characterization of your dataset, interspersed with
summary statistics and plots.

We analyze DOB construction incidents across NYC's five boroughs(Bronx, Brooklyn, Manhattan, Queens, and State Island), evaluating each record with a Heat Vulnerability Index (HVI) at ZIP/ZCTA level and baseline monthly climate normals such as mean temperature and precipitation that mapped by month. After cleaning data by parsing dates, removing duplicate Accident Report ID, and restricting the time window to 2024-01-01 through 2025-09-30, we normalized and calculate the Severity Index:
SeverityIndex = 10Fatality + 2Injury - min / (max - min)
This emphasizes fatalities while preserving injury granularity. All categorical variables (Borough, Month) are standardized for aggregation and modeling.

== Data Integration and Cohort
Deduplication: Dropped repeated Accident Report ID s before analysis
HVI join: Join ZIPs to 5 digits; left-joined HVI onto incidents
Climate join: Monthly "Baseline" normals parsed and mapped 1 to 12 month; units normalized from string to numeric
Study window: Incidents filtered to 2024-01 to 2025-09 to reflect current activity.

== Borough × Month Aggregation
We compute borough–month totals and means needed for the rate-based modeling.  
The exported panel (n = 715 borough-months) includes:

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
  [Bronx], [10451], [Jul-24], [1], [0], [1],
  [Bronx], [10451], [Aug-24], [1], [0], [1],
  [Bronx], [10451], [Dec-24], [1], [0], [1],
  [Bronx], [10451], [Jan-25], [1], [0], [1],
  [Bronx], [10451], [Feb-25], [2], [1], [0],
  [Bronx], [10451], [Jun-25], [1], [0], [1],
  [Bronx], [10451], [Aug-25], [1], [0], [1],
)

Excerpt shown above; full panel saved as `monthly_borough.csv`.
== Temperature Precipitation and HVI added
We compute borough month totals and means needed for the rate-based modeling.  
After merging with climate and HVI data, records with missing HVI values for certain postcodes were removed.  
The resulting dataset contains n = 415 borough month observations.

#table(
  columns: 9,
  align: (left, right, right, right, right, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,

  [Borough], [Postcode], [YearMonth], [IncidentCount], [Fatality], [Injury], [AvgTemp], [AvgPrecip], [HVI],
  [Bronx], [10451], [Feb-24], [1], [0], [1], [35.5], [3.1], [5],
  [Bronx], [10451], [Mar-24], [1], [0], [1], [42.7], [4.4], [5],
  [Bronx], [10451], [Apr-24], [1], [0], [1], [53.3], [4.5], [5],
  [Bronx], [10451], [Jun-24], [3], [1], [2], [71.7], [4.4], [5],
  [Bronx], [10451], [Jul-24], [1], [0], [2], [76.7], [4.6], [5],
  [Bronx], [10451], [Aug-24], [1], [0], [1], [75.5], [4.4], [5],
  [Bronx], [10451], [Dec-24], [1], [0], [1], [37.8], [4.0], [5],
  [Bronx], [10452], [Apr-24], [2], [0], [2], [53.3], [4.5], [5],
  [Bronx], [10452], [May-24], [3], [0], [3], [62.6], [4.2], [5],
  [Bronx], [10452], [Jun-24], [2], [0], [2], [71.7], [4.4], [5],
  [Bronx], [10452], [Jul-24], [2], [0], [1], [76.7], [4.6], [5],
  [Bronx], [10452], [Oct-24], [1], [0], [1], [57.2], [4.4], [5],
  [Bronx], [10453], [Mar-24], [1], [0], [1], [42.7], [4.4], [5],
)

Excerpt shown above; the full cleaned panel is exported as `final_df`.
== Information before correlation
#table(
  columns: 6,
  align: (left, right, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,

  [Borough], [AvgFatality], [AvgInjury], [AvgIncident], [FatalityRate%], [InjuryRate%],
  [Bronx], [0.019231], [1.096154], [1.307692], [1.47], [83.82],
  [Brooklyn], [0.012422], [1.037267], [1.434783], [0.87], [72.29],
  [Manhattan], [0.016667], [1.138889], [1.311111], [1.27], [86.86],
  [Queens], [0.017857], [1.321429], [1.660714], [1.08], [79.57],
  [Staten Island], [0.000000], [0.000000], [1.200000], [0.00], [0.00],
)

#table(
  columns: 5,
  align: (left, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,

  [YearMonth], [TotalFatality], [TotalInjury], [TotalIncident], [FatalityRate%],
  [2024-01], [0], [50], [57], [0.00],
  [2024-02], [2], [42], [53], [3.77],
  [2024-03], [0], [53], [59], [0.00],
  [2024-04], [0], [51], [64], [0.00],
  [2024-05], [0], [46], [62], [0.00],
  [2024-06], [2], [55], [74], [2.70],
  [2024-07], [1], [42], [54], [1.85],
  [2024-08], [0], [43], [49], [0.00],
  [2024-09], [0], [33], [41], [0.00],
  [2024-10], [1], [33], [44], [2.27],
  [2024-11], [0], [22], [37], [0.00],
  [2024-12], [1], [33], [40], [2.50],
)
= Monthly Rate Trends

#figure(
  image("figures/month_rate_line.jpg", width: 80%),
  caption: [Month-level fatality and injury rate trends],
)
#table(
  columns: 7,
  align: (left, left, right, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,

  [Borough], [YearMonth], [TotalFatality], [TotalInjury], [TotalIncident], [FatalityRate%], [InjuryRate%],
  [Bronx], [2024-01], [0], [4], [4], [0.0], [100.00],
  [Bronx], [2024-02], [0], [2], [3], [0.0], [66.67],
  [Bronx], [2024-03], [0], [6], [6], [0.0], [100.00],
  [Bronx], [2024-04], [0], [6], [7], [0.0], [85.71],
  [Bronx], [2024-05], [0], [7], [8], [0.0], [87.50],
)
Excerpt shown above; the full cleaned panel is exported as `borough_month_summary`.
#figure(
  image("figures/fatality_rate_heatmap.jpg", width: 80%),
  caption: [Month-level fatality and injury rate trends],
)


== Weighted HVI
Weighted averaging is used when different observations contribute unequally to an aggregate measure.
Here, each record represents a borough–month, and each has:

a Heat Vulnerability Index (HVI), and

a number of incidents (IncidentCount).

Since a borough-month with 100 incidents carries more information about actual human exposure than one with only 2 incidents, we weight the mean by IncidentCount rather than giving all months equal influence.


== Global Correlation

#table(
  columns: 6,
  align: (left, right, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,
  [ ], [TotalIncidents], [Fatality], [Injury], [AvgTemp], [AvgPrecip],
  [TotalIncidents], [1.000], [0.120], [0.958], [0.025], [0.023],
  [Fatality], [0.120], [1.000], [0.075], [-0.007], [-0.153],
  [Injury], [0.958], [0.075], [1.000], [0.020], [0.019],
  [AvgTemp], [0.025], [-0.007], [0.020], [1.000], [0.707],
  [AvgPrecip], [0.023], [-0.153], [0.019], [0.707], [1.000],
)

#v(0.6em)

#table(
  columns: 6,
  align: (left, right, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,
  [ ], [HVI_w], [Brooklyn], [Manhattan], [Queens], [Staten Island],
  [TotalIncidents], [-0.573], [0.485], [0.513], [-0.305], [-0.387],
  [Fatality], [-0.093], [0.045], [0.161], [-0.071], [-0.099],
  [Injury], [-0.596], [0.347], [0.606], [-0.287], [-0.417],
  [AvgTemp], [-0.000], [-0.011], [-0.011], [-0.011], [0.067],
  [AvgPrecip], [0.005], [-0.012], [-0.012], [-0.012], [0.074],
)

#v(0.6em)

#table(
  columns: 6,
  align: (left, right, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,
  [ ], [HVI_w], [Brooklyn], [Manhattan], [Queens], [Staten Island],
  [HVI_w], [1.000], [-0.047], [-0.759], [0.201], [-0.205],
  [Brooklyn], [-0.047], [1.000], [-0.300], [-0.300], [-0.158],
  [Manhattan], [-0.759], [-0.300], [1.000], [-0.300], [-0.158],
  [Queens], [0.201], [-0.300], [-0.300], [1.000], [-0.158],
  [Staten Island], [-0.205], [-0.158], [-0.158], [-0.158], [1.000],
)


Figure 1. Correlation heatmap

#figure(
  image("figures/global_correlation_heatmap.jpg", width: 80%),
  caption: [Month-level fatality and injury rate trends],
)

== Log map
#figure(
  image("figures/log_scaled_correlation_heatmap.jpg", width: 80%),
  caption: [Month-level fatality and injury rate trends],
)
In order to get rid of log(0) just delete some meaningless parameter.

== regression model and plane
=== Poisson for Injury
#table(
  columns: 7,
  align: (left, right, right, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,

  [Variable], [coef], [std err], [z], [P>|z|], [0.025], [0.975],
  [Intercept], [0.1547], [1.059], [0.146], [0.884], [-1.921], [2.230],
  [Brooklyn], [-0.2823], [0.307], [-0.919], [0.358], [-0.884], [0.320],
  [Manhattan], [-0.2225], [0.528], [-0.421], [0.674], [-1.258], [0.813],
  [Queens], [-0.1458], [0.254], [-0.574], [0.566], [-0.643], [0.352],
  [Staten Island], [-21.7844], [1.33e+04], [-0.002], [0.999], [-2.6e+04], [2.6e+04],
  [AvgTemp], [-0.0019], [0.004], [-0.445], [0.650], [-0.010], [0.006],
  [AvgPrecip], [0.0521], [0.154], [0.337], [0.736], [-0.255], [0.359],
  [HVI_w], [-0.0965], [0.193], [-0.500], [0.617], [-0.475], [0.282],
)

#figure(
  image("figures/poisson_injury_coefficients.jpg", width: 80%),
  caption: [Month-level fatality and injury rate trends],
)
=== Negative Binomial for fatality

#table(
  columns: 7,
  align: (left, right, right, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,

  [Variable], [coef], [std err], [z], [P>|z|], [0.025], [0.975],
  [Intercept], [-9.6771], [10.237], [-0.945], [0.345], [-29.742], [10.387],
  [Brooklyn], [2.6615], [3.226], [0.825], [0.409], [-3.662], [8.985],
  [Manhattan], [6.3483], [5.632], [1.127], [0.260], [-4.690], [17.387],
  [Queens], [2.0102], [2.608], [0.771], [0.441], [-3.101], [7.121],
  [Staten Island], [-12.8188], [1.26e+04], [-0.001], [0.999], [-2.46e+04], [2.46e+04],
  [AvgTemp], [0.0391], [0.044], [0.881], [0.379], [-0.048], [0.126],
  [AvgPrecip], [-1.8932], [1.459], [-1.298], [0.194], [-4.753], [0.966],
  [HVI_w], [2.3466], [2.061], [1.139], [0.255], [-1.693], [6.386],
)

#figure(
  image("figures/neg_bin_fatality_coefficients.jpg", width: 80%),
  caption: [Month-level fatality and injury rate trends],
)
=== logistical modeling
#table(
  columns: 7,
  align: (left, right, right, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,

  [Variable], [coef], [std err], [z], [P>|z|], [0.025], [0.975],
  [Intercept], [-8.1713], [8.01e+06], [-1.02e−06], [1.000], [-1.57e+07], [1.57e+07],
  [Brooklyn], [5.1530], [5.176], [0.996], [0.319], [-4.992], [15.298],
  [Manhattan], [12.6504], [10.640], [1.189], [0.234], [-8.204], [33.504],
  [Queens], [4.0825], [4.332], [0.942], [0.346], [-4.427], [12.592],
  [Staten Island], [-11.9435], [1.46e+04], [-0.001], [0.999], [-2.86e+04], [2.86e+04],
  [Month_2], [21.5534], [3.45e+07], [0.000], [1.000], [-8.82e+07], [8.82e+07],
  [Month_3], [1.5652], [1e+09], [1.56e−09], [1.000], [-1.96e+09], [1.96e+09],
  [Month_4], [-1.2629], [7.31e+07], [−1.73e−08], [1.000], [−1.43e+08], [1.43e+08],
  [Month_5], [−0.1959], [5.55e+07], [−3.53e−09], [1.000], [−1.09e+08], [1.09e+08],
  [Month_6], [14.1388], [5.82e+07], [2.44e−07], [1.000], [−1.14e+08], [1.14e+08],
  [Month_7], [11.9547], [5.97e+07], [2.00e−07], [1.000], [−1.17e+08], [1.17e+08],
  [Month_8], [−11.5953], [5.93e+07], [−1.96e−07], [1.000], [−1.16e+08], [1.16e+08],
  [Month_9], [−13.6277], [9.72e+07], [−1.40e−07], [1.000], [−1.91e+08], [1.91e+08],
  [Month_10], [28.4699], [5.43e+07], [5.24e−07], [1.000], [−1.06e+08], [1.06e+08],
  [Month_11], [−50.2970], [3.74e+07], [−1.34e−06], [1.000], [−1.39e+08], [1.39e+08],
  [Month_12], [38.5362], [4.81e+07], [7.99e−07], [1.000], [−9.42e+07], [9.42e+07],
  [AvgTemp], [1.0339], [3.304], [0.312], [0.755], [−5.442], [7.510],
  [AvgPrecip], [−22.3676], [5.44e+06], [−4.12e−06], [1.000], [−1.07e+07], [1.07e+07],
  [HVI_w], [3.6795], [3.579], [1.028], [0.304], [−3.336], [10.695],
)

== Visual Summaries (referenced figures)


#figure(
  image("figures/coef_comparison.jpg", width: 80%),
  caption: [Month-level fatality and injury rate trends],
)

#figure(
  image("figures/pred_fatal_heatmap.jpg", width: 80%),
  caption: [Month-level fatality and injury rate trends],
)
#figure(
  image("figures/pred_fatal_spatial.jpg", width: 80%),
  caption: [Month-level fatality and injury rate trends],
)

== Plan for Deliverable 3
Targets:

1. Binary injury risk per event (𝑦(𝐼) = 1[Injury≥1]
2. Count severity per borough-month (injury counts; alternative: SeverityIndex as continuous/ordinal).

Features:
Exposure (TotalIncidents) as offset or feature; Borough fixed effects; Month seasonality; collapsed event types if available; HVI/temperature retained for robustness.

Models:
1. Counts: Compare Poisson vs. Negative Binomial; consider Zero-Inflated variants if excess zeros persist.
2. Binary: Regularized logistic (L1/L2) or Firth/rare-event logit to address separation; probability calibration (Brier, ECE).

Validation:
1. Temporal split (train: early months; test: later months) to avoid leakage.
2. Rolling origin CV on borough-month panel.
3. Metrics: AUROC/AUPRC and Brier (binary); MAE/RMSE and deviance (counts).
4. Operational lift: proportion of injuries captured in top-k risk deciles.

Interpretability & Fairness:
Report borough effects and calibrated risk by borough; inspect error parity across boroughs and high-HVI ZIPs; document any systematic miscalibration.

Next Steps:
1. Add exposure controls beyond raw counts (e.g., permits, active sites) if obtainable.
2. Consider hierarchical (mixed) models with borough random effects to share strength and stabilize fatality estimates.
3. Extend window or pool across years to increase fatality signal for NegBin/logit.

== Reference 
=== data reference 


=== formula reference
Hilbe (2011), Negative Binomial Regression.
 Cameron & Trivedi (2013), Regression Analysis of Count Data.
Hosmer, D. W., Lemeshow, S., & Sturdivant, R. X. (2013). Applied Logistic Regression (3rd ed.). Wiley.
Cameron, A. C., & Trivedi, P. K. (2013). Regression Analysis of Count Data (2nd ed.). Cambridge University Press.











