/*
02_top_paying_skills.sql

Question: What are the highest-paying skills for data engineers in Spain? 
Cuestion: Cuales son las competencias de la ingenieria de datos que mas se pagan en España? 

- Calculate the median salary for each skill required in data enigneering positions
  Calcular el salario medio por cada competencia requerida en puestos de ingenieria de datos

- Focus on positions in Spain with specified salaries
  Enfocar en puestos de España que espesificen el salario

- Include skill frequency to identify both salary and demand
  Incluir la frecuencia de cada competencia para identificar el salario y la demanda 

- Why? Helps identify which skills command the highest compensation while also showing how common
  those skills are, providing a more complete picture for skill development priorities
  Porque? Ayuda identificar las competencias que exigen la mayor compensación y que tan comun son.
  Eso nos da una mejor idea de cuales competencias priorizar en nuestra formacion.
*/

-- -- query for seeing how much salary data we're working with
-- SELECT 
--     job_title_short, 
--     job_country, 
--     job_location,
--     salary_rate,
--     salary_year_avg,
--     salary_hour_avg
-- FROM job_postings_fact
-- WHERE  
--     job_country = 'Spain' 
--     AND job_title_short = 'Data Engineer'
--     AND
--         (
--             salary_rate IS NOT NULL
--             OR salary_year_avg IS NOT NULL
--             OR salary_hour_avg IS NOT NULL
--         )
-- ORDER BY
--     salary_year_avg DESC;























SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 2) AS median_salary,
    COUNT(DISTINCT jpf.job_id) AS demand_count,
    -- count if a job salary is posted
    COUNT
      ( 
        DISTINCT CASE
        WHEN 
          (
            jpf.salary_year_avg IS NOT NULL 
            OR jpf.salary_hour_avg IS NOT NULL 
            OR jpf.salary_rate IS NOT NULL
          )
        THEN jpf.job_id
        END
      ) 
      AS annual_salary_count
FROM
    job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd 
        ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd
        ON sjd.skill_id = sd.skill_id 
WHERE
    -- jpf.job_title_short = 'Data Engineer'
    -- AND 
    jpf.job_country = 'Spain'
GROUP BY
    sd.skills 
HAVING 
    COUNT(DISTINCT jpf.job_id) > 100
    AND annual_salary_count > 10 -- aliasing here may not be allowed by all SQL programs
ORDER BY 
    median_salary DESC ;


















