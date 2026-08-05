-- -----------------------------------------------------OBJECTIVES --------------------------------------------------------------------------------

-- Question 1: What is the distribution of account balance across different regions?

SELECT
	GeographyLocation,
    ROUND(SUM(Balance),2) AS total_balance,
    ROUND(SUM(Balance) * 100 / (SELECT SUM(Balance) FROM bank_churn), 2) AS percentage
FROM customer_info a
JOIN bank_churn b ON a.CustomerID = b.CustomerID
JOIN geography c ON a.GeographyID = c.GeographyID
GROUP BY GeographyLocation
ORDER BY percentage DESC;

-- Question 2: Identify the top 5 customers with the highest Estimated Salary in the last quarter of the year.

SELECT
	CustomerID, Surname, EstimatedSalary, `Bank DOJ`
FROM customer_info
WHERE QUARTER(`Bank DOJ`) = 4
ORDER BY EstimatedSalary DESC
LIMIT 5;

-- Question 3: Calculate the average number of products used by customers who have a credit card.

SELECT
	AVG(NumOfProducts) AS avg_products_used_by_creditcard_holder
FROM bank_churn
WHERE HasCrCard = 1;

-- Question 4: Determine the churn rate by gender for the most recent year in the dataset.

SELECT
	GenderCategory,
    ROUND(SUM(Exited) * 100 / COUNT(*), 2) AS Churn_Rate_Percentage
FROM customer_info a
JOIN bank_churn b ON a.CustomerID = b.CustomerID
JOIN gender c ON a.GenderID = c.GenderID
WHERE YEAR(`Bank DOJ`) = (SELECT YEAR(MAX(`Bank DOJ`)) FROM customer_info)
GROUP BY GenderCategory;

-- Question 5: Compare the average credit score of customers who have exited and those who remain.

SELECT
	ExitCategory,
    ROUND(AVG(CreditScore), 2) AS AvgCreditScore
FROM bank_churn a
JOIN exit_customer b ON a.Exited = b.ExitID
GROUP BY ExitCategory;

-- Question 6: Which gender has a higher average estimated salary, and how does it relate to the number of active accounts?

SELECT
	GenderCategory,
    ROUND(AVG(EstimatedSalary), 2) AS AvgEstimatedSalary,
    SUM(IsActiveMember_Corrected) AS No_Of_Active_Accounts
FROM customer_info a
JOIN bank_churn b ON a.CustomerID = b.CustomerID
JOIN gender c ON a.GenderID = c.GenderID
GROUP BY GenderCategory;

-- Question 7: Segment the customers based on their credit score and identify the segment with the highest exit rate.
-- (Credit Score Segmentation: Excellent: 800–850, Very Good: 740–799, Good: 670–739, Fair: 580–669, Poor: 300–579)

SELECT 
    CASE 
        WHEN CreditScore BETWEEN 800 AND 850 THEN 'Excellent (800-850)'
        WHEN CreditScore BETWEEN 740 AND 799 THEN 'Very Good (740-799)'
        WHEN CreditScore BETWEEN 670 AND 739 THEN 'Good (670-739)'
        WHEN CreditScore BETWEEN 580 AND 669 THEN 'Fair (580-669)'
        WHEN CreditScore BETWEEN 300 AND 579 THEN 'Poor (300-579)'
        ELSE 'Other'
    END AS Credit_Segment,
    COUNT(CustomerID) AS Total_Customers,
    SUM(Exited) AS Churned_Customers,
    ROUND(SUM(Exited) * 100 / COUNT(CustomerID), 2) AS Exit_Rate_Percentage
FROM bank_churn
GROUP BY Credit_Segment
ORDER BY Exit_Rate_Percentage DESC;

-- Question 8: Find out which geographic region has the highest number of active customers with a tenure greater than 5 years.

SELECT
	GeographyLocation,
    COUNT(a.CustomerID) AS No_Of_Active_Customers
FROM customer_info a
JOIN bank_churn b ON a.CustomerID = b.CustomerID
JOIN geography c ON a.GeographyID = c.GeographyID
WHERE IsActiveMember_Corrected = 1 AND Tenure > 5
GROUP BY GeographyLocation
ORDER BY No_Of_Active_Customers DESC;

-- Question 9: What is the impact of having a credit card on customer churn, based on the available data?

