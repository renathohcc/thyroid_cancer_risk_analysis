# Analytical Dashboard: Thyroid Cancer Risk Based on Clinical and Hormonal Factors

## Overview
This project aims to analyze the relationship between clinical, demographic, and hormonal data of patients and the risk of being diagnosed with **thyroid cancer**. The analysis was conducted to identify potential correlations between variables and highlight the most relevant factors for prognosis. Results are displayed through an interactive dashboard developed in Power BI.

The data used in this study was obtained from a publicly available dataset on the Kaggle platform. You can access the original dataset [at this link](https://www.kaggle.com/datasets/bhargavchirumamilla/thyroid-cancer-risk-dataset)

---

## Objectives
- 1️⃣ Explore correlations between patient data and thyroid cancer diagnosis.
- 2️⃣ Understand how each factor (demographic, clinical, or hormonal) influences the risk and final diagnosis.

---

## Tools Used
- **Python**: Data cleaning, spreadsheet conversion, and support scripts
- **MySQL**: Creation and execution of queries with aggregations and filters
- **Power BI**: Development of interactive visualizations
- **Figma**: Visual design and graphical elements

---

## Project Workflow
1. **Data extraction and preprocessing** using Python (cleaning, formatting, structuring)
2. **SQL database creation** for optimized organization and querying
3. **Development of exploratory and descriptive queries** in SQL
4. **Dashboard construction in Power BI**, complemented by Figma visuals

---

## Extracted Insights

![Page 01: KPIs, Distributions and Initial Analysis](Resources/Page%201.png)

### General Data Overview:
- 23.27% of the cases studied resulted in a **malignant thyroid cancer diagnosis**.
- 15% of the cases were classified as **high risk**.
- **Family history** was the **most common risk factor** among malignant cases.
- Gender distribution: **59.96% female**, **40.04% male**.
- Most common ethnicities: **Caucasian (29.93%)** and **Asian (25.04%)**.
- **India** showed the highest malignancy rate among analyzed countries: **32.89%**.

![Page 02: Detailed Analysis per factor](Resources/Page%202.png)

### Exploratory Analysis:
- **Age vs Risk**: The average risk level remained constant across all age ranges, indicating **no direct correlation** with the diagnosis.
- **Nodule Size vs Diagnosis**: Malignancy probability remained constant across all nodule size ranges, suggesting that **size alone is not a determining factor**.
- **Hormones (TSH, T3, T4) vs Risk/Diagnosis**: Average hormone levels remained stable across all risk levels and diagnosis types. **No hormone showed significant variation** that could be directly linked to malignancy.
- **Combined Risk Factors**: Combinations with the highest malignancy percentages frequently included:
  - **Family History**
  - **Radiation Exposure**
  - **Iodine Deficiency**

---

## Conclusion
The analysis revealed no direct correlation between hormone levels or patient age and a **thyroid cancer diagnosis**. Likewise, nodule size alone did not prove relevant. However, combinations of multiple risk factors — especially family history, radiation exposure, and iodine deficiency — showed stronger associations with malignancy.

This project emphasizes the importance of multidimensional analysis to better understand oncological risk and demonstrates how interactive dashboards can support data-driven decision-making.

---

## Dashboard Access
To access the published version of the dashboard, click [here](https://app.powerbi.com/view?r=eyJrIjoiOTJkNDFhZmYtYzc0MS00MmRjLWFjYWUtNjFiZGM5MGRhZDQ3IiwidCI6IjBlZjRjMzY5LTE5NmUtNDQ2Ny1hNDY2LTZkNTJmZWFjYjNkYyJ9) 

---

## 📜 License
This project is open-source and available under the MIT License.

---

### 🎯 Author
Developed by **Renatho Campos**  
📧 Contact: renathohcc@hotmail.com
