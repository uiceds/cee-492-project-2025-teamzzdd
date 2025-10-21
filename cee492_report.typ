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

== Borough x Month Aggregation
We compute borough-month totals and means needed for the rate-based modeling. the exported panel (n=93 borough-months) includes:
#table(
columns: 7, align: (left, right, right, right, right, right, right), inset: 4pt, stroke: 0.5pt,
[Borough], [Year], [Month], [Injury], [Fatality], [SeverityIndex (mean)], [TotalIncidents],
[Bronx], [2024], [1], [4], [0], [0.167], [4],
[Bronx], [2024], [6], [9], [1], [0.233], [10],
[Bronx], [2024], [8], [7], [0], [0.130], [9],
[Bronx], [2024], [9], [4], [0], [0.133], [5],
[Bronx], [2024], [10], [4], [0], [0.167], [4],
)
excert; full panel saved as borough_month_aggregated.csv

== Global Correlation
We used event-level variables SeverityIndex, AvgTemp, AvgPrecip, and HVI. the Pearson correlation are small in magnitude:
 #table(
columns: 5, align: (left, right, right, right, right), inset: 4pt, stroke: 0.5pt,
[ ], [SeverityIndex], [AvgTemp], [AvgPrecip], [HVI],
[SeverityIndex], [1.000], [-0.034], [-0.038], [-0.008],
[AvgTemp], [-0.034], [1.000], [0.707], [0.029],
[AvgPrecip], [-0.038], [0.707], [1.000], [0.010],
[HVI], [-0.008], [0.029], [0.010], [1.000],
)

Figure 1. Correlation heatmap

Implication. Severity shows near-zero linear association with temperature, precipitation, or HVI at the individual-event level; temperature and precipitation co-vary (r ≈ 0.71).

== Borough × Month Correlation
Aggregating by Borough × Year × Month highlights structure relevant to operations:
#table(
columns: 8, align: (left, right, right, right, right, right, right, right), inset: 4pt, stroke: 0.5pt,
[ ], [TotalIncidents], [Injury], [Fatality], [SeverityIndex], [AvgTemp], [AvgPrecip], [HVI],
[TotalIncidents], [1.000], [0.961], [0.072], [0.094], [-0.029], [0.043], [-0.386],
[Injury], [0.961], [1.000], [0.018], [0.185], [-0.053], [0.043], [-0.398],
[Fatality], [0.072], [0.018], [1.000], [0.557], [-0.060], [-0.136], [-0.053],
[SeverityIndex], [0.094], [0.185], [0.557], [1.000], [-0.069], [-0.042], [0.179],
[AvgTemp], [-0.029], [-0.053], [-0.060], [-0.069], [1.000], [0.716], [-0.008],
[AvgPrecip], [0.043], [0.043], [-0.136], [-0.042], [0.716], [1.000], [0.016],
[HVI], [-0.386], [-0.398], [-0.053], [0.179], [-0.008], [0.016], [1.000],
)
Figure 2. Correlation heatmap (borough-month).
Implications: 
Operational load dominates injuries: TotalIncidents ↔ Injury (r = 0.961).
Severity co-moves with fatalities (r = 0.557).
HVI relates negatively to overall activity and injuries (r ≈ −0.39), suggesting fewer incidents recorded in hotter-risk ZIPs, potentially due to spatial activity patterns rather than climate stress per se.

== Distribution Transforms
We stabilize skew via log(1+x) for counts and standardize climate/HVI (z-score). Correlations persist:
#table(
columns: 7, align: (left, right, right, right, right, right, right), inset: 4pt, stroke: 0.5pt,
[ ], [log_Injury], [log_Fatality], [log_TotalIncidents], [z_AvgTemp], [z_AvgPrecip], [z_HVI],
[log_Injury], [1.000], [0.066], [0.951], [-0.065], [0.040], [-0.190],
[log_Fatality], [0.066], [1.000], [0.127], [-0.047], [-0.113], [-0.057],
[log_TotalIncidents], [0.951], [0.127], [1.000], [-0.054], [0.025], [-0.247],
[z_AvgTemp], [-0.065], [-0.047], [-0.054], [1.000], [0.716], [-0.008],
[z_AvgPrecip], [0.040], [-0.113], [0.025], [0.716], [1.000], [0.016],
[z_HVI], [-0.190], [-0.057], [-0.247], [-0.008], [0.016], [1.000],
)
Figure 3. Correlation heatmap after log/z transforms.
Implication. The exposure signal remains (log incidents ↔ log injuries ≈ 0.95); climate/HVI associations remain weak.

== Visual Summaries (referenced figures)
Figure 1. Event-level correlations (Severity vs. climate/HVI).
Figure 2. Borough-month correlations (Injury/Severity vs. exposure, climate, HVI).
Figure 3. Transformed correlations (log counts; standardized climate/HVI).
Figure 4. Coefficient contrast: Poisson (injury) vs. NegBin (fatality).
Figure 5. Predicted injury rate vs. temperature (Poisson; Manhattan; offset = 1).
Figure 6. Logistic predicted probabilities vs. temperature (injury & fatality).
Figure 7. Borough heatmaps of predicted injury/fatality rates.
(All figures follow Science figure prep guidance: no titles, captions here; text size matches body; subfigures labeled where applicable.)


= Predictive Modeling
A section entitled "Predictive Modeling", including a brief plan for the predictive model you will create for Deliverable 3.

We model injury risk and severity at the borough-month level that counts with axposure and event-level occurrence (binary outcomes). Exposure is proxied by TotalIncidents using a log offset.
== Count Models (Borough × Month)

Specification:
i. Injury (Poisson GLM): Injury ~ AvgTemp + HVI + C(Borough) with offset logExp = log(TotalIncidents)
ii. Fatality (NegBin GLM): Fatality ~ AvgTemp + HVI + C(Borough) with the same offset

Key results (n = 93 borough-months):
Poisson—Injury (Pseudo  ≈ 0.128):
Staten Island effect is significant and negative (coef −1.559, p = 0.018).
AvgTemp (p = 0.722) and HVI (p = 0.347) are not significant once exposure and borough are controlled.

NegBin—Fatality (Pseudo ≈ 0.010):
No covariates reach significance; fatal events are rare and noisy at this aggregation, favoring either longer horizons or pooling strategies.
Interpretation. Spatial effects dominate: conditioning on exposure, borough differences explain most variation in injuries; climate and HVI do not add predictive power in this window.

Figures:
Figure 4. Coefficient bars (Poisson vs. NegBin).
Figure 5. Predicted injury rate vs temperature (holding HVI at mean, borough = Manhattan).
Figure 7. Borough-level predicted injury/fatality heatmaps (model means).

== Event-Level Logistic Models
Specification:
- HasInjury ~ AvgTemp + HVI + C(Borough) + C(Month) (n = 949; Pseudo R² = 0.0337, LLR p = 0.0045).
- HasFatal ~ AvgTemp + HVI + C(Borough) + C(Month) (optimization warning; quasi-separation).
Key results:
- Injury model: Brooklyn has lower odds vs. reference (coef −0.804, p = 0.006); month and climate/HVI terms are not robustly significant.
- Fatality model: Non-convergence and quasi-separation indicate extremely sparse positives; standard logit is unreliable without penalization/rare-event adjustments.

Figure 6. Predicted probabilities vs. temperature (injury and fatality logit curves; hold HVI at mean, borough = Manhattan, month = July).

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










