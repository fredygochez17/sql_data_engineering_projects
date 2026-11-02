-- 02_load_schema_dw.sql
-- Load Schema Data Warehouse
-- Step 2: Data Warehouse — Load data from CSV files into tables


-- start with inserting into tables without foreign key constraints
SELECT '=== Loading company_dim Table ===' AS info;

INSERT INTO company_dim (company_id, name) -- no foreign keys in declaration (see 01_create_tables_dw.sql)
SELECT company_id, name   
FROM read_csv( -- Duckdb autoloads httpfs extensions by default for reading and writing to remote files 
        'https://storage.googleapis.com/sql_de/company_dim.csv', 
        AUTO_DETECT = true -- optional param, true by default
);

SELECT '=== Loading skills_dim Table ===' AS info;

INSERT INTO skills_dim(skill_id, skills, type) -- no foreign keys in declaration (see 01_create_tables_dw.sql)
SELECT skill_id, skills, type
FROM read_csv( -- Duckdb autoloads httpfs extensions by default for reading and writing to remote files 
        'https://storage.googleapis.com/sql_de/skills_dim.csv', 
        AUTO_DETECT = true -- optional param, true by default
);

SELECT '=== Loading job_postings_fact Table ===' AS info;

INSERT INTO job_postings_fact (
    job_id                  ,
    company_id              ,
    job_title_short         ,
    job_title               ,
    job_location            ,
    job_via                 ,
    job_schedule_type       ,
    job_work_from_home      ,
    search_location         ,
    job_posted_date         ,
    job_no_degree_mention   ,
    job_health_insurance    ,
    job_country             ,
    salary_rate             ,
    salary_year_avg         ,
    salary_hour_avg    
)     
SELECT
    job_id                  ,
    company_id              ,
    job_title_short         ,
    job_title               ,
    job_location            ,
    job_via                 ,
    job_schedule_type       ,
    job_work_from_home      ,
    search_location         ,
    job_posted_date         ,
    job_no_degree_mention   ,
    job_health_insurance    ,
    job_country             ,
    salary_rate             ,
    salary_year_avg         ,
    salary_hour_avg
FROM read_csv(
        'https://storage.googleapis.com/sql_de/job_postings_fact.csv', 
        AUTO_DETECT = true -- optional param, true by default
);

SELECT '=== Loading skills_job_dim Table ===' AS info;

INSERT INTO skills_job_dim (skill_id, job_id)
SELECT skill_id, job_id
FROM read_csv(  
        'https://storage.googleapis.com/sql_de/skills_job_dim.csv', 
        AUTO_DETECT = true -- optional param, true by default
);