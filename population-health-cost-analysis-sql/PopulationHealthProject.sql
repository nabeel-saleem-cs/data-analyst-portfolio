/**********************************************************************************************/
-- Create database
CREATE DATABASE PopulationHealthProject
/**********************************************************************************************/

/**********************************************************************************************/
--Import data from Excel (CSV fies) using "Import Flat File" 

-- After data import, check if the data was imported correctly
/**********************************************************************************************/

-- check how many rows transferred
select count (*) from dbo.claims
-- 2000 rows transferred 

select count (*) from dbo.diagnoses
-- 5 rows transferred 

select count (*) from dbo.members
-- 500 rows transferred 

/**********************************************************************************************/
-- check the data to make sure all fields are included
/**********************************************************************************************/

select top 5 * from dbo.claims

select top 5 * from dbo.diagnoses

select top 5 * from dbo.members

/**********************************************************************************************/
-- disease prevalence analysis query
/**********************************************************************************************/

SELECT
d.disease_name,
COUNT(DISTINCT c.member_id) AS members_with_disease,
CAST(
ROUND(
COUNT(DISTINCT c.member_id) * 100.0 /
(SELECT COUNT(*) FROM members),2
) AS DECIMAL(5,2)
) AS prevalence_percent
FROM claims c
JOIN diagnoses d
ON c.diagnosis_code = d.diagnosis_code
GROUP BY d.disease_name
ORDER BY prevalence_percent DESC

/**********************************************************************************************/
-- Financial Analysis
/**********************************************************************************************/

SELECT
d.disease_name,
COUNT(DISTINCT c.member_id) AS members,
SUM(c.paid_amount) AS total_cost,
AVG(c.paid_amount) AS avg_claim_cost
FROM claims c
JOIN diagnoses d
ON c.diagnosis_code = d.diagnosis_code
GROUP BY d.disease_name
ORDER BY total_cost DESC

/**********************************************************************************************/
-- Disease Prevelance by Age Group
/**********************************************************************************************/

-- Step 1 — Calculate Age for Each Member
SELECT 
member_id,
birth_date,
DATEDIFF(YEAR, birth_date, GETDATE()) AS age
FROM members

-- Step 2 - Assign Age Groups
SELECT 
member_id,
birth_date,
DATEDIFF(YEAR, birth_date, GETDATE()) AS age,
CASE
    WHEN DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 0 AND 17 THEN '0-17'
    WHEN DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 18 AND 34 THEN '18-34'
    WHEN DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 35 AND 49 THEN '35-49'
    WHEN DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 50 AND 64 THEN '50-64'
    ELSE '65+'
END AS age_group
FROM members

--Step 3 — Join Claims with Members and Diagnoses
SELECT 
c.member_id,
m.birth_date,
CASE
    WHEN DATEDIFF(YEAR, m.birth_date, GETDATE()) BETWEEN 0 AND 17 THEN '0-17'
    WHEN DATEDIFF(YEAR, m.birth_date, GETDATE()) BETWEEN 18 AND 34 THEN '18-34'
    WHEN DATEDIFF(YEAR, m.birth_date, GETDATE()) BETWEEN 35 AND 49 THEN '35-49'
    WHEN DATEDIFF(YEAR, m.birth_date, GETDATE()) BETWEEN 50 AND 64 THEN '50-64'
    ELSE '65+'
END AS age_group,
c.diagnosis_code,
d.disease_name
FROM claims c
JOIN members m ON c.member_id = m.member_id
JOIN diagnoses d ON c.diagnosis_code = d.diagnosis_code

-- Step 4 — Count Unique Members per Disease per Age Group
SELECT
age_group,
d.disease_name,
COUNT(DISTINCT c.member_id) AS members_with_disease
FROM claims c
JOIN members m ON c.member_id = m.member_id
JOIN diagnoses d ON c.diagnosis_code = d.diagnosis_code
GROUP BY age_group, d.disease_name
ORDER BY age_group, members_with_disease DESC

