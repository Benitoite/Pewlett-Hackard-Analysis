-- Module Challenge Deliverable 1

--Join employee info with title info, filtered by a date range
SELECT e.emp_no, e.first_name, e.last_name,
    ttl.title, ttl.from_date, ttl.to_date
INTO retirement_titles
FROM employees as e
LEFT JOIN titles as ttl
ON e.emp_no = ttl.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
    first_name,
    last_name,
    title
INTO distinct_retires
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

--Get counts per title
SELECT count(title), title
INTO retire_title_counts
FROM distinct_retires
GROUP BY title
ORDER BY count DESC;

--Module Challenge Deliverable 2

--Join employee info with title info, filtered by a date range
SELECT DISTINCT ON (emp_no) e.emp_no, e.first_name, e.last_name, e.birth_date,
    de.from_date, de.to_date,
	ttl.title
INTO mentor_eligibility
FROM employees as e
LEFT JOIN dept_emp as de
ON e.emp_no = de.emp_no
LEFT JOIN titles as ttl
ON e.emp_no = ttl.emp_no
WHERE de.to_date = '9999-01-01'
	   AND (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no;

--Module Challenge Deliverable 3

--Get the number of employees per dept for a graph
-- Employee count by department number
SELECT count(e.emp_no), de.dept_no
INTO current_counts_3
FROM employees as e
LEFT JOIN dept_emp as de
ON e.emp_no = de.emp_no
WHERE de.to_date = '9999-01-01'
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM current_counts_3;

-- Get number of retiring employees per dept for a graph
SELECT DISTINCT ON (dr.emp_no) dr.emp_no, de.dept_no
INTO retire_table_3
FROM distinct_retires as dr
LEFT JOIN dept_emp as de
ON dr.emp_no = de.emp_no

SELECT count(rt3.emp_no)
INTO retire_counts_3
FROM retire_table_3 as rt3
LEFT JOIN dept_emp as de
ON rt3.emp_no = de.emp_no
-- Filter to currently employed
WHERE de.to_date = ('9999-01-01')
GROUP BY rt3.dept_no
ORDER BY rt3.dept_no;

SELECT * FROM retire_counts_3

--Get the number of mentorship eligible employees per dept for a graph
SELECT count(me.emp_no)
INTO mentors_3
FROM mentor_eligibility as me
LEFT JOIN dept_emp as de
ON me.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;
	  
SELECT * FROM mentors_3;

--Select More Mentors Hypothetical Option
--Join employee info with title info, filtered by a date range
SELECT DISTINCT ON (emp_no) e.emp_no, e.first_name, e.last_name, e.birth_date,
    de.from_date, de.to_date,
	ttl.title
INTO mentor_eligibility_expanded
FROM employees as e
LEFT JOIN dept_emp as de
ON e.emp_no = de.emp_no
LEFT JOIN titles as ttl
ON e.emp_no = ttl.emp_no
WHERE de.to_date = '9999-01-01'
	   AND (e.birth_date BETWEEN '1964-11-30' AND '1965-12-31')
ORDER BY emp_no;

--Get the number of EXPANDED mentorship eligible employees per dept for a graph
SELECT count(mee.emp_no)
INTO mentors_3_expanded
FROM mentor_eligibility_expanded as mee
LEFT JOIN dept_emp as de
ON mee.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;
	  
SELECT * FROM mentors_3_expanded;

--Module lesson code:


-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO emp_counts
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT emp_no,
    first_name,
    last_name,
    gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');	

SELECT e.emp_no,
    e.first_name,
    e.last_name,
    e.gender,
    s.salary,
    de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	      AND (de.to_date = '9999-01-01');
		  
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
SELECT ce.emp_no,
    ce.first_name,
    ce.last_name,
    d.dept_name
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

--Skill Drill
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    d.dept_name
FROM employees as e
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE dept_name IN ('Sales', 'Development')
ORDER BY dept_name;


-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
    dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
    emp_no INT NOT NULL,
    dept_no VARCHAR NOT NULL,
	from_date DATE,
	to_date DATE,
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

CREATE TABLE titles (
    emp_no INT NOT NULL,
    title VARCHAR NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
);

SELECT * FROM retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;




-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT ri.emp_no,
    ri.first_name,
ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

-- Specify Column Data
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
    de.to_date
-- Create New Table To Hold Data
INTO current_emp
-- Join Two Tables
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
-- Filter to currently employed
WHERE de.to_date = ('9999-01-01');



