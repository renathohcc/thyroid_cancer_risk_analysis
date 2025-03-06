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