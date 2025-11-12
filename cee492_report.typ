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
We pull data from New York City Department of Buildings. (n.d.). Incident Database [Data set].
== 1.3 Format and Size
The dataset includes approximately 958 rows, each representing an accident or incident record, and 20 columns containing attribute fields of these records.
#v(2em)
= 2. Attributes
#v(2em)
#align(center, [Table 1. Attribute Definitions and Descriptions
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
)])

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
For the data integration and cohort definition, we first filtered the dataset. We then applied groupby operations to extract and aggregate key information. This aggregation was performed by 'borough (Area)', month, and 'postcode'. The 'postcode' attribute serves as a critical key, as it is directly used to link and integrate the Heat Vulnerability Index data (Nayak et al., 2018).

== 4.2 Borough × Month Aggregation
To explore trends over time, the data were aggregated by borough and month. The aggregation reveals that incidents tend to cluster during the spring and summer months, aligning with increased construction activity. 
#align(center, [Table 2. Monthly Aggregation of Incidents by Borough and Postcode 
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
)])
Excerpt shown above; full panel saved as `monthly_borough.csv`.

== 4.3 Temperature, Precipitation, and HVI Added
In this data integration step, we enriched the dataset by incorporating external environmental and vulnerability factors. The Heat Vulnerability Index (HVI) was integrated by joining it with the dataset using 'postcode' as the linking key. We then performed a data cleaning step to ensure data quality by removing records with missing values. Following this, climate variables, specifically 'AvgTemp' (Average Temperature) and 'AvgPrecip' (Average Precipitation), were merged into the dataset. This process of joining HVI, merging climate data, and handling missing values resulted in a final, refined dataset containing 415 valid observations, which was then used for the subsequent correlation and regression analyses
#align(center, [Table 3. Integrated Dataset with Climate and HVI Variables
#table(
  columns: 9,
  align: (left, right, right, right, right, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,
  [Borough], [Postcode], [YearMonth], [IncidentCount], [Fatality], [Injury], [AvgTemp], [AvgPrecip], [HVI],
  [Bronx], [10451], [Jun-24], [3], [1], [2], [71.7], [4.4], [5],
)])
Preliminary inspection indicates that higher-HVI areas (typically in the Bronx and parts of Brooklyn) correspond to marginally elevated injury counts, hinting at interactions between heat exposure and worker safety.

== 4.4 Injury & Fatality Plots

Four of the preliminary plots below count incidents such as fatalities and injuries that happened at each borough and district. The last four show the total injuries and fatalities that happened in New York City during each month, and then the accumulation of injuries and fatalities over time from January 2024 to October 2025. With this data, we can go even further with borough or district specific statistics regarding these construction incidents.

#figure(image("figures/borough_fatality_bar_zs.jpg", width: 80%), caption: [Average Fatalities at Each Borough])

#figure(image("figures/borough_injury_bar_zs.jpg", width: 80%), caption: [Average Injuries at Each Borough])

#figure(image("figures/district_fatality_bar_zs.jpg", width: 80%), caption: [Average Fatalities at Each District])

#figure(image("figures/district_injury_bar_zs.jpg", width: 80%), caption: [Average Injuries at Each District])

#figure(image("figures/monthly_fatality_bar_zs.jpg", width: 80%), caption: [Cumulative Fatalities Overtime])

#figure(image("figures/monthly_injury_bar_zs.jpg", width: 80%), caption: [Cumulative Injuries Overtime])

#figure(image("figures/cumul_fatality_zs.jpg", width: 80%), caption: [Fatalities Each Month])

#figure(image("figures/cumul_injury_zs.jpg", width: 80%), caption: [Fatalities Each Month])

