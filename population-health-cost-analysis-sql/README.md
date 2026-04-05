# 🏥 Population Health Analytics (SQL Project)

## 📌 Overview
This project analyzes healthcare claims data to uncover **disease prevalence, cost drivers, and population health trends** using SQL.

---

## 🎯 Key Objectives
- Analyze **disease prevalence**
- Identify **high-cost conditions**
- Examine **health trends by age group**
- Perform **data quality and eligibility checks**

---

## 🗂️ Dataset
- **Claims** – medical claims and costs  
- **Members** – demographics and enrollment data  
- **Diagnoses** – disease mappings  

---

## 🛠️ Tools Used
- **SQL (SSMS)**
- Data analysis & aggregation  
- Joins and business logic  

---

## 📊 Analysis Performed

### Disease Prevalence
Calculated the percentage of members diagnosed with each condition.

**Approach:** Counted distinct members per diagnosis and divided by total members to determine prevalence percentage.

---

### Financial Analysis
Analyzed cost distribution by disease.

**Approach:** Aggregated total and average claim costs grouped by diagnosis to identify high-cost conditions.

---

### Age Group Analysis
Examined how disease prevalence varies by age.

**Approach:** Derived member age using birth date, grouped into age bands, and calculated prevalence within each group.

---

### Eligibility Validation
Checked for invalid claims based on enrollment rules.

**Approach:** Flagged claims where service date occurred before enrollment date and summarized valid vs invalid counts.


## 📁 Project Contents
- SQL script with full analysis  
- Screenshots of query execution  
- Results and insights  

---

## 📈 Key Takeaway
Demonstrates ability to **analyze healthcare data, write efficient SQL queries, and generate actionable insights**.

