# 🗄️ SQL: Company Employee Performance Analysis (ScienceQtech)

## 📌 Project Overview
* **Goal:** To clean up a company's employee database and write queries to check salaries, employee ratings, and who reports to whom.
* **Dataset:** 3 connected tables covering employee details, project timelines, and data science teams (`emp_record_table`, `proj_table`, and `data_science_team`).

## 🛠️ Tools Used
* **Platform:** MySQL Workbench
* **Key SQL Techniques:** Joining tables, Window Functions (`DENSE_RANK`), Views, and Stored Functions.

---

## ⚙️ How I Built the Project (Step-by-Step)
1. **Database Clean up:** Fixed messy date formats and incorrect data types using `ALTER TABLE` commands so queries run smoothly.
2. **Connecting Tables:** Added Primary and Foreign Keys to link the employee and project tables together.
3. **Fixing Missing Data:** Found and fixed an empty project ID record by running a `LEFT JOIN` query looking for `NULL` fields that was breaking the database links.
4. **Automation:** Created a stored SQL function that automatically checks an employee's years of experience and assigns their official job title.

---

## 💡 Key Insights (What I Found)
* **Insight 1 (Company Hierarchy):** Used a `INNER JOIN` query to map out employee IDs to manager IDs to identify active team hierarchies and count exactly how many employees report to each manager.
* **Insight 2 (Salary Ranges):** Found the minimum `MIN(SALARY)` and maximum `MAX(SALARY)` salaries for every single job role in the company to see how pay is distributed.
* **Insight 3 (Top Performers):** Used a window function `MAX(EMP_RATING) OVER(PARTITION BY DEPT)` to find the highest employee rating in each department.
* **Insight 4 (Experience Ranking):** Ranked all employees from highest to lowest based on their total years of experience using `DENSE_RANK() OVER(ORDER BY EXP DESC)` function.

---

## 📐 Database Structure (ER Diagram)
Below is the visual layout showing how the employee, project, and team tables connect to each other:

![Database ER Diagram](./visuals/Screenshot%202026-06-05%20181834.png)

---

## 🚀 Explore My Work (Quick Links)
* 💻 **[View Code Script](https://github.com/paladitya2077-datawizard/sql-employee-performance-mapping-project/blob/a3be6a4f268341f8da57720fc99d92c27c40f1d7/scripts/Aditya%20Pal%20SQL%20ScienceQtech%20Project.sql):** See my clean SQL queries, joins, and functions.
* 🖼️ **[Browse Result Screenshots](https://github.com/paladitya2077...):** Look at screenshots of the final query output tables.