-- Step 5 Step 5 — Calculate Prevalence Percentage
SELECT
CASE
    WHEN DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 0 AND 17 THEN '0-17'
    WHEN DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 18 AND 34 THEN '18-34'
    WHEN DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 35 AND 49 THEN '35-49'
    WHEN DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 50 AND 64 THEN '50-64'
    ELSE '65+'
END AS age_group,
COUNT(*) AS total_members
FROM members
GROUP BY 
CASE
    WHEN DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 0 AND 17 THEN '0-17'
    WHEN DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 18 AND 34 THEN '18-34'
    WHEN DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 35 AND 49 THEN '35-49'
    WHEN DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 50 AND 64 THEN '50-64'
    ELSE '65+'
END

-- Step 6 — Combine Count + Total Members to Get Prevalence
SELECT
c.age_group,
c.disease_name,
c.members_with_disease,
CAST(ROUND(c.members_with_disease * 100.0 / t.total_members, 2) AS DECIMAL(5,2)) AS prevalence_percent
FROM
(
    SELECT
    CASE
        WHEN DATEDIFF(YEAR, m.birth_date, GETDATE()) BETWEEN 0 AND 17 THEN '0-17'
        WHEN DATEDIFF(YEAR, m.birth_date, GETDATE()) BETWEEN 18 AND 34 THEN '18-34'
        WHEN DATEDIFF(YEAR, m.birth_date, GETDATE()) BETWEEN 35 AND 49 THEN '35-49'
        WHEN DATEDIFF(YEAR, m.birth_date, GETDATE()) BETWEEN 50 AND 64 THEN '50-64'
        ELSE '65+'
    END AS age_group,
    d.disease_name,
    COUNT(DISTINCT c.member_id) AS members_with_disease
    FROM claims c
    JOIN members m ON c.member_id = m.member_id
    JOIN diagnoses d ON c.diagnosis_code = d.diagnosis_code
    GROUP BY
    CASE
        WHEN DATEDIFF(YEAR, m.birth_date, GETDATE()) BETWEEN 0 AND 17 THEN '0-17'
        WHEN DATEDIFF(YEAR, m.birth_date, GETDATE()) BETWEEN 18 AND 34 THEN '18-34'
        WHEN DATEDIFF(YEAR, m.birth_date, GETDATE()) BETWEEN 35 AND 49 THEN '35-49'
        WHEN DATEDIFF(YEAR, m.birth_date, GETDATE()) BETWEEN 50 AND 64 THEN '50-64'
        ELSE '65+'
    END,
    d.disease_name
) c
JOIN
(
    SELECT
    CASE
        WHEN DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 0 AND 17 THEN '0-17'
        WHEN DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 18 AND 34 THEN '18-34'
        WHEN DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 35 AND 49 THEN '35-49'
        WHEN DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 50 AND 64 THEN '50-64'
        ELSE '65+'
    END AS age_group,
    COUNT(*) AS total_members
    FROM members
    GROUP BY
    CASE
        WHEN DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 0 AND 17 THEN '0-17'
        WHEN DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 18 AND 34 THEN '18-34'
        WHEN DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 35 AND 49 THEN '35-49'
        WHEN DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 50 AND 64 THEN '50-64'
        ELSE '65+'
    END
) t
ON c.age_group = t.age_group
ORDER BY c.age_group, prevalence_percent DESC

/**********************************************************************************************/
--Eligibility Analysis
/**********************************************************************************************/

-- Step 1 — Identify Valid vs Invalid Claims (pull top 5 only)
SELECT 
c.claim_id,
c.member_id,
m.enrollment_date,
c.service_date,
CASE 
    WHEN c.service_date >= m.enrollment_date THEN 'Valid'
    ELSE 'Invalid'
END AS claim_status
into #temp
FROM claims c
JOIN members m
ON c.member_id = m.member_id

select top 5*
from #temp

-- Step 2 — Count Invalid Claims
SELECT
COUNT(*) AS total_claims,
SUM(CASE WHEN c.service_date < m.enrollment_date THEN 1 ELSE 0 END) AS invalid_claims,
SUM(CASE WHEN c.service_date >= m.enrollment_date THEN 1 ELSE 0 END) AS valid_claims
FROM claims c
JOIN members m
ON c.member_id = m.member_id