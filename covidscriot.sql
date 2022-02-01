-- What countries would YOU most likely contract covid?
SELECT location, (max(total_cases)/max(population))*100 AS percentage_positive_population

FROM owid_covid_data.population_cases

WHERE continent is not null

GROUP BY location
ORDER BY 2 DESC

-- In what country are YOU most likely to die from covid?
SELECT location, (max(total_deaths)/max(total_cases))*100 AS percentage_death_of_positive_patients

FROM owid_covid_data.population_cases

WHERE continent is not null

GROUP BY location
ORDER BY 2 DESC

-- Is there a linear relationship between the percentage of CASES and percentage of DEATHS in the different locations?

SELECT location, (max(total_cases)/max(population))*100 AS percentage_positive_population,
    (max(total_deaths)/max(total_cases))*100 AS percentage_death_of_positive_patients

FROM owid_covid_data.population_cases
WHERE continent is not null and total_cases is not null

GROUP BY location
ORDER BY 1

-- Probability of having covid related health issues by location

WITH CTE_Percentage_Positive_or_Death AS

(SELECT location, (max(total_cases)/max(population))*100 AS percentage_positive_population,
    (max(total_deaths)/max(total_cases))*100 AS percentage_death_of_positive_patients

FROM owid_covid_data.population_cases
WHERE continent is not null and total_cases is not null

GROUP BY location
)

SELECT location, percentage_positive_population * percentage_death_of_positive_patients as covid_viability_percentage
FROM CTE_Percentage_Positive_or_Death
ORDER BY covid_viability_percentage DESC;

-- Peru had 61 percent covid viability, this is to confirm
SELECT location, (max(total_cases)/max(population))*100 AS percentage_positive_population,
    (max(total_deaths)/max(total_cases))*100 AS percentage_death_of_positive_patients

FROM owid_covid_data.population_cases
WHERE location = 'Peru'

GROUP BY location
