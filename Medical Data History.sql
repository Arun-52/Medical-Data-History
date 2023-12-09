-- 1. Show first name, last name, and gender of patients who's gender is 'M'
SELECT first_name, last_name, gender
FROM project_medical_data_history.patients
WHERE gender = 'M';

-- 2. Show first name and last name of patients who does not have allergies.
SELECT first_name, last_name
FROM project_medical_data_history.patients
WHERE allergies IS NULL;

-- 3. Show first name of patients that start with the letter 'C'
SELECT first_name
FROM project_medical_data_history.patients
WHERE first_name LIKE 'C%';

-- 4. Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
SELECT first_name, last_name
FROM project_medical_data_history.patients
WHERE weight BETWEEN 100 AND 120;

-- 5. Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'
SELECT first_name, last_name,
COALESCE(allergies, 'NKA') AS allergies
FROM project_medical_data_history.patients;

-- 6. Show first name and last name concatenated into one column to show their full name.
SELECT
    CONCAT(first_name, ' ', last_name) AS full_name
FROM project_medical_data_history.patients;

-- 7. Show first name, last name, and the full province name of each patient.
SELECT patients.first_name, patients.last_name, project_medical_data_history.province_names.province_name
FROM project_medical_data_history.patients
JOIN project_medical_data_history.province_names ON patients.province_id = province_names.province_id;


-- 8. Show how many patients have a birth_date with 2010 as the birth year.
SELECT COUNT(*) AS patient_count
FROM project_medical_data_history.patients
WHERE YEAR(birth_date) = 2010;

-- 9. Show the first_name, last_name, and height of the patient with the greatest height.
SELECT first_name, last_name, height
FROM  project_medical_data_history.patients
ORDER BY height DESC
LIMIT 1;

-- 10. Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000
SELECT * FROM project_medical_data_history.patients
WHERE patient_id IN (1, 45, 534, 879, 1000);

-- 11. Show the total number of admissions
SELECT COUNT(*) AS total_admissions
FROM project_medical_data_history.admissions;

-- 12. Show all the columns from admissions where the patient was admitted and discharged on the same day.
SELECT * FROM project_medical_data_history.admissions
WHERE DATE(admission_date) = DATE(discharge_date);

-- 13. Show the total number of admissions for patient_id 579.
SELECT COUNT(*) AS total_admissions
FROM project_medical_data_history.admissions
WHERE patient_id = 579;

-- 14. Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?
SELECT DISTINCT city
FROM project_medical_data_history.patients 
WHERE province_id = 'NS';

-- 15. Write a query to find the first_name, last name and birth date of patients who have height more than 160 and weight more than 70
SELECT first_name, last_name, birth_date
FROM project_medical_data_history.patients
WHERE height > 160 AND weight > 70;

-- 16. Show unique birth years from patients and order them by ascending.
SELECT DISTINCT YEAR(birth_date) AS birth_year
FROM project_medical_data_history.patients
ORDER BY birth_year ASC;

-- 17. Show unique first names from the patients table which only occurs once in the list.
SELECT first_name
FROM project_medical_data_history.patients
GROUP BY first_name
HAVING COUNT(first_name) = 1;

-- 18. Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
SELECT patient_id, first_name
FROM project_medical_data_history.patients
WHERE first_name LIKE 's%s' AND LENGTH(first_name) >= 6;

-- 19. Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.   Primary diagnosis is stored in the admissions table.
SELECT p.patient_id, p.first_name, p.last_name
FROM project_medical_data_history.patients p
JOIN project_medical_data_history.admissions a ON p.patient_id = a.patient_id
WHERE a.diagnosis = 'Dementia';

-- 20. Display every patient's first_name. Order the list by the length of each name and then by alphbetically.
SELECT first_name
FROM project_medical_data_history.patients
ORDER BY LENGTH(first_name), first_name;

-- 21. Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.
SELECT
  COUNT(CASE WHEN gender = 'M' THEN 1 END) AS total_male_patients,
  COUNT(CASE WHEN gender = 'F' THEN 1 END) AS total_female_patients