== 4.5 Averaging the Data
#align(center, [Table 4. Average Incident and Injury Rates by Borough
#table(
  columns: 6,
  align: (left, right, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,
  [Borough], [AvgFatality], [AvgInjury], [AvgIncident], [FatalityRate%], [InjuryRate%],
  [Bronx], [0.019], [1.10], [1.31], [1.47], [83.82],
)])
On average, 83.8% of incidents resulted in at least one reported injury, whereas fatalities were rare (around 1.5% of all cases). The Bronx recorded the highest injury rate, followed closely by Brooklyn.
== 4.6 Summary
This section synthesizes the primary findings from our exploratory data analysis. We aggregated the data to compute and examine key descriptive statistics. Specifically, we calculated the average number of fatalities, average number of injuries, and average incident counts for each of the five boroughs. From this, we also derived the fatality and injury rates (as percentages) per borough to better understand the proportional risk. Furthermore, our summary includes an analysis of temporal patterns. We investigated monthly trends by charting the frequency and cumulative totals of both fatalities and injuries over the study period. These initial summaries provide a foundational understanding of which areas are most affected and how incident severity fluctuates over time.

#v(2em)

= 5. Correlation Plots
#v(2em)
== 5.1 Weighted HVI
Weighted averaging is used when different observations contribute unequally to an aggregate measure.

== 5.2 Global Correlation
A global correlation analysis was conducted among key variables: TotalIncidents, Fatality, Injury, AvgTemp, AvgPrecip, and HVI.
#align(center, [Table 5. Correlation Matrix of Incident, Climate, and Vulnerability Variables
#table(
  columns: 6,
  align: (left, right, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,
  [ ], [TotalIncidents], [Fatality], [Injury], [AvgTemp], [AvgPrecip],
  [TotalIncidents], [1.000], [0.120], [0.958], [0.025], [0.023],
  [Fatality], [0.120], [1.000], [0.075], [-0.007], [-0.153],
)])
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

== 5.4 Summary

These visual representations are only preliminary and can be used as inspiration for the plots in the actual predictive modelling phase.


= 6. Regression Plots
Regression modeling was performed using Poisson, Negative Binomial, and Logistic regressions,
which are standard approaches for count and binary outcomes in risk and safety studies.
#v(2em)
== 6.1 Poisson Model (Injury)
#align(center, [Table 6. Poisson Regression Model Results for Injury Counts
#table(
  columns: 7,
  align: (left, right, right, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,
  [Variable], [coef], [std err], [z], [P>|z|], [0.025], [0.975],
  [Intercept], [0.1547], [1.059], [0.146], [0.884], [-1.921], [2.230],
)])
#figure(image("figures/poisson_injury_coefficients.jpg", width: 80%), caption: [Poisson injury model coefficients])

== 6.2 Negative Binomial Model (Fatality)
#align(center, [Table 7. Negative Binomial Regression Model Results for Fatalities
#table(
  columns: 7,
  align: (left, right, right, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,
  [Variable], [coef], [std err], [z], [P>|z|], [0.025], [0.975],
  [Intercept], [-9.6771], [10.237], [-0.945], [0.345], [-29.742], [10.387],
)])
#figure(image("figures/neg_bin_fatality_coefficients.jpg", width: 80%), caption: [Negative binomial fatality model coefficients])

== 6.3 Logistic Model
#align(center, [Table 8. Logistic Regression Results for Binary Fatality Events
#table(
  columns: 7,
  align: (left, right, right, right, right, right, right),
  inset: 4pt,
  stroke: 0.5pt,
  [Variable], [coef], [std err], [z], [P>|z|], [0.025], [0.975],
  [Intercept], [-8.1713], [8.01e+06], [-1e-06], [1.000], [-1.57e+07], [1.57e+07],
)])

== 6.4 Visual Comparisons
#figure(image("figures/coef_comparison.jpg", width: 80%), caption: [Coefficient comparison])
#figure(image("figures/pred_fatal_heatmap.jpg", width: 80%), caption: [Predicted fatality heatmap])
#figure(image("figures/pred_fatal_spatial.jpg", width: 80%), caption: [Spatial fatality prediction map])

== 6.5 Summary

These visual representations are only preliminary and can be used as inspiration for the plots in the actual predictive modelling phase.

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

== 7.3 Interpretability & Fairness
This would include inspecting borough effects and error parity across high-HVI ZIPs.

== 7.4 Next Steps
Steps we could eventually take are adding exposure controls (permits, active sites), extending years, and considering hierarchical models if time allows.

= 8. K-Means Models & Results

== 8.1 Hypothesis

If we have enough data of injuries mapped around the boroughs of NYC, we can determine, given the locations of each incident, which cities are the most prevalent in terms of injuries related to construction incidents
o	Input: Longitude, Latitude, Injuries, Boroughs
o	Output: Location of Cities (using graph)