SELECT
	CreditCategory,
    ROUND(SUM(Exited) * 100 / COUNT(*), 2) AS Churn_Rate_Percentage
FROM bank_churn
JOIN credit_card ON HasCrCard = CreditID
GROUP BY CreditCategory;

-- Question 10: For customers who have exited, what is the most common number of products they had used?

SELECT
	NumOfProducts,
    COUNT(*) AS Customer_Count
FROM bank_churn
WHERE Exited = 1
GROUP BY NumOfProducts
ORDER BY Customer_Count DESC;

-- Question 11: Examine the trend of customer joining over time and identify any seasonal patterns (yearly or monthly).

SELECT 
    YEAR(`Bank DOJ`) AS Join_Year,
    MONTHNAME(`Bank DOJ`) AS Join_Month,
    MONTH(`Bank DOJ`) AS Month_Number,
    COUNT(CustomerID) AS Total_New_Customers
FROM customer_info
GROUP BY Join_Year, Join_Month, Month_Number
ORDER BY Join_Year, Month_Number;

-- Question 12: Analyze the relationship between the number of products and the account balance for customers who have exited.

SELECT 
    NumOfProducts,
    COUNT(CustomerId) AS Total_Exited,
    SUM(CASE WHEN Balance = 0 THEN 1 ELSE 0 END) AS Zero_Balance_Count,
    SUM(CASE WHEN Balance > 0 THEN 1 ELSE 0 END) AS Has_Balance_Count,
    ROUND(AVG(CASE WHEN Balance > 0 THEN Balance ELSE NULL END), 2) AS Avg_NonZero_Balance
FROM bank_churn
WHERE Exited = 1
GROUP BY NumOfProducts
ORDER BY NumOfProducts;

-- Question 15: Find gender-wise average income of Male and Female in each Geography id. Also rank the gender according to the average value.

SELECT
	GeographyLocation,
    GenderCategory,
    ROUND(AVG(EstimatedSalary),2) AS Average_Income,
    RANK()OVER(PARTITION BY GeographyLocation ORDER BY ROUND(AVG(EstimatedSalary),2) DESC) AS Gender_Rank
FROM customer_info a
JOIN gender b ON a.GenderID = b.GenderID
JOIN geography c ON a.GeographyID = c.GeographyID
GROUP BY GeographyLocation, GenderCategory
ORDER BY GeographyLocation, Gender_Rank;

-- Question 16: Find out the average tenure of the people who have exited in each age bracket (18-30, 31-50, 50+).

SELECT 
	CASE 
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 50 THEN '31-50'
        WHEN Age > 50 THEN '50+'
        ELSE 'Under 18'
	END AS Age_Bracket,
    ROUND(AVG(Tenure), 2) AS Average_Tenure,
    COUNT(a.CustomerID) AS Total_Exited_Customers
FROM bank_churn a
JOIN customer_info b ON a.CustomerID = b.CustomerID
WHERE Exited = 1
GROUP BY Age_Bracket
ORDER BY Age_Bracket;

-- Question 19: Rank each bucket of credit score as per the number of customers who have churned the bank.

SELECT 
    CASE 
		WHEN CreditScore BETWEEN 300 AND 579 THEN 'Poor (300-579)'
		WHEN CreditScore BETWEEN 580 AND 669 THEN 'Fair (580-669)'
		WHEN CreditScore BETWEEN 670 AND 739 THEN 'Good (670-739)'
		WHEN CreditScore BETWEEN 740 AND 799 THEN 'Very Good (740-799)'
		WHEN CreditScore BETWEEN 800 AND 850 THEN 'Excellent (800-850)' 
		ELSE 'Other'
	END AS Credit_Bucket,
    COUNT(CustomerID) AS Total_Churned_Customers,
	RANK() OVER(ORDER BY COUNT(CustomerID) DESC) AS Churn_Rank
FROM bank_churn
WHERE Exited = 1
GROUP BY Credit_Bucket
ORDER BY Churn_Rank;

-- Question 20: According to the age buckets find the number of customers who have a credit card.
-- Also retrieve those buckets who have lesser than average number of credit cards per bucket.

