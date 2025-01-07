CREATE DATABASE FINANCE;
Show Databases;
Use FINANCE;
Show Tables;

Select * from Financial_Loan; 

-- How many loan applications have been submitted overall?
Select COUNT(*) from Financial_Loan;

-- MTD Loan Applications
-- How many loan applications have been submitted in the current month to date (MTD)?
DROP VIEW MTD_Loan_Applications;
CREATE View MTD_Loan_Applications AS
SELECT COUNT(id) AS Total_Applications FROM Financial_Loan
WHERE MONTH(issue_date) = 12
;
SELECT * FROM MTD_Loan_Applications;

-- Method 2
SELECT 
    COUNT(*) AS MTD_Loan_Applications
FROM 
    Financial_Loan
WHERE 
    issue_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') -- First day of the current month
    AND issue_date <= CURDATE(); -- Current date

-- PMTD Loan Applications
-- How many loan applications were submitted in the previous month to date (PMTD)?
CREATE View Previous_MTD_Loan_Applications AS
SELECT COUNT(id) AS Total_Applications FROM Financial_Loan
WHERE MONTH(issue_date) = 11;
SELECT * FROM Previous_MTD_Loan_Applications;

-- Total Funded Amount
-- What is the total funded amount for all loans?
-- DROP View Total_Funded_Amount;
CREATE View Total_Funded_Amount AS
SELECT SUM(loan_amount) 
FROM Financial_Loan;
SELECT * FROM Total_Funded_Amount;

-- MTD Total Funded Amount
DROP VIEW MTD_Total_Funded_Amount;
CREATE View MTD_Total_Funded_Amount AS
SELECT SUM(loan_amount) 
FROM Financial_Loan WHERE MONTH(issue_date) = 12;
SELECT * FROM MTD_Total_Funded_Amount;


-- PMTD Total Funded Amount
-- What was the total funded amount for loans in the previous month to date?
CREATE View PMTD_Total_Funded_Amount AS
SELECT SUM(loan_amount) 
FROM Financial_Loan WHERE MONTH(issue_date) = 11;
SELECT * FROM PMTD_Total_Funded_Amount;

-- Total Amount Received
-- What is the total amount received across all loans?
CREATE View Total_Amount_Received AS
SELECT SUM(total_payment) AS Total_Amount_Collected FROM Financial_Loan;
SELECT * FROM Total_Amount_Received;

-- MTD Total Amount Received
-- What is the total amount received in the current month to date?
CREATE View MTD_Total_Amount_Received AS
SELECT SUM(total_payment) AS Total_Amount_Collected FROM Financial_Loan WHERE MONTH(issue_date) = 12;
SELECT * FROM MTD_Total_Amount_Received;

-- PMTD Total Amount Received
CREATE View PMTD_Total_Amount_Received AS
SELECT SUM(total_payment) AS Total_Amount_Collected FROM Financial_Loan WHERE MONTH(issue_date) = 11;
SELECT * FROM PMTD_Total_Amount_Received;

-- Interest Rate and Debt-to-Income (DTI) Analysis

-- Average Interest Rate
-- What is the average interest rate for all loans?
CREATE View Average_Interest_Rate AS
SELECT AVG(int_rate) AS Total_Amount_Collected FROM Financial_Loan;
SELECT * FROM Average_Interest_Rate;

-- MTD Average Interest
-- What is the average interest rate for loans issued in the current month to date?
CREATE View MTD_Average_Interest_Rate AS
SELECT AVG(int_rate) AS Total_Amount_Collected FROM Financial_Loan WHERE MONTH(issue_date) = 12;
SELECT * FROM MTD_Average_Interest_Rate;

-- PMTD Average Interest
-- What was the average interest rate for loans issued in the previous month to date?
CREATE View PMTD_Average_Interest_Rate AS
SELECT AVG(int_rate) AS Total_Amount_Collected FROM Financial_Loan WHERE MONTH(issue_date) = 11;
SELECT * FROM PMTD_Average_Interest_Rate;

-- Avg DTI
-- What is the average Debt-to-Income (DTI) ratio for all borrowers?
CREATE View Average_DTI AS
SELECT AVG(dti) AS Total_Amount_Collected FROM Financial_Loan;
SELECT * FROM Average_DTI;

-- MTD Avg DTI
-- What is the average DTI ratio for loans issued in the current month to date?
CREATE View MTD_Average_DTI AS
SELECT AVG(dti) AS Total_Amount_Collected FROM Financial_Loan WHERE MONTH(issue_date) = 12;
SELECT * FROM MTD_Average_DTI;

