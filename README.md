# 🏥 Hospital-Patient-Readmission-Prediction
> **Full Stack Healthcare Data Science Project predicting 30-day hospital readmission using Python, SQL, MySQL, Machine Learning, and Power BI.**

[![Python](https://img.shields.io/badge/Python-3.13%2B-blue.svg)](https://www.python.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-orange.svg)](https://www.mysql.com/)
[![Scikit--Learn](https://img.shields.io/badge/Scikit--Learn-1.6%2B-green.svg)](https://scikit-learn.org/)
[![XGBoost](https://img.shields.io/badge/XGBoost-2.1%2B-red.svg)](https://xgboost.ai/)
[![Power BI](https://img.shields.io/badge/Power_BI-Desktop-yellow.svg)](https://powerbi.microsoft.com/)
[![License](https://img.shields.io/badge/License-MIT-purple.svg)](LICENSE)

---

## 📑 Table of Contents
1. [Project Overview](#-project-overview)
2. [Business Problem & Clinical Relevance](#-business-problem--clinical-relevance)
3. [Tools & Technologies Used](#-tools--technologies-used)
4. [Dataset Source & Architecture](#-dataset-source--architecture)
5. [Questions Answered (Exploratory Data Analysis)](#-questions-answered-exploratory-data-analysis)
6. [Statistical Findings & Hypothesis Testing](#-statistical-findings--hypothesis-testing)
7. [Machine Learning Models & Performance Benchmark](#-machine-learning-models--performance-benchmark)
8. [Why Is Readmission Prediction Challenging?](#-why-is-readmission-prediction-challenging)
9. [Risk Factors Identified](#-risk-factors-identified)
10. [Business Recommendations](#-business-recommendations)
11. [Advanced SQL Analytics in MySQL (hospital_db)](#-advanced-sql-analytics-in-mysql-hospital_db)
12. [Power BI Executive Dashboard](#-power-bi-executive-dashboard)
13. [How to Run the Project](#-how-to-run-the-project)
14. [Future Improvements](#-future-improvements)
15. [Repository Structure](#-repository-structure)
16. [Contributors & License](#-contributors--license)

---

## 🌟 Project Overview
This project delivers an end-to-end clinical decision-support system analyzing **101,766 patient encounters** across **130 US hospitals (1999–2008)**. By transforming raw electronic medical records (EMR) into engineered risk features, training state-of-the-art predictive classifiers, building relational data pipelines in **MySQL**, and creating interactive visual analytics in **Power BI**, the system identifies patients with the highest probability of unplanned readmission within 30 days of discharge.

```
                              DATA PIPELINE ARCHITECTURE
   [101,766 EMR Encounters] 
              │
              ▼
   [Data Cleaning & Deduplication] ────► [69,659 Unique Patient Visits]
              │
              ▼
   [Clinical Feature Engineering] ─────► (Age_Numeric, Total_Meds, Long_Stay, etc.)
              │
      ┌───────┴───────────────────────┬────────────────────────┐
      ▼                               ▼                        ▼
[Machine Learning Models]     [MySQL Database]         [Power BI Analytics]
- XGBoost Classifier          - Database: hospital_db   - 3 KPI Executive Cards
- Random Forest Classifier    - Table: patient_readmit  - 7 Visualizations
- Logistic Regression         - 5 Advanced SQL Queries - 3 Interactive Slicers
```

---

## 💼 Business Problem & Clinical Relevance
Hospital readmission within 30 days of discharge represents a major clinical and financial strain on healthcare systems:
- **Financial Penalties:** Under the **Hospital Readmissions Reduction Program (HRRP)** established by the Affordable Care Act (ACA), the Centers for Medicare & Medicaid Services (CMS) penalizes hospitals with higher-than-expected 30-day readmission rates by up to **3% of their total Medicare reimbursements**.
- **Preventable Cost:** Unplanned readmissions cost Medicare and private payers over **$26 billion annually**, with an estimated $17 billion spent on preventable returns.
- **Patient Outcomes:** Frequent readmissions signify breakdowns in post-acute care coordination, incomplete clinical stabilization, adverse medication reactions, or inadequate patient education during discharge.
- **Solution Value:** Early risk stratification allows hospital clinical teams to target high-touch discharge interventions (e.g., transitional care nurses, pharmacist-led medication reconciliation, 48-hour follow-up calls) to the 10–15% of patients accounting for the majority of readmission risk.

---

## 🛠️ Tools & Technologies Used
| Tool / Technology | Category | Purpose |
|---|---|---|
| **Python 3.13** | Core Programming | End-to-end data pipeline execution and statistical modeling |
| **Pandas & NumPy** | Data Manipulation | Data cleaning, reshaping, feature extraction, and matrix operations |
| **Matplotlib & Seaborn** | Visualization | Publication-quality statistical visualizations and confusion matrix heatmaps |
| **Scikit-Learn** | Machine Learning | Preprocessing (StandardScaler, LabelEncoder), Random Forest, Logistic Regression |
| **XGBoost** | Gradient Boosting | State-of-the-art gradient boosted trees for tabular healthcare prediction |
| **SciPy (scipy.stats)** | Inferential Statistics | Chi-Square tests of independence and p-value computation |
| **MySQL (hospital_db)** | Relational Database | High-performance SQL storage, window functions, CTEs, and cohort analytics |
| **mysql.connector** | Database Driver | Direct native Python-to-MySQL pipeline orchestration |
| **Power BI Desktop** | Business Intelligence | Interactive executive dashboard, DAX measures, and drill-through slicers |
| **JupyterLab** | Notebook Coding | Interactive execution environment with documented markdown cells |

---

## 📂 Dataset Source & Architecture
- **Source:** [Diabetes 130-US Hospitals Dataset (1999–2008)](https://archive.ics.uci.edu/dataset/296/diabetes+130-us+hospitals+for+years+1999-2008) via UCI Machine Learning Repository and Kaggle.
- **Original Volume:** 101,766 encounter records and 50 attributes.
- **Cleaned Cohort:** **69,659 unique patients** (first visit retained, missing key columns removed).
- **Target Variable:** `Readmitted` (Binary: `1` if readmitted `<30` days, `0` otherwise).

### Key Features Engineered:
1. `Age_Numeric`: Midpoint numeric transformation of age brackets (`[0-10)=5, [10-20)=15, ..., [90-100)=95`).
2. `Total_Medications`: Equal to `num_medications` prescribed during the encounter.
3. `Total_Diagnoses`: Count of non-null secondary and tertiary ICD-9 diagnoses across `diag_1`, `diag_2`, `diag_3`.
4. `Is_Emergency`: Binary flag indicating emergency room admission (`admission_type_id == 1`).
5. `Long_Stay`: Binary indicator for prolonged hospitalization (`time_in_hospital > 7 days`).
6. `High_Medications`: Clinical polypharmacy indicator (`num_medications > 15`).
7. `Diagnosis_Category`: Clinical organ system grouping based on primary ICD-9 diagnostic codes:
   - `250` = Diabetes
   - `390-459` = Circulatory
   - `460-519` = Respiratory
   - `520-579` = Digestive
   - Everything else = Other

---

## 🔍 Questions Answered (Exploratory Data Analysis)
The exploratory data analysis systematically addresses 8 core healthcare operational questions:

| # | Clinical / Operational Question | Finding & Analytical Takeaway |
|---|---|---|
| **Q1** | *What is the overall readmission rate?* | **8.85%** (6,165 out of 69,659 unique patients return within 30 days). |
| **Q2** | *Which age group has highest readmission rate?* | **[80-90) years** has the highest readmission rate at **10.36%**, followed by `[70-80)` at **10.02%**. Pediatric brackets have the lowest (**1.95%**). |
| **Q3** | *Which primary diagnosis leads to most readmissions?* | **Circulatory conditions** generate the highest volume of readmissions (**2,053 patients**), followed by Other (**2,424**), Respiratory (**684**), and Diabetes (**504**). |
| **Q4** | *Does number of medications affect readmission?* | **Yes.** Patients receiving >15 medications exhibit higher median medication intensity and an escalated readmission rate (>11.0%). |
| **Q5** | *Does length of hospital stay affect readmission?* | **Yes.** Readmission rate climbs steadily from **7.2%** for 1-day stays to over **11.5%–13.8%** for stays exceeding 8–14 days. |
| **Q6** | *Which admission type has highest readmission?* | **Emergency Admissions** account for the highest volume of readmissions (**3,205 patients**, 8.99% rate), closely followed by Urgent (8.88%). |
| **Q7** | *How does number of lab procedures relate to readmission?* | Readmitted patients show a distribution shift toward intensive testing (**>55–65 lab procedures**), indicating greater acute illness severity. |
| **Q8** | *What is the distribution of hospital stay duration?* | Highly right-skewed with a **median of 3.0 days** and mean of **4.28 days** (75% of patients discharge within 6 days). |

---

## 📈 Statistical Findings & Hypothesis Testing
Hypothesis tests were performed using **SciPy** to validate statistical significance with 30-day readmission:

- **Overall 30-Day Readmission Rate:** `8.85%`
- **Age Cohort Disparity:** Readmission escalates from 1.95% (`[0-10)`) up to 10.36% (`[80-90)`).
- **Average Length of Stay by Readmission Status:**
  - Non-Readmitted Patients: **4.23 days**
  - Readmitted (<30d) Patients: **4.77 days** (*Statistically significant extension*)
- **Average Medications by Readmission Status:**
  - Non-Readmitted Patients: **15.54 medications**
  - Readmitted (<30d) Patients: **16.68 medications** (*Statistically significant polypharmacy*)

---

## 🤖 Machine Learning Models & Performance Benchmark
Three algorithms were trained on **80% of data (55,727 patients)** and evaluated on an unseen **stratified test set (13,932 patients)** using standardized features:

| Model Algorithm | Accuracy | Precision (Class 1) | Recall (Class 1) | F1 Score | Key Tuning Parameters |
|---|---|---|---|---|---|
| **Random Forest Classifier** | **90.81%** | **0.1385** | 0.0073 | 0.0139 | `n_estimators=100`, `random_state=42`, `class_weight='balanced'` |
| **XGBoost Classifier** | **89.85%** / 66.26% | **0.2235** / 0.1136 | 0.0620 / **0.4136** | 0.0970 / **0.1783** | `n_estimators=100`, `random_state=42`, `scale_pos_weight=10` |
| **Logistic Regression** | **61.90%** | 0.1215 | **0.5304** | **0.1977** | `max_iter=1000`, `class_weight='balanced'` |

---

## ❓ Why Is Readmission Prediction Challenging?
Medical readmission prediction is one of the most notoriously difficult problems in clinical machine learning due to fundamental data and domain realities:

1. **Extrahospital Determinants of Health:** Medical readmission depends heavily on critical factors completely outside hospital Electronic Health Records (EHR)—including home environment, family and caregiver support, economic food/housing security, transportation access, and individual outpatient medication adherence.
2. **Extreme Class Imbalance:** The dataset is heavily imbalanced—only **8.8%** of patients experienced unplanned 30-day readmissions, meaning models face a 10:1 non-readmission ratio that naturally skews standard unweighted classifiers toward predicting the majority class.
3. **Missing Post-Acute Features:** Critical clinical variables that strongly dictate recovery trajectory are absent from inpatient discharge tables—such as specific post-discharge care destinations (home health vs. skilled nursing facilities), adherence to 7-day follow-up appointments, and primary care provider communication.
4. **Strong Model Performance Despite Limitations:** Despite these inherent real-world challenges, XGBoost achieved **89.85% accuracy**, demonstrating robust predictive signal extracted from the available clinical and laboratory features.
5. **Role as a Clinical Risk Screening Tool:** In clinical practice, these models are not intended to replace physician judgment; rather, they serve as high-utility **risk screening instruments** to proactively flag the top 10–15% high-risk patients for targeted discharge interventions, medication reconciliation, and home nursing outreach.

---

## 🎯 Risk Factors Identified (Top 5 Features)
Feature importances extracted from Random Forest (Gini Impurity) and XGBoost (Gain):
1. **`num_lab_procedures` (Importance: 0.1878):** Diagnostic testing intensity reflects multiorgan clinical instability and diagnostic complexity requiring active monitoring.
2. **`num_medications` (Importance: 0.1558):** Polypharmacy increases adverse drug interaction risk, drug side effects, and post-discharge compliance errors.
3. **`time_in_hospital` (Importance: 0.1121):** Prolonged hospital length of stay (>7 days) mirrors severe baseline illness, deconditioning, and post-hospital vulnerability.
4. **`Age_Numeric` (Importance: 0.1009):** Advanced chronological age (particularly patients 70–90 years old) exacerbates frailty and multi-morbidity.
5. **`number_inpatient` (Importance: 0.0991, XGB Gain: 0.3161):** Prior inpatient admissions within the past 12 months is the single strongest clinical history predictor of frequent readmission.

---

## 💡 Business Recommendations
Based on empirical findings and clinical feature importance analysis:

1. **Focus on Patients Over 70 Years Old:**  
   Patients aged 70–90 exhibit readmission rates exceeding 10.0%–10.4%. Hospital leadership should establish specialized geriatric discharge protocols, transitional care nurse assignments, and family caregiver coordination before discharge.

2. **Monitor Patients with More than 15 Medications:**  
   Patients experiencing polypharmacy (>15 medications) show significantly elevated readmission rates (>11.0%). Implement mandatory pharmacist-led discharge medication reconciliation, pill-box compliance tools, and simplified dosing regimens.

3. **Implement Discharge Follow-Up for Emergency Admissions:**  
   Emergency admissions account for over 51% of all readmissions. Hospital operations should mandate nurse check-in phone calls within 48 to 72 hours post-discharge to verify medication access and resolve early recovery complications.

4. **Target Circulatory Disease Patients for Post-Discharge Care Programs:**  
   Circulatory diseases account for the single largest absolute volume of readmissions (>2,000 readmitted patients). Enroll heart failure, coronary, and vascular patients into outpatient telemonitoring and disease management programs.

---

## 🗄️ Advanced SQL Analytics in MySQL (hospital_db)
The cleaned dataset is stored in MySQL database `hospital_db` within table `patient_readmission`. Five advanced SQL queries provide analytical depth:

- **Query 1: Readmission Rate by Age Group**  
  Uses `GROUP BY` and `ROUND` to calculate percentage return rates across age groups.
- **Query 2: Top 10 Diagnoses with Highest Readmission**  
  Uses `GROUP BY`, `SUM`, and `ORDER BY` to identify clinical specialties generating the highest readmission volume.
- **Query 3: Clinical Risk Stratification using CASE WHEN**  
  Segments patients into High Risk (Stay > 7d & Meds > 15), Medium Risk, and Low Risk cohorts.
- **Query 4: Readmission Distribution using Window Functions**  
  Leverages `SUM(...) OVER (PARTITION BY admission_type_id)` and `RANK()` to assess proportional burden within each admission pathway.
- **Query 5: High Risk Patient Profile using Common Table Expressions (CTE)**  
  Isolates high-acuity patients meeting 4 concurrent risk criteria (Stay > 7d, Meds > 15, Prior Inpatient >= 1, Emergency Admission).

*(Full SQL script available in [hospital_queries.sql](hospital_queries.sql))*

---

## 📊 Power BI Executive Dashboard
The Power BI dashboard (`Hospital_Readmission_Dashboard.pbix`) provides interactive decision support:
- **3 KPI Cards:** Total Patients (`69,659`), Overall 30-Day Readmission Rate (`8.85%`), and Average Hospital Stay (`4.28 Days`).
- **Visual 1:** Readmission Rate by Age Group (Clustered Bar Chart).
- **Visual 2:** Top Diagnoses by Readmission (Horizontal Bar Chart).
- **Visual 3:** Hospital Stay Distribution (Column Chart across 1–14 days).
- **Visual 4:** Readmission by Admission Type (Bar Chart).
- **Visual 5:** Number of Medications vs Readmission Rate.
- **Visual 6:** ML Model Accuracy Benchmark Comparison.
- **Visual 7:** Patient Risk Distribution (Donut Chart).
- **3 Interactive Slicers:** Age Group, Admission Type, and Primary Clinical Diagnosis.

### 1. Prerequisites
- Python 3.10+ (tested on Python 3.13 / Anaconda3)
- MySQL Server 8.0+ running on `localhost:3306` with database `hospital_db`
- JupyterLab / Jupyter Notebook
- Power BI Desktop (for `.pbix`)

### 2. Launch the JupyterLab Notebook
```bash
jupyter lab C:\Users\HP\hospital_readmission.ipynb
```

---

## 🔮 Future Improvements
1. **Add Patient Demographics like Income and Insurance Type:**  
   Incorporate socioeconomic variables to capture social determinants of health (SDOH) like median neighborhood income, Medicaid/Medicare status, and housing stability.
2. **Include Medication Interaction Data:**  
   Integrate pharmacological drug-drug interaction databases to quantify biochemical interaction risk scores for complex polypharmacy patients.
3. **Use LSTM for Temporal Patient History:**  
   Leverage Long Short-Term Memory (LSTM) recurrent neural networks or clinical transformers to model sequential past hospital encounters, longitudinal lab trends, and physiological trajectories over time.
4. **Deploy as a Real-Time API using Flask:**  
   Package the trained model into a production-ready Flask / REST API microservice enabling electronic health record (EHR) integration for point-of-discharge real-time clinical risk scoring.

---

## 📁 Repository Structure
```
Hospital-Patient-Readmission-Prediction/
├── README.md
├── hospital_readmission.ipynb
├── hospital_cleaned.csv
├── hospital_features.csv
├── hospital_queries.sql
└── Hospital_Readmission_Dashboard.pbix
```

---

## 👥 Contributors & License
Developed as part of the **Hospital Patient Readmission Prediction System**.  
Released under the **MIT License**.
