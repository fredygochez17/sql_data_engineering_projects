/*

-- duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"

-- Mother Duck (remote): 
-- duckdb md:dw_marts -c ".read build_dw_marts.sql"

-- NEW USERS:
-- Run this snippet to attach database
ATTACH 'md:_share/dw_marts/3803039b-0c25-44f0-87d8-447f9eeaaa5e';

*/


-- Step 1: DW — Create star schema tables
.read 01_create_tables_dw.sql

-- Step 2: DW — Load data from CSV files into tables
.read 02_load_schema_dw.sql

-- Step 3: Mart — Create flat mart
.read 03_create_flat_mart.sql

-- Step 4: Mart — Create skills demand mart
.read 04_create_skills_mart.sql

-- Step 5: Mart — Create priority roles mart
.read 05_create_priority_mart.sql

-- Step 6: Mart — Update priority roles mart
.read 06_update_priority_mart.sql