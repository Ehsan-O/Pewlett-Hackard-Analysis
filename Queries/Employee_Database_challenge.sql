------------------------------------------
-- "DELIVARABLE #1"
------------------------------------------
SELECT e.emp_no,
    e.first_name,
	e.last_name,
	ti.title,
    ti.from_date,
 	ti.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as ti
ON e.emp_no = ti.emp_no
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY e.emp_no ASC;


-- Removing the duplicate rows to keep the most recent title
SELECT DISTINCT ON (emp_no) emp_no,
				first_name,
				Last_name,
				title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

-- Getting the number of employees with the same title
SELECT count(ut.emp_no), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY count DESC;


------------------------------------------
-- "DELIVERABLE #2"
------------------------------------------
SELECT DISTINCT ON (e.emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	ti.title
INTO mentorship_eligibilty
FROM employees as e
INNER JOIN dept_emp as de
	ON e.emp_no = de.emp_no
INNER JOIN titles as ti
 	ON e.emp_no = ti.emp_no
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31') AND (de.to_date = ('9999-01-01'))
ORDER BY e.emp_no;


------------------------------------------
-- Additional Tables
------------------------------------------
-- Retrieving only the current employees with theire modt recent titles 
SELECT DISTINCT ON (emp_no) emp_no,
				first_name,
				Last_name,
				title,
				to_date
INTO current_unique_titles
FROM retirement_titles
WHERE (retirement_titles.to_date = ('9999-01-01'))
ORDER BY emp_no, to_date DESC;

-- Getting the number of the retirement-ready employess for each title (the current employees)
SELECT count(cut.emp_no), cut.title
INTO current_retiring_titles
FROM current_unique_titles as cut
GROUP BY cut.title
ORDER BY count DESC;

-- indicating the number of the retirement-ready employess in each department
SELECT d.dept_name, count(cut.emp_no)
INTO department_retirement
FROM current_unique_titles as cut
INNER JOIN dept_emp as de ON cut.emp_no = de.emp_no
INNER JOIN departments as d ON de.dept_no = d.dept_no
WHERE de.to_date = '9999-01-01'
GROUP BY d.dept_name
ORDER BY d.dept_name;

-- Retrieving the number of mentors in each department
SELECT d.dept_name, count(me.emp_no)
INTO department_mentors
FROM mentorship_eligibilty as me
INNER JOIN dept_emp as de ON me.emp_no = de.emp_no
INNER JOIN departments as d ON de.dept_no = d.dept_no
WHERE de.to_date = '9999-01-01'
GROUP BY d.dept_name
ORDER BY d.dept_name;