-- PMTD Avg DTI
-- What was the average DTI ratio for loans issued in the previous month to date?
CREATE View PMTD_Average_DTI AS
SELECT AVG(dti) AS Total_Amount_Collected FROM Financial_Loan WHERE MONTH(issue_date) = 11;
SELECT * FROM PMTD_Average_DTI;


-- Loan Performance Metrics

-- Good Loan Issued
-- How many loans are classified as "Good" loans?
CREATE View Good_Loan_Issued AS
SELECT COUNT(id) AS total_count FROM Financial_Loan WHERE loan_status='current' or loan_status='fully_paid';
SELECT * FROM Good_Loan_Issued;

-- Good Loan Percentage
-- What percentage of total loans are classified as "Good" loans?
-- DROP VIEW Good_Loan_Percentage;
CREATE View Good_Loan_Percentage AS
SELECT (SUM(CASE WHEN loan_status='current' or loan_status='fully_paid' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS total_count FROM Financial_Loan;
SELECT * FROM Good_Loan_Percentage;

-- Good Loan Funded Amount
-- What is the funded amount for "Good" loans?
CREATE View Good_Loan_Funded_Amount AS
SELECT SUM(loan_amount) AS total_count FROM Financial_Loan WHERE loan_status='current' or loan_status='fully_paid';
SELECT * FROM Good_Loan_Funded_Amount;

-- Good Loan Amount Received
-- What is the total amount received for "Good" loans?
CREATE View Good_Loan_Amount_Received AS
SELECT SUM(total_payment) AS total_count FROM Financial_Loan WHERE loan_status='current' or loan_status='fully_paid';
SELECT * FROM Good_Loan_Amount_Received;

-- Bad Loan Issued
-- How many loans are classified as "Bad" loans?
CREATE View Bad_Loan_Issued AS
SELECT COUNT(id) AS total_count FROM Financial_Loan WHERE loan_status='Charged Off';
SELECT * FROM Bad_Loan_Issued;

-- Bad Loan Percentage
-- What percentage of total loans are classified as "Bad" loans?
CREATE View Bad_Loan_Percentage AS
SELECT (SUM(CASE WHEN loan_status='Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS total_count FROM Financial_Loan;
SELECT * FROM bad_Loan_Percentage;

-- Bad Loan Applications

-- How many loan applications were classified as "Bad"?

-- Bad Loan Funded Amount
-- What is the funded amount for "Bad" loans?
CREATE View Bad_Loan_Funded_Amount AS
SELECT SUM(loan_amount) AS total_count FROM Financial_Loan WHERE loan_status='Charged Off';
SELECT * FROM Bad_Loan_Funded_Amount;

-- Bad Loan Amount Received
-- What is the total amount received for "Bad" loans?
CREATE View Bad_Loan_Amount_Received AS
SELECT SUM(total_payment) AS total_count FROM Financial_Loan WHERE loan_status='Charged Off';
SELECT * FROM Bad_Loan_Amount_Received;

-- Loan Status Metrics

-- Loan Status Breakdown
-- What is the distribution of loans across statuses such as "Fully Paid," "Current," "Charged Off," and "Default"?
-- Method 1
CREATE VIEW Loan_Status_Metrics AS
SELECT 
    loan_status, 
    COUNT(*) AS loan_count,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Financial_Loan)) AS percentage_of_total,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_received_amount
FROM Financial_Loan
GROUP BY loan_status
ORDER BY loan_count DESC;

SELECT * FROM Loan_Status_Metrics;
-- Method 2
SELECT
        loan_status,
        COUNT(id) AS LoanCount,
        SUM(total_payment) AS Total_Amount_Received,
        SUM(loan_amount) AS Total_Funded_Amount,
        AVG(int_rate * 100) AS Interest_Rate,
        AVG(dti * 100) AS DTI
    FROM
        Financial_Loan
    GROUP BY
        loan_status;

-- Method 3
SELECT 
	loan_status, 
	SUM(total_payment) AS MTD_Total_Amount_Received, 
	SUM(loan_amount) AS MTD_Total_Funded_Amount 
FROM Financial_Loan
WHERE MONTH(issue_date) = 12 
GROUP BY loan_status;
-- ------------------------------------------- -----------------------
-- OVERVIEW

-- Loan Distribution Metrics

-- Loan Applications by Month
-- What is the distribution of loan applications by month?
-- Method 1 
CREATE VIEW Loan_Applications_By_Month AS
SELECT 
    MONTH(issue_date) AS application_month, 
    YEAR(issue_date) AS application_year,
    COUNT(*) AS total_applications
FROM Financial_Loan
GROUP BY YEAR(issue_date), MONTH(issue_date)
ORDER BY application_year, application_month;

SELECT * FROM Loan_Applications_By_Month;

-- Method 2
-- CREATE VIEW Loan_Applications_By_Month2 AS
-- SELECT 
--     YEAR(issue_date) AS Year,
--     MONTH(issue_date) AS Month_Number, 
--     DATE_FORMAT(issue_date, '%M') AS Month_Name, 
--     COUNT(id) AS Total_Loan_Applications,
--     SUM(loan_amount) AS Total_Funded_Amount,
--     SUM(total_payment) AS Total_Amount_Received
-- FROM Financial_Loan
-- GROUP BY YEAR(issue_date), MONTH(issue_date)
-- ORDER BY MONTH(issue_date);

-- SELECT * FROM Loan_Applications_By_Month2;


-- Loan Applications by State
-- What is the distribution of loan applications by state?
-- Drop VIEW Loan_Applications_Metrics_By_State;
CREATE VIEW Loan_Applications_Metrics_By_State AS
SELECT 
	address_state AS State, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM Financial_Loan
GROUP BY address_state
ORDER BY address_state;

SELECT * FROM Loan_Applications_Metrics_By_State;

-- Loan Applications by Term
-- What is the distribution of loans by term (e.g., 12 months, 36 months)?
Drop VIEW Loan_Applications_Metrics_By_Term;
CREATE VIEW Loan_Applications_Metrics_By_Term AS
SELECT 
    "Term in", 
    count(*) as loan_count 
FROM Financial_Loan
GROUP BY "Term in"
ORDER BY loan_count DESC;

SELECT * FROM Loan_Applications_Metrics_By_Term;
-- Method 2
SELECT 
	`term in` AS Term, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM Financial_Loan
GROUP BY term;

-- Loan Applications by Employment Length
-- What is the distribution of loans by the borrower’s employment length?
Drop VIEW Loan_Applications_Metrics_By_Employment_Length;
CREATE VIEW Loan_Applications_Metrics_By_Employment_Length AS
SELECT 
	`emp_length` AS Employment_Length,
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM Financial_Loan
GROUP BY Employment_Length ORDER BY Employment_Length;
SELECT * FROM Loan_Applications_Metrics_By_Employment_Length;

-- Loan Applications by Purpose
-- What is the distribution of loans by the purpose of the loan?
-- Drop VIEW Loan_Applications_Metrics_By_Purpose;
CREATE VIEW Loan_Applications_Metrics_By_Purpose AS
SELECT 
	purpose,
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM Financial_Loan
GROUP BY purpose;
SELECT * FROM Loan_Applications_Metrics_By_Purpose;

-- Loan Applications by Home Ownership
-- What is the distribution of loans by the borrower's home ownership status?
-- Drop VIEW Loan_Applications_Metrics_By_Home_Ownership;
CREATE VIEW Loan_Applications_Metrics_By_Home_Ownership AS
SELECT 
	Home_Ownership,
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM Financial_Loan
GROUP BY Home_Ownership;
SELECT * FROM Loan_Applications_Metrics_By_Home_Ownership;



-- Example Queries and Filters
-- Filter by Loan Grade
-- What are the results when applying filters (e.g., Grade A) on dashboards?
-- Drop VIEW Filter_by_Loan_Grade;
CREATE VIEW Filter_by_Loan_Grade AS
SELECT 
	Grade,
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM Financial_Loan
GROUP BY grade;
SELECT * FROM Filter_by_Loan_Grade;



-- What was the total amount received in the previous month to date?
-- 1. Total Loan Amount by State
--     * What is the total loan amount granted by each state?
CREATE View Total_Loan_Amount_WRT_State AS
SELECT Address_State, Sum(Loan_Amount) as Total_Amount from Financial_Loan Group By Address_State Order By Total_Amount DESC;
SELECT * FROM Total_Loan_Amount_WRT_State;

-- How many loans are in each loan_status?
CREATE View Total_Loan_Loan_Status AS
SELECT Loan_Status, Count(*) as Loan_Count from Financial_Loan Group By Loan_Status Order By Loan_Count DESC;
SELECT * FROM Total_Loan_Loan_Status;

-- 3. Average Annual Income of Borrowers by Grade
--     * What is the average annual income for borrowers in each loan grade?
CREATE View Average_Annual_Income_of_Borrowers_by_Grade AS
SELECT Sub_Grade, AVG(Annual_Income) as AVG_Income from Financial_Loan Group By Sub_Grade Order By AVG_Income DESC;
SELECT * FROM Average_Annual_Income_of_Borrowers_by_Grade;

-- 4. Loan Status by Employment Length
--     * What is the loan status distribution (approved, denied) by the number of years of employment?
CREATE View Loan_Status_by_Employment_Length AS
SELECT "emp_length(Years)",          -- Grouping by years of employment
    Loan_Status,                  -- Including loan status
    COUNT(*) AS loan_count  from Financial_Loan Group By "emp_length(Years)",         
    Loan_Status ORDER BY "emp_length(Years)",         
    Loan_Status DESC;
SELECT * FROM Loan_Status_by_Employment_Length;


-- 5. Loan Amount by Home Ownership Status
--     * What is the average loan amount based on the home ownership status (e.g., home owner, renter)?
CREATE View Loan_Amount_by_Home_Ownership_Status AS
SELECT home_ownership, Sum(Loan_Amount) as Total_Amount from Financial_Loan Group By home_ownership Order By Total_Amount DESC;
SELECT * FROM Loan_Amount_by_Home_Ownership_Status;

-- 6. Loans with Highest Interest Rates
--     * Which loans have the highest interest rates, and what are their details?
CREATE View Loans_with_Highest_Interest_Rates AS
SELECT * from Financial_Loan Where int_Rate = (SELECT MAX(int_Rate) from Financial_Loan);
SELECT * FROM Loans_with_Highest_Interest_Rates;

-- 7. Loan Payments Status and Next Payment Date
--     * What are the loans that have an outstanding payment and their next payment dates?
CREATE View Loan_Payments_Status_and_Next_Payment_Date AS
SELECT id, Loan_Status, Next_Payment_Date from Financial_Loan Where Loan_Status IN ('Current', 'Default') and Next_Payment_Date != 'Pending';
SELECT * FROM Loan_Payments_Status_and_Next_Payment_Date;

-- 8. Loans Issued in the Last 30 Days
--     * What are the loans that were issued within the last 30 days?
-- DROP VIEW Loans_Issued_Last_30_Days;
CREATE VIEW Loans_Issued_Last_30_Days AS
SELECT 
    id,                  
    issue_date,             
    loan_amount,            
    loan_status             
FROM 
    Financial_Loan
WHERE 
    STR_TO_DATE(issue_date, '%d-%m-%y') >= CURDATE() - INTERVAL 30 DAY;
  
SELECT * FROM Loans_Issued_Last_30_Days;



-- MoM(MOnth-On-Month)-------------------
SELECT 
    YEAR(issue_date) AS Year,
    MONTH(issue_date) AS Month,
    COUNT(id) AS Total_Applications,
    LAG(COUNT(id), 1) OVER (ORDER BY YEAR(issue_date), MONTH(issue_date)) AS Previous_Month_Applications,
    COUNT(id) - LAG(COUNT(id), 1) OVER (ORDER BY YEAR(issue_date), MONTH(issue_date)) AS MoM_Growth
FROM 
    Financial_Loan
GROUP BY 
    YEAR(issue_date), MONTH(issue_date)
ORDER BY 
    YEAR(issue_date), MONTH(issue_date);


SELECT 
    CURRENT_MONTH.Year,
    CURRENT_MONTH.Month,
    CURRENT_MONTH.Total_Loan_Amount AS MTD_Loan_Amount,
    PREVIOUS_MONTH.Total_Loan_Amount AS PMTD_Loan_Amount,
    -- MoM Growth Calculation
    CASE 
        WHEN PREVIOUS_MONTH.Total_Loan_Amount = 0 THEN 0
        ELSE (CURRENT_MONTH.Total_Loan_Amount - PREVIOUS_MONTH.Total_Loan_Amount) / PREVIOUS_MONTH.Total_Loan_Amount * 100
    END AS MoM_Growth_Percentage
FROM 
    -- Subquery for Current Month's Data
    (SELECT 
        YEAR(issue_date) AS Year,
        MONTH(issue_date) AS Month,
        SUM(loan_amount) AS Total_Loan_Amount
     FROM Financial_Loan
     GROUP BY YEAR(issue_date), MONTH(issue_date)) AS CURRENT_MONTH
     
JOIN 
    -- Subquery for Previous Month's Data
    (SELECT 
        YEAR(issue_date) AS Year,
        MONTH(issue_date) AS Month,
        SUM(loan_amount) AS Total_Loan_Amount
     FROM Financial_Loan
     GROUP BY YEAR(issue_date), MONTH(issue_date)) AS PREVIOUS_MONTH
ON CURRENT_MONTH.Year = PREVIOUS_MONTH.Year 
AND CURRENT_MONTH.Month = PREVIOUS_MONTH.Month + 1
ORDER BY CURRENT_MONTH.Year, CURRENT_MONTH.Month;
 

