use financial_loan_analysis;
SELECT COUNT(*) FROM financial_loan_data;
SELECT * FROM financial_loan_data;

-- Calculating Total Loan Applications
SELECT COUNT(id) AS Total_Applications FROM financial_loan_data;

ALTER TABLE financial_loan_data
ADD COLUMN issued_date_dt DATE;

UPDATE financial_loan_data
SET issued_date_dt = STR_TO_DATE(issue_date, '%d-%m-%Y');

-- Total_Loan_Applications
SELECT COUNT(id) AS Total_Loan_Applications 
FROM financial_loan_data;

-- Calculating  Month To Date Total Loan Applications
SELECT COUNT(id) AS MTD_Total_Loan_Applications 
FROM financial_loan_data
WHERE MONTH(issued_date_dt)=12 AND YEAR(issued_Date_dt)=2021;
  
-- Calculating  Previous Month To Date Total Loan Applications
SELECT COUNT(id) AS PMTD_Total_Loan_Applications 
FROM financial_loan_data
WHERE MONTH(issued_date_dt)=11 AND YEAR(issued_Date_dt)=2021;

-- Change in percentage between MTD and PMTD total loan applications
SELECT 
    MTD_Total_Loan_Applications,
    PMTD_Total_Loan_Applications,
    ((MTD_Total_Loan_Applications - PMTD_Total_Loan_Applications) / PMTD_Total_Loan_Applications) * 100 
        AS Percentage_Change
FROM
(
    SELECT 
        -- MTD
        SUM(CASE 
            WHEN MONTH(issued_date_dt) = 12 
             AND YEAR(issued_date_dt) = 2021 
            THEN 1 ELSE 0 END) AS MTD_Total_Loan_Applications,

        -- PMTD
        SUM(CASE 
            WHEN MONTH(issued_date_dt) = 11 
             AND YEAR(issued_date_dt) = 2021 
            THEN 1 ELSE 0 END) AS PMTD_Total_Loan_Applications

    FROM financial_loan_data
) t;

-- Calculating  Month To Date Total Funded Amount
SELECT SUM(loan_amount) AS MTD_Loan_Applications 
FROM financial_loan_data
WHERE MONTH(issued_date_dt)=12 AND YEAR(issued_Date_dt)=2021;

-- Calculating Previous Month To Date Total Funded Amount 
SELECT SUM(loan_amount) AS PMTD_Loan_Applications 
FROM financial_loan_data
WHERE MONTH(issued_date_dt)=11 AND YEAR(issued_Date_dt)=2021;

-- Total Received Amount
SELECT  SUM(total_payment) AS Total_Received_Amount FROM  financial_loan_data;

-- Total Received Amount Month To Date
SELECT  SUM(total_payment) AS MTD_Total_Received_Amount FROM  financial_loan_data
WHERE MONTH(issued_date_dt)=12 AND YEAR(issued_date_dt)=2021;
  
-- Total Received Amount Previous Month To Date
SELECT  SUM(total_payment) AS PMTD_Total_Received_Amount FROM  financial_loan_data
WHERE MONTH(issued_date_dt)=11 AND YEAR(issued_date_dt)=2021;

-- Average Interest Rate %
SELECT ROUND(AVG(int_rate) * 100,2) AS AVG_Interest_Rate FROM financial_loan_data;

-- Average Interest Rate % Month To Date
SELECT ROUND(AVG(int_rate) * 100,2) AS MTD_AVG_Interest_Rate FROM financial_loan_data
WHERE MONTH(issued_date_dt)=12 AND YEAR(issued_date_dt)=2021;

-- Average Interest Rate % Previous Month To Date
SELECT ROUND(AVG(int_rate) * 100,2) AS PMTD_AVG_Interest_Rate FROM financial_loan_data
WHERE MONTH(issued_date_dt)=11 AND YEAR(issued_date_dt)=2021;

-- Average DTI % 
SELECT ROUND(AVG(dti) * 100,2) AS AVG_DTI FROM financial_loan_data;

-- Average DTI % Month To Date
SELECT ROUND(AVG(dti) * 100,2) AS AVG_DTI_MTD FROM financial_loan_data
WHERE MONTH(issued_date_dt) =12 AND YEAR(issued_date_dt)=2021;

-- Average DTI % Previous Month To Date
SELECT ROUND(AVG(dti) * 100,2)  AVG_DTI_PMTD FROM financial_loan_data
WHERE MONTH(issued_date_dt) =11 AND YEAR(issued_date_dt)=2021;

-- Good loan application Percentage
SELECT (COUNT(CASE WHEN loan_status='Fully Paid' OR loan_status='Current' THEN id END) *100)
/
COUNT(id) AS Good_Loan_Percentage FROM financial_loan_data;

