SELECT DISTINCT bureau_pull_type
FROM data_warehouse.v69__bureau_details;


-- Check 1
SELECT *
FROM data_warehouse.v69__bureau_details
WHERE application_id IS NULL;

-- Check 2
SELECT *
FROM data_warehouse.v69__bureau_details
WHERE bureau_pull_type IS NULL
OR bureau_pull_type NOT IN ('TRANSUNION_PD_SOFT', 'TRANSUNION_PD_HARD', 'TRANSUNION_LYON_HARD');

-- Check 3
SELECT *
FROM data_warehouse.v69__bureau_details
WHERE bureau_pull_time IS NULL;

-- Check 4
SELECT *
FROM data_warehouse.v69__bureau_details
WHERE (bureau_pull_type LIKE '%PD_HARD%' AND response_data NOT LIKE '%{%success%true}%')
OR response_data IS NULL;