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

== Construction Management Related
The dataset consists of construction-related incidents and accidents in New York City. It provides a large-scale CSV file suitable for predictive analysis.

== File Content

=== Source
New York City Building Incident and Accident Reports.

=== Format and Size
The dataset includes approximately 958 rows, each representing an accident or incident record, and 20 columns containing attribute fields of these records.

=== Attributes
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
The objective is to use regression models to predict fatality, injury, and an index of severity for construction incidents based on temporal and spatial variables.

== Preprocessing
Filtering may be applied to eliminate less effective variables, such as postcode, to improve model performance.

== Output
- Fatality count  
- Injury count  
- Computed severity index (e.g., grade scale from 1 = less severe to 10 = highly severe)

== Input
Date, record type, latitude, longitude, type of incident, and BIN (business effect case, combined with other data).

== Mathematical Formulation
$$
Injury/Fatality\ Index = \beta_0 + \beta_1 (type\ of\ events) + \beta_2 (time) \\
+ \beta_3 (other\ variables)
$$



If injury numbers are used as dependent variables, Poisson or negative binomial regression may be applied.

== Significance
The purpose of the model is to help avoid incidents and accidents by identifying the dominant attributes influencing outcomes, thereby guiding proactive protection measures in construction management.






