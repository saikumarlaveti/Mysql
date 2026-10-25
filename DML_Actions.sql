MySQL Lesson 7 — DML Complete Revision Notes
These notes cover everything you learned while practicing questions Q1–Q31. You can use them for daily revision, coding practice, and Java backend developer interviews.
1. What is DML?
DML (Data Manipulation Language) is used to insert, modify, and delete data stored in database tables.
Command	Purpose
INSERT	Add new records
UPDATE	Modify existing records
DELETE	Remove records

SELECT is commonly classified as DQL (Data Query Language), although some classifications group it with DML.
2. Create a practice table
CREATE DATABASE college;
USE college;

CREATE TABLE student (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    marks DECIMAL(5,2)
);


Example data:
id	name	age	marks
101	Ravi	22	85.50
102	Sai	23	90.00
103	Kumar	21	78.50
104	Priya	22	92.00
105	Anil	24	65.00

3. INSERT — Add records
Syntax:
INSERT INTO table_name (column1, column2)
VALUES (value1, value2);


Insert one record:
INSERT INTO student (id, name, age, marks)
VALUES (106, 'Rahul', 23, 88.50);


Insert multiple records:
INSERT INTO student (id, name, age, marks)
VALUES
(107, 'Kiran', 22, 81.50),
(108, 'Vijay', 24, 95.00);


Insert selected columns:
INSERT INTO student (id, name)
VALUES (109, 'Amit');


Here, age and marks become NULL because those columns allow missing values and have no explicit default.

Remember: Text values need single quotes, while numeric values normally do not.
4. UPDATE — Modify records
Syntax:
UPDATE table_name
SET column_name = value
WHERE condition;


Update one column:
UPDATE student
SET marks = 95
WHERE id = 101;


Update multiple columns:
UPDATE student
SET age = 25, marks = 98
WHERE id = 102;


Increase an existing value:
UPDATE student
SET marks = marks + 5
WHERE marks < 80;


Update every record:
UPDATE student
SET age = 25;


Without WHERE, every row is targeted. Safe Update Mode may prevent execution.
5. DELETE — Remove records
Syntax:
DELETE FROM table_name
WHERE condition;


Delete one student:
DELETE FROM student
WHERE id = 105;


Delete multiple matching students:
DELETE FROM student
WHERE age > 23;


Delete all records:
DELETE FROM student;


This removes all rows but keeps the table structure. Safe Update Mode may block the statement.

Important: Remember DELETE FROM, not just DELETE.
6. WHERE — Filtering conditions
Operator	Meaning	Example
=	Equal to	age = 22
>	Greater than	marks > 80
<	Less than	marks < 80
>=	Greater than or equal	age >= 20
<=	Less than or equal	age <= 25
<>	Not equal	age <> 22

Example:
UPDATE student
SET marks = 100
WHERE age >= 20;


7. AND and OR
AND: Both conditions must be true.
UPDATE student
SET marks = marks + 5
WHERE age > 20 AND marks < 80;


OR: At least one condition must be true.
DELETE FROM student
WHERE marks < 40 OR age > 30;


Use parentheses when combining conditions:
UPDATE student
SET marks = 90
WHERE (age = 22 OR age = 23)
AND marks < 80;


8. IN — Multiple matching values
Instead of writing several OR conditions:
DELETE FROM student
WHERE name IN ('Ravi', 'Kiran', 'Vijay');


This matches any of the three names.

Remember that each string needs its own quotation marks.
  
9. BETWEEN — Inclusive ranges
UPDATE student
SET marks = marks + 10
WHERE age BETWEEN 20 AND 25;


Equivalent to:
UPDATE student
SET marks = marks + 10
WHERE age >= 20 AND age <= 25;


BETWEEN includes both boundary values.
  
10. NULL — Missing values
NULL represents an absent or unknown value. It is not the same as zero or an empty string.

Find missing marks:
SELECT * FROM student
WHERE marks IS NULL;


Update missing marks:
UPDATE student
SET marks = 90
WHERE marks IS NULL;


Find non-missing marks:
SELECT * FROM student
WHERE marks IS NOT NULL;


Incorrect:
WHERE marks = NULL;
WHERE marks = 'null';


Use IS NULL instead.
11. DELETE vs TRUNCATE vs DROP
Feature	DELETE	TRUNCATE	DROP
Category	DML	DDL	DDL
Removes rows	Yes	All rows	Entire table
Supports WHERE	Yes	No	No
Keeps table structure	Yes	Yes	No
Transaction rollback	Possible	Normally no	Normally no
AUTO_INCREMENT reset	Normally no	Yes	Table removed

