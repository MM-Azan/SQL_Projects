# 🎬 Netflix Titles Data Cleaning Project

This SQL project focuses on cleaning the **Netflix Movies and TV Shows Dataset**. It showcases essential data cleaning skills using SQL, including:

- Removing unnecessary columns
- Handling duplicates
- Standardizing inconsistent data
- Handling null/blank values
- Creating useful derived columns
- Preparing a clean final table for analysis

---

## 🗂️ Dataset

- **Name:** Netflix Movies and TV Shows
- **Source:** [Kaggle - Netflix Titles](https://www.kaggle.com/datasets/shivamb/netflix-shows)

---

## 🛠️ Tools Used

- **SQL (MySQL)**
- DBMS of your choice (e.g., MySQL Workbench, DBeaver, or phpMyAdmin)

---

## 🔍 Data Cleaning Steps

### ✅ Step 1: Remove Unnecessary Columns
- Dropped placeholder or blank columns like `MyUnknownColumn_[12]`.

### ✅ Step 2: Check for and Remove Duplicates
- Used `ROW_NUMBER()` with a `CTE` to identify duplicate records based on all fields.

### ✅ Step 3: Standardize Text Data
- Trimmed extra whitespace in columns like `title`, `director`, `cast`, etc.

### ✅ Step 4: Handle Null or Blank Values
- Used `CASE WHEN` to detect blanks/nulls
- Replaced blanks with `"Unknown"` for consistency

### ✅ Step 5: Parse Duration into Two Columns
- Separated duration into:
  - `duration_int`: the number (e.g., `90`, `2`)
  - `duration_unit`: the unit (`min`, `season`)

### ✅ Step 6: Convert Text Dates to `DATE` Format
- Created `clean_date_added` column using `STR_TO_DATE()`

### ✅ Step 7: Create Final Clean Table
- Created `netflix_final` table with all cleaned and standardized data

---

## 📁 Output Table Structure

Final table: `netflix_final`

| Column Name         | Description                       |
|---------------------|-----------------------------------|
| show_id             | Unique ID for show                |
| type                | Movie or TV Show                  |
| title               | Cleaned title                     |
| director            | Cleaned director info             |
| cast                | Cleaned cast                      |
| country             | Cleaned country                   |
| date_added          | Original text date                |
| release_year        | Year released                     |
| rating              | MPAA/TV rating                    |
| duration            | Original duration text            |
| listed_in           | Genres                            |
| description         | Show description                  |
| clean_date_added    | `DATE` format of `date_added`     |
| duration_int        | Numeric value of duration         |
| duration_unit       | Unit of duration (`min`, `season`)|

---

## 📌 Summary

This project demonstrates key SQL data cleaning steps that are valuable for:
- Entry-level data analyst roles
- Data preparation before visualization or modeling
- Building portfolio projects that show real data transformation

---

## 🙋‍♂️ Author

**Miguel Mateo C. Almazan**  
Email: miguelalmazan.official@gmail.com  
Location: Quezon City, PH
