-- ==============================================================================
-- PROJECT: Hospital Patient Readmission Prediction System
-- DATABASE: MySQL (hospital_db)
-- TABLE: patient_readmission
-- AUTHOR: Healthcare Data Science Team
-- DESCRIPTION: 5 Advanced Clinical SQL Queries for Readmission Analytics
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- DATABASE SETUP & TABLE CREATION SCRIPT
-- ------------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS hospital_db;
USE hospital_db;

-- ------------------------------------------------------------------------------
-- QUERY 1: Readmission Rate by Age Group using GROUP BY and ROUND
-- Business Purpose:
--   Evaluates how 30-day unplanned readmission rates scale across chronological
--   age cohorts to support geriatric discharge protocols and resource allocation.
-- ------------------------------------------------------------------------------
SELECT 
    age AS age_group,
    COUNT(*) AS total_patients,
    SUM(Readmitted) AS readmitted_patients,
    ROUND((SUM(Readmitted) * 100.0 / COUNT(*)), 2) AS readmission_rate_pct
FROM patient_readmission
GROUP BY age
ORDER BY readmission_rate_pct DESC;


-- ------------------------------------------------------------------------------
-- QUERY 2: Top 10 Diagnoses with Highest Readmission using GROUP BY and ORDER BY
-- Business Purpose:
--   Identifies the primary clinical organ system diagnoses associated with
--   the highest volume of readmissions, highlighting high-risk clinical specialties.
-- ------------------------------------------------------------------------------
SELECT 
    Diagnosis_Category AS primary_diagnosis_group,
    COUNT(*) AS total_patients,
    SUM(Readmitted) AS readmitted_patients,
    ROUND((SUM(Readmitted) * 100.0 / COUNT(*)), 2) AS readmission_rate_pct
FROM patient_readmission
GROUP BY Diagnosis_Category
ORDER BY readmitted_patients DESC
LIMIT 10;


-- ------------------------------------------------------------------------------
-- QUERY 3: Risk Classification of Patients using CASE WHEN
-- Business Purpose:
--   Segments the inpatient population into actionable risk tiers (High, Medium,
--   Low) based on clinical complexity: Polypharmacy (num_medications > 15) and
--   extended hospital length of stay (time_in_hospital > 7 days).
-- ------------------------------------------------------------------------------
SELECT 
    CASE 
        WHEN time_in_hospital > 7 AND num_medications > 15 THEN 'High Risk'
        WHEN time_in_hospital > 4 OR num_medications > 10 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_classification,
    COUNT(*) AS total_patients,
    SUM(Readmitted) AS readmitted_patients,
    ROUND((SUM(Readmitted) * 100.0 / COUNT(*)), 2) AS readmission_rate_pct,
    ROUND(AVG(time_in_hospital), 2) AS avg_hospital_stay_days,
    ROUND(AVG(num_medications), 2) AS avg_medications_prescribed
FROM patient_readmission
GROUP BY risk_classification
ORDER BY readmission_rate_pct DESC;


-- ------------------------------------------------------------------------------
-- QUERY 4: 30-Day vs Other Readmission Comparison using Window Functions
-- Business Purpose:
--   Compares readmission categories (<30 days, >30 days, NO) across admission
--   types (Emergency, Urgent, Elective) using SQL Window Functions (PARTITION BY,
--   OVER, and RANK) to assess proportional readmission burdens.
-- ------------------------------------------------------------------------------
SELECT 
    admission_type_id,
    Admission_Type_Desc AS admission_type_description,
    readmitted_status AS readmission_category,
    COUNT(*) AS encounter_count,
    SUM(COUNT(*)) OVER (PARTITION BY admission_type_id) AS total_encounters_in_admission_type,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY admission_type_id), 2) AS pct_within_admission_type,
    RANK() OVER (PARTITION BY admission_type_id ORDER BY COUNT(*) DESC) AS encounter_volume_rank
FROM patient_readmission
GROUP BY admission_type_id, Admission_Type_Desc, readmitted_status
ORDER BY admission_type_id, encounter_count DESC;


-- ------------------------------------------------------------------------------
-- QUERY 5: High Risk Patient Profile using Common Table Expression (CTE) and Multiple Conditions
-- Business Purpose:
--   Isolates high-risk patients meeting multiple critical clinical criteria:
--   Extended stay (>7 days), Polypharmacy (>15 medications), Prior Inpatient
--   visits (>=1), and Emergency Admission (Is_Emergency = 1).
--   Aggregates by age bracket and primary diagnosis to uncover top risk hotspots.
-- ------------------------------------------------------------------------------
WITH HighRiskCohort AS (
    SELECT 
        patient_nbr,
        encounter_id,
        age,
        Diagnosis_Category,
        time_in_hospital,
        num_medications,
        number_inpatient,
        number_emergency,
        Readmitted
    FROM patient_readmission
    WHERE time_in_hospital > 7 
      AND num_medications > 15 
      AND number_inpatient >= 1
      AND Is_Emergency = 1
)
SELECT 
    age AS patient_age_bracket,
    Diagnosis_Category AS primary_diagnosis_category,
    COUNT(*) AS high_risk_patient_count,
    SUM(Readmitted) AS readmitted_patients_count,
    ROUND(SUM(Readmitted) * 100.0 / COUNT(*), 2) AS readmission_rate_pct,
    ROUND(AVG(time_in_hospital), 1) AS avg_hospital_stay_days,
    ROUND(AVG(num_medications), 1) AS avg_medications_prescribed
FROM HighRiskCohort
GROUP BY age, Diagnosis_Category
HAVING COUNT(*) >= 5
ORDER BY readmission_rate_pct DESC, high_risk_patient_count DESC
LIMIT 15;
