/* 
03_optimal_skills.sql

Question: What are the most optimal skills for all data jobs in Spain balancing both demand and salary? 
- Create a ranking column that combines demand count and median salary to identify the most valuable skills
- Focus only on Data positions with specified annual salaries
- Why? This approach highlights skills that balance market demand and financial reward.

*/


SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS salary_count,
    ROUND((MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*))) / 500_000, 2) AS score_normalized
FROM
    job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd 
        ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd
        ON sjd.skill_id = sd.skill_id 
WHERE
    -- jpf.job_title_short = 'Data Engineer' -- not enough data for just data engineering positions
    jpf.salary_year_avg IS NOT NULL -- only count rows that contain a salary value
    AND jpf.job_country = 'Spain'
GROUP BY
    sd.skills 
HAVING 
    COUNT(jpf.*) > 10
ORDER BY 
    score_normalized DESC ;

/*
output:

┌────────────┬───────────────┬──────────────┬──────────────────┐
│   skills   │ median_salary │ salary_count │ score_normalized │
│  varchar   │    double     │    int64     │      double      │
├────────────┼───────────────┼──────────────┼──────────────────┤
│ spark      │      133621.0 │           38 │             0.97 │
│ python     │      101029.0 │          101 │             0.93 │
│ sql        │      100500.0 │           84 │             0.89 │
│ aws        │      101029.0 │           56 │             0.81 │
│ azure      │      107922.0 │           34 │             0.76 │
│ scala      │      134241.0 │           17 │             0.76 │
│ databricks │      111175.0 │           23 │              0.7 │
│ airflow    │      111175.0 │           20 │             0.67 │
│ tableau    │       99960.0 │           27 │             0.66 │
│ pandas     │      131580.0 │           11 │             0.63 │
│ excel      │       98500.0 │           21 │              0.6 │
│ kafka      │      111671.0 │           14 │             0.59 │
│ java       │       96773.0 │           20 │             0.58 │
│ looker     │       98972.0 │           18 │             0.57 │
│ git        │      101029.0 │           17 │             0.57 │
│ r          │       90000.0 │           23 │             0.56 │
│ snowflake  │      100495.0 │           16 │             0.56 │
│ docker     │       89100.0 │           22 │             0.55 │
│ power bi   │       93324.0 │           16 │             0.52 │
│ kubernetes │       89100.0 │           13 │             0.46 │
│ gcp        │       96773.0 │           11 │             0.46 │
│ go         │       89100.0 │           12 │             0.44 │
│ github     │       63781.0 │           12 │             0.32 │
└────────────┴───────────────┴──────────────┴──────────────────┘
  23 rows                                            4 columns
  *** median_salary expressed in US dollars ***

1. KEY INSIGHTS
    A.  Spark ranks first.
        Spark leads the ranking by combining a relatively high median salary with a 
        meaningful number of salary observations. Python and SQL follow closely, 
        benefiting from much larger samples. The findings also show that the highest
        paid skills (e.g. Scala & Pandas) don't necessarily yield the strongest combined
        scores. 
    B.  Python and SQL offer a strong combination of salary and demand.
        Python has 101 salary observations, the largest count in the output, while SQL 
        has 84. Both having median salaries around $100,000. They appear to frequently
        with competitive reported salaries. For somone building data engineering 
        capabilities, they are sensible foundational skills to prioritize. 
    C.  Specialized technologies appear posmising
        -   Scala holds the highest median salary, but only 17 salary observations, causing
            it to yield a lower score than Spark, Python, or SQL. 
        -   Databricks and Airflow have identical median salaries and scores of 0.70 and 
            0.67, respectively.
        -   Kafka has a median of $111,671, but its smaller sample of 14 observations 
            limits confidence in the estimate.
        -   Azure and AWS both rank relatively highly, supporting further investigation of 
            cloud-related skills.
        These results suggest possible specializations worth exploring.

2. LIMITATIONS OF THE ANALYSIS
    -   Salary data is uneven. 
        Spark has 38 observations, while Python has 101. Smaller samples can produce less 
        stable median estimates, especially for Scala, Pandas, and Kafka.
    -   The data combines different job families.
        Some skills may rank highly because they are associated with a particular role or 
        seniority level.
    -   The dataset may not fully represent Spain's current job market.
        The reported figures reflect the available postings and salary data, not every 
        employer or current vacancy in Spain.

3. IMPROVEMENTS FOR FUTURE ANALYSIS
    - Compare the score against raw demand
    - Gather more data job market data from Spain and add it to the data base
    - Separate the job families (i.e. Data Engineer, Data Analyst, Data Scientist, etc...)
    - Test alternative ranking formulas (e.g. adding weights to counts w/ & w/out job salaries )
    - Explore seniority and work arrangement. (Entry vs Early Career vs Senior level)


*/