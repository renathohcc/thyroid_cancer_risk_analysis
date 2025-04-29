-- Correlation between Age and cancer risk
SELECT 
    CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 50 THEN '30 to 50'
        Else 'Over 50'
    END AS age_range,
    thyroid_cancer_risk,
    COUNT(*) AS total,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY     
		CASE
			WHEN age < 30 THEN 'Under 30'
			WHEN age BETWEEN 30 AND 50 THEN '30 to 50'
			Else 'Over 50'
        end
        ), 2) AS percentage
FROM
    thyroid_db
GROUP BY age_range , thyroid_cancer_risk
ORDER BY age_range, total DESC;

-- Correlation between Nodule size and risk / diagnosis
SELECT 
    CASE
        WHEN nodule_size < 2 THEN 'Under 2 mm'
        WHEN nodule_size >= 2 AND nodule_size <= 4 THEN '2 mm to 4 mm'
        ELSE 'Over 4 mm'
    END AS nodule_size_range,
    thyroid_cancer_risk,
    COUNT(*) AS total,
        ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (
        PARTITION BY 
            CASE
                WHEN nodule_size < 2 THEN 'Under 2 mm'
                WHEN nodule_size >= 2 AND nodule_size <= 4 THEN '2 mm to 4 mm'
                ELSE 'Over 4 mm'
            END
    ), 2) AS percentage
FROM
    thyroid_db
GROUP BY nodule_size_range , thyroid_cancer_risk
ORDER BY nodule_size_range , total DESC;

SELECT 
    CASE
        WHEN nodule_size < 2 THEN 'Under 2 mm'
        WHEN nodule_size >= 2 and nodule_size <= 4 then '2 mm to 4 mm'
        ELSE 'Over 4 mm'
    END AS nodule_size_range,
    diagnosis,
    COUNT(*) AS total,
        ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (
        PARTITION BY 
            CASE
                WHEN nodule_size < 2 THEN 'Under 2 mm'
				WHEN nodule_size >= 2 and nodule_size <= 4 then '2 mm to 4 mm'
				ELSE 'Over 4 mm'
            END
    ), 2) AS percentage
FROM
    thyroid_db
GROUP BY nodule_size_range , diagnosis
ORDER BY nodule_size_range , total DESC;

-- How hormonal levels correlation with risk levels
-- TSH
SELECT 
	case
		when tsh_level < 4 then 'Under 4'
        when tsh_level >= 4 and tsh_level <= 7 then '4 to 7'
        else 'Over 7'
	end as tsh_range,
    thyroid_cancer_risk,
    count(*) as total,
    round(100*count(*) / sum(count(*)) over (
    partition by
		case
			when tsh_level < 4 then 'Under 4'
			when tsh_level >= 4 and tsh_level <= 7 then '4 to 7'
			else 'Over 7'
		end
	),2) as percentage
FROM
    thyroid_db
group by tsh_range, thyroid_cancer_risk
order by tsh_range, total desc;

-- T3
SELECT 
	case
		when t3_level < 1.5 then 'Under 1.5'
        when t3_level >= 1.5 and t3_level <= 3 then '1.5 to 3'
        else 'Over 3'
	end as t3_range,
    thyroid_cancer_risk,
    count(*) as total,
    round(100*count(*) / sum(count(*)) over (
    partition by
		case
		when t3_level < 1.5 then 'Under 1.5'
        when t3_level >= 1.5 and t3_level <= 3 then '1.5 to 3'
        else 'Over 3'
		end
	),2) as percentage
FROM
    thyroid_db
group by t3_range, thyroid_cancer_risk
order by t3_range, total desc;

-- T4
SELECT 
	case
		when t4_level < 8 then 'Under 8'
        when t4_level >= 8 and t4_level <= 10 then '8 to 10'
        else 'Over 10'
	end as t4_range,
    thyroid_cancer_risk,
    count(*) as total,
    round(100*count(*) / sum(count(*)) over (
    partition by
		case
		when t4_level < 8 then 'Under 8'
        when t4_level >= 8 and t4_level <= 10 then '8 to 10'
        else 'Over 10'
		end
	),2) as percentage
FROM
    thyroid_db
group by t4_range, thyroid_cancer_risk
order by t4_range, total desc;

-- What countries have more malignant cases?
SELECT 
    country, COUNT(*) AS total_malignant_cases
FROM
    thyroid_db
GROUP BY country
ORDER BY total_malignant_cases DESC
LIMIT 5;

-- percentage of malignant cases by country
SELECT 
    country,
    COUNT(CASE WHEN diagnosis = 'malignant' THEN 1 ELSE NULL END) AS total_malignant_cases,
    round(COUNT(CASE WHEN diagnosis = 'malignant' THEN 1 ELSE NULL END) * 100.0 
    / COUNT(*),2) AS percentage_malignant
