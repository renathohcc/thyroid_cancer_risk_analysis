-- Demographic distribution
	-- Per gender
SELECT 
    gender, COUNT(*) AS total
FROM
    thyroid_db
GROUP BY gender;

	-- per age
SELECT 
    CASE
        WHEN age < 30 THEN 'under 30'
        WHEN age BETWEEN 30 AND 50 THEN '30 to 50'
        ELSE 'over 50'
    END AS age_range,
    COUNT(*) AS total
FROM
    thyroid_db
GROUP BY age_range
ORDER BY total DESC;

	-- per country
SELECT 
    country, COUNT(*) AS total
FROM
    thyroid_db
GROUP BY country
ORDER BY total DESC;
	-- per ethnicity
SELECT 
    ethnicity, COUNT(*) AS total
FROM
    thyroid_db
GROUP BY ethnicity
ORDER BY total DESC;

-- Risk factors
SELECT 
    'family_history_cases' AS risk_factor, COUNT(*) AS total
FROM
    thyroid_db
WHERE
    family_history = 'y' 
UNION ALL SELECT 
    'radiation_exposure_cases', COUNT(*)
FROM
    thyroid_db
WHERE
    radiation_exposure = 'y' 
UNION ALL SELECT 
    'iodine_deficiency_cases', COUNT(*)
FROM
    thyroid_db
WHERE
    iodine_deficiency = 'y' 
UNION ALL SELECT 
    'smoking_cases', COUNT(*)
FROM
    thyroid_db
WHERE
    smoking = 'y' 
UNION ALL SELECT 
    'obesity_cases', COUNT(*)
FROM
    thyroid_db
WHERE
    obesity = 'y' 
UNION ALL SELECT 
    'diabetes_cases', COUNT(*)
FROM
    thyroid_db
WHERE
    diabetes = 'y'
ORDER BY total DESC;

-- How much risk factors per patient
SELECT 
    COUNT(*) AS total_patients,
    (family_history = 'y') +
    (radiation_exposure = 'y') +
    (iodine_deficiency = 'y') +
    (smoking = 'y') +
    (obesity = 'y') +
    (diabetes = 'y') AS num_risk_factors
FROM 
    thyroid_db
GROUP BY num_risk_factors
ORDER BY num_risk_factors DESC;

-- Distribution of TSH, T3 and T4. Existe extreme values?
SELECT 
    'TSH' AS hormone,
    MIN(tsh_level) AS min_value,
    MAX(tsh_level) AS max_value,
    AVG(tsh_level) AS avg_value,
    STDDEV(tsh_level) AS stddev_value
FROM thyroid_db

UNION ALL

SELECT 
    'T3',
    MIN(t3_level),
    MAX(t3_level),
    AVG(t3_level),
    STDDEV(t3_level)
FROM thyroid_db

UNION ALL

SELECT 
    'T4',
    MIN(t4_level),
    MAX(t4_level),
    AVG(t4_level),
    STDDEV(t4_level)
FROM thyroid_db;

-- Risk classification: What proportion of patients are classified as low, medium and high risk?
SELECT 
    thyroid_cancer_risk,
    diagnosis,
    COUNT(*) AS total_patients
FROM 
    thyroid_db
GROUP BY thyroid_cancer_risk, diagnosis
ORDER BY thyroid_cancer_risk, total_patients DESC;

-- How many cases were diagnosed as benign vs. malignant
SELECT 
    diagnosis, COUNT(*) AS total
FROM
    thyroid_db
GROUP BY diagnosis
ORDER BY total DESC;