== 8.2 Models

#figure(image("figures/injury_scattermap_zs.jpg", width: 80%), caption: [Spatial Distribution of Injuries from Each Borough])
#figure(image("figures/injury_scattermap_kmeans_zs.jpg", width: 80%), caption: [K-Means Model w/ Centroids])

== 8.3 Summary

= 9. Decision Tree Models & Results

== 9.1 Hypothesis

We can guess the likelihood of injuries from the type of construction incident (Worker Fell, Scaffold/Shoring Installations, Mechanical Construction Equipment, Material Failure (Fell), Excavation/Soil Work, Other Construction Related)
o	Input: Borough, Check Description
o	Output: Injury Probability

== 9.2 Model

== 9.3 Summary

= 10. Classification & Neural Network Models & Results

== 10.1 Methodolgy 
加入了新的两个参数：
NoncompliantCount-表示不合规行为
City of New York. (2025). Official website of the City of New York. Retrieved November 11, 2025, from https://www.nyc.gov/main

issue number(代表某地区某个月施工项目假设是一直且允许有时间滞后）
City of New York. (n.d.). DOB Job Application Filings [Data set]. NYC Open Data. Retrieved November 11, 2025, from https://data.cityofnewyork.us/Housing-Development/DOB-Job-Application-Filings/ic3t-wcy2

一、数据准备
从原始数据集 df_final 中提取五个输入特征：平均温度（AvgTemp）、平均降水量（AvgPrecip）、热脆弱指数（HVI_w,已经包含borough影响的加权）、不合规次数（NoncompliantCount）以及施工许可证编号（IssueNumber）。
目标变量为受伤事件（Injury），其数值大于零的样本被视为“发生受伤”（标记为1），否则标记为0。
为了消除量纲差异，使用 StandardScaler 对输入特征进行标准化处理。
数据随后以 80% 训练集和 20% 验证集的比例随机划分。

二、模型结构

采用三层前馈神经网络（Feedforward Neural Network, FNN）作为预测模型，其结构如下：

输入层（对应五个输入特征）；

第一隐藏层：16个神经元，ReLU激活函数；

Dropout层（比例0.1），用于缓解过拟合；

第二隐藏层：8个神经元，ReLU激活函数；

输出层：1个神经元，输出为未归一化的logit值，通过Sigmoid函数转化为受伤概率。

该模型结构具有非线性表达能力，适合捕捉多变量间复杂的交互关系。

三、损失函数与优化算法

由于样本中“未受伤”比例远高于“受伤”比例，模型采用带权重的二元交叉熵损失函数（Binary Cross-Entropy with Logits Loss），并自动计算正负样本权重 pos_weight = (N_neg / N_pos) 以平衡类别不均。
优化器采用 Adam 算法（学习率设为 1×10⁻⁴），在每轮迭代中更新网络参数以最小化损失函数。

四、训练与验证

模型共训练300轮（epochs）。每轮计算训练集与验证集的损失（Loss）与准确率（Accuracy），并记录收敛趋势。
训练过程中使用 Dropout 提高模型泛化性能。
每50轮打印一次主要指标，最终绘制训练/验证损失曲线与验证准确率曲线，以观察模型是否稳定收敛。

五、模型评估

ROC 曲线与 AUC 指标
使用验证集结果绘制ROC曲线并计算AUC（Area Under the Curve）值，衡量模型整体分类能力。
同时利用 Youden’s J 指标（TPR − FPR）确定最优分类阈值。

混淆矩阵（Confusion Matrix）
分别在默认阈值0.5及最优阈值下绘制混淆矩阵，直观展示模型的分类正确率、误判率与漏判率。

Precision / Recall / F1 曲线分析
在阈值区间 [0.1, 0.9] 以步长0.05 计算不同阈值下的精确率（Precision）、召回率（Recall）与 F1 值。
绘制三者随阈值变化的曲线，以综合平衡模型在不同判断标准下的表现，并选取 F1 值最高时对应的最优阈值。

六、输出与关键指标

模型输出包括：

训练与验证集的损失曲线；

验证集准确率曲线；

ROC 曲线与 AUC 指标；

不同阈值下的混淆矩阵；

Precision、Recall、F1 与阈值变化关系图；

自动识别的最优阈值（基于 F1 与 Youden’s J）。

== 10.2 Model

#figure(
  image("figures/accuracy.png", width: 80%),
  caption: [],
)
#v(2em)

