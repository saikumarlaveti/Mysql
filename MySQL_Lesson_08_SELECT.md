# MySQL Lesson 8 — SELECT, WHERE, DISTINCT & Aliases

> **GitHub-ready revision notes and coding practice**  
> Topics: DQL, `SELECT`, `WHERE`, comparison operators, `DISTINCT`, column aliases, combined filtering.  
> **Practice completed:** Q1–Q16. **First-attempt result:** 15/16 (Q15 corrected during review); Q16 answered correctly.

## Table of contents

1. [Learning objectives](#1-learning-objectives)
2. [What is DQL?](#2-what-is-dql)
3. [Set up the practice database](#3-set-up-the-practice-database)
4. [SELECT — retrieve records](#4-select--retrieve-records)
5. [WHERE — filter records](#5-where--filter-records)
6. [Comparison operators](#6-comparison-operators)
7. [DISTINCT — unique results](#7-distinct--unique-results)
8. [Aliases with AS](#8-aliases-with-as)
9. [Combine SELECT, WHERE, DISTINCT and AS](#9-combine-select-where-distinct-and-as)
10. [Additional filtering: AND and BETWEEN](#10-additional-filtering-and-and-between)
11. [SQL execution order](#11-sql-execution-order)
12. [Common mistakes and corrections](#12-common-mistakes-and-corrections)
13. [Java / Spring Boot connection](#13-java--spring-boot-connection)
14. [Interview questions with answers](#14-interview-questions-with-answers)
15. [Practice questions Q1–Q16](#15-practice-questions-q1q16)
16. [Answer key](#16-answer-key)
17. [Final revision checklist](#17-final-revision-checklist)

---

## 1. Learning objectives

After this lesson, you should be able to:

- Retrieve every column or selected columns from a table.
- Filter rows using `WHERE` and comparison operators.
- Remove duplicate **result rows** using `DISTINCT`.
- Rename output columns using `AS` without changing the schema.
- Combine filtering, unique results and aliases in one query.
- Explain these concepts in a Java backend interview.

## 2. What is DQL?

**DQL (Data Query Language)** is a commonly used classification for SQL queries that read data. Its principal command is `SELECT`. Some SQL classifications include `SELECT` under DML rather than treating DQL as a separate formal category.

| Command | Purpose | Changes stored data? |
|---|---|---|
| `SELECT` | Read data | No |
| `INSERT` | Add rows | Yes |
| `UPDATE` | Modify rows | Yes |
| `DELETE` | Remove rows | Yes |

## 3. Set up the practice database

Run this once in MySQL Workbench. The script creates a clean, reproducible practice table. **Warning:** `DROP TABLE IF EXISTS employees` deletes an existing `employees` table in the `college` database; use only in a practice database.

```sql
CREATE DATABASE IF NOT EXISTS college;
USE college;

DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(30),
    salary DECIMAL(10,2),
    age INT,
    city VARCHAR(30)
);

INSERT INTO employees (emp_id, emp_name, department, salary, age, city)
VALUES
    (101, 'Sai',   'IT',      50000, 25, 'Hyderabad'),
    (102, 'Ravi',  'HR',      35000, 28, 'Chennai'),
    (103, 'Priya', 'IT',      65000, 26, 'Bangalore'),
    (104, 'Kiran', 'Finance', 45000, 30, 'Hyderabad'),
    (105, 'Anil',  'IT',      55000, 27, 'Chennai'),
    (106, 'Sneha', 'HR',      40000, 24, 'Bangalore'),
    (107, 'Rahul', 'Finance', 60000, 29, 'Hyderabad'),
    (108, 'Divya', 'IT',      70000, 25, 'Pune');

SELECT * FROM employees;
```

### Starting dataset

| emp_id | emp_name | department | salary | age | city |
|---:|---|---|---:|---:|---|
| 101 | Sai | IT | 50000 | 25 | Hyderabad |
| 102 | Ravi | HR | 35000 | 28 | Chennai |
| 103 | Priya | IT | 65000 | 26 | Bangalore |
| 104 | Kiran | Finance | 45000 | 30 | Hyderabad |
| 105 | Anil | IT | 55000 | 27 | Chennai |
| 106 | Sneha | HR | 40000 | 24 | Bangalore |
| 107 | Rahul | Finance | 60000 | 29 | Hyderabad |
| 108 | Divya | IT | 70000 | 25 | Pune |

> **Note:** Without `ORDER BY`, SQL does not guarantee row order. Output tables in these notes show one possible ordering.

## 4. SELECT — retrieve records

**Syntax:**

```sql
SELECT column1, column2
FROM table_name;
```

### A. Retrieve all columns

```sql
SELECT * FROM employees;
```

`*` means all columns. This returns all eight rows and six columns.

### B. Retrieve employee names only

```sql
SELECT emp_name FROM employees;
```

| emp_name |
|---|
| Sai |
| Ravi |
| Priya |
| Kiran |
| Anil |
| Sneha |
| Rahul |
| Divya |

### C. Retrieve two columns

```sql
SELECT emp_name, salary FROM employees;
```

| emp_name | salary |
|---|---:|
| Sai | 50000 |
| Ravi | 35000 |
| Priya | 65000 |
| Kiran | 45000 |
| Anil | 55000 |
| Sneha | 40000 |
| Rahul | 60000 |
| Divya | 70000 |

**Interview tip:** Prefer explicit columns instead of `SELECT *` when your application only needs a few fields. This avoids retrieving unnecessary data and makes query results more predictable.

## 5. WHERE — filter records

`WHERE` restricts which rows are returned.

```sql
SELECT *
FROM employees
WHERE department = 'IT';
```

| emp_name | department |
|---|---|
| Sai | IT |
| Priya | IT |
| Anil | IT |
| Divya | IT |

Another example:

```sql
SELECT emp_name, salary
FROM employees
WHERE salary > 50000;
```

| emp_name | salary |
|---|---:|
| Priya | 65000 |
| Anil | 55000 |
| Rahul | 60000 |
| Divya | 70000 |

`>` excludes the boundary: Sai's salary of exactly 50000 is not returned.

## 6. Comparison operators

| Operator | Meaning | Example |
|---|---|---|
| `=` | Equal to | `city = 'Hyderabad'` |
| `<>` or `!=` | Not equal to | `department <> 'IT'` |
| `>` | Greater than | `salary > 50000` |
| `<` | Less than | `age < 27` |
| `>=` | Greater than or equal to | `salary >= 50000` |
| `<=` | Less than or equal to | `age <= 25` |

```sql
-- Employees younger than 27
SELECT * FROM employees WHERE age < 27;

-- Employees living in Hyderabad
SELECT * FROM employees WHERE city = 'Hyderabad';

-- Employees earning exactly 40000
SELECT * FROM employees WHERE salary = 40000;
```

**Reminder:** Quote string literals such as `'Hyderabad'`; numeric literals such as `40000` normally do not need quotes.

## 7. DISTINCT — unique results

`DISTINCT` removes duplicate **rows from the query result**. It does **not** delete records from the table.

```sql
SELECT DISTINCT department
FROM employees;
```

| department |
|---|
| IT |
| HR |
| Finance |

```sql
SELECT DISTINCT city
FROM employees;
```

| city |
|---|
| Hyderabad |
| Chennai |
| Bangalore |
| Pune |

### DISTINCT across multiple columns

```sql
SELECT DISTINCT department, city
FROM employees;
```

This returns each unique **department–city pair**. `DISTINCT` does not independently deduplicate each selected column.

For example, `IT / Hyderabad` and `IT / Chennai` are distinct pairs even though both have the same department.

**Interview tip:** A normal `SELECT` may contain duplicate values. Use `DISTINCT` only when you actually need unique result rows; it can add processing work.

## 8. Aliases with AS

An alias changes the **heading shown in the query result**. It does not rename the column in the database.

```sql
SELECT emp_name AS EmployeeName
FROM employees;
```

| EmployeeName |
|---|
| Sai |
| Ravi |
| Priya |
| Kiran |
| Anil |
| Sneha |
| Rahul |
| Divya |

```sql
SELECT salary AS MonthlySalary
FROM employees;
```

Aliases can make report output or DTO projections easier to read:

```sql
SELECT
    emp_name AS EmployeeName,
    salary AS MonthlySalary
FROM employees;
```

`AS` is optional for simple aliases in MySQL, but using it often improves readability.

## 9. Combine SELECT, WHERE, DISTINCT and AS

**Question:** Retrieve unique cities of Finance employees and label the column `FinanceCity`.

```sql
SELECT DISTINCT city AS FinanceCity
FROM employees
WHERE department = 'Finance';
```

| FinanceCity |
|---|
| Hyderabad |

Both Finance employees (Kiran and Rahul) live in Hyderabad, so the unique result contains one city.

### Common mistake from practice Q15

```sql
-- Incorrect for the stated requirement:
SELECT DISTINCT city AS FinanceCity
FROM employees;
```

This query is valid SQL, but it retrieves cities from **all departments** because it omits the filter.

**Requirement checklist:**

| Requirement | SQL fragment |
|---|---|
| Retrieve city | `SELECT city` |
| Unique results | `DISTINCT` |
| Output heading | `AS FinanceCity` |
| Finance only | `WHERE department = 'Finance'` |

## 10. Additional filtering: AND and BETWEEN

You already encountered these while practicing Lesson 8. They are covered more fully in Lesson 9.

### AND — both conditions must match

```sql
SELECT *
FROM employees
WHERE department = 'HR' AND age > 25;
```

| emp_name | department | age |
|---|---|---:|
| Ravi | HR | 28 |

### BETWEEN — inclusive boundaries

```sql
SELECT emp_name, salary
FROM employees
WHERE salary BETWEEN 40000 AND 60000;
```

| emp_name | salary |
|---|---:|
| Sai | 50000 |
| Kiran | 45000 |
| Anil | 55000 |
| Sneha | 40000 |
| Rahul | 60000 |

`BETWEEN 40000 AND 60000` includes both 40000 and 60000.

## 11. SQL execution order

The written order of a simple query is:

```sql
SELECT DISTINCT department AS DepartmentName
FROM employees
WHERE salary > 45000;
```

A useful simplified **logical processing order** is:

1. `FROM` — identify source table.
2. `WHERE` — filter rows.
3. `SELECT` — choose expressions/columns.
4. `DISTINCT` — remove duplicate result rows.
5. Output aliases label the selected expressions.

This is a conceptual model, **not** a promise about the database optimizer's physical execution plan.

## 12. Common mistakes and corrections

| Mistake | Better approach | Reason |
|---|---|---|
| `SELECT emp_name employees;` | `SELECT emp_name FROM employees;` | `FROM` identifies the table. |
| `WHERE city = Hyderabad` | `WHERE city = 'Hyderabad'` | String literal needs quotes. |
| `WHERE salary > 50000` when 50000 must be included | `WHERE salary >= 50000` | `>` excludes the boundary. |
| `SELECT city FROM employees` when only unique cities are needed | `SELECT DISTINCT city FROM employees` | Without `DISTINCT`, repeated values remain. |
| `SELECT DISTINCT city ...` when only Finance cities are requested | Add `WHERE department = 'Finance'` | Unique values still need filtering. |
| Assuming `AS` renames the stored column | Use `ALTER TABLE` for a permanent schema rename | Aliases only affect query output. |
| Assuming row order is guaranteed | Add `ORDER BY` when ordering matters | SQL result order is unspecified otherwise. |
| `WHERE salary = NULL` | `WHERE salary IS NULL` | NULL needs special comparison syntax. |

**Formatting tip:** Use uppercase SQL keywords, spaces around operators, and semicolons. MySQL generally accepts lowercase keywords too.

## 13. Java / Spring Boot connection

In a Spring Boot employee-management API, read operations commonly correspond to SQL queries:

| Endpoint example | Data retrieval goal | SQL concept |
|---|---|---|
| `GET /employees` | All employees | `SELECT *` |
| `GET /employees?department=IT` | Employees in IT | `WHERE` |
| `GET /employees/cities` | Unique cities | `DISTINCT` |
| `GET /employees/summary` | Selected named fields | Column selection + `AS` |

Example SQL used by a repository/query layer:

```sql
SELECT emp_name AS EmployeeName, salary AS MonthlySalary
FROM employees
WHERE department = 'IT';
```

For application input, use **parameterized queries** (JDBC prepared statements, Spring Data query parameters, etc.) rather than concatenating user text into SQL. This reduces SQL injection risk.

## 14. Interview questions with answers

**Q1. What does SELECT do?**  
Reads rows and selected expressions from one or more data sources.

**Q2. What is the difference between SELECT * and SELECT emp_name?**  
`*` retrieves all columns; the named-column query retrieves only the requested column.

**Q3. What is WHERE used for?**  
It filters rows using a condition before they are included in the query result.

**Q4. What does DISTINCT do?**  
Removes duplicate rows from the query result; it does not change stored table data.

**Q5. Does DISTINCT work with multiple columns?**  
Yes. It checks uniqueness across the entire selected combination.

**Q6. What is an alias?**  
A temporary output name for a column or expression, often specified with `AS`.

**Q7. Does AS permanently rename a database column?**  
No. A schema change is required to rename a stored column.

**Q8. What is the difference between WHERE salary > 50000 and WHERE salary >= 50000?**  
The first excludes 50000; the second includes it.

**Q9. Is BETWEEN inclusive?**  
Yes, both endpoints are included.

**Q10. Can WHERE and DISTINCT be used together?**  
Yes. Filter the rows with `WHERE`, then obtain unique selected results with `DISTINCT`.

**Q11. Does SELECT guarantee the order of rows?**  
No. Use `ORDER BY` to request a specific order.

**Q12. How is SELECT useful in Spring Boot?**  
It underpins read/query endpoints, including filtered lookups and DTO projections.

---

## 15. Practice questions Q1–Q16

Use the eight-row `employees` dataset from [Section 3](#3-set-up-the-practice-database). Try the questions before checking the answer key.

### Part 1 — SELECT and WHERE (Q1–Q5)

1. Retrieve all records from `employees`.
2. Retrieve only employee names.
3. Retrieve employee names and salaries.
4. Retrieve employees who work in IT.
5. Retrieve employees whose salary is greater than 50000.

### Part 2 — WHERE and DISTINCT (Q6–Q10)

6. Retrieve employees whose age is less than 27.
7. Retrieve employees who live in Hyderabad.
8. Retrieve employees whose salary is exactly 40000.
9. Retrieve all unique department names.
10. Retrieve all unique city names.

### Part 3 — Aliases and combined filters (Q11–Q15)

11. Retrieve employee names with the column alias `EmployeeName`.
12. Retrieve salary with the column alias `MonthlySalary`.
13. Retrieve employees working in HR whose age is greater than 25.
14. Retrieve employee names and salaries for employees earning between 40000 and 60000, inclusive.
15. Retrieve unique cities of employees working in Finance, with the output column named `FinanceCity`.

### Part 4 — Final correction challenge (Q16)

16. Retrieve unique departments of employees whose salary is greater than 45000, and display the column as `DepartmentName`.

### Personal practice review

- **Q1–Q5:** 5/5 correct.
- **Q6–Q10:** 5/5 correct.
- **Q11–Q15:** 4/5 correct initially. Q15 needed `WHERE department = 'Finance'`.
- **Q16:** 1/1 correct.
- **Total:** 15/16 correct on first attempt; the missed concept was subsequently reviewed.

## 16. Answer key

> Expand this section only after attempting the questions yourself.

<details>
<summary><strong>Show SQL solutions for Q1–Q16</strong></summary>

### Q1–Q5

```sql
-- Q1
SELECT * FROM employees;

-- Q2
SELECT emp_name FROM employees;

-- Q3
SELECT emp_name, salary FROM employees;

-- Q4
SELECT * FROM employees WHERE department = 'IT';

-- Q5
SELECT * FROM employees WHERE salary > 50000;
```

### Q6–Q10

```sql
-- Q6
SELECT * FROM employees WHERE age < 27;

-- Q7
SELECT * FROM employees WHERE city = 'Hyderabad';

-- Q8
SELECT * FROM employees WHERE salary = 40000;

-- Q9
SELECT DISTINCT department FROM employees;

-- Q10
SELECT DISTINCT city FROM employees;
```

### Q11–Q15

```sql
-- Q11
SELECT emp_name AS EmployeeName FROM employees;

-- Q12
SELECT salary AS MonthlySalary FROM employees;

-- Q13
SELECT * FROM employees
WHERE department = 'HR' AND age > 25;

-- Q14
SELECT emp_name, salary FROM employees
WHERE salary BETWEEN 40000 AND 60000;

-- Q15
SELECT DISTINCT city AS FinanceCity
FROM employees
WHERE department = 'Finance';
```

### Q16

```sql
SELECT DISTINCT department AS DepartmentName
FROM employees
WHERE salary > 45000;
```

Expected Q16 output (order not guaranteed):

| DepartmentName |
|---|
| IT |
| Finance |

</details>

## 17. Final revision checklist

- [ ] I can explain DQL and the purpose of `SELECT`.
- [ ] I can select all columns or only specified columns.
- [ ] I can write `WHERE` filters with numeric and text conditions.
- [ ] I understand `<`, `>`, `<=`, `>=`, `=`, and `<>`.
- [ ] I can explain why `DISTINCT` does not delete table records.
- [ ] I understand that multiple-column `DISTINCT` applies to the combination.
- [ ] I can rename query output columns with `AS`.
- [ ] I can combine `DISTINCT`, aliases and `WHERE` without missing a requirement.
- [ ] I know `BETWEEN` includes its endpoints.
- [ ] I know `ORDER BY` is needed for guaranteed ordering.
- [ ] I can solve Q1–Q16 without looking at the answer key.

### What's next?

**MySQL Lesson 9 — SQL Operators:** `AND`, `OR`, `NOT`, `IN`, `NOT IN`, `BETWEEN`, `NOT BETWEEN`, `LIKE`, `NOT LIKE`, `IS NULL`, and `IS NOT NULL`.

---

**Suggested GitHub commit:** `docs: add MySQL Lesson 8 SELECT revision notes and 16 exercises`
