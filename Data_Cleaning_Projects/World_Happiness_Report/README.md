# 🌍 SQL Data Cleaning Project: World Happiness Report (2015–2019)

This is my third data cleaning project using **SQL**, focusing on the **World Happiness Report** from **2015 to 2019**. The datasets across the years had different formats, column names, and missing values that required thorough cleaning and standardization.

In this project, I carefully merged five years of global happiness data into a single, consistent, and analysis-ready table.

---

## 📁 Dataset: World Happiness Reports (2015–2019)

The raw datasets were sourced from Kaggle, consisting of separate CSV files for each year:
- 2015
- 2016
- 2017
- 2018
- 2019

Each dataset contained country-specific happiness scores and contributing factors, but the column names, formats, and available variables changed over time.

---

## 🧽 Cleaning Process (Step-by-Step)

### ✅ Step 1: Identified Common Columns
- I carefully reviewed each dataset to find consistent columns that could be used across all years.
- Mapped different column names to a **unified schema**.

---

### ✅ Step 2: Cleaned and Standardized Each Table Individually
- Created duplicate tables to protect the raw data.
- Renamed columns to a **common naming convention** for easy merging.
- Converted data types to preserve decimal precision (e.g., `DECIMAL(10,5)` for scores).
- Removed unnecessary columns that:
  - Did not exist across all years.
  - Measured different statistical concepts (e.g., Standard Error vs. Confidence Intervals).
- Added a **`Year` column** to each table to track the source year.

---

### ✅ Step 3: Addressed Missing Regions
- Some datasets did not include the `Region` column.
- Used `JOIN` statements to fill missing regions by matching countries from previous years.
- Manually updated unmatched countries based on external knowledge.

---

### ✅ Step 4: Merged All Years Into a Final Table
- Combined the cleaned tables using `UNION ALL`.
- Created a final master table: **`clean_all_years`**

---

## 📚 Column Mapping Reference

| Unified Column Name           | 2015                          | 2016                               | 2017                          | 2018                         | 2019                         |
|--------------------------------|-------------------------------|------------------------------------|-------------------------------|------------------------------|------------------------------|
| `Country`                      | Country                       | Country                            | Country                       | Country or region            | Country or region            |
| `Region`                       | Region                        | Region                             | Added via JOIN                | Added via JOIN               | Added via JOIN               |
| `Happiness Rank`               | Happiness Rank                | Happiness Rank                     | Happiness Rank                | Overall Rank                 | Overall Rank                 |
| `Happiness Score`              | Happiness Score               | Happiness Score                    | Happiness Score               | Score                        | Score                        |
| `GDP per Capita`               | Economy (GDP per capita)      | Economy (GDP per capita)           | Economy (GDP per capita)      | GDP per Capita               | GDP per Capita               |
| `Social Support`               | Family                        | Family                             | Family                        | Social Support               | Social Support               |
| `Health Life Expectancy`       | Health (life expectancy)      | Health (life expectancy)           | Health (life expectancy)      | Healthy life expectancy      | Healthy life expectancy      |
| `Freedom`                      | Freedom                       | Freedom                            | Freedom                       | Freedom to make life choices | Freedom to make life choices |
| `Trust (Government Corruption)`| Trust (government corruption) | Trust (government corruption)      | Trust (government corruption) | Perceptions of corruption    | Perceptions of corruption    |
| `Generosity`                   | Generosity                    | Generosity                         | Generosity                    | Generosity                   | Generosity                   |

---

## 🚫 Columns Dropped for Consistency
- `Dystopia Residual`
- `Standard Error`
- `Lower/Upper Confidence Intervals`
- `Whisker High/Low`

> These columns were excluded to standardize the dataset and because they were **not consistently available across all years** or **measured incomparable statistical concepts.**

---

## 🛠️ Tools Used
- **MySQL**
- SQL functions: `CTE`, `ROW_NUMBER()`, `JOIN`, `UNION ALL`, `ALTER TABLE`

---

## 📊 Final Output: `clean_all_years`
The dataset is now fully cleaned, standardized, and ready for analysis or visualization in Power BI or Tableau.

---

## 📬 Contact Me
Feel free to reach out if you have feedback, questions, or tips!

📧 miguelalmazan.official@gmail.com  
📍 Quezon City, Philippines