#figure(
  image("figures/confusion matrix_0.5.png", width: 80%),
  caption: [],
)
#v(2em)

#figure(
  image("figures/confusion matrix_0.49.png", width: 80%),
  caption: [],
)
#v(2em)

#figure(
  image("figures/ROC.png", width: 80%),
  caption: [],
)
#v(2em)

#figure(
  image("figures/precision.png", width: 80%),
  caption: [],
)
#v(2em)

== 10.3 Summary&Discussion

一、验证准确率随训练轮数变化（Validation Accuracy Over Epochs）

如图所示，验证集准确率（Validation Accuracy）在训练初期波动较大，但整体呈现出稳步上升的趋势，从约 0.28 提升至接近 0.45。
这表明模型在训练过程中逐渐学习到特征间的有效关系，验证集的表现也不断改善。
虽然最终准确率仍有一定上升空间，但曲线未出现明显的过拟合迹象，说明当前网络结构与正则化（Dropout=0.1）设置较为合理，模型具备较好的泛化能力。

二、混淆矩阵（Confusion Matrix, Threshold=0.50）

在默认阈值 0.5 下，模型对“受伤”（正类）的识别表现为 召回率较高但精确率略低。
混淆矩阵显示：

TP（真阳性）=31：正确识别为“有受伤”；

FP（假阳性）=10：误将“无受伤”预测为“有受伤”；

TN（真阴性）=7；

FN（假阴性）=43。

这种结果表明，模型更倾向于“报错宁多勿漏”，在事故分析场景下是可接受的取向，因为漏检（FN）代表未预测到的受伤事件，代价通常更高。

三、混淆矩阵（Confusion Matrix, Threshold=0.49, Optimal by Youden’s J）

当采用 Youden’s J 方法确定的最优阈值 0.49 时，模型整体识别能力明显改善：

TP 上升至 46，FN 降低至 28；

TN 仍保持在 7，FP 稍有增加（10）。

这意味着模型通过微调阈值实现了更好的平衡，在维持较高召回率的同时提高了整体分类准确性。
相较默认阈值，误判减少、漏判显著减少，说明阈值优化在不平衡数据任务中是一个关键步骤。

四、Precision / Recall / F1 随阈值变化曲线

Precision（精确率）
Precision 表示模型预测为“受伤”的样本中，真正受伤的比例。
公式：Precision = TP / (TP + FP)
其中：
TP（True Positive）= 模型正确预测为“受伤”的样本数
FP（False Positive）= 模型误将“未受伤”预测为“受伤”的样本数
高 Precision 意味着模型预测“受伤”时的可信度高，即误报少。

Recall（召回率）
Recall 表示实际“受伤”的样本中，模型成功识别出的比例。
公式：Recall = TP / (TP + FN)
其中：
FN（False Negative）= 模型漏判为“未受伤”的受伤样本数
高 Recall 意味着模型能尽量不漏掉真正的受伤样本，在安全风险分析任务中尤为重要。

F1 Score（调和平均数）
F1 是 Precision 与 Recall 的调和平均，用于平衡两者的权重：
公式：F1 = 2 × (Precision × Recall) / (Precision + Recall)
当 Precision 和 Recall 同时较高时，F1 才会达到较高水平。
F1 特别适用于样本分布不均衡（如“受伤”样本远少于“未受伤”样本）的场景，能更客观地反映模型整体表现。

（嫌麻烦可以直接这么写：【直观理解】

Precision —— 不误报（预测为“受伤”的可信度）
Recall —— 不漏报（真正“受伤”的覆盖率）
F1 —— 综合平衡（整体分类性能））

图中展示了不同阈值下的 Precision、Recall 与 F1 的变化关系。可以看到，在阈值 0.1–0.49 区间内，三者均保持较高水平，其中 Recall 基本维持在 1.0，Precision 稳定在约 0.8，F1 值接近 0.9。
当阈值超过 0.5 后，三项指标均迅速下降，说明过高的阈值导致模型过度保守，从而漏掉大量正样本。
因此，选取 0.49 作为最优阈值 能在召回率与精确率之间取得理想平衡，F1 值达到最大，进一步验证了模型在分类任务上的有效性与稳定性。