-- Total Good Loan Applications
SELECT COUNT(id) AS Total_Good_Applications FROM financial_loan_data
WHERE loan_status IN ('Fully Paid','Current');

-- Total Good Loan Funded Amount
SELECT SUM(loan_amount) AS Total_Good_Loan_Funded_Amount FROM financial_loan_data
WHERE loan_status IN ('Fully Paid','Current');

-- Total Good Loan Received_Amount
SELECT SUM(total_payment) AS Total_Good_Loan_Received_Amount FROM financial_loan_data
WHERE loan_status IN ('Fully Paid','Current');

-- Bad Loan Application Percentage
SELECT (COUNT(CASE WHEN loan_status ='Charged Off' THEN id END)*100)
/
COUNT(id) AS Bad_Loan_Application_Percentage FROM financial_loan_data;

-- Total Bad Loan Applications
SELECT COUNT(id) AS Total_Bad_Loan_Applications FROM financial_loan_data
WHERE loan_status ='Charged Off';

-- Total Bad Loan Funded Amount
SELECT SUM(loan_amount) AS Total_Bad_Loan_Funded_Amount FROM financial_loan_data
WHERE loan_status ='Charged Off';


  -- Total Bad Loan Received Amount
SELECT SUM(total_payment) AS Total_Bad_Loan_Received_Amount FROM financial_loan_data
WHERE loan_status ='Charged Off';

-- Loan Status analysis
SELECT 
loan_status,
COUNT(id) AS Total_Applications,
SUM(total_payment) AS Total_Received_Amount,
SUM(loan_amount) AS Total_Funded_Amount,
ROUND(AVG(int_rate * 100),2) AS Interest_Rate,
ROUND(AVG(dti * 100),2) AS DTI
FROM financial_loan_data
GROUP BY loan_status;

-- Loan Status analysis MTD

SELECT
loan_status,
SUM(loan_amount) AS MTD_Total_Funded_Amount,
SUM(total_payment) AS MTD_Total_Amount_Received
FROM financial_loan_data
WHERE MONTH(issued_date_dt)=12
GROUP BY loan_status;

-- Monthly Trend Analysis
SELECT 
MONTH(issued_date_dt) AS Month_Number,
MONTHNAME(issued_date_dt) AS Month_Name,
COUNT(id) AS Total_Applications,
SUM(total_payment) AS Total_Received_Amount,
SUM(loan_amount) AS Total_Funded_Amount
FROM financial_loan_data
GROUP BY MONTH(issued_date_dt) ,MONTHNAME(issued_date_dt)
ORDER BY MONTH(issued_date_dt);
 
-- Regional Analysis
SELECT 
address_state,
COUNT(id) AS Total_Applications,
SUM(total_payment) AS Total_Received_Amount,
SUM(loan_amount) AS Total_Funded_Amount
FROM financial_loan_data
GROUP BY address_state
ORDER BY address_state;


-- Top 10 States with Highest Loan Applications 
SELECT 
address_state,
COUNT(id) AS Total_Applications,
SUM(total_payment) AS Total_Received_Amount,
SUM(loan_amount) AS Total_Funded_Amount
FROM financial_loan_data
GROUP BY address_state
ORDER BY COUNT(id) DESC
LIMIT 10;

-- Analysis by Term
SELECT 
term AS Term,
COUNT(id) AS Total_Applications,
SUM(total_payment) AS Total_Received_Amount,
SUM(loan_amount) AS Total_Funded_Amount
FROM financial_loan_data
GROUP BY term
ORDER BY term ;

-- Emp Length 

SELECT 
	emp_length AS Employee_Length, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM financial_loan_data
GROUP BY emp_length
ORDER BY emp_length;

-- Anaysis By Purpose
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM financial_loan_data
GROUP BY purpose
ORDER BY purpose;

-- Analysis by Home Ownership
SELECT 
	home_ownership AS Home_Ownership, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM financial_loan_data
GROUP BY home_ownership
ORDER BY home_ownership;

-- mom

SELECT 
    Year,
    Month,
    Total_Funded,

    -- Previous Month Value
    LAG(Total_Funded) OVER (ORDER BY Year, Month) AS Prev_Month_Funded,

    -- MoM %
    ((Total_Funded - LAG(Total_Funded) OVER (ORDER BY Year, Month)) / 
     LAG(Total_Funded) OVER (ORDER BY Year, Month)) * 100 AS MoM_Percentage

FROM
(
    SELECT 
        YEAR(issued_date_dt) AS Year,
        MONTH(issued_date_dt) AS Month,
        SUM(loan_amount) AS Total_Funded

    FROM financial_loan_data
    GROUP BY Year, Month
) t

ORDER BY Year, Month;