FROM
    thyroid_db
GROUP BY country
ORDER BY percentage_malignant DESC, total_malignant_cases DESC
LIMIT 5;

-- Combination of risks factors
SELECT 
    CONCAT(CASE
                WHEN family_history = 'y' THEN 'Family History, '
                ELSE ''
            END,
            CASE
                WHEN radiation_exposure = 'y' THEN 'Radiation Exposure, '
                ELSE ''
            END,
            CASE
                WHEN iodine_deficiency = 'y' THEN 'Iodine Deficiency, '
                ELSE ''
            END,
            CASE
                WHEN smoking = 'y' THEN 'Smoking, '
                ELSE ''
            END,
            CASE
                WHEN obesity = 'y' THEN 'Obesity, '
                ELSE ''
            END,
            CASE
                WHEN diabetes = 'y' THEN 'Diabetes, '
                ELSE ''
            END) AS risk_factors_combination,
    COUNT(*) AS total_patients,
    COUNT(CASE
        WHEN diagnosis = 'malignant' THEN 1
        ELSE NULL
    END) AS malignant_cases,
    ROUND(COUNT(CASE
                WHEN diagnosis = 'malignant' THEN 1
                ELSE NULL
            END) * 100.0 / COUNT(*),
            2) AS percentage_malignant
FROM
    thyroid_db
WHERE
    family_history = 'y'
        OR radiation_exposure = 'y'
        OR iodine_deficiency = 'y'
        OR smoking = 'y'
        OR obesity = 'y'
        OR diabetes = 'y'
GROUP BY risk_factors_combination
ORDER BY percentage_malignant DESC , malignant_cases DESC;

SELECT 
    CONCAT(
        CASE WHEN family_history = 'y' THEN 'FH, ' ELSE '' END,
        CASE WHEN radiation_exposure = 'y' THEN 'RE, ' ELSE '' END,
        CASE WHEN iodine_deficiency = 'y' THEN 'ID, ' ELSE '' END,
        CASE WHEN smoking = 'y' THEN 'S, ' ELSE '' END,
        CASE WHEN obesity = 'y' THEN 'O, ' ELSE '' END,
        CASE WHEN diabetes = 'y' THEN 'D, ' ELSE '' END
    ) AS risk_factors_combination_abbr,
    
    CONCAT(
        CASE WHEN family_history = 'y' THEN 'Family History, ' ELSE '' END,
        CASE WHEN radiation_exposure = 'y' THEN 'Radiation Exposure, ' ELSE '' END,
        CASE WHEN iodine_deficiency = 'y' THEN 'Iodine Deficiency, ' ELSE '' END,
        CASE WHEN smoking = 'y' THEN 'Smoking, ' ELSE '' END,
        CASE WHEN obesity = 'y' THEN 'Obesity, ' ELSE '' END,
        CASE WHEN diabetes = 'y' THEN 'Diabetes, ' ELSE '' END
    ) AS risk_factors_combination_full,
    
    COUNT(*) AS total_patients,
    
    COUNT(CASE WHEN diagnosis = 'malignant' THEN 1 ELSE NULL END) AS malignant_cases,
    
    ROUND(
        COUNT(CASE WHEN diagnosis = 'malignant' THEN 1 ELSE NULL END) / COUNT(*),
        4
    ) AS percentage_malignant

FROM
    thyroid_db
WHERE
    family_history = 'y'
    OR radiation_exposure = 'y'
    OR iodine_deficiency = 'y'
    OR smoking = 'y'
    OR obesity = 'y'
    OR diabetes = 'y'

GROUP BY risk_factors_combination_abbr, risk_factors_combination_full
ORDER BY percentage_malignant DESC, malignant_cases DESC;

-- Long table Hormone levels
SELECT 
    Patient_ID,
    'TSH' AS hormone,
    TSH_Level AS hormone_value,
    Thyroid_Cancer_Risk
FROM
    thyroid_db
UNION ALL
SELECT 
    Patient_ID,
    'T3' AS hormone,
    T3_Level AS hormone_value,
    Thyroid_Cancer_Risk
FROM
    thyroid_db
UNION ALL
SELECT 
    Patient_ID,
    'T4' AS hormone,
    T4_Level AS hormone_value,
    Thyroid_Cancer_Risk
FROM
    thyroid_db;

SELECT 
    hormone,
    Thyroid_Cancer_Risk,
    ROUND(AVG(hormone_value), 2) AS avg_value,
    MIN(hormone_value) AS min,
    MAX(hormone_value) AS max,
    COUNT(*) AS total_cases,
    Diagnosis
