# 🏦 Analytical CRM Development for a Bank

## 📝 Project Overview

This project involves a comprehensive Exploratory Data Analysis (EDA) of a retail bank's dataset comprising **10K customer records spanning four years (2016–2019)**. The primary objective is to transform raw customer, account, and transaction data into a clear view of why customers leave (churn) and what will make them stay. By engineering corrected metrics and segmenting the customer base, this project prescribes data-driven retention strategies to key stakeholders to combat a persistent ~20% churn rate.

<img width="1281" height="717" alt="Screenshot 2026-07-28 024145" src="https://github.com/user-attachments/assets/528368d0-10ec-4011-80bf-1c717c9067dc" />

## 🛠️ Tech Stack & Skills Demonstrated

* **Tools:** Power BI, SQL, DAX
* **Data Processing:** Data Cleaning, Relational Data Modeling (Star Schema), Data Validation.
* **Analytical Techniques:** Exploratory Data Analysis (EDA), Root Cause Analysis, Cohort Analysis, Anomaly Detection.
* **Business Intelligence:** Interactive Dashboard Design, KPI Tracking, Strategic Retention Prioritization.

## 🗄️ Dataset Architecture

The dataset spans 7 relational tables built around one core fact table (`Bank_Churn`), joined by `CustomerID`, and contains zero missing values. It includes:

* **Geographical & Demographic Data:** Country (France, Germany, Spain), Age, and Gender.
* **Financial Profile:** Credit Score, Current Account Balance, and Estimated Salary.
* **Engagement & Product Usage:** Tenure, Number of Products held, Credit Card ownership, and Active Member status.

> *Note: Comprehensive data cleaning was performed prior to analysis, including the creation of a corrected metric (`IsActiveMember_Corrected`) to fix a systemic data-entry lag where 735 exited customers were inaccurately flagged as still "Active".*

## 💡 Key Insights & Strategic Engineering

### 1. The "Churn Risk" Profile

* **Concept:** Segmented customers by behavior, geography, and financial health to isolate the strongest signals of future churn.
* **Key Findings:** Risk is highly concentrated among specific segments:
    1. **Demographics:** Customers aged 50+ exhibit the highest risk, with nearly a 45% churn rate.
    2. **Product Depth:** 1,409 of exited customers held just a single product, highlighting that one product equates to zero switching cost. 
    3. **Credit Health:** Customers with "Poor" credit (300–579) churn at the highest rate (22.02%).

### 2. Geographic & Seasonal Strategy

* **Insight:** Identified Germany as a structural outlier—it holds the fewest active members yet possesses the highest churn rate (32.44%) and the highest average balance among exiting customers.
* **Strategy:** Prescribed localized service quality investigations in Germany and targeted seasonal acquisition campaigns around reliable new-customer spikes observed every March, September, and November.

### 3. Dynamic Visual Dashboards

* Designed an interactive suite of Power BI dashboards: **Customer Demographics**, **Churn Analysis**, and **Product Engagement**.
* Empowered stakeholders with a CRM-native "Churn Risk" live view to surface at-risk accounts based on product depth and active status before the relationship ends.

## 📂 Repository Structure

* `Bank_CRM.pbix`: The interactive Power BI dashboard file containing the relational data model, DAX measures, and visual reports.
* `Bank_CRM.docx`: A detailed written report breaking down the EDA process and the logic behind the strategic recommendations.
* `Bank_CRM.pptx`: A high-level slide deck summarizing the root cause analysis, demographic vulnerabilities, and the top strategic retention actions.
* `Bank_CRM.sql`: SQL scripts detailing the CTEs and the segmentation logic used to prepare the dataset.

## 👨‍💻 Author

**Shreyas Rawat**

* Aspiring Data Scientist & Analyst
* LinkedIn: https://www.linkedin.com/in/shreyash-rawat-21a07b2002c
* GitHub: https://github.com/rawatshreyash217-stack