FROM project_medical_data_history.patients;

-- 22. Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
SELECT patient_id, diagnosis
FROM project_medical_data_history.admissions
GROUP BY patient_id, diagnosis
HAVING COUNT(*) > 1;

-- 23. Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending.
SELECT city, COUNT(*) AS total_patients
FROM project_medical_data_history.patients
GROUP BY city
ORDER BY total_patients DESC, city ASC;

-- 24. Show first name, last name and role of every person that is either patient or doctor. The roles are either "Patient" or "Doctor"
SELECT patient_id AS person_id, first_name, last_name, 'Patient' AS role
FROM
  project_medical_data_history.patients
UNION
SELECT doctor_id AS person_id, first_name, last_name, 'Doctor' AS role
FROM
  project_medical_data_history.doctors;

-- 25. Show all allergies ordered by popularity. Remove NULL values from query.
SELECT allergies, COUNT(*) AS allergy_count
FROM project_medical_data_history.patients
WHERE allergies IS NOT NULL
GROUP BY allergies
ORDER BY allergy_count DESC;

-- 26. Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
SELECT first_name, last_name, birth_date
FROM project_medical_data_history.patients
WHERE EXTRACT(YEAR FROM birth_date) BETWEEN 1970 AND 1979
ORDER BY birth_date;

-- 27. We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order.  EX: SMITH,jane
SELECT CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS full_name
FROM project_medical_data_history.patients
ORDER BY first_name DESC;

-- 28. Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
SELECT province_id, SUM(height) AS total_height
FROM project_medical_data_history.patients
GROUP BY province_id
HAVING total_height >= 7000;

-- 29. Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
SELECT MAX(weight) - MIN(weight) AS weight_difference
FROM project_medical_data_history.patients
WHERE last_name = 'Maroni';

-- 30. Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
SELECT DAY(admission_date) AS day_of_month, COUNT(*) AS admissions_count
FROM project_medical_data_history.admissions
GROUP BY day_of_month
ORDER BY admissions_count DESC, day_of_month;

-- 31. Show all of the patients grouped into weight groups. Show the total amount of patients in each weight group. Order the list by the weight group decending. e.g. if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.
SELECT
  CASE
    WHEN weight BETWEEN 100 AND 109 THEN '100 Weight Group'
    WHEN weight BETWEEN 110 AND 119 THEN '110 Weight Group'
    ELSE 'Other Weight Group'
  END AS weight_group,
  COUNT(*) AS total_patients
FROM project_medical_data_history.patients
WHERE weight IS NOT NULL
GROUP BY weight_group
ORDER BY weight_group DESC;

-- 32. Show patient_id, weight, height, isObese from the patients table. Display isObese as a boolean 0 or 1. Obese is defined as weight(kg)/(height(m). Weight is in units kg. Height is in units cm.
SELECT patient_id, weight, height,
CASE WHEN (weight / (height / 100) / (height / 100)) >= 30 THEN 1 ELSE 0 END AS isObese
FROM project_medical_data_history.patients;

-- 33. Show patient_id, first_name, last_name, and attending doctor's specialty. Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'. Check patients, admissions, and doctors tables for required information.
SELECT
  p.patient_id,
  p.first_name,
  p.last_name,
  d.specialty AS attending_doctor_specialty
FROM
  project_medical_data_history.patients p
  JOIN project_medical_data_history.admissions a ON p.patient_id = a.patient_id
  JOIN project_medical_data_history.doctors d ON a.attending_doctor_id = d.doctor_id
WHERE
  a.diagnosis = 'Epilepsy'
  AND d.first_name = 'Lisa';
  
  -- 34. All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password. 35. All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.
   -- The password must be the following, in order:
  --  patient_id - the numerical length of patient's last_name  - year of patient's birth_date
SELECT patient_id,
CONCAT(patient_id, LENGTH(last_name), YEAR(birth_date)) AS temp_password
FROM
  project_medical_data_history.patients
WHERE
  patient_id IN (SELECT DISTINCT patient_id FROM project_medical_data_history.admissions);