/*

-- data job roles
SELECT DISTINCT job_title_short FROM job_postings_fact ;
┌───────────────────────────┐
│      job_title_short      │
│          varchar          │
├───────────────────────────┤
│ Senior Data Analyst       │
│ Cloud Engineer            │
│ Machine Learning Engineer │
│ Data Analyst              │
│ Software Engineer         │
│ Data Engineer             │
│ Data Scientist            │
│ Business Analyst          │
│ Senior Data Scientist     │
│ Senior Data Engineer      │
└───────────────────────────┘
           10 rows

Output Specific to Data Engineers:
┌─────────┬───────────────┬──────────────┬─────────────────────┐
│ skills  │ median_salary │ demand_count │ annual_salary_count │
│ varchar │    double     │    int64     │        int64        │
├─────────┼───────────────┼──────────────┼─────────────────────┤
│ sql     │      133000.0 │         6866 │                  23 │
│ azure   │      124900.0 │         4162 │                  11 │
│ spark   │      124900.0 │         3591 │                  17 │
│ python  │      118000.0 │         6895 │                  21 │
│ aws     │      111172.0 │         4236 │                  16 │
└─────────┴───────────────┴──────────────┴─────────────────────┘
                          5 rows
      *** Salary amounts expressed in US Dollars ***


Output for the Broader Data Job Market: 
┌────────────┬───────────────┬──────────────┬─────────────────────┐
│   skills   │ median_salary │ demand_count │ annual_salary_count │
│  varchar   │    double     │    int64     │        int64        │
├────────────┼───────────────┼──────────────┼─────────────────────┤
│ scala      │      134241.0 │         3897 │                  17 │
│ spark      │      133620.5 │         7332 │                  66 │
│ pandas     │      131580.0 │         2344 │                  39 │
│ kafka      │      111670.5 │         2772 │                  14 │
│ databricks │      111175.0 │         4082 │                  51 │
│ airflow    │      111175.0 │         3310 │                  20 │
│ azure      │      107921.5 │         9213 │                  34 │
│ python     │      101029.0 │        22820 │                 109 │
│ git        │      101029.0 │         4077 │                  17 │
│ aws        │      101029.0 │        10086 │                  87 │
│ sql        │      100500.0 │        20447 │                  86 │
│ snowflake  │      100494.5 │         3135 │                  16 │
│ tableau    │       99960.0 │         5181 │                  28 │
│ looker     │       98972.0 │         1754 │                  18 │
│ excel      │       98500.0 │         4716 │                  25 │
│ java       │       96773.0 │         3371 │                  21 │
│ gcp        │       96773.0 │         3152 │                  11 │
│ power bi   │       93324.0 │         5996 │                  18 │
│ r          │       90000.0 │         5658 │                  25 │
│ docker     │       89100.0 │         3247 │                  22 │
│ go         │       89100.0 │         2026 │                  12 │
│ kubernetes │       89100.0 │         2809 │                  13 │
│ github     │      63781.25 │         1342 │                  15 │
└────────────┴───────────────┴──────────────┴─────────────────────┘
                              23 rows
          *** Salary amounts expressed in US Dollars ***

Two distinct perspectives for data job market in Spain:
One focused on data engineering positions
Another covering the broader data job market


1. KEY INSIGHTS

    A.  Data Engineer Postions in Spain:
        - SQL and Python have the highest demand counts. Both appear across thousands of Data Engineer postings, 
          reinforcing their value as core skills for this career path.
        - SQL has the highest reported median salary in this particular result. However, its median is based on
          only 23 postings with annual salary values, so it should be interpreted as an observed association rather
          than a reliable market-wide salary benchmark.
        - Cloud platforms are prominent. Azure and AWS both appear frequently, suggesting that cloud infrastructure 
          knowledge is a useful complement to programming and querying skills.
        - Spark is associated with a relatively high reported median salary. This makes distributed data processing 
          worth exploring as a specialization after establishing the fundamentals.

    B.  The broader data job market:
        - Python and SQL stand out for demand. They have the two largest demand counts in your output, suggesting 
          broad applicability across data roles.
        - Spark, Scala, Kafka, and Databricks appear in the higher-salary group. These technologies are associated
          with distributed processing, data pipelines, and large-scale data platforms. Their results make them 
          promising subjects for future analysis.
        - Pandas is worth investigating. It has a relatively high reported median salary, but its smaller demand 
          count means it would be useful to examine which job titles and salary observations contribute to that 
          result.
        - Cloud skills are broadly relevant. AWS and Azure have substantial demand counts, while GCP also appears 
          in the results. Comparing these platforms by job title could reveal where each is most relevant.
        - A skill's apparent salary ranking differs from its demand ranking. Python and SQL are widespread, while 
          some specialized tools have higher reported medians. That is a useful distinction between skills 
          associated with broad opportunity and those associated with particular technical specializations.

    Important Note: These figures do not demonstrate that learning a particular skill causes a higher salary. 
                    Salary differences may reflect seniority, job title, employer, industry, location, and other 
                    factors.
    
    C.  Summary
        - Core skills: SQL and Python
          High demand across the broader data market and strong demand within Data Engineer postings,
          making them sensible foundational skills
        - Complementary skills: AWS and Azure
          Cloud knowledge is relevant to data engineering and can complement SQL and Python skills.
        - Potential specialization: Spark and related data-platform tools
          Spark, Kafka, Databricks, and Airflow are worth exploring for work involving distributed data 
          processing and orchestration.


2. LIMITATIONS OF THE DATA

    1 - Limited Salary Coverage
        Only a subset of postings contain salary values. For example, the results specific to Data Engineers 
        include 23 annual salary observations for SQL and 11 for Azure which are fairly small sample sizes.
    2 - Currency and salary comparability are unverified.
        The currency and any conversion methodology have not been independently confirmed. The salary figures 
        should therefore remain labeled as reported dataset values, not assumed to be euros or definitive 
        local-market salaries.
    3 - Salary is not isolated from other variables
        The query does not control for seniority, employer, industry, contract type, or other factors that 
        could explain salary differences. A high median does not mean the skill itself commands a premium.
    4 - The minimum sample threshold affects the rankings. 
        Lowering [annual_salary_count] to 10 lets more skills into the output, but it also allows less stable 
        medians simply due to a qualitative filtering decision. 
    5 - The time period may not reflect the current market.
        The dataset's coverage may not fully represent hiring conditions in October 2026. The database reflects
        job-postings taken between January 2023 and June 2025


3. CONSIDERATIONS FOR FUTURE ANALYSIS

    -   Analyze seniority and experience
        Compare similar levels of responsibility to reduce misleading comparisons between different kinds of jobs.
    -   Add time-based analysis
        Examine changes in skill demand across posting dates, if the dataset has sufficient date coverage.
    -   Store outputs & analysis in their own file to avoid cluttering SQL files

*/