WITH Bucket_Calculations AS (
    SELECT 
        CASE 
            WHEN Age BETWEEN 18 AND 30 THEN '18-30'
            WHEN Age BETWEEN 31 AND 50 THEN '31-50'
            WHEN Age > 50 THEN '50+'
            ELSE 'Under 18'
        END AS Age_Bracket,
        SUM(CASE WHEN HasCrCard = 1 THEN 1 ELSE 0 END) AS Total_Credit_Cards,
        AVG(SUM(CASE WHEN HasCrCard = 1 THEN 1 ELSE 0 END)) OVER() AS Avg_Credit_Cards
    FROM bank_churn b
    JOIN customer_info c ON b.CustomerID = c.CustomerID
    GROUP BY Age_Bracket
)
SELECT
	Age_Bracket, Total_Credit_Cards
FROM Bucket_Calculations
WHERE Total_Credit_Cards < Avg_Credit_Cards
ORDER BY Age_Bracket;

-- Question 21: Rank the Locations as per the number of people who have churned the bank and average balance of those customers.

SELECT
	GeographyLocation,
    COUNT(a.CustomerID) AS Total_Churned_Customers,
    ROUND(AVG(Balance),2) AS Average_Balance,
    RANK()OVER(ORDER BY COUNT(a.CustomerID) DESC, ROUND(AVG(Balance),2) DESC) AS Location_Rank
FROM customer_info a
JOIN bank_churn b ON a.CustomerID = b.CustomerID
JOIN geography c ON a.GeographyID = c.GeographyID
WHERE Exited = 1
GROUP BY GeographyLocation
ORDER BY Location_Rank;

-- Question 23: Without using any type of “Join”, fetch the “ExitCategory” from Exit_Customer table to the Bank_Churn table.

SELECT b.*,
	(
		SELECT e.ExitCategory
		FROM exit_customer e
		WHERE b.Exited = e.ExitID
    ) AS ExitCategory
FROM bank_churn b;

-- Question 25: Fetch the CustomerID, their Surname and whether they are Active or not, for the customers whose surname ends with “on”.

SELECT
	c.CustomerID, Surname, ActiveCategory
FROM customer_info c
JOIN bank_churn b ON c.CustomerID = b.CustomerID
JOIN active_customer a ON a.ActiveID = b.IsActiveMember_Corrected
WHERE Surname LIKE '%on';

-- ------------------------------------------------------------ SUBJECTIVES -----------------------------------------------------------------------------------

-- Question 9: Utilize SQL queries to segment customers based on demographics and account details.

WITH Customer_Segments AS (
    SELECT 
        c.CustomerID,
        GeographyLocation,
        Exited,
        -- Demographic Segmentation
        CASE 
            WHEN Age < 23 THEN 'Gen Z / Student (< 23)'
            WHEN Age BETWEEN 23 AND 40 THEN 'Young Professional (23-40)'
            WHEN Age BETWEEN 41 AND 60 THEN 'Mid-Career (41-60)'
            ELSE 'Retiree (60+)' 
        END AS Life_Stage,
        -- Account Detail Segmentation
        CASE 
            WHEN Balance = 0 THEN 'Zero Balance'
            WHEN Balance BETWEEN 1 AND 50000 THEN 'Low Balance (< 50k)'
            WHEN Balance BETWEEN 50001 AND 150000 THEN 'Medium Balance (50k-150k)'
            ELSE 'High Balance (150k+)' 
        END AS Wealth_Tier
    FROM
		bank_churn b
		JOIN customer_info c ON b.CustomerID = c.CustomerID
		JOIN geography g ON g.GeographyID = c.GeographyID
)
SELECT 
    GeographyLocation,
    Life_Stage,
    Wealth_Tier,
    COUNT(CustomerID) AS Total_Customers,
    SUM(Exited) AS Total_Churned,
    ROUND((SUM(Exited) / COUNT(CustomerId)) * 100, 2) AS Churn_Rate_Percentage
FROM 
    Customer_Segments
GROUP BY 
    GeographyLocation, Life_Stage, Wealth_Tier
ORDER BY 
    Churn_Rate_Percentage DESC;
    
-- Question 14: In the “bank_churn” table how can you modify the name of “HasCrCard” column to “Has_CreditCard”?

ALTER TABLE bank_churn 
RENAME COLUMN HasCrCard TO Has_CreditCard;

-- (Run the below query to get the original column name back, as all the other above queries utilises the original column name)
ALTER TABLE bank_churn 
RENAME COLUMN Has_CreditCard TO HasCrCard;