# 📉 Data Cleaning Project: World Layoffs

This is my **first** data cleaning project using **SQL**, where I worked with a dataset containing layoff records from tech companies around the world. The main goal of this project was to clean and standardize the raw data, making it ready for deeper analysis or dashboard visualization.

---

## 📁 Dataset: `layoffs.csv`

This dataset includes columns such as:

- `company`
- `location`
- `industry`
- `total_laid_off`
- `percentage_laid_off`
- `date`
- `stage`
- `country`
- `funds_raised_millions`

---

## 🧽 Steps I Took to Clean the Data

### ✅ 1. **Created a backup table**
Duplicated the original `layoffs` table into `layoffs_staging` to preserve raw data before making any transformations.

---

### 🧹 2. **Removed duplicates**
- Used a `ROW_NUMBER()` window function to identify duplicate rows based on matching values across all columns.
- Inserted cleaned data into a second staging table `layoffs_staging2`, and removed rows where `row_num > 1`.

---

### 🧼 3. **Standardized formatting**
- Applied `TRIM()` to remove extra white spaces from string fields.
- Manually fixed inconsistencies:
  - `"Crypto %"` → `"Crypto"`
  - `"United States."` → `"United States"`

---

### 📅 4. **Formatted dates**
- Converted the `date` column from `TEXT` to `DATE` using `STR_TO_DATE()`.

---

### ❓ 5. **Handled missing values**
- Counted all `NULL` or blank fields across key columns.
- Replaced:
  - Blank/`NULL` `industry` → `"Unknown"`
  - Blank/`NULL` `stage` → `"Unknown"`
- Left numeric fields (`total_laid_off`, `percentage_laid_off`) as they were, due to their sensitive nature.

---

### 🧹 6. **Dropped helper columns**
- Removed the `row_num` column once it was no longer needed.

---

### 📦 7. **Created final cleaned table**
Created `world_layoffs_final` containing the fully cleaned and standardized data.

---

## 🛠️ Tools Used

- **MySQL**
- SQL functions: `CTE`, `ROW_NUMBER()`, `TRIM()`, `STR_TO_DATE()`
- Manual text-based cleaning

---

## 📊 Final Output: `world_layoffs_final`
A clean, consistent, and analysis-ready SQL table of layoffs data.

---

## 📚 Acknowledgment

As someone just starting my **data analyst** journey, I followed this **YouTube tutorial** by Alex The Analyst as a guide for this learning project:

🎥 [SQL Data Cleaning Full Project – Alex The Analyst](https://www.youtube.com/watch?v=OT1RErkfLNQ&t=11481s)

The dataset used (`layoffs.csv`) was also provided in that tutorial.

> I do **not claim original authorship** of the dataset or the instructional structure. This project was completed strictly for learning purposes as I develop my foundational skills in SQL and data cleaning. My intention is full transparency and growth through guided practice. 🙏

---

## 🧠 What I Learned

- Identifying and removing duplicates with `ROW_NUMBER()`
- The value of string consistency for analysis
- How to convert text-formatted dates into proper date types
- A structured approach to cleaning data in SQL

---
