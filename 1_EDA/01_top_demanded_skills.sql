/* 
01_top_demanded_skills.sql

EDA - Exploratory Data Analysis

Questions: What are the most in-demand skills for data engineers in Spain? 
Cuestion: Cuales son las competencias mas requeridas para ingenieros de datos en España?

- Identify the top 10 in-demand skills for data engineers
  Identificar las competencias top 10 para ingenieros de datos
- Focus on job postings in Spain
  Enfocar en ofertas de empleo en España
- Why? Porque?
    - Retrieve the top 10 skills with the highest demand in the Spanish market, providing 
      insites into the most valuable skills for data data engineers seeking work in Spain
      Identificar las 10 competencias mas requeridas en España, y ofrecer información sobre 
      las habilidades más valiosas para los ingenieros de datos que buscan empleo en España.

- connect to job database when opening duckdb:
$ duckdb md:data_jobs_luke
or
- local copy of luke's data base as of 2026/10/13 (yyyy/mm/dd):
/home/fredy/projects/data_bases/data_jobs.duckdb
*/


-- -- query for job postings date range
-- SELECT
--     MIN(job_posted_date) AS oldest_post_date,
--     MAX(job_posted_date) AS most_recent_post_date
-- FROM 
--     job_postings_fact
-- WHERE 
--     job_location = 'Spain' ;
-- jan 2023 to jun 2025





SELECT
    sd.skills,
    COUNT(jpf.*) AS demand_count
FROM
    job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd 
        ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd
        ON sjd.skill_id = sd.skill_id 
WHERE
    jpf.job_country = 'Spain'
    AND 
    jpf.job_title_short = 'Data Engineer'
GROUP BY
    sd.skills 
ORDER BY 
    demand_count DESC 
LIMIT 10 ;


/*
Here's a breakdown of the most in demand skills for data engineers in Spain            
looking at data between January 2023 to June 2025:
`Este es el resumen de las competencias mas requeridas por la Ingenieria de datos                            
`en España tomando en cuenta datos entre Enero del 2023 a Junio del 2025:    

Python and SQL are by far the most in-demand skills, with nearly 6,900 job
postings each. 
`Las competencias mas en demanda son las de Python y SQL con casi 6.900
`ofertas de empleo cada una en cual son mencionadas.

Cloud platforms AWS and Azure round out the top 5 skills being mentioned in more
than 4 thousand job postings each.
`Plataformas cloud como AWS y Azure forman parte de las top 5 competencias
`llegando a mas de 4 mil ofertas de empleo cada una.

Apache Spark completes the top 5 with over 3.5 thousand job postings, highlighting 
the ever present importance of big data processing skills.   
`Apache Spark completa el top 5 siendo mencionada en mas de 3.500 ofertas de empleo,
`destacando la importancia en poder procesar grandes cantidades de datos.


┌────────────┬──────────────┐
│   skills   │ demand_count │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ python     │         6895 │
│ sql        │         6866 │
│ aws        │         4236 │
│ azure      │         4162 │
│ spark      │         3591 │
│ scala      │         2270 │
│ databricks │         2124 │
│ airflow    │         1803 │
│ snowflake  │         1658 │
│ kafka      │         1588 │
└────────────┴──────────────┘
  10 rows         2 columns


Key Takeaways:                                                                   
- Python and SQL are the foundational skills for data engineers                  
- Cloud Platforms (such as AWS & Azure) are critical for Modern Data Engineering 
- Big data tools like Apache Spark and Databricks are highly valued                             
- Scala, like Python, is another highly requested programming language
- Airflow, Snowflake, and Kafka round out the top 10 most requested skills

`Puntos Claves:                                                                              
`- Python y SQL son fundamentales para la ingenieria de datos                                
`- Plataformas Cloud (como AWS y Azure) son criticas para el proceso de datos moderno        
`- Herramientas para manejar grandes cantidades de datos, como Apache Spark y Databricks, 
`  son indespensables  
`- Scala, como Python, es otro lenguaje de programación que se pide frecuentemente                              
`- Airflow, Snowflake, y Kafka completan el top 10 de las competencias mas requeridas   
*/