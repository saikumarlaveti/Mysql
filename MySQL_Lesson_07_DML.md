# MySQL Lesson 07 — Data Manipulation Language (DML)

> **Study notes · MySQL 8.x · Beginner → Interview revision**  
> Topics: `INSERT`, `UPDATE`, `DELETE`, filtering conditions, transactions, safe updates, and 31 practice questions.

## Contents

1. [Learning objectives](#1-learning-objectives)
2. [DML at a glance](#2-dml-at-a-glance)
3. [Practice database and sample data](#3-practice-database-and-sample-data)
4. [INSERT — adding rows](#4-insert--adding-rows)
5. [UPDATE — changing rows](#5-update--changing-rows)
6. [DELETE — removing rows](#6-delete--removing-rows)
7. [WHERE and comparison operators](#7-where-and-comparison-operators)
8. [AND, OR, and parentheses](#8-and-or-and-parentheses)
9. [IN and BETWEEN](#9-in-and-between)
10. [NULL values](#10-null-values)
11. [DELETE vs TRUNCATE vs DROP](#11-delete-vs-truncate-vs-drop)
12. [Safe Update Mode — Error 1175](#12-safe-update-mode--error-1175)
13. [Transactions — COMMIT and ROLLBACK](#13-transactions--commit-and-rollback)
14. [Common mistakes and debugging](#14-common-mistakes-and-debugging)
15. [Java / Spring Boot connection](#15-java--spring-boot-connection)
16. [Interview questions](#16-interview-questions)
17. [Practice questions Q1–Q31](#17-practice-questions-q1q31)
18. [Revision checklist](#18-revision-checklist)

---

## 1. Learning objectives

After this lesson, you should be able to:

- Insert one row, multiple rows, or selected columns.
- Update a particular row, multiple columns, or a calculated value.
- Delete selected rows safely.
- Filter rows using `WHERE`, comparison operators, `AND`, `OR`, `IN`, `BETWEEN`, and `IS NULL`.
- Explain the difference between `DELETE`, `TRUNCATE`, and `DROP`.
- Understand MySQL Workbench Safe Update Mode and basic transaction control.

## 2. DML at a glance

**DML (Data Manipulation Language)** changes the data stored inside tables.

| Command | Purpose | Typical syntax |
|---|---|---|
| `INSERT` | Add rows | `INSERT INTO ... VALUES ...` |
| `UPDATE` | Modify existing rows | `UPDATE ... SET ... WHERE ...` |
| `DELETE` | Remove rows | `DELETE FROM ... WHERE ...` |

`SELECT` retrieves data. It is often taught separately as **DQL (Data Query Language)**, though some classifications include it under DML.

## 3. Practice database and sample data

Run the following setup in **MySQL Workbench**. It creates a dedicated table named `student_dml_practice` so you do not accidentally change your existing `student` table.

```sql
CREATE DATABASE IF NOT EXISTS college;
USE college;

CREATE TABLE IF NOT EXISTS student_dml_practice (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    marks DECIMAL(5,2)
);
```

**One-time sample-data setup** (run only on an empty practice table):

```sql
INSERT INTO student_dml_practice (id, name, age, marks)
VALUES
    (101, 'Ravi', 22, 85.50),
    (102, 'Sai', 23, 90.00),
    (103, 'Kumar', 21, 78.50),
    (104, 'Priya', 22, 92.00),
    (105, 'Anil', 24, 65.00);

SELECT * FROM student_dml_practice;
```

| id | name | age | marks |
|---:|---|---:|---:|
| 101 | Ravi | 22 | 85.50 |
| 102 | Sai | 23 | 90.00 |
| 103 | Kumar | 21 | 78.50 |
| 104 | Priya | 22 | 92.00 |
| 105 | Anil | 24 | 65.00 |

> **Important:** The explanations below use `student_dml_practice`. The **original 31 questions** use `student`, matching your earlier exercises. You can replace `student` with `student_dml_practice` when practicing in this dedicated table. Each exercise is independent: reset the data or use a transaction if you want predictable results.

## 4. INSERT — adding rows

**General syntax**

```sql
INSERT INTO table_name (column1, column2, ...)
VALUES (value1, value2, ...);
```

**Insert one row**

```sql
INSERT INTO student_dml_practice (id, name, age, marks)
VALUES (106, 'Rahul', 23, 88.50);
```

**Insert multiple rows**

```sql
INSERT INTO student_dml_practice (id, name, age, marks)
VALUES
    (107, 'Kiran', 22, 81.50),
    (108, 'Vijay', 24, 95.00);
```

**Insert only some columns**

```sql
INSERT INTO student_dml_practice (id, name)
VALUES (109, 'Amit');
```

Here, `age` and `marks` default to `NULL` because they are nullable and have no explicit defaults.

**Remember:** Strings use single quotes (`'Amit'`); numbers are usually written without quotes (`109`, `95.00`). Each inserted row must have a unique `id` because it is a primary key.

## 5. UPDATE — changing rows

**General syntax**

```sql
UPDATE table_name
SET column_name = new_value
WHERE condition;
```

**Update one column**

```sql
UPDATE student_dml_practice
SET marks = 95
WHERE id = 101;
```

**Update multiple columns**

```sql
UPDATE student_dml_practice
SET age = 25, marks = 98
WHERE id = 102;
```

**Increase an existing value**

```sql
UPDATE student_dml_practice
SET marks = marks + 5
WHERE marks < 80;
```

**Update every row**

```sql
UPDATE student_dml_practice
SET age = 25;
```

Without a `WHERE` clause, the statement targets **all rows**. MySQL Safe Update Mode may block this command. Always check the intended rows first:

```sql
SELECT * FROM student_dml_practice WHERE id = 101;
```

## 6. DELETE — removing rows

**General syntax**

```sql
DELETE FROM table_name
WHERE condition;
```

**Delete one row**

```sql
DELETE FROM student_dml_practice
WHERE id = 105;
```

**Delete multiple matching rows**

```sql
DELETE FROM student_dml_practice
WHERE age > 23;
```

**Delete all rows**

```sql
DELETE FROM student_dml_practice;
```

This removes rows but **keeps the table and its columns**. Safe Update Mode may block a `DELETE` without an acceptable key-based restriction.

> Memorize the basic form: **`DELETE FROM table_name WHERE condition;`**

## 7. WHERE and comparison operators

`WHERE` chooses which rows a query affects.

| Operator | Meaning | Example |
|---|---|---|
| `=` | Equal to | `age = 22` |
| `>` | Greater than | `marks > 80` |
| `<` | Less than | `marks < 80` |
| `>=` | Greater than or equal to | `age >= 20` |
| `<=` | Less than or equal to | `age <= 25` |
| `<>` or `!=` | Not equal to | `age <> 22` |

```sql
UPDATE student_dml_practice
SET marks = 100
WHERE age >= 20;
```

**Common trap:** `age > 20` excludes age 20; `age >= 20` includes it.

## 8. AND, OR, and parentheses

`AND` requires **both** conditions to be true:

```sql
UPDATE student_dml_practice
SET marks = marks + 5
WHERE age > 20 AND marks < 80;
```

`OR` requires **at least one** condition to be true:

```sql
DELETE FROM student_dml_practice
WHERE marks < 40 OR age > 30;
```

Use parentheses for mixed logic:

```sql
UPDATE student_dml_practice
SET marks = 90
WHERE (age = 22 OR age = 23)
  AND marks < 80;
```

`AND` has higher precedence than `OR` in SQL; parentheses make the intention explicit.

## 9. IN and BETWEEN

**IN** matches any item in a list:

```sql
DELETE FROM student_dml_practice
WHERE name IN ('Ravi', 'Kiran', 'Vijay');
```

Equivalent to `name = 'Ravi' OR name = 'Kiran' OR name = 'Vijay'` for these non-NULL values.

**BETWEEN** includes both boundaries:

```sql
UPDATE student_dml_practice
SET marks = marks + 10
WHERE age BETWEEN 20 AND 25;
```

Equivalent to:

```sql
WHERE age >= 20 AND age <= 25
```

For ranges that should exclude endpoints, use `<` and `>` explicitly.

## 10. NULL values

`NULL` means **missing or unknown**, not zero, empty text, or the string `'null'`.

**Find missing marks**

```sql
SELECT * FROM student_dml_practice
WHERE marks IS NULL;
```

**Fill missing marks**

```sql
UPDATE student_dml_practice
SET marks = 90
WHERE marks IS NULL;
```

**Find present marks**

```sql
SELECT * FROM student_dml_practice
WHERE marks IS NOT NULL;
```

Incorrect checks:

```sql
-- Do not use these to test SQL NULL:
-- WHERE marks = NULL;
-- WHERE marks = 'null';
```

`= NULL` evaluates to UNKNOWN, not TRUE; `'null'` is a string literal.

## 11. DELETE vs TRUNCATE vs DROP

| Feature | `DELETE` | `TRUNCATE` | `DROP` |
|---|---|---|---|
| Category | DML | DDL | DDL |
| What it removes | Matching rows or all rows | All rows | Entire table |
| `WHERE` supported | Yes | No | No |
| Table structure retained | Yes | Yes | No |
| Transaction rollback | Possible before commit (InnoDB) | Not normally possible | Not normally possible |
| `AUTO_INCREMENT` | Normally not reset | Reset | Table removed |

```sql
DELETE FROM student_dml_practice WHERE id = 101;
TRUNCATE TABLE student_dml_practice;
DROP TABLE student_dml_practice;
```

> **Do not run all three lines together** unless you intend to empty and then remove the practice table. In MySQL, `TRUNCATE` and `DROP` cause implicit commits.

## 12. Safe Update Mode — Error 1175

Safe Update Mode helps prevent broad, accidental changes. Workbench may reject `UPDATE` or `DELETE` statements that do not use a suitable key restriction.

Check current session setting:

```sql
SELECT @@SQL_SAFE_UPDATES;
```

Temporarily disable it **only when needed**:

```sql
SET SQL_SAFE_UPDATES = 0;

-- Verify your target rows first.
SELECT * FROM student_dml_practice WHERE age = 22;

UPDATE student_dml_practice
SET marks = marks + 5
WHERE age = 22;

SET SQL_SAFE_UPDATES = 1;
```

In Workbench, you can also use **Edit → Preferences → SQL Editor → Safe Updates**, then reconnect. Prefer leaving protection enabled during normal practice.

## 13. Transactions — COMMIT and ROLLBACK

With a transactional engine such as **InnoDB**, you can control whether changes are kept.

**Undo a change:**

```sql
START TRANSACTION;

UPDATE student_dml_practice
SET marks = 95
WHERE id = 101;

ROLLBACK;
```

**Save a change:**

```sql
START TRANSACTION;

UPDATE student_dml_practice
SET marks = 95
WHERE id = 101;

COMMIT;
```

`ROLLBACK` undoes uncommitted transactional changes; `COMMIT` makes them permanent. DDL statements such as `DROP TABLE` and `TRUNCATE TABLE` generally cause implicit commits in MySQL.

## 14. Common mistakes and debugging

| Mistake | Correct version / lesson |
|---|---|
| `DELETE student ...` | `DELETE FROM student ...` |
| `marks = 'null'` | `marks IS NULL` |
| `marks = NULL` | `marks IS NULL` |
| `age > 20` when age 20 is included | `age >= 20` |
| `name IN ('Ravi,'Kiran')` | `name IN ('Ravi', 'Kiran')` |
| `VALUES (113, Vijay)` | `VALUES (113, 'Vijay')` |
| `age > 22` when age must equal 22 | `age = 22` |
| `UPDATE ...` without `WHERE` | Targets every row; verify this is intended |
| `WHERE marks = 102` when question says ID 102 | `WHERE id = 102` |
| Wrong table name (`students` vs `student`) | Use the exact table name |

**Before running UPDATE or DELETE:**

1. Read the question carefully: `>`, `<`, `>=`, `<=`, `=`.
2. Check the exact table and column names.
3. Preview the affected rows with `SELECT ... WHERE ...`.
4. Consider a transaction for changes you may want to undo.
5. Confirm how many rows were affected.

## 15. Java / Spring Boot connection

A student-management backend often maps HTTP actions to SQL operations:

| REST API | Typical SQL operation |
|---|---|
| `POST /students` | `INSERT` |
| `PUT /students/101` | `UPDATE` |
| `DELETE /students/101` | `DELETE` |
| `GET /students` | `SELECT` (retrieval/DQL) |

In a Spring Boot project, you might execute these through **JDBC**, **Spring Data JPA**, or **Hibernate**. Understanding the underlying SQL helps you debug database behavior even when an ORM generates the statements.

## 16. Interview questions

Try answering without looking at the notes:

1. What does DML stand for? Name three DML commands.
2. What is the difference between `INSERT` and `UPDATE`?
3. Why is `WHERE` important in `UPDATE` and `DELETE`?
4. What happens when `UPDATE` has no `WHERE`?
5. What happens when `DELETE` has no `WHERE`?
6. Explain `DELETE` vs `TRUNCATE` vs `DROP`.
7. Can a `DELETE` be rolled back in MySQL?
8. Does `TRUNCATE` reset `AUTO_INCREMENT`?
9. What is the difference between `NULL`, `0`, and `''`?
10. Why is `IS NULL` used instead of `= NULL`?
11. What is the difference between `AND` and `OR`?
12. Does `BETWEEN` include both endpoints?
13. What does `IN ('Ravi', 'Sai')` mean?
14. What causes MySQL Error 1175?
15. What is the difference between `COMMIT` and `ROLLBACK`?

---

## 17. Practice questions Q1–Q31

> **Instructions:** Write SQL queries using a table named `student` with columns `id`, `name`, `age`, and `marks`. Assume `id` is a primary key and `age` / `marks` allow `NULL`. Treat each question as an independent exercise; earlier updates/deletes may change the table contents.
>
> **Q1–Q3:** Restated from the initial DML practice for a complete numbered set.

### Part 1 — Basic DML (Q1–Q8)

1. Insert a student with ID 106, name `'Anil'`, age 22, and marks 81.50.
2. Insert two students in one statement: `(107, 'Saikumar', 24, 99.00)` and `(108, 'Santosh', 23, 100.00)`.
3. Update the marks to 96 for the student whose ID is 102.
4. Increase marks by 3 for all students whose marks are below 80.
5. Delete the student whose ID is 105.
6. Delete students whose age is greater than 23.
7. Update every student's age to 25.
8. Explain the difference between `DELETE` and `DROP`.

### Part 2 — INSERT, UPDATE, and DELETE (Q9–Q18)

9. Insert a student with ID 110, name `'Rahul'`, age 24, and marks 88.50.
10. Update the age to 26 and marks to 95 for student ID 102.
11. Increase marks by 5 for students whose age is exactly 22.
12. Delete all students whose marks are below 50.
13. What happens if you execute `DELETE FROM student;` without a `WHERE` clause?
14. Increase marks by 10 for students whose marks are less than or equal to 70.
15. Update the name to `'Arjun'` for the student whose ID is 103.
16. Delete students whose age is exactly 25.
17. Insert two students in one `INSERT` statement: `(111, 'Kiran', 22, 82.50)` and `(112, 'Priya', 23, 91.00)`.
18. Explain the difference between `DELETE` and `TRUNCATE`.

### Part 3 — Multiple conditions (Q19–Q23)

19. Increase marks by 5 for students whose age is greater than 20 **AND** marks are below 80.
20. Delete students whose marks are below 40 **OR** age is greater than 30.
21. Update the age to 24 for students whose name is `'Sai'` or `'Ravi'`.
22. Insert a student with ID 113 and name `'Vijay'`, without specifying age or marks. Assume both columns allow `NULL`.
23. What happens if you execute `UPDATE student SET marks = 100;` without a `WHERE` clause?

### Part 4 — Advanced DML revision (Q24–Q28)

24. Increase marks by 10 for students whose age is between 20 and 25 **inclusive**.
25. Delete students whose names are `'Ravi'`, `'Kiran'`, or `'Vijay'`.
26. Update marks to 90 for students whose marks are `NULL`.
27. Insert a student with ID 114, name `'Amit'`, age 23, and marks 75.50.
28. Explain the difference between `UPDATE student SET marks = 90;` and `UPDATE student SET marks = 90 WHERE id = 101;`.

### Part 5 — Final revision (Q29–Q31)

29. Update marks to 100 for students whose age is between 18 and 22, **including both ages**.
30. Delete students whose names are `'John'`, `'David'`, or `'Peter'`.
31. Update age to 21 for students whose age is `NULL`.

---

## 18. Revision checklist

- [ ] I can insert one row and multiple rows.
- [ ] I can insert only selected columns and explain `NULL` defaults.
- [ ] I can update one row, multiple columns, and calculated values.
- [ ] I can safely delete one row or several rows.
- [ ] I can use `WHERE` with `=`, `>`, `<`, `>=`, and `<=`.
- [ ] I can combine conditions with `AND` and `OR`.
- [ ] I can use `IN` and inclusive `BETWEEN` correctly.
- [ ] I can distinguish `NULL` from strings and zero.
- [ ] I can explain `DELETE`, `TRUNCATE`, and `DROP`.
- [ ] I understand Error 1175 and Safe Update Mode.
- [ ] I can explain `COMMIT` and `ROLLBACK`.
- [ ] I can solve Q1–Q31 without looking at examples.

### Suggested revision plan

| Session | Focus |
|---|---|
| Day 1 | INSERT, UPDATE, DELETE |
| Day 2 | WHERE, AND, OR, IN, BETWEEN |
| Day 3 | NULL, transactions, safe updates |
| Day 4 | Attempt Q1–Q31 independently |
| Day 7 | Retry missed questions and explain answers aloud |

**Next lesson:** MySQL Lesson 08 — `SELECT`, `WHERE`, `DISTINCT`, and aliases.