Examples:
DELETE FROM student WHERE id = 101;

TRUNCATE TABLE student;

DROP TABLE student;


In MySQL, TRUNCATE and DROP cause implicit commits. A DELETE can be rolled back if executed within an appropriate transaction before commit.
12. Safe Update Mode — Error 1175
Safe Update Mode helps prevent accidental mass updates or deletions.

Temporarily disable it:
SET SQL_SAFE_UPDATES = 0;


Run your intended query, after checking the condition:
UPDATE student
SET marks = marks + 5
WHERE age = 22;


Enable it again:
SET SQL_SAFE_UPDATES = 1;


For normal practice, keep Safe Update Mode enabled.
13. Transactions — COMMIT and ROLLBACK
Transactions are important for controlling changes.
START TRANSACTION;

UPDATE student
SET marks = 95
WHERE id = 101;

ROLLBACK;


ROLLBACK cancels the uncommitted update.
START TRANSACTION;

UPDATE student
SET marks = 95
WHERE id = 101;

COMMIT;


COMMIT permanently saves the transaction's changes. These examples assume a transactional storage engine such as InnoDB.
14. Common mistakes from your practice
Mistake	Correct approach
DELETE student	DELETE FROM student
marks = 'null'	marks IS NULL
age > 20 when 20 is included	age >= 20
name IN ('Ravi,'Kiran')	name IN ('Ravi','Kiran')
VALUES (113,Vijay)	VALUES (113,'Vijay')
age > 22 when age is exactly 22	age = 22
Forgetting WHERE	Check whether all rows should change

15. Real-world Java backend example
Imagine you are developing a Spring Boot student-management application.
API	Database operation
POST /students	INSERT
PUT /students/101	UPDATE
DELETE /students/101	DELETE
GET /students	SELECT

These SQL concepts are the foundation for implementing CRUD operations using Spring Data JPA, Hibernate, and JDBC.
  
================================================================================================================
Part 1 — Basic DML (Q1–Q8)
  
1. Insert a student with ID 106, name 'Anil', age 22, and marks 81.50.
2. Insert two students in one statement: (107, 'Saikumar', 24, 99.00) and (108, 'Santosh', 23, 100.00).
3. Update the marks to 96 for the student whose ID is 102.
4. Increase marks by 3 for all students whose marks are below 80.
5. Delete the student whose ID is 105.
6. Delete students whose age is greater than 23.
7. Update every student's age to 25.
8. Explain the difference between DELETE and DROP.
  
Part 2 — INSERT, UPDATE and DELETE (Q9–Q18)
  
9. Insert a student with ID 110, name 'Rahul', age 24, and marks 88.50.
10. Update the age to 26 and marks to 95 for student ID 102.
11. Increase marks by 5 for students whose age is 22.
12. Delete all students whose marks are below 50.
13. What happens if you execute DELETE FROM student; without a WHERE clause?
14. Increase marks by 10 for students whose marks are less than or equal to 70.
15. Update the name to 'Arjun' for the student whose ID is 103.
16. Delete students whose age is exactly 25.
17. Insert two students in a single INSERT statement: (111, 'Kiran', 22, 82.50) and (112, 'Priya', 23, 91.00).
18. Explain the difference between DELETE and TRUNCATE.
  
Part 3 — Multiple conditions (Q19–Q23)
  
19. Increase marks by 5 for students whose age is greater than 20 AND marks are below 80.
20. Delete students whose marks are below 40 OR age is greater than 30.
21. Update the age to 24 for students whose name is 'Sai' or 'Ravi'.
22. Insert a student with ID 113 and name 'Vijay', without specifying age or marks. Assume both columns allow NULL.
23. What happens if you execute UPDATE student SET marks = 100; without a WHERE clause?
  
Part 4 — Advanced DML revision (Q24–Q28)
  
24. Increase marks by 10 for students whose age is between 20 and 25 (inclusive).
25. Delete students whose names are 'Ravi', 'Kiran', or 'Vijay'.
26. Update marks to 90 for students whose marks are NULL.
27. Insert a student with ID 114, name 'Amit', age 23 and marks 75.50.
28. Explain the difference between UPDATE student SET marks = 90; and UPDATE student SET marks = 90 WHERE id = 101;.
  
Part 5 — Final revision (Q29–Q31)
  
29. Update marks to 100 for students whose age is between 18 and 22, including both ages.
30. Delete students whose names are 'John', 'David', or 'Peter'.
31. Update age to 21 for students whose age is NULL.
