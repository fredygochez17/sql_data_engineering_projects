/*

-- Step 6: Mart — Update priority roles mart
-- .read 06_update_priority_mart.sql

*/

SELECT '=== Updating Roles for Priority Mart ===' AS info;-------

-- update data engineer to priority 1
UPDATE priority_mart.priority_roles
SET priority_lvl = 1
WHERE role_name = 'Data Engineer';---------

-- add data scientist as level 3
INSERT INTO priority_mart.priority_roles(role_id, role_name, priority_lvl)
VALUES (4, 'Data Scientist', 3);------

-- Data Check
SELECT * FROM priority_mart.priority_roles;-------


-- CREATE TEMP TABLE
SELECT '=== Creating Temp Source Table for Priority Mart ===' AS info;

CREATE OR REPLACE TEMP TABLE src_priority_jobs AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.priority_lvl,
    CURRENT_TIMESTAMP AS updated_at
FROM
    job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
INNER JOIN priority_mart.priority_roles AS r
    ON jpf.job_title_short  = r.role_name;--------

-- MERGE INTO
-- combine UPDATE, INSERT, AND DELETE
SELECT '=== Batch Updating Priority Marts Snapshot ===' AS info;-------

MERGE INTO priority_mart.priority_jobs_snapshot AS tgt
USING src_priority_jobs AS src
ON tgt.job_id = src.job_id
WHEN MATCHED AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl THEN
    UPDATE SET 
        priority_lvl = src.priority_lvl,
        updated_at = src.updated_at
WHEN NOT MATCHED THEN
    INSERT (
        job_id,                              
        job_title_short,                     
        company_name,                        
        job_posted_date,                     
        salary_year_avg,                     
        priority_lvl,                        
        updated_at                           
    )                                        
    VALUES (
        src.job_id,                          
        src.job_title_short,                 
        src.company_name,                    
        src.job_posted_date,                 
        src.salary_year_avg,                 
        src.priority_lvl,                    
        src.updated_at
    )
WHEN NOT MATCHED BY SOURCE THEN DELETE;---------

-- final check query
SELECT
    job_title_short,
    COUNT(*) AS job_count,
    MIN(priority_lvl) AS priority_lvl,
    MIN(updated_at) AS updated_at
FROM priority_mart.priority_jobs_snapshot
GROUP BY job_title_short
ORDER BY job_count DESC;---------