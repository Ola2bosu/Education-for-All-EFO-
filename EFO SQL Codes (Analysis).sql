--ANALYSIS QUESTIONS
-- What demographic characteristics (e.g., gender, job field, state) are most common among current donors, and are there untapped demographics that should be targeted?
SELECT gender, 
	job_field, 
	state, 
	COUNT(*) AS donor_count, 
	SUM(donation) AS total_donation
FROM Donation_Data
GROUP BY gender, 
	job_field, 
	state
ORDER BY total_donation DESC, 
	donor_count
;

-- How does the donor's university affiliation (university) correlate with their likelihood to contribute? Are there specific universities with higher donor representation?
SELECT university, 
	COUNT(*) AS donor_count, 
	AVG(CASE WHEN donation_frequency = 'Once' THEN 1 ELSE 0 END) AS once_contributors_percentage,
	AVG(CASE WHEN donation_frequency = 'Weekly' THEN 1 ELSE 0 END) AS weekly_contributors_percentage,
	AVG(CASE WHEN donation_frequency = 'Monthly' THEN 1 ELSE 0 END) AS monthly_contributors_percentage,
	AVG(CASE WHEN donation_frequency = 'Yearly' THEN 1 ELSE 0 END) AS yearly_contributors_percentage
	FROM Donor_Data2
	GROUP BY university
	ORDER BY donor_count DESC
;

-- In which states (state) do we have the lowest donor representation, and what targeted strategies can be implemented to increase outreach in those regions?
SELECT state, 
	COUNT(*) AS donor_count, 
	SUM(donation) as donation
FROM Donation_Data
GROUP BY state
ORDER BY donor_count ASC, 
	donation ASC
LIMIT 25
;

-- Does the donor's second language (second language) influence their likelihood to donate, and how can language-specific communication strategies be optimized?
SELECT second_language,
	AVG(CASE WHEN donation_frequency = 'Once' THEN 1 ELSE 0 END) AS once_contributors_percentage,
	AVG(CASE WHEN donation_frequency = 'Weekly' THEN 1 ELSE 0 END) AS weekly_contributors_percentage,
	AVG(CASE WHEN donation_frequency = 'Monthly' THEN 1 ELSE 0 END) AS monthly_contributors_percentage,
	AVG(CASE WHEN donation_frequency = 'Yearly' THEN 1 ELSE 0 END) AS yearly_contributors_percentage, 
	Sum(donation) as total_donation 
FROM Donor_Data2
JOIN Donation_Data
ON Donor_Data2.id = Donation_Data.id
GROUP BY second_language
ORDER BY total_donation DESC
;

-- What are the common patterns in donation frequency (donation frequency), and how do these patterns vary across different donor segments?
SELECT donation_frequency,
	COUNT(*) AS donor_count
FROM Donor_Data2
GROUP BY donation_frequency
ORDER BY donor_count DESC
;

-- What characteristics (e.g., job field, state, car, university) are common among high-value donors, and how can this information be used to identify and target potential major contributors?
SELECT job_field,
	state,
    car,
	university,
	AVG(donation) AS avg_donation
FROM Donation_Data
JOIN Donor_Data2
ON Donation_Data.id = Donor_Data2.id
GROUP BY job_field,
	state,
	university,
    car,
HAVING AVG(donation) >= 350
ORDER by avg_donation DESC
;  

-- What trends are observed in major gifts, and are there specific factors (e.g., university affiliation, job field) that consistently contribute to larger donations?
SELECT university,
	job_field,
    car,
	AVG(donation) AS avg_donation,
FROM Donation_Data
JOIN Donor_Data2 
ON Donation_Data.id = Donor_Data2.id
WHERE donation >= 400
GROUP BY university,
	car,
	job_field
ORDER BY avg_donation ASC
;

-- Which donor qualify for our incentives as the top contributors? 
SELECT id,
	first_name,
	last_name,
	email,
	donation
FROM Donation_Data
WHERE donation >= 400
ORDER BY donation DESC
;