FROM
    (SELECT 
        'TSH' AS hormone,
            Thyroid_Cancer_Risk,
            TSH_Level AS hormone_value
    FROM
        thyroid_db
    WHERE
        TSH_Level IS NOT NULL UNION ALL SELECT 
        'T3', Thyroid_Cancer_Risk, T3_Level
    FROM
        thyroid_db
    WHERE
        T3_Level IS NOT NULL UNION ALL SELECT 
        'T4', Thyroid_Cancer_Risk, T4_Level
    FROM
        thyroid_db
    WHERE
        T4_Level IS NOT NULL) AS hormones
GROUP BY hormone , Thyroid_Cancer_Risk
ORDER BY hormone , CASE Thyroid_Cancer_Risk
    WHEN 'low' THEN 1
    WHEN 'medium' THEN 2
    WHEN 'high' THEN 3
END;

-- Only malignant cases
SELECT 
    hormone,
    Thyroid_Cancer_Risk,
    ROUND(AVG(hormone_value), 2) AS avg_value,
    MIN(hormone_value) AS min,
    MAX(hormone_value) AS max,
    COUNT(*) AS total_cases
FROM
    (SELECT 
        'TSH' AS hormone,
            Thyroid_Cancer_Risk,
            TSH_Level AS hormone_value
    FROM
        thyroid_db
    WHERE
        Diagnosis = 'malignant' AND TSH_Level IS NOT NULL UNION ALL SELECT 
        'T3', Thyroid_Cancer_Risk, T3_Level
    FROM
        thyroid_db
    WHERE
        Diagnosis = 'malignant' AND T3_Level IS NOT NULL UNION ALL SELECT 
        'T4', Thyroid_Cancer_Risk, T4_Level
    FROM
        thyroid_db
    WHERE
       Diagnosis = 'malignant' AND T4_Level IS NOT NULL) AS hormones
GROUP BY hormone , Thyroid_Cancer_Risk
ORDER BY hormone , CASE Thyroid_Cancer_Risk
    WHEN 'low' THEN 1
    WHEN 'medium' THEN 2
    WHEN 'high' THEN 3
END;

-- Benign vs Malignant cases hormones
SELECT 
    'Benign' AS diagnosis,
    hormone,
    Thyroid_Cancer_Risk,
    ROUND(AVG(hormone_value), 2) AS avg_value,
    MIN(hormone_value) AS min,
    MAX(hormone_value) AS max,
    COUNT(*) AS total_cases
FROM (
    SELECT 'TSH' AS hormone, Thyroid_Cancer_Risk, TSH_Level AS hormone_value
    FROM thyroid_db
    WHERE diagnosis = 'benign' AND TSH_Level IS NOT NULL

    UNION ALL

    SELECT 'T3', Thyroid_Cancer_Risk, T3_Level
    FROM thyroid_db
    WHERE diagnosis = 'benign' AND T3_Level IS NOT NULL

    UNION ALL

    SELECT 'T4', Thyroid_Cancer_Risk, T4_Level
    FROM thyroid_db
    WHERE diagnosis = 'benign' AND T4_Level IS NOT NULL
) AS hormones_benign
GROUP BY hormone, Thyroid_Cancer_Risk

UNION ALL

SELECT 
    'Malignant' AS diagnosis,
    hormone,
    Thyroid_Cancer_Risk,
    ROUND(AVG(hormone_value), 2) AS avg_value,
    MIN(hormone_value) AS min,
    MAX(hormone_value) AS max,
    COUNT(*) AS total_casos
FROM (
    SELECT 'TSH' AS hormone, Thyroid_Cancer_Risk, TSH_Level AS hormone_value
    FROM thyroid_db
    WHERE diagnosis = 'malignant' AND TSH_Level IS NOT NULL

    UNION ALL

    SELECT 'T3', Thyroid_Cancer_Risk, T3_Level
    FROM thyroid_db
    WHERE diagnosis = 'malignant' AND T3_Level IS NOT NULL

    UNION ALL

    SELECT 'T4', Thyroid_Cancer_Risk, T4_Level
    FROM thyroid_db
    WHERE diagnosis = 'malignant' AND T4_Level IS NOT NULL
) AS hormones_malign
GROUP BY hormone, Thyroid_Cancer_Risk
ORDER BY hormone, diagnosis,
    CASE Thyroid_Cancer_Risk
        WHEN 'Baixo' THEN 1
        WHEN 'Médio' THEN 2
        WHEN 'Alto' THEN 3
    END;
    
-- Distribution by category
SELECT 
    'Gender' AS category,
    Gender AS valor,
    COUNT(*) AS total_cases
FROM
    thyroid_db
WHERE
    Gender IS NOT NULL
GROUP BY Gender 
UNION ALL SELECT 
    'Ethnicity' AS category,
    Ethnicity AS valor,
    COUNT(*) AS total_casos
FROM
    thyroid_db
WHERE
    Ethnicity IS NOT NULL
GROUP BY Ethnicity
ORDER BY category , total_cases DESC;