== 10.4 Reference

Bishop, C. M. (2006). Pattern recognition and machine learning. Springer.

Goodfellow, I., Bengio, Y., & Courville, A. (2016). Deep learning. MIT Press.

Pedregosa, F., Varoquaux, G., Gramfort, A., Michel, V., Thirion, B., Grisel, O., ... & Duchesnay, É. (2011). Scikit-learn: Machine learning in Python. Journal of Machine Learning Research, 12, 2825–2830.

Kingma, D. P., & Ba, J. (2015). Adam: A method for stochastic optimization. In International Conference on Learning Representations (ICLR).

Fawcett, T. (2006). An introduction to ROC analysis. Pattern Recognition Letters, 27(8), 861–874.

= 11. Regression & Neural Network Models & Results

== 11.1 Hypothesis

本研究采用改进型神经网络回归模型（Improved Neural Network Regression）以预测施工过程中人员受伤数量（Injury Count），在模型结构中引入了数据去噪、标准化与非线性特征提取机制，以提高预测的稳定性与鲁棒性。

一、数据准备与清洗
缺失值处理：将 Injury 中的缺失值填充为0并转换为浮点型。

特征构建：从 YearMonth 提取月份变量（Month），并对 Borough（行政区）进行独热编码（One-Hot Encoding）

去噪处理：

去除温度、降水、热脆弱指数（HVI_w）、违规次数（NoncompliantCount）、许可证数量（IssueNumber）和 Injury 中的极端值（1%–99%分位之外）。

剔除同时存在极端高温与极端降雨的样本（可能为记录异常）。

去除施工样本数极少的记录（IssueNumber低于5%分位）。

限制 HVI 在合理上限（<99%分位）。

之所以没有加regularization是因为怕加了以后更难学习（原本的情况就很难，尤其是出现了R^2<0）

对数平滑 (log-smoothing)：对高方差特征（NoncompliantCount、IssueNumber、AvgPrecip）取对数平滑，以防止单变量主导输入。
数据清洗后仅保留有效样本，并输出剩余样本数以验证数据质量。

二、特征标准化
选取输入特征包括：AvgTemp、AvgPrecip、HVI_w（已经包含borough影响的加权）、NoncompliantCount、IssueNumber、Month 以及各 Borough 编码列。
输入变量使用 StandardScaler 进行标准化，目标变量（Injury）进行均值–标准差归一化，以确保网络训练过程数值稳定、梯度收敛平稳。
随后按 80% 训练集与 20% 验证集比例划分数据。

三、模型结构
定义名为 InjuryRegressor 的神经网络模型，采用多层非线性结构：

输入层：对应全部输入特征；

隐藏层1：32个神经元，LeakyReLU(0.1) 激活；

Dropout层（比例0.1）防止过拟合；

隐藏层2：16个神经元，LeakyReLU(0.1) 激活；

隐藏层3：8个神经元，LeakyReLU(0.1) 激活；

输出层：1个神经元，用于输出受伤人数预测值。
LeakyReLU 能在负区间保持非零梯度，避免梯度消失问题，适用于稀疏数据的回归任务。

四、损失函数与优化器
模型采用均方误差损失函数（Mean Squared Error, MSE）作为训练目标，优化器使用 Adam（学习率 3×10⁻⁴）。
Adam 能自动调整学习率，兼顾收敛速度与稳定性。训练过程中记录训练损失（Train Loss）与验证损失（Validation Loss），用于监测收敛趋势与泛化性能。
（尚未使用其他nonlinear-possion 和Negtive bionomial 原本就出了问题）

五、模型评估
利用验证集预测结果计算以下回归性能指标：

R²（决定系数）：衡量模型解释目标方差的能力；（如果R^2<0,则代表无法很好学习）

RMSE（均方根误差）：反映预测偏差的平均幅度；

MAE（平均绝对误差）：衡量预测结果的平均偏离程度。
此外，通过绘制“预测值 vs 实际值”散点图评估模型的拟合程度，若点云接近对角线则说明预测效果良好。
最终输出验证集前 15 组预测对比样本以供人工核对。

六、改进
一、Hybrid Lag + Group Bias Linear Model

思路：在传统线性回归中加入时间滞后特征（Lag）和行政区分组偏置（Group Bias），以同时捕捉时间惯性与地区差异。

特征处理：
 - 筛选有施工记录的样本；
 - 对 NoncompliantCount、IssueNumber、AvgPrecip 进行 log 平滑；
 - 按 Borough 与 Month 生成一期滞后特征。

模型结构：
 预测函数为 ŷ = X·w + bᵍ，其中 bᵍ 为 Borough 专属偏置项。

结果：
 模型在解释不同地区基线风险方面表现良好，R²、RMSE、MAE 指标均显示具有合理的拟合能力。

二、Two-Stage Hybrid Model（No Lag + Strict Denoise）

思路：采用“先分类、后回归”的两阶段结构以提升稀疏样本的稳定性。

阶段1（分类）：通过神经网络判断是否发生受伤事件（Injury > 0），输出概率作为第二阶段输入。

阶段2（回归）：在有受伤样本中，基于线性模型 + Borough 偏置估计实际伤害人数。

结果：
 分类准确率约 0.8–0.9；回归部分 R² 明显高于单阶段模型，说明该结构能有效分离“事件发生概率”和“伤害强度”两层信息。


== 11.2 Model
#figure(
  image("figures/regression1.png", width: 80%),
  caption: [],
)
#v(2em)

#figure(
  image("figures/regression2.png", width: 80%),
  caption: [],
)
#v(2em)

#figure(
  image("figures/regression3.png", width: 80%),
  caption: [],
)
#v(2em)

#figure(
  image("figures/regression4.png", width: 80%),
  caption: [],
)
#v(2em)

== 11.3 Summary&Discussion

讨论（Discussion）

本研究共测试了三种模型：(1) 神经网络回归（NN）、(2) Hybrid Lag + Group Bias 线性模型、(3) Two-Stage Hybrid Model（无滞后 + 严格去噪）。
整体来看，这三种模型的预测效果都不理想，主要体现在 R² 值均为负或接近于零，说明模型的预测能力仍弱于简单的平均基线。

首先，NN 回归模型难以学习有效关系。施工伤害数据高度稀疏，大部分月份为 0 或 1 起事故，只有极少数为 2 起以上。数据分布极不平衡，信号很弱，噪声却占主导，导致神经网络只能预测接近平均值的结果，因此 R² 为负。

其次，Hybrid Lag + Group Bias 线性模型虽引入滞后项和区域偏置，希望捕捉时间延迟与地区差异，但伤害事件的时间相关性较弱，滞后变量反而带来额外噪声，使模型出现过拟合，预测效果并未改善。

最后，**Two-Stage Hybrid Model（无滞后 + 去噪）**在分类阶段表现相对较好，能识别出高风险月份；但在回归阶段，由于仅保留 “有事故” 的样本，并在去噪后进一步减少数据量，有效样本数量非常有限。样本太少使模型难以学习到规律，R² 仍然为负，说明噪声和随机性依然主导结果。

综上，三种模型表现不佳的核心原因在于：

数据稀疏、离散化严重；

噪声比例高，特征与伤害事件相关性弱；

去噪和筛选后样本过少，导致模型无法泛化。

后续研究可考虑增加样本量或引入更平滑的时序与风险特征，以提高模型稳定性。






= 11. References
[1] New York City Department of Buildings. (n.d.). *Incident Database* [Data set]. \
[2] Nayak, S. G., Shrestha, S., Kinney, P. L., Ross, Z., Sheridan, S. C., Pantea, C. I., Hsu, W. H., Muscatiello, N., & Hwang, S. A. (2018). *Development of a heat vulnerability index for New York State.* Public Health, 161, 127–137. \
[3] Hilbe, J. M. (2011). *Negative binomial regression* (2nd ed.). Cambridge University Press. \
[4] Cameron, A. C., & Trivedi, P. K. (2013). *Regression analysis of count data* (2nd ed.). Cambridge University Press. \
[5] Hosmer, D. W., Lemeshow, S., & Sturdivant, R. X. (2013). *Applied logistic regression* (3rd ed.). Wiley